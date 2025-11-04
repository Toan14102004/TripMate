// Saved Cubit for managing saved tours state
import 'package:bloc/bloc.dart';
import 'package:trip_mate/commons/log.dart';
import 'package:trip_mate/core/ultils/toast_util.dart';
import 'package:trip_mate/features/saved/domain/usecases/saved_usecase.dart';
import 'package:trip_mate/features/saved/presentation/providers/saved_state.dart';
import 'package:trip_mate/service_locator.dart';

class SavedCubit extends Cubit<SavedState> {
  SavedCubit() : super(SavedLoading());

  static const int _pageLimit = 4;

  Future<void> initialize() async {
    // Emit loading state unless already loading
    if (state is! SavedLoading) {
      emit(SavedLoading());
    }
    
    final result = await sl<GetSavedToursUseCase>().call(
      page: 1,
      limit: _pageLimit,
    );

    result.fold(
      (left) {
        ToastUtil.showErrorToast(left);
        emit(SavedError(message: left));
      },
      (right) {
        final data = right as SavedToursData;
        // Check if there are more items to load
        final hasMore = data.tours.length >= _pageLimit;
        emit(data.copyWith(
          currentPage: 1,
          hasMore: hasMore,
          isLoadingMore: false,
        ));
      },
    );
  }

  Future<void> loadMore() async {
    if (state is! SavedToursData) return;
    
    final currentState = state as SavedToursData;
    
    // Prevent multiple simultaneous load more requests
    if (currentState.isLoadingMore || !currentState.hasMore) {
      logDebug('Load more prevented: isLoadingMore=${currentState.isLoadingMore}, hasMore=${currentState.hasMore}');
      return;
    }

    // Set loading more flag
    emit(currentState.copyWith(isLoadingMore: true));

    final nextPage = currentState.currentPage + 1;
    logDebug('Loading page $nextPage');

    final result = await sl<GetSavedToursUseCase>().call(
      page: nextPage,
      limit: _pageLimit,
    );

    result.fold(
      (left) {
        // On error, keep current state but stop loading
        ToastUtil.showErrorToast(left);
        emit(currentState.copyWith(
          isLoadingMore: false,
          hasMore: false,
        ));
      },
      (right) {
        final newData = right as SavedToursData;
        
        // Merge new tours with existing tours
        final allTours = [...currentState.tours, ...newData.tours];
        
        // Check if there are more items to load
        final hasMore = newData.tours.length >= _pageLimit;
        
        logDebug('Loaded ${newData.tours.length} tours, total: ${allTours.length}, hasMore: $hasMore');
        
        emit(SavedToursData(
          tours: allTours,
          currentPage: nextPage,
          hasMore: hasMore,
          isLoadingMore: false,
        ));
      },
    );
  }

  Future<void> removeTour(int tourId) async {
    if (state is SavedToursData) {
      final currentState = state as SavedToursData;
      final updatedTours = currentState.tours
          .where((tour) => tour.tourId != tourId)
          .toList();
      
      emit(currentState.copyWith(tours: updatedTours));
    }
  }

  Future<void> refreshTours() async {
    await initialize();
  }
}
