class WalletEntity {
  final String accountNumber;
  final double balance;
  final String bankName;
  final String bankCode;
  final DateTime createdAt;

  WalletEntity({
    required this.accountNumber,
    required this.balance,
    required this.bankName,
    required this.bankCode,
    required this.createdAt,
  });
}
