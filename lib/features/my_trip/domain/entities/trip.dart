class Trip {
  final String bookingId;
  final String id;
  final String title;
  final String location;
  final String imageUrl;
  final String duration;
  final double rating;

  Trip({
    required this.bookingId,
    required this.id,
    required this.title,
    required this.location,
    required this.imageUrl,
    required this.duration,
    required this.rating,
  });
}


// Models
class BookingDetail {
  final int bookingId;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String address;
  final DateTime bookingDate;
  final int numAdults;
  final int numChildren;
  final double totalPrice;
  final String? codeCoupon;
  final String bookingStatus;
  final bool receiveEmail;
  final TourInfo tour;
  final DateInfo date;

  BookingDetail({
    required this.bookingId,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.bookingDate,
    required this.numAdults,
    required this.numChildren,
    required this.totalPrice,
    this.codeCoupon,
    required this.bookingStatus,
    required this.receiveEmail,
    required this.tour,
    required this.date,
  });

  factory BookingDetail.fromJson(Map<String, dynamic> json) {
    return BookingDetail(
      bookingId: json['bookingId'],
      fullName: json['fullName'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      address: json['address'],
      bookingDate: DateTime.parse(json['bookingDate']),
      numAdults: json['numAdults'],
      numChildren: json['numChildren'],
      totalPrice: double.parse(json['totalPrice'].toString()),
      codeCoupon: json['codeCoupon'],
      bookingStatus: json['bookingStatus'],
      receiveEmail: json['receiveEmail'],
      tour: TourInfo.fromJson(json['tour']),
      date: DateInfo.fromJson(json['date']),
    );
  }
}

class TourInfo {
  final int tourId;
  final String title;
  final String image;
  final String destination;
  final String time;
  final int reviewCount;
  final double starAvg;

  TourInfo({
    required this.tourId,
    required this.title,
    required this.image,
    required this.destination,
    required this.time,
    required this.reviewCount,
    required this.starAvg,
  });

  factory TourInfo.fromJson(Map<String, dynamic> json) {
    return TourInfo(
      tourId: json['tourId'],
      title: json['title'],
      image: json['image'],
      destination: json['destination'],
      time: json['time'],
      reviewCount: json['reviewCount'],
      starAvg: (json['starAvg'] as num).toDouble(),
    );
  }
}

class DateInfo {
  final int dateId;
  final DateTime startDate;
  final DateTime endDate;
  final double priceAdult;
  final double priceChildren;

  DateInfo({
    required this.dateId,
    required this.startDate,
    required this.endDate,
    required this.priceAdult,
    required this.priceChildren,
  });

  factory DateInfo.fromJson(Map<String, dynamic> json) {
    return DateInfo(
      dateId: json['dateId'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      priceAdult: double.parse(json['priceAdult'].toString()),
      priceChildren: double.parse(json['priceChildren'].toString()),
    );
  }
}