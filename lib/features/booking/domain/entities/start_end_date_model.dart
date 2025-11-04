// Model cho Start-End Date
class StartEndDateModel {
  final int id;
  final DateTime startDate;
  final DateTime endDate;
  final double priceAdult;
  final double priceChildren;
  final int availableSlots;
  final int? tourId;
  final String? status;
  
  StartEndDateModel({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.priceAdult,
    required this.priceChildren,
    required this.availableSlots,
    this.tourId,
    this.status,
  });
  
  factory StartEndDateModel.fromJson(Map<String, dynamic> json) {
        // Hàm helper để xử lý cả int, double và String
        double _parsePrice(dynamic value) {
            if (value == null) return 0.0;
            if (value is num) return value.toDouble();
            if (value is String) {
                // Thử phân tích chuỗi, nếu thất bại thì trả về 0.0
                return double.tryParse(value) ?? 0.0;
            }
            return 0.0; // Giá trị mặc định nếu không phải kiểu mong muốn
        }

        return StartEndDateModel(
            id: json['dateId'] ?? json['id'] ?? 0, // Dùng 'dateId' hoặc 'id'
            startDate: DateTime.parse(json['startDate'] ?? DateTime.now().toString()),
            endDate: DateTime.parse(json['endDate'] ?? DateTime.now().toString()),
            
            // Áp dụng hàm helper để xử lý giá tiền
            priceAdult: _parsePrice(json['priceAdult']),
            priceChildren: _parsePrice(json['priceChildren']),
            
            // Dữ liệu mẫu dùng 'quantity', code dùng 'availableSlots'
            availableSlots: json['quantity'] ?? json['availableSlots'] ?? 0, 
            tourId: json['tourId'],
            status: json['status'],
        );
    }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'priceAdult': priceAdult,
      'priceChildren': priceChildren,
      'availableSlots': availableSlots,
      if (tourId != null) 'tourId': tourId,
      if (status != null) 'status': status,
    };
  }
}
