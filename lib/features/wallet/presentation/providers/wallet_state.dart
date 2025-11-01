import 'package:trip_mate/features/wallet/domain/entities/wallet_entity.dart';

abstract class WalletState {}

class WalletInitial extends WalletState {}

class WalletLoading extends WalletState {}

class WalletData extends WalletState {
  final String accountNumber;
  final double balance;
  final String bankName;
  final String bankCode;
  final DateTime createdAt;

  WalletData({
    required this.accountNumber,
    required this.balance,
    required this.bankName,
    required this.bankCode,
    required this.createdAt,
  });

  factory WalletData.fromEntity(WalletEntity entity) {
    return WalletData(
      accountNumber: entity.accountNumber,
      balance: entity.balance,
      bankName: entity.bankName,
      bankCode: entity.bankCode,
      createdAt: entity.createdAt,
    );
  }

  WalletData copyWith({
    String? accountNumber,
    double? balance,
    String? bankName,
    String? bankCode,
    DateTime? createdAt,
  }) {
    return WalletData(
      accountNumber: accountNumber ?? this.accountNumber,
      balance: balance ?? this.balance,
      bankName: bankName ?? this.bankName,
      bankCode: bankCode ?? this.bankCode,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class WalletError extends WalletState {
  final String message;
  WalletError(this.message);
}
