import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:trip_mate/commons/helpers/is_dark_mode.dart';
import 'package:trip_mate/core/configs/theme/app_colors.dart';
import 'package:trip_mate/features/wallet/data/sources/bank_service.dart';
import 'package:trip_mate/features/wallet/domain/entities/bank_model.dart';
import 'package:trip_mate/features/wallet/presentation/providers/wallet_provider.dart';
import 'package:trip_mate/features/wallet/presentation/widgets/bank_selection.dart';
// Import các file cần thiết
// import 'package:trip_mate/features/wallet/data/models/bank_model.dart';
// import 'package:trip_mate/features/wallet/data/services/bank_service.dart';
// import 'package:trip_mate/core/configs/theme/app_colors.dart';

class WalletRegistrationScreen extends StatefulWidget {
  const WalletRegistrationScreen({super.key});

  @override
  State<WalletRegistrationScreen> createState() => _WalletRegistrationScreenState();
}

class _WalletRegistrationScreenState extends State<WalletRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _accountNameController = TextEditingController();
  final TextEditingController _accountNumberController = TextEditingController();
  final TextEditingController _bankCodeController = TextEditingController();
  final TextEditingController _initialBalanceController = TextEditingController(text: '0.00');

  final BankService _bankService = BankService();
  List<Bank> _banks = [];
  Bank? _selectedBank;
  bool _isLoading = false;
  bool _isBanksLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBanks();
  }

  Future<void> _loadBanks() async {
    try {
      final banks = await _bankService.fetchBanks();
      setState(() {
        _banks = banks;
        _isBanksLoading = false;
      });
    } catch (e) {
      setState(() {
        _isBanksLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load banks: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _accountNameController.dispose();
    _accountNumberController.dispose();
    _bankCodeController.dispose();
    _initialBalanceController.dispose();
    super.dispose();
  }

  void _registerWallet() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedBank == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a bank')),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      final String accountName = _accountNameController.text;
      final String accountNumber = _accountNumberController.text;
      final String bankName = _selectedBank!.name;
      final String bankCode = _selectedBank!.code;
      final double initialBalance = double.tryParse(_initialBalanceController.text) ?? 0.0;

      await context.read<WalletCubit>().registerNewWallet(
        accountName: accountName,
        accountNumber: accountNumber,
        bankName: bankName,
        bankCode: bankCode,
        initialBalance: initialBalance,
      );
      
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showBankSelectionDialog() {
    final isDarkMode = context.isDarkMode;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BankSelectionDialog(
          banks: _banks,
          selectedBank: _selectedBank,
          isDarkMode: isDarkMode,
          onBankSelected: (Bank bank) {
            setState(() {
              _selectedBank = bank;
              _bankCodeController.text = bank.code;
            });
            Navigator.pop(context);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: Text(
          'Register New Wallet',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        backgroundColor: isDarkMode ? AppColors.surfaceDark : primaryColor,
        elevation: 0,
        iconTheme: IconThemeData(
          color: isDarkMode ? AppColors.white : AppColors.white,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Icon minh họa
              Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDarkMode 
                        ? AppColors.surfaceDark 
                        : AppColors.primaryLight,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.account_balance_wallet_outlined,
                    size: 60,
                    color: primaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              Text(
                'Provide your bank account details to create your wallet.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 30),

              // Account Holder Name
              _buildTextField(
                controller: _accountNameController,
                labelText: 'Account Holder Name',
                hintText: 'e.g., NGUYEN PHAN THANH AN',
                icon: Icons.person_outline,
                isDarkMode: isDarkMode,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter account holder name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Account Number
              _buildTextField(
                controller: _accountNumberController,
                labelText: 'Account Number',
                hintText: 'e.g., 0123456789',
                icon: Icons.credit_card,
                isDarkMode: isDarkMode,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter account number';
                  }
                  if (value.length < 8) {
                    return 'Account number must be at least 8 digits';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Bank Selection Dropdown
              GestureDetector(
                onTap: _isBanksLoading ? null : _showBankSelectionDialog,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: isDarkMode ? AppColors.surfaceDark : AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _selectedBank == null 
                          ? (isDarkMode ? AppColors.grey600 : AppColors.grey200)
                          : primaryColor,
                      width: _selectedBank == null ? 1 : 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.apartment,
                        color: primaryColor.withOpacity(0.7),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _isBanksLoading
                            ? Text(
                                'Loading banks...',
                                style: TextStyle(
                                  color: isDarkMode 
                                      ? AppColors.grey400 
                                      : AppColors.grey600,
                                  fontSize: 16,
                                ),
                              )
                            : _selectedBank == null
                                ? Text(
                                    'Select Bank',
                                    style: TextStyle(
                                      color: isDarkMode 
                                          ? AppColors.grey400 
                                          : AppColors.grey600,
                                      fontSize: 16,
                                    ),
                                  )
                                : Row(
                                    children: [
                                      if (_selectedBank!.logo.isNotEmpty)
                                        Image.network(
                                          _selectedBank!.logo,
                                          width: 24,
                                          height: 24,
                                          fit: BoxFit.contain,
                                          errorBuilder: (context, error, stackTrace) {
                                            return const SizedBox.shrink();
                                          },
                                        ),
                                      if (_selectedBank!.logo.isNotEmpty)
                                        const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          _selectedBank!.shortName,
                                          style: TextStyle(
                                            color: isDarkMode 
                                                ? AppColors.white 
                                                : AppColors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                      ),
                      Icon(
                        Icons.arrow_drop_down,
                        color: isDarkMode ? AppColors.grey400 : AppColors.grey600,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Bank Code (Read-only)
              _buildTextField(
                controller: _bankCodeController,
                labelText: 'Bank Code',
                hintText: 'Auto-filled',
                icon: Icons.code,
                isDarkMode: isDarkMode,
                readOnly: true,
                enabled: false,
              ),
              const SizedBox(height: 30),

              // Register Button
              ElevatedButton(
                onPressed: _isLoading ? null : _registerWallet,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 4,
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Register Wallet',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    String? hintText,
    IconData? icon,
    required bool isDarkMode,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    bool readOnly = false,
    bool enabled = true,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      readOnly: readOnly,
      enabled: enabled,
      style: TextStyle(
        color: isDarkMode ? AppColors.white : AppColors.black,
      ),
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: icon != null
            ? Icon(
                icon,
                color: Theme.of(context).primaryColor.withOpacity(0.7),
              )
            : null,
        filled: true,
        fillColor: isDarkMode ? AppColors.surfaceDark : AppColors.white,
        labelStyle: TextStyle(
          color: isDarkMode ? AppColors.grey400 : AppColors.grey600,
        ),
        hintStyle: TextStyle(
          color: isDarkMode ? AppColors.grey500 : AppColors.grey400,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDarkMode ? AppColors.grey600 : AppColors.grey200,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDarkMode ? AppColors.grey600 : AppColors.grey200,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDarkMode ? AppColors.grey700 : AppColors.grey300,
          ),
        ),
      ),
      validator: validator,
    );
  }
}