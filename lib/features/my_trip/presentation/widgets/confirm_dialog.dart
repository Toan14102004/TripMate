import 'package:flutter/material.dart';
import 'package:trip_mate/core/configs/theme/app_colors.dart';
import 'package:intl/intl.dart';

class PaymentConfirmationDialog extends StatelessWidget {
  final double currentBalance;
  final double totalAmount;
  final VoidCallback onConfirm;
  final bool isDarkMode;

  const PaymentConfirmationDialog({
    super.key,
    required this.currentBalance,
    required this.totalAmount,
    required this.onConfirm,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
    final hasEnoughBalance = currentBalance >= totalAmount;

    return Dialog(
      backgroundColor: isDarkMode ? AppColors.surfaceDark : AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: hasEnoughBalance
                    ? AppColors.primary.withOpacity(0.1)
                    : AppColors.error.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                hasEnoughBalance
                    ? Icons.account_balance_wallet_rounded
                    : Icons.warning_rounded,
                size: 48,
                color: hasEnoughBalance ? AppColors.primary : AppColors.error,
              ),
            ),
            const SizedBox(height: 20),

            // Title
            Text(
              'Xác nhận thanh toán',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: isDarkMode ? AppColors.white : AppColors.black,
              ),
            ),
            const SizedBox(height: 24),

            // Balance Info Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDarkMode
                    ? AppColors.darkBackground
                    : AppColors.grey50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDarkMode ? AppColors.grey600 : AppColors.grey200,
                ),
              ),
              child: Column(
                children: [
                  // Current Balance
                  _buildInfoRow(
                    label: 'Số dư hiện tại',
                    value: formatter.format(currentBalance),
                    valueColor:
                        isDarkMode ? AppColors.grey100 : AppColors.grey700,
                    isDarkMode: isDarkMode,
                  ),
                  const SizedBox(height: 12),
                  Divider(
                    color: isDarkMode ? AppColors.grey600 : AppColors.grey200,
                    height: 1,
                  ),
                  const SizedBox(height: 12),

                  // Total Amount
                  _buildInfoRow(
                    label: 'Tổng tiền phải trả',
                    value: formatter.format(totalAmount),
                    valueColor: AppColors.error,
                    isDarkMode: isDarkMode,
                    isAmount: true,
                  ),
                  const SizedBox(height: 12),
                  // Divider(
                  //   color: isDarkMode ? AppColors.grey600 : AppColors.grey200,
                  //   height: 1,
                  // ),
                  // const SizedBox(height: 12),

                  // // Remaining Balance
                  // _buildInfoRow(
                  //   label: 'Số dư sau thanh toán',
                  //   value: formatter.format(currentBalance - totalAmount),
                  //   valueColor: hasEnoughBalance
                  //       ? AppColors.success
                  //       : AppColors.error,
                  //   isDarkMode: isDarkMode,
                  //   isBold: true,
                  // ),
                ],
              ),
            ),

            // Warning Message if insufficient balance
            if (!hasEnoughBalance) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.error.withOpacity(0.3),
                  ),
                ),
                child: const Row(
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: AppColors.error,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Số dư không đủ để thực hiện giao dịch này!',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.error,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                // Cancel Button
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(
                        color: isDarkMode
                            ? AppColors.grey600
                            : AppColors.grey300,
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
                        color: isDarkMode
                            ? AppColors.grey300
                            : AppColors.grey700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Confirm Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: hasEnoughBalance
                        ? () {
                            Navigator.pop(context);
                            onConfirm();
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: hasEnoughBalance
                          ? AppColors.primary
                          : AppColors.grey400,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: hasEnoughBalance ? 2 : 0,
                    ),
                    child: Text(
                      hasEnoughBalance ? 'Xác nhận' : 'Không đủ tiền',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required String label,
    required String value,
    required Color valueColor,
    required bool isDarkMode,
    bool isAmount = false,
    bool isBold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: isDarkMode ? AppColors.grey400 : AppColors.grey600,
            fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isAmount || isBold ? 18 : 16,
            fontWeight: isBold || isAmount ? FontWeight.w700 : FontWeight.w600,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}

// Extension để dễ dàng gọi dialog
extension PaymentDialogExtension on BuildContext {
  Future<void> showPaymentConfirmation({
    required double currentBalance,
    required double totalAmount,
    required VoidCallback onConfirm,
  }) {
    final isDarkMode = Theme.of(this).brightness == Brightness.dark;

    return showDialog(
      context: this,
      barrierDismissible: false,
      builder: (context) => PaymentConfirmationDialog(
        currentBalance: currentBalance,
        totalAmount: totalAmount,
        onConfirm: onConfirm,
        isDarkMode: isDarkMode,
      ),
    );
  }
}

// ============ CÁCH SỬ DỤNG ============

// Trong widget của bạn:
class PaymentButtonExample extends StatelessWidget {
  final double currentBalance = 5000000; // Ví dụ: 5 triệu
  final double totalAmount = 3500000; // Ví dụ: 3.5 triệu

  const PaymentButtonExample({super.key});

  void _handlePayment() {
    // Xử lý thanh toán ở đây
    print('Processing payment...');
    // TODO: Gọi API, update database, etc.
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: OutlinedButton.icon(
        onPressed: () {
          // Hiện dialog xác nhận
          context.showPaymentConfirmation(
            currentBalance: currentBalance,
            totalAmount: totalAmount,
            onConfirm: _handlePayment,
          );
        },
        icon: const Icon(
          Icons.monetization_on_rounded,
          color: AppColors.primary,
        ),
        label: const Text(
          'Trả tiền',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
    );
  }
}

// ============ HOẶC CÁCH GỌI TRUYỀN THỐNG ============

void _showPaymentDialog(BuildContext context) {
  final isDarkMode = Theme.of(context).brightness == Brightness.dark;
  final double currentBalance = 5000000;
  final double totalAmount = 3500000;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => PaymentConfirmationDialog(
      currentBalance: currentBalance,
      totalAmount: totalAmount,
      isDarkMode: isDarkMode,
      onConfirm: () {
        print('Payment confirmed!');
        // Xử lý thanh toán
      },
    ),
  );
}