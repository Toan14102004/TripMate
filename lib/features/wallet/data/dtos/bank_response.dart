import 'package:trip_mate/features/wallet/domain/entities/bank_model.dart';

class BankListResponse {
  final String code;
  final String desc;
  final List<Bank> data;

  BankListResponse({
    required this.code,
    required this.desc,
    required this.data,
  });

  factory BankListResponse.fromJson(Map<String, dynamic> json) {
    return BankListResponse(
      code: json['code'] as String,
      desc: json['desc'] as String,
      data: (json['data'] as List)
          .map((bank) => Bank.fromJson(bank as Map<String, dynamic>))
          .toList(),
    );
  }
}