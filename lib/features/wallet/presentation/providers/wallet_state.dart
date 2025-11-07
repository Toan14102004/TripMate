import 'package:trip_mate/features/wallet/domain/entities/wallet_entity.dart';

abstract class WalletState {}

class WalletInitial extends WalletState {}

class WalletLoading extends WalletState {}

class WalletData extends WalletState {
  final String accountNumber;
  final String accountName;
  final double balance;
  final String bankName;
  final String bankCode;
  final DateTime createdAt;

  WalletData({
    required this.accountNumber,
    required this.balance,
    required this.bankName,
    required this.accountName,
    required this.bankCode,
    required this.createdAt,
  });

  factory WalletData.fromEntity(WalletEntity entity) {
    return WalletData(
      accountNumber: entity.accountNumber,
      accountName: entity.accountName,
      balance: entity.balance,
      bankName: entity.bankName,
      bankCode: entity.bankCode,
      createdAt: entity.createdAt,
    );
  }

  WalletData copyWith({
    String? accountNumber,
    String? accountName,
    double? balance,
    String? bankName,
    String? bankCode,
    DateTime? createdAt,
  }) {
    return WalletData(
      accountName: accountName ?? this.accountName,
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
