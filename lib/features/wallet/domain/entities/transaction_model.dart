// transaction_request.dart
class TransactionRequest {
  final int userWalletAccountId;
  final int amount;
  final TransactionType type;

  TransactionRequest({
    required this.userWalletAccountId,
    required this.amount,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      'userWalletAccountId': userWalletAccountId,
      'amount': amount,
      'type': type.value,
    };
  }
}

enum TransactionType {
  NAP_TIEN('NAP_TIEN'),
  RUT_TIEN('RUT_TIEN');

  final String value;
  const TransactionType(this.value);
}

// transaction_response.dart
class TransactionResponse {
  final TransactionData data;

  TransactionResponse({required this.data});

  factory TransactionResponse.fromJson(Map<String, dynamic> json) {
    return TransactionResponse(
      data: TransactionData.fromJson(json['data']),
    );
  }
}

class TransactionData {
  final String paymentId;
  final String status;
  final String transactionId;
  final String transactionContent;

  TransactionData({
    required this.paymentId,
    required this.status,
    required this.transactionId,
    required this.transactionContent,
  });

  factory TransactionData.fromJson(Map<String, dynamic> json) {
    return TransactionData(
      paymentId: json['paymentId'].toString(),
      status: json['status'] as String,
      transactionId: json['transactionId'].toString(),
      transactionContent: json['transaction_content'] as String,
    );
  }
}

// transaction_status.dart
class TransactionStatus {
  final String status;
  final DateTime? updatedAt;

  TransactionStatus({
    required this.status,
    this.updatedAt,
  });

  factory TransactionStatus.fromJson(Map<String, dynamic> json) {
    return TransactionStatus(
      status: json['status'] as String,
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt']) 
          : null,
    );
  }
}

enum TransactionStatusEnum {
  PENDING,
  SUCCESS,
  EXPIRED,
  FAILED;

  static TransactionStatusEnum fromString(String status) {
    switch (status.toUpperCase()) {
      case 'SUCCESS':
        return TransactionStatusEnum.SUCCESS;
      case 'PENDING':
        return TransactionStatusEnum.PENDING;
      case 'EXPIRED':
        return TransactionStatusEnum.EXPIRED;
      case 'FAILED':
        return TransactionStatusEnum.FAILED;
      default:
        return TransactionStatusEnum.PENDING;
    }
  }
}