import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:trip_mate/commons/helpers/is_dark_mode.dart';
import 'package:trip_mate/core/configs/theme/app_colors.dart';
import 'package:trip_mate/features/wallet/presentation/providers/wallet_provider.dart';
import 'package:trip_mate/features/wallet/presentation/providers/wallet_state.dart';
import 'package:trip_mate/features/wallet/presentation/screens/wallet_registor.dart';
import 'package:trip_mate/features/wallet/presentation/widgets/deposit_dialog.dart';
import 'package:trip_mate/features/wallet/presentation/widgets/wallet_card.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  late WalletCubit _walletCubit;

  @override
  void initState() {
    super.initState();
    context.read<WalletCubit>().initialize();
  }

  @override
  void dispose() {
    _walletCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: context.isDarkMode ? AppColors.surfaceDark : AppColors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Ví Tiền',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: context.isDarkMode ? AppColors.white : AppColors.black,
          ),
        ),
      ),
      body: BlocBuilder<WalletCubit, WalletState>(
        builder: (context, state) {
          if (state is WalletLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            );
          } else if (state is WalletError) {
            if(state.message == "Wallet not found"){
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const WalletRegistrationScreen()),
              );
            }
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppColors.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Lỗi tải dữ liệu',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: context.isDarkMode ? AppColors.white : AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    style: TextStyle(
                      fontSize: 14,
                      color: context.isDarkMode ? AppColors.grey400 : AppColors.grey600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => _walletCubit.initialize(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Thử lại',
                      style: TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (state is WalletData) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WalletCard(
                      accountNumber: state.accountNumber,
                      balance: state.balance,
                      bankName: state.bankName,
                    ),
                    const SizedBox(height: 32),
    
                    Text(
                      'Thông Tin Ngân Hàng',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: context.isDarkMode ? AppColors.white : AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoCard(
                      context: context,
                      icon: Icons.account_balance,
                      label: 'Tên Ngân Hàng',
                      value: state.bankName,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoCard(
                      context: context,
                      icon: Icons.credit_card,
                      label: 'Số Tài Khoản',
                      value: state.accountNumber,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoCard(
                      context: context,
                      icon: Icons.code,
                      label: 'Tên Chủ Tài Khoản',
                      value: state.accountName,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoCard(
                      context: context,
                      icon: Icons.calendar_today,
                      label: 'Ngày Tạo',
                      value: DateFormat('dd/MM/yyyy').format(state.createdAt),
                    ),
                    const SizedBox(height: 32),
    
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) => DepositDialog(
                              walletCubit: _walletCubit,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 4,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.add_circle_outline, color: AppColors.white),
                            SizedBox(width: 12),
                            Text(
                              'Nạp Tiền',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          }
    
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildInfoCard({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.isDarkMode ? AppColors.surfaceDark : AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: context.isDarkMode ? AppColors.grey700 : AppColors.grey200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: context.isDarkMode ? AppColors.grey400 : AppColors.grey600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: context.isDarkMode ? AppColors.white : AppColors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
