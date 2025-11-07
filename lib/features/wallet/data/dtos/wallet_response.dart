import 'package:trip_mate/features/wallet/domain/entities/wallet_entity.dart';

class WalletResponse {
  final String id;
  final String accountNumber;
  final double balance;
  final String bankName;
  final String bankCode;
  final String accountName;
  final DateTime createdAt;

  WalletResponse({
    required this.id,
    required this.accountNumber,
    required this.balance,
    required this.bankName,
    required this.bankCode,
    required this.accountName,
    required this.createdAt,
  });

  factory WalletResponse.fromMap(Map<String, dynamic> map) {
    return WalletResponse(
      id: map['id']?.toString() ?? '',
      accountNumber: map['accountNumber']?.toString() ?? '',
      balance: double.tryParse(map['balance']?.toString() ?? '0') ?? 0.0,
      bankName: map['bankName'] ?? '',
      bankCode: map['bankCode'] ?? '',
      accountName: map['accountName'] ?? '',
      createdAt: DateTime.parse(
        map['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  WalletEntity toEntity() {
    return WalletEntity(
      accountNumber: accountNumber,
      balance: balance,
      bankName: bankName,
      bankCode: bankCode,
      createdAt: createdAt,
      accountName: accountName,
    );
  }
}
