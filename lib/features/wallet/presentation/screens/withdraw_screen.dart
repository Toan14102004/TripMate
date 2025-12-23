import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trip_mate/commons/helpers/is_dark_mode.dart';
import 'package:trip_mate/commons/widgets/basic_app_button.dart';
import 'package:trip_mate/core/configs/theme/app_colors.dart';
import 'package:trip_mate/core/ultils/toast_util.dart';
import 'package:trip_mate/features/wallet/data/sources/wallet_api_source.dart';

class WithdrawScreen extends StatefulWidget {
  const WithdrawScreen({super.key});

  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final WalletApiSource _walletApiSource = WalletApiSource();
  
  bool _isLoading = false;
  int? _userWalletAccountId;

  @override
  void initState() {
    super.initState();
    _loadWalletInfo();
  }

  Future<void> _loadWalletInfo() async {
    // Load wallet account ID from API or storage
    // For now, we'll use a default value
    setState(() {
      _userWalletAccountId = 1; // This should be fetched from user's wallet data
    });
  }

  Future<void> _handleWithdraw() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_userWalletAccountId == null) {
      ToastUtil.showErrorToast('Wallet information not found');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final amount = double.parse(_amountController.text);

    final result = await _walletApiSource.withdrawMoney(
      userWalletAccountId: _userWalletAccountId!,
      amount: amount,
    );

    setState(() {
      _isLoading = false;
    });

    result.fold(
      (error) {
        ToastUtil.showErrorToast(error);
      },
      (success) {
        ToastUtil.showSuccessToast('Withdrawal request successful!');
        _amountController.clear();
        // Navigate back or refresh wallet
        Navigator.pop(context, true);
      },
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: isDark ? AppColors.white : AppColors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Withdraw',
          style: TextStyle(
            color: isDark ? AppColors.white : AppColors.black,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card with info
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.amber.shade400, Colors.orange.shade400],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.amber.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.account_balance_wallet,
                      color: Colors.white,
                      size: 48,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Withdraw from Wallet',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Enter amount to withdraw',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Wallet Account ID (readonly)
              Text(
                'Wallet Account ID',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.grey50 : AppColors.black,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.grey700 : AppColors.grey100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark ? AppColors.grey600 : AppColors.grey300,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.credit_card,
                      color: isDark ? AppColors.grey400 : AppColors.grey600,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      _userWalletAccountId?.toString() ?? 'Loading...',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.grey300 : AppColors.grey700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Amount Input
              Text(
                'Withdrawal Amount (VND)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.grey50 : AppColors.black,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.white : AppColors.black,
                ),
                decoration: InputDecoration(
                  hintText: 'Enter amount',
                  hintStyle: TextStyle(
                    color: isDark ? AppColors.grey500 : AppColors.grey400,
                  ),
                  prefixIcon: Icon(
                    Icons.attach_money,
                    color: Colors.amber,
                  ),
                  filled: true,
                  fillColor: isDark ? AppColors.grey700 : AppColors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isDark ? AppColors.grey600 : AppColors.grey300,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isDark ? AppColors.grey600 : AppColors.grey300,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colors.amber,
                      width: 2,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colors.red,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter amount';
                  }
                  final amount = double.tryParse(value);
                  if (amount == null || amount <= 0) {
                    return 'Amount must be greater than 0';
                  }
                  if (amount < 10000) {
                    return 'Minimum amount is 10,000 VND';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Quick amount buttons
              Text(
                'Suggested Amounts',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppColors.grey400 : AppColors.grey600,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [100000, 200000, 500000, 1000000].map((amount) {
                  return InkWell(
                    onTap: () {
                      _amountController.text = amount.toString();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.grey700 : AppColors.grey100,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.amber.withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        '${amount ~/ 1000}K',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.white : AppColors.black,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),

              // Info box
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.blue.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.blue,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Money will be transferred to your bank account within 1-3 business days',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? AppColors.grey300 : AppColors.grey700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Submit button
              BasicAppButton(
                onPressed: _isLoading ? () {} : _handleWithdraw,
                text: _isLoading ? 'Processing...' : 'Confirm Withdrawal',
                height: 54,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

