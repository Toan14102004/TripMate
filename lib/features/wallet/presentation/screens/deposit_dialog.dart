import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:trip_mate/commons/env.dart';
import 'package:trip_mate/commons/helpers/is_dark_mode.dart';
import 'package:trip_mate/commons/log.dart';
import 'package:trip_mate/core/configs/theme/app_colors.dart';
import 'package:trip_mate/features/wallet/domain/entities/transaction_model.dart';
import 'package:trip_mate/features/wallet/presentation/providers/wallet_provider.dart';
import 'package:http/http.dart' as http;
import 'package:trip_mate/features/wallet/presentation/providers/wallet_state.dart';

class DepositDialog extends StatefulWidget {
  final WalletCubit walletCubit;

  const DepositDialog({
    super.key,
    required this.walletCubit,
  });

  @override
  State<DepositDialog> createState() => _DepositDialogState();
}

class _DepositDialogState extends State<DepositDialog> {
  final TextEditingController _amountController = TextEditingController();
  final NumberFormat _currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
  
  bool _isLoading = false;
  bool _showQR = false;
  String? _qrData;
  String? _transactionContent;
  int? _amount;
  String _status = '';
  StreamSubscription? _sseSubscription;
  
  @override
  void dispose() {
    _amountController.dispose();
    _sseSubscription?.cancel();
    super.dispose();
  }

  Future<void> _createTransaction() async {
    final amount = int.tryParse(_amountController.text.replaceAll(RegExp(r'[^0-9]'), ''));
    
    if (amount == null || amount < 1) {
      _showError('Vui lòng nhập số tiền hợp lệ (>= 1)');
      return;
    }

    setState(() {
      _isLoading = true;
      _status = 'Đang tạo giao dịch...';
    });

    try {
      final request = TransactionRequest(
        userWalletAccountId: widget.walletCubit.state is WalletData 
            ? int.tryParse((widget.walletCubit.state as WalletData).id) ?? 0
            : 1,
        amount: amount,
        type: TransactionType.NAP_TIEN,
      );

      final response = await http.post(
        Uri.parse('${Environment.kDomain}transactions/InOutcoin'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 201) {
        final result = TransactionResponse.fromJson(jsonDecode(response.body));
        
        setState(() {
          _amount = amount;
          _transactionContent = result.data.transactionContent;
          _qrData = _generateQRUrl(amount, result.data.transactionContent);
          _showQR = true;
          _status = 'Đang chờ thanh toán...';
          _isLoading = false;
        });

        // Bắt đầu lắng nghe SSE
        _listenToSSE(result.data.paymentId);
      } else {
        logError('HTTP ${response.statusCode}');
        throw Exception('HTTP ${response.statusCode}');
      }
    } catch (e) {
      logError('HTTP ${e.toString()}');
      setState(() {
        _isLoading = false;
        _status = '';
      });
      _showError('Không thể tạo giao dịch. Vui lòng thử lại.');
    }
  }

  String _generateQRUrl(int amount, String content) {
    // Tạo URL QR code theo format của Sepay
    return 'https://qr.sepay.vn/img?acc=96247H06JB&bank=BIDV&amount=$amount&des=$content';
  }

  void _listenToSSE(String paymentId) {
    final client = http.Client();
    final request = http.Request(
      'GET',
      Uri.parse('${Environment.kDomain}transactions/stream/$paymentId'),
    );

    client.send(request).then((response) {
      response.stream
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .listen(
            (line) {
              if (line.startsWith('data: ')) {
                final data = line.substring(6);
                try {
                  final json = jsonDecode(data);
                  final status = json['status'] as String;
                  
                  setState(() {
                    _status = 'Trạng thái: $status';
                  });

                  if (status == 'SUCCESS') {
                    _sseSubscription?.cancel();
                    _showSuccess();
                  } else if (status == 'EXPIRED') {
                    _sseSubscription?.cancel();
                    _showExpired();
                  }
                } catch (e) {
                  debugPrint('Error parsing SSE: $e');
                }
              }
            },
            onError: (error) {
              debugPrint('SSE Error: $error');
              setState(() {
                _status = 'Lỗi kết nối';
              });
            },
            onDone: () {
              debugPrint('SSE connection closed');
            },
          );
    });
  }

  void _showSuccess() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: AppColors.success, size: 32),
            SizedBox(width: 12),
            Text('Thành công'),
          ],
        ),
        content: const Text('Giao dịch nạp tiền đã hoàn tất!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Đóng success dialog
              Navigator.pop(context); // Đóng deposit dialog
              widget.walletCubit.initialize(); // Reload wallet
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showExpired() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.error_outline, color: AppColors.error, size: 32),
            SizedBox(width: 12),
            Text('Hết hạn'),
          ],
        ),
        content: const Text('Giao dịch đã hết hạn. Vui lòng tạo giao dịch mới.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _showQR = false;
                _qrData = null;
                _status = '';
              });
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
      ),
    );
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã sao chép'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.account_balance_wallet,
                      color: AppColors.primary,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      _showQR ? 'Quét mã QR' : 'Nạp tiền',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: context.isDarkMode ? AppColors.white : AppColors.black,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Nội dung
              if (!_showQR) ...[
                // Input số tiền
                Text(
                  'Số tiền nạp',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: context.isDarkMode ? AppColors.grey400 : AppColors.grey600,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    hintText: 'Nhập số tiền',
                    prefixText: 'đ ',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.primary, width: 2),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
                const SizedBox(height: 24),

                // Button tạo giao dịch
                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _createTransaction,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: AppColors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Tạo giao dịch',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.white,
                            ),
                          ),
                  ),
                ),
              ] else ...[
                // Hiển thị QR Code
                Text(
                  'Số tiền: ${_currencyFormat.format(_amount)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.grey300),
                  ),
                  child: Column(
                    children: [
                      if (_qrData != null)
                        Image.network(
                          _qrData!,
                          width: 250,
                          height: 250,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const SizedBox(
                              width: 250,
                              height: 250,
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return const SizedBox(
                              width: 250,
                              height: 250,
                              child: Center(
                                child: Icon(Icons.error),
                              ),
                            );
                          },
                        ),
                      const SizedBox(height: 16),
                      Text(
                        'Quét mã QR để hoàn tất giao dịch',
                        style: TextStyle(
                          fontSize: 14,
                          color: context.isDarkMode ? AppColors.grey400 : AppColors.grey600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Nội dung chuyển khoản
                if (_transactionContent != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: context.isDarkMode ? AppColors.surfaceDark : AppColors.grey100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Nội dung chuyển khoản',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: context.isDarkMode ? AppColors.grey400 : AppColors.grey600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _transactionContent!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => _copyToClipboard(_transactionContent!),
                          icon: const Icon(Icons.copy, size: 20),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Trạng thái
                if (_status.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _status.contains('SUCCESS')
                          ? AppColors.success.withOpacity(0.1)
                          : _status.contains('EXPIRED')
                              ? AppColors.error.withOpacity(0.1)
                              : AppColors.warning.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _status.contains('SUCCESS')
                              ? Icons.check_circle
                              : _status.contains('EXPIRED')
                                  ? Icons.error
                                  : Icons.info,
                          color: _status.contains('SUCCESS')
                              ? AppColors.success
                              : _status.contains('EXPIRED')
                                  ? AppColors.error
                                  : AppColors.warning,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _status,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: _status.contains('SUCCESS')
                                  ? AppColors.success
                                  : _status.contains('EXPIRED')
                                      ? AppColors.error
                                      : AppColors.warning,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}