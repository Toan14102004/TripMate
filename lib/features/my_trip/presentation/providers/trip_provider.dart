import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_mate/features/my_trip/data/repositories/trip_repository.dart';
import '../../domain/entities/trip.dart';
import '../../domain/usecases/get_my_trips.dart';
import '../../data/sources/trip_remote_source.dart';
import '../../data/sources/trip_local_source.dart';
import '../../data/repositories/my_trip_repository_impl.dart';
import '../../domain/repositories/my_trip_repository.dart';

// Provider này cung cấp một instance của MyTripRepository.
// Các lớp khác sẽ phụ thuộc vào lớp trừu tượng (MyTripRepository),
// không phải lớp thực thi (MyTripRepositoryImpl).
final myTripRepositoryProvider = Provider<MyTripRepository>((ref) {
  // Trả về lớp thực thi ở đâya
  return MyTripRepositoryImpl(
    remote: TripRemoteSource(),
    local: TripLocalSource(),
  );
});

// Provider này cung cấp use case 'GetMyTrips'.
// Nó phụ thuộc vào myTripRepositoryProvider.
final getMyTripsProvider = Provider<GetMyTrips>((ref) {
  // Đọc repository từ provider ở trên
  final repo = ref.read(myTripRepositoryProvider);
  // Khởi tạo use case với repository
  return GetMyTrips(repo as TripRepository);
});

// StateNotifierProvider quản lý trạng thái của danh sách chuyến đi (loading, data, error).
final tripListNotifierProvider = StateNotifierProvider<TripListNotifier, AsyncValue<List<Trip>>>((ref) {
  // Đọc use case từ provider ở trên
  final getTrips = ref.read(getMyTripsProvider);
  // Khởi tạo Notifier với use case
  return TripListNotifier(getTrips);
});

// Lớp StateNotifier để quản lý và thông báo các thay đổi về trạng thái.
class TripListNotifier extends StateNotifier<AsyncValue<List<Trip>>> {
  final GetMyTrips _getMyTrips;

  // Constructor nhận vào use case và đặt trạng thái ban đầu là loading.
  TripListNotifier(this._getMyTrips) : super(const AsyncValue.loading()) {
    // Gọi hàm load() ngay khi Notifier được tạo.
    load();
  }

  // Hàm để tải dữ liệu từ use case.
  Future<void> load() async {
    // Đặt lại trạng thái là loading mỗi khi tải lại.
    state = const AsyncValue.loading();
    try {
      // Gọi use case để lấy danh sách chuyến đi.
      final list = await _getMyTrips();
      // Nếu thành công, cập nhật trạng thái với dữ liệu.
      state = AsyncValue.data(list);
    } catch (e, st) {
      // Nếu có lỗi, cập nhật trạng thái với thông tin lỗi.
      state = AsyncValue.error(e, st);
    }
  }
}