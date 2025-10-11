// TODO: MyTrip 기능에 대한 리포지토리 인터페이스를 정의하세요.
import '../entities/trip.dart';

abstract class MyTripRepository {
  Future<List<Trip>> getMyTrips();
}
