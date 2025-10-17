// TODO: MyTrip 기능에 대한 유스케이스를 정의하세요.
import 'package:dartz/dartz.dart';
import 'package:trip_mate/core/configs/usecases/usecase.dart';
import 'package:trip_mate/features/my_trip/domain/repositories/my_trip_repository.dart';
import 'package:trip_mate/service_locator.dart';

class GetMyTripToursUseCase extends UseCase<Either, dynamic> {
  @override
  Future<Either> call({params}) async {
    return await sl<MyTripRepository>().getMyTrips();
  }
}