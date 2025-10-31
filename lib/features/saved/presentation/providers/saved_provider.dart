// Saved Cubit for managing saved tours state
import 'package:bloc/bloc.dart';
import 'package:trip_mate/core/ultils/toast_util.dart';
import 'package:trip_mate/features/saved/domain/usecases/saved_usecase.dart';
import 'package:trip_mate/features/saved/presentation/providers/saved_state.dart';
import 'package:trip_mate/service_locator.dart';

class SavedCubit extends Cubit<SavedState> {
  SavedCubit() : super(SavedLoading());

  Future<void> initialize() async {
    // Emit loading state unless already loading
    if (state is! SavedLoading) {
      emit(SavedLoading());
    }
    
    final result = await sl<GetSavedToursUseCase>().call();

    result.fold(
      (left) {
        ToastUtil.showErrorToast(left);
        emit(SavedError(message: left));
      },
      (right) {
        emit(right as SavedToursData);
      },
    );
  }

  Future<void> removeTour(int tourId) async {
    if (state is SavedToursData) {
      final currentState = state as SavedToursData;
      final updatedTours = currentState.tours
          .where((tour) => tour.tourId != tourId)
          .toList();
      
      emit(SavedToursData(tours: updatedTours));
    }
  }

  Future<void> refreshTours() async {
    await initialize();
  }
}
