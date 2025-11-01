import 'package:flutter/material.dart';
import 'package:trip_mate/commons/helpers/is_dark_mode.dart';
import 'package:trip_mate/core/configs/theme/app_colors.dart';
import 'package:trip_mate/features/wallet/presentation/providers/wallet_provider.dart';

class DepositDialog extends StatefulWidget {
  final WalletCubit walletCubit;

  const DepositDialog({
    Key? key,
    required this.walletCubit,
  }) : super(key: key);

  @override
  State<DepositDialog> createState() => _DepositDialogState();
}

class _DepositDialogState extends State<DepositDialog> {
  late TextEditingController _amountController;
  double? _selectedAmount;

  final List<double> _quickAmounts = [100000, 250000, 500000, 1000000];

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _deposit() {
    final amount = _selectedAmount ?? double.tryParse(_amountController.text);
    
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập số tiền hợp lệ'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    widget.walletCubit.depositMoney(amount);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: context.isDarkMode ? AppColors.surfaceDark : AppColors.white,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Nạp Tiền',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: context.isDarkMode ? AppColors.white : AppColors.black,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.close,
                      color: context.isDarkMode ? AppColors.grey400 : AppColors.grey600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                onChanged: (_) {
                  setState(() => _selectedAmount = null);
                },
                decoration: InputDecoration(
                  hintText: 'Nhập số tiền',
                  hintStyle: TextStyle(
                    color: context.isDarkMode ? AppColors.grey500 : AppColors.grey400,
                  ),
                  prefixIcon: const Icon(Icons.attach_money, color: AppColors.primary),
                  suffixText: 'đ',
                  suffixStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                  filled: true,
                  fillColor: context.isDarkMode ? AppColors.surfaceDark.withOpacity(0.5) : AppColors.primaryLight,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: context.isDarkMode ? AppColors.grey700 : AppColors.grey200,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: context.isDarkMode ? AppColors.grey700 : AppColors.grey200,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Text(
                'Chọn Nhanh',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: context.isDarkMode ? AppColors.grey300 : AppColors.grey600,
                ),
              ),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                physics: const NeverScrollableScrollPhysics(),
                children: _quickAmounts.map((amount) {
                  final isSelected = _selectedAmount == amount;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedAmount = amount;
                        _amountController.clear();
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : 
                            (context.isDarkMode ? AppColors.surfaceDark.withOpacity(0.5) : AppColors.primaryLight),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? AppColors.primary : 
                              (context.isDarkMode ? AppColors.grey700 : AppColors.grey200),
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '${(amount / 1000).toStringAsFixed(0)}K',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? AppColors.white : AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _deposit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                  child: const Text(
                    'Nạp Tiền',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: context.isDarkMode ? AppColors.grey700 : AppColors.grey200,
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Hủy',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: context.isDarkMode ? AppColors.grey300 : AppColors.grey600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
