// MyTrip Cubit for managing MyTrip tours state
import 'package:bloc/bloc.dart';
import 'package:trip_mate/core/ultils/toast_util.dart';
import 'package:trip_mate/features/my_trip/data/dtos/trip_dto.dart';
import 'package:trip_mate/features/my_trip/domain/usecases/get_my_trip_usecase.dart';
import 'package:trip_mate/features/my_trip/presentation/providers/my_trip_state.dart';
import 'package:trip_mate/service_locator.dart';

class MyTripCubit extends Cubit<MyTripState> {
  MyTripCubit() : super(MyTripLoading());

  Future<void> initialize() async {
    // Emit loading state unless already loading
    if (state is! MyTripLoading) {
      emit(MyTripLoading());
    }
    
    final result = await sl<GetMyTripToursUseCase>().call();

    result.fold(
      (left) {
        ToastUtil.showErrorToast(left);
        emit(MyTripError(message: left));
      },
      (right) {
        List<TripDto> myTrip = right as List<TripDto>;

        emit(MyTripToursData(tours: myTrip.map((e) => e.toEntity()).toList()));
      },
    );
  }

  Future<void> removeTour(int tourId) async {
    if (state is MyTripToursData) {
      final currentState = state as MyTripToursData;
      final updatedTours = currentState.tours
          .where((tour) => tour.id != tourId)
          .toList();
      
      emit(MyTripToursData(tours: updatedTours));
    }
  }

  Future<void> refreshTours() async {
    await initialize();
  }
}