import 'package:flutter/material.dart';
import 'package:trip_mate/commons/helpers/is_dark_mode.dart';
import 'package:trip_mate/core/configs/theme/app_colors.dart';
import 'package:trip_mate/features/wallet/data/sources/wallet_api_source.dart';

class TransactionHistoryScreen extends StatefulWidget {
  String accountId;
  TransactionHistoryScreen({super.key, required this.accountId});

  @override
  State<TransactionHistoryScreen> createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  String? selectedStatus;
  String? selectedType;
  int currentPage = 1;
  final int limit = 10;
  bool isLoading = false;

  final List<String> statusOptions = ['SUCCESS', 'EXPIRED', 'FAILED'];
  final List<String> typeOptions = ['NAP_TIEN', 'RUT_TIEN'];

  // Mock data - thay thế bằng API call thực tế
  List<Map<String, dynamic>> transactions = [];
  int totalTransactions = 0;

  @override
  void initState() {
    super.initState();
    selectedStatus = statusOptions[0];
    selectedType = typeOptions[0];
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    setState(() => isLoading = true);
    
    final accountIdInt = int.tryParse(widget.accountId) ?? 0;
    
    final data = await WalletApiSource.getHistoryTransactions(
        currentPage: currentPage,
        limit: limit,
        status: selectedStatus,
        type: selectedType,
        accountId: accountIdInt
    );
    setState(() {
        final rawTransactions = data['transactions'] as List<dynamic>? ?? []; 
        transactions = rawTransactions
            .whereType<Map<String, dynamic>>()
            .toList();
        totalTransactions = int.tryParse(data['countTransaction'].toString()) ?? 0;
        isLoading = false;
    });
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'SUCCESS':
        return AppColors.success;
      case 'PENDING':
        return AppColors.warning;
      case 'EXPIRED':
        return AppColors.grey500;
      case 'FAILED':
        return AppColors.error;
      default:
        return AppColors.grey500;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'SUCCESS':
        return 'Thành công';
      case 'PENDING':
        return 'Đang xử lý';
      case 'EXPIRED':
        return 'Hết hạn';
      case 'FAILED':
        return 'Thất bại';
      default:
        return status;
    }
  }

  String _formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  String _formatAmount(String amount) {
    final value = double.tryParse(amount) ?? 0;
    if (value == 0) return '0 đ';
    return '${value.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (match) => '${match[1]},')} đ';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final totalPages = (totalTransactions / limit).ceil();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lịch sử giao dịch',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Filter Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowLight,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lọc giao dịch',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildFilterDropdown(
                        label: 'Trạng thái',
                        value: selectedStatus ?? 'TẤT CẢ',
                        items: statusOptions,
                        onChanged: (value) {
                          setState(() {
                            selectedStatus = value == 'TẤT CẢ' ? null : value;
                            currentPage = 1;
                          });
                          _loadTransactions();
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildFilterDropdown(
                        label: 'Loại',
                        value: selectedType ?? 'TẤT CẢ',
                        items: typeOptions,
                        onChanged: (value) {
                          setState(() {
                            selectedType = value == 'TẤT CẢ' ? null : value;
                            currentPage = 1;
                          });
                          _loadTransactions();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Transaction List
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : transactions.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.receipt_long_outlined,
                              size: 64,
                              color: AppColors.grey400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Chưa có giao dịch nào',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: AppColors.grey500,
                                  ),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _loadTransactions,
                        child: ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: transactions.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final transaction = transactions[index];
                            return _buildTransactionCard(transaction, isDark);
                          },
                        ),
                      ),
          ),

          // Pagination
          if (totalPages > 1)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowLight,
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: currentPage > 1
                        ? () {
                            setState(() => currentPage--);
                            _loadTransactions();
                          }
                        : null,
                    icon: const Icon(Icons.chevron_left),
                    style: IconButton.styleFrom(
                      backgroundColor: currentPage > 1
                          ? AppColors.primary.withOpacity(0.1)
                          : AppColors.grey200,
                      foregroundColor:
                          currentPage > 1 ? AppColors.primary : AppColors.grey400,
                    ),
                  ),
                  Text(
                    'Trang $currentPage / $totalPages',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  IconButton(
                    onPressed: currentPage < totalPages
                        ? () {
                            setState(() => currentPage++);
                            _loadTransactions();
                          }
                        : null,
                    icon: const Icon(Icons.chevron_right),
                    style: IconButton.styleFrom(
                      backgroundColor: currentPage < totalPages
                          ? AppColors.primary.withOpacity(0.1)
                          : AppColors.grey200,
                      foregroundColor: currentPage < totalPages
                          ? AppColors.primary
                          : AppColors.grey400,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown({
    required String label,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkBackground : AppColors.grey50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isDark ? AppColors.grey600 : AppColors.grey200,
            ),
          ),
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            underline: const SizedBox(),
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionCard(Map<String, dynamic> transaction, bool isDark) {
    final status = transaction['status'] as String;
    final amount = transaction['amount_in'] as String;
    final account = transaction['account'] as Map<String, dynamic>;
    
    return InkWell(
      onTap: () {
        _showTransactionDetail(transaction);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? AppColors.grey700 : AppColors.grey200,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        account['accountName'] ?? '',
                        style: Theme.of(context).textTheme.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${account['bankName']} • ${account['accountNumber']}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _getStatusText(status),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _getStatusColor(status),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Divider(color: isDark ? AppColors.grey700 : AppColors.grey200),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Số tiền',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatAmount(amount),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColors.primary,
                          ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Thời gian',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDate(transaction['transaction_date']),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Mã GD: ${transaction['paymentId']}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  void _showTransactionDetail(Map<String, dynamic> transaction) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final account = transaction['account'] as Map<String, dynamic>;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.grey300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Chi tiết giao dịch',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            _buildDetailRow('Mã giao dịch', transaction['paymentId']),
            _buildDetailRow('Trạng thái', _getStatusText(transaction['status'])),
            _buildDetailRow('Số tiền', _formatAmount(transaction['amount_in'])),
            _buildDetailRow('Thời gian', _formatDate(transaction['transaction_date'])),
            _buildDetailRow('Tài khoản', account['accountName']),
            _buildDetailRow('Số tài khoản', account['accountNumber']),
            _buildDetailRow('Ngân hàng', account['bankName']),
            _buildDetailRow('Nội dung', transaction['transaction_content']),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Đóng'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}