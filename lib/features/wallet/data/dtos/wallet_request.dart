class WalletRequest {
  final String accountNumber;
  final double amount;

  WalletRequest({
    required this.accountNumber,
    required this.amount,
  });

  Map<String, dynamic> toMap() {
    return {
      'accountNumber': accountNumber,
      'amount': amount,
    };
  }
}
