import 'package:trip_mate/features/wallet/domain/entities/wallet_entity.dart';

class WalletResponse {
  final String accountNumber;
  final double balance;
  final String bankName;
  final String bankCode;
  final DateTime createdAt;

  WalletResponse({
    required this.accountNumber,
    required this.balance,
    required this.bankName,
    required this.bankCode,
    required this.createdAt,
  });

  factory WalletResponse.fromMap(Map<String, dynamic> map) {
    return WalletResponse(
      accountNumber: map['accountNumber'] ?? '',
      balance: (map['balance'] ?? 0).toDouble(),
      bankName: map['bankName'] ?? '',
      bankCode: map['bankCode'] ?? '',
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  WalletEntity toEntity() {
    return WalletEntity(
      accountNumber: accountNumber,
      balance: balance,
      bankName: bankName,
      bankCode: bankCode,
      createdAt: createdAt,
    );
  }
}
