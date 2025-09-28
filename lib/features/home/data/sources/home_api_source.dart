<<<<<<< HEAD
<<<<<<< HEAD
// TODO: Home 기능의 API 소스를 구현하세요.
class HomeApiSource {}
=======
=======

>>>>>>> ab29dfa0fd4c829fe8e3e5893a1c3ccf8a2b065f
// // TODO: Home 기능의 API 소스를 구현하세요.
// import 'package:dio/dio.dart';
// import 'package:trip_mate/features/home/domain/models/tour_model.dart';

// class HomeApiSource {
//   final Dio _dio = Dio();

//   // Lấy danh sách tất cả tour/packages
//   Future<List<TourModel>> fetchAllPackages() async {
//     final response = await _dio.get('https://api-url.com/api/tours');
//     // Parse response về List<TourModel>
//     // return List<TourModel>.from(response.data.map((e) => TourModel.fromJson(e)));
//     // Nếu chưa có API thật, trả về mock data
//     throw UnimplementedError();
//   }

//   // Lấy danh sách popular packages
//   Future<List<TourModel>> fetchPopularPackages() async {
//     final response = await _dio.get('https://api-url.com/api/tours/popular');
//     throw UnimplementedError();
//   }

//   // Lấy danh sách top packages
//   Future<List<TourModel>> fetchTopPackages() async {
//     final response = await _dio.get('https://api-url.com/api/tours/top');
//     throw UnimplementedError();
//   }

//   // Lấy chi tiết một tour/package
//   Future<TourModel> fetchPackageDetail(int tourId) async {
//     final response = await _dio.get('https://api-url.com/api/tours/$tourId');
//     throw UnimplementedError();
//   }
// Future<String> fetchUserAvatarUrl() async {
    // Gọi API lấy thông tin user
    // final response = await http.get(Uri.parse('https://api.com/user/profile'));
    // final data = jsonDecode(response.body);
    // return data['avatarUrl'];
    // Demo: trả về link avatar mẫu
  // return 'https://yourapi.com/path/to/avatar.jpg';
// }
// }


import 'package:dio/dio.dart';
import 'package:trip_mate/features/home/domain/models/tour_model.dart';

class HomeApiSource {
  final Dio _dio = Dio();

  // Lấy danh sách tất cả tour/packages
  Future<List<TourModel>> fetchAllPackages() async {
  
    return [
      TourModel(
        tourId: 1,
        title: 'Apanemo Resort',
        image: 'assets/images/apanemo.png',
        destination: 'East Evritania',
        rating: 4.9,
        reviewCount: 1200,
        price: 90,
      ),
      TourModel(
        tourId: 2,
        title: 'Laguna Resort',
        image: 'assets/images/laguna.png',
        destination: 'Santorini',
        rating: 4.7,
        reviewCount: 900,
        price: 90,
      ),
    ];
  }

  // Lấy danh sách popular packages
  Future<List<TourModel>> fetchPopularPackages() async {
    return [
      TourModel(
        tourId: 3,
        title: 'The Blue House',
        subtitle: '2 days 3 night full package',
        image: 'assets/images/blue_house.png',
        rating: 4.8,
        isBookmarked: false,
      ),
      TourModel(
        tourId: 4,
        title: 'Apanemo Resort',
        subtitle: '3 days 2 night full package',
        image: 'assets/images/apanemo.png',
        rating: 4.9,
        isBookmarked: true,
      ),
    ];
  }

  // Lấy danh sách top packages
  Future<List<TourModel>> fetchTopPackages() async {
    return [
      TourModel(
        tourId: 5,
        title: 'Imperial Luxury Hotel',
        image: 'assets/images/luxury_hotel.png',
        destination: 'Queensland',
        rating: 4.9,
        reviewCount: 7200,
        price: 120,
      ),
      TourModel(
        tourId: 6,
        title: 'Walkabout Beach Hotel',
        image: 'assets/images/walkabout.png',
        destination: 'New Zealand',
        rating: 4.8,
        reviewCount: 6400,
        price: 100,
      ),
      TourModel(
        tourId: 7,
        title: 'Antlers Hilton Resort',
        image: 'assets/images/hilton.png',
        destination: 'Singapore',
        rating: 4.6,
        reviewCount: 3900,
        price: 100,
      ),
    ];
  }

  // Lấy chi tiết một tour/package
  Future<TourModel> fetchPackageDetail(int tourId) async {
    // Dữ liệu cứng tạm thời cho chi tiết
    return TourModel(
      tourId: tourId,
      title: 'The Lind Boracay Resort',
      description: 'The Lind Boracay resort has its own train station and can be reached from either lau spezia or levantonipo. From la spezia, take the local train trendo regionale in the direction of sestrin levante and get off at the first stop. From levanto, take the regional train in direction of la spezia centrale.',
      image: 'assets/images/lind_boracay.png',
      destination: 'East Evritania, Singapore',
      rating: 4.8,
      reviewCount: 8400,
      price: 520,
      subtitle: '2 days 3 night full package',
      isBookmarked: false,
    );
  }

  Future<String> fetchUserAvatarUrl() async {
  // Trả về ảnh 
  return 'assets/images/avatar.png'; 
}
}
<<<<<<< HEAD
>>>>>>> feature/home-screen
=======

>>>>>>> ab29dfa0fd4c829fe8e3e5893a1c3ccf8a2b065f
