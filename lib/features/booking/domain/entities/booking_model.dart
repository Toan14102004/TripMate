// Model cho Booking Response
class BookingModel {
  final int id;
  final int tourId;
  final int userId;
  final int dateId;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String? address;
  final int numAdults;
  final int numChildren;
  final double totalPrice;
  final String bookingStatus;
  final bool receiveEmail;
  final DateTime createdAt;
  final DateTime? updatedAt;
  
  BookingModel({
    required this.id,
    required this.tourId,
    required this.userId,
    required this.dateId,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    this.address,
    required this.numAdults,
    required this.numChildren,
    required this.totalPrice,
    required this.bookingStatus,
    required this.receiveEmail,
    required this.createdAt,
    this.updatedAt,
  });
  
  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] ?? 0,
      tourId: json['tourId'] ?? 0,
      userId: json['userId'] ?? 0,
      dateId: json['dateId'] ?? 0,
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      address: json['address'],
      numAdults: json['numAdults'] ?? 1,
      numChildren: json['numChildren'] ?? 0,
      totalPrice: (json['totalPrice'] ?? 0).toDouble(),
      bookingStatus: json['bookingStatus'] ?? 'pending',
      receiveEmail: json['receiveEmail'] ?? true,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toString()),
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt']) 
          : null,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tourId': tourId,
      'userId': userId,
      'dateId': dateId,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      if (address != null) 'address': address,
      'numAdults': numAdults,
      'numChildren': numChildren,
      'totalPrice': totalPrice,
      'bookingStatus': bookingStatus,
      'receiveEmail': receiveEmail,
      'createdAt': createdAt.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    };
  }
}