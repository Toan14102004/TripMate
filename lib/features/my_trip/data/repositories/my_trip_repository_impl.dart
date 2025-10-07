// TODO: MyTrip 기능의 리포지토리를 구현하세요.
// Xóa import không cần thiết và có thể gây lỗi
// import 'package:trip_mate/features/my_trip/data/repositories/trip_repository.dart';

// Import lớp abstract (interface) đúng từ domain
import 'package:trip_mate/features/my_trip/domain/repositories/my_trip_repository.dart';

import '../../domain/entities/trip.dart';
import '../dtos/trip_dto.dart';
import '../sources/trip_local_source.dart';
import '../sources/trip_remote_source.dart';

// Sửa lại để implements đúng interface là 'MyTripRepository'
class MyTripRepositoryImpl implements MyTripRepository {
  final TripRemoteSource remote;
  final TripLocalSource local;

  MyTripRepositoryImpl({
    required this.remote,
    required this.local,
  });

  @override
  Future<List<Trip>> getTrips() async {
    try {
      // Lấy dữ liệu mới từ remote
      final dtos = await remote.fetchTrips();
      // Lưu vào cache local
      await local.cacheTrips(dtos);
      // Chuyển đổi DTOs thành Entities và trả về
      return dtos.map((dto) => dto.toEntity()).toList();
    } catch (e) {
      // Nếu có lỗi (ví dụ: không có mạng), thử lấy từ cache
      final cachedDtos = await local.getCachedTrips();
      // Chuyển đổi DTOs từ cache thành Entities và trả về
      return cachedDtos.map((dto) => dto.toEntity()).toList();
    }
  }

  @override
  Future<Trip?> getTripById(String id) async {
    try {
      // Tối ưu: Thử lấy trực tiếp từ remote source trước
      // (Giả sử remote source có phương thức fetchTripById)
      // final dto = await remote.fetchTripById(id);
      // return dto?.toEntity();

      // Cách hiện tại (kém hiệu quả nhưng vẫn hoạt động):
      // Lấy tất cả các chuyến đi và tìm kiếm
      final allTrips = await getTrips();
      // Sử dụng firstWhereOrNull từ collection package để code gọn hơn
      // hoặc giữ nguyên firstWhere với orElse
      try {
        return allTrips.firstWhere((trip) => trip.id == id);
      } catch (e) {
        return null; // Không tìm thấy trip với id tương ứng
      }
    } catch (e) {
      // Nếu có lỗi, trả về null
      return null;
    }
  }
}
