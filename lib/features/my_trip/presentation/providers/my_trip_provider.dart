// MyTrip Cubit for managing MyTrip tours state
import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trip_mate/commons/log.dart';
import 'package:trip_mate/commons/storage_keys/auth.dart';
import 'package:trip_mate/core/ultils/toast_util.dart';
import 'package:trip_mate/features/my_trip/data/dtos/trip_dto.dart';
import 'package:trip_mate/features/my_trip/domain/usecases/get_my_trip_usecase.dart';
import 'package:trip_mate/features/my_trip/presentation/providers/my_trip_state.dart';
import 'package:trip_mate/service_locator.dart';

class MyTripCubit extends Cubit<MyTripState> {
  MyTripCubit() : super(MyTripLoading());

  static const int _pageLimit = 4;
  String? _cachedUserId;

  Future<String> _getUserId() async {
    if (_cachedUserId != null && _cachedUserId!.isNotEmpty) return _cachedUserId!;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      // Try to get userId from SharedPreferences, fallback to '1' if not found
      _cachedUserId = prefs.getString(AuthKeys.kUserId);
      
      if (_cachedUserId == null || _cachedUserId!.isEmpty) {
        logDebug('UserId not found in SharedPreferences, using fallback: 1');
        _cachedUserId = '1';
      }
      
      return _cachedUserId!;
    } catch (e) {
      logDebug('Error getting userId: $e, using fallback: 1');
      _cachedUserId = '1';
      return _cachedUserId!;
    }
  }

  Future<void> initialize({String bookingStatus = 'pending'}) async {
    // Emit loading state unless already loading
    if (state is! MyTripLoading) {
      emit(MyTripLoading());
    }
    
    final userId = await _getUserId();
    final result = await sl<GetMyTripToursUseCase>().call(
      userId: userId,
      bookingStatus: bookingStatus,
      page: 1,
      limit: _pageLimit,
    );

    // Check if cubit is still active before emitting
    if (isClosed) return;

    result.fold(
      (left) {
        ToastUtil.showErrorToast(left);
        if (!isClosed) {
          emit(MyTripError(message: left));
        }
      },
      (right) {
        List<TripDto> myTrip = right as List<TripDto>;
        final tours = myTrip.map((e) => e.toEntity()).toList();
        final hasMore = tours.length >= _pageLimit;
        
        if (!isClosed) {
          emit(MyTripToursData(
            tours: tours,
            bookingStatus: bookingStatus,
            currentPage: 1,
            hasMore: hasMore,
            isLoadingMore: false,
          ));
        }
      },
    );
  }

  Future<void> changeTab(String bookingStatus) async {
    if (!isClosed) {
      emit(MyTripLoading());
    }
    await initialize(bookingStatus: bookingStatus);
  }

  Future<void> loadMore() async {
    if (isClosed || state is! MyTripToursData) return;
    
    final currentState = state as MyTripToursData;
    
    // Prevent multiple simultaneous load more requests
    if (currentState.isLoadingMore || !currentState.hasMore) {
      logDebug('Load more prevented: isLoadingMore=${currentState.isLoadingMore}, hasMore=${currentState.hasMore}');
      return;
    }

    // Set loading more flag
    if (!isClosed) {
      emit(currentState.copyWith(isLoadingMore: true));
    }

    final nextPage = currentState.currentPage + 1;
    logDebug('Loading page $nextPage with status ${currentState.bookingStatus}');

    final userId = await _getUserId();
    final result = await sl<GetMyTripToursUseCase>().call(
      userId: userId,
      bookingStatus: currentState.bookingStatus,
      page: nextPage,
      limit: _pageLimit,
    );

    // Check if cubit is still active before emitting
    if (isClosed) return;

    result.fold(
      (left) {
        // On error, keep current state but stop loading
        ToastUtil.showErrorToast(left);
        if (!isClosed) {
          emit(currentState.copyWith(
            isLoadingMore: false,
            hasMore: false,
          ));
        }
      },
      (right) {
        List<TripDto> newTrips = right as List<TripDto>;
        final newTours = newTrips.map((e) => e.toEntity()).toList();
        
        // Merge new tours with existing tours
        final allTours = [...currentState.tours, ...newTours];
        
        // Check if there are more items to load
        final hasMore = newTours.length >= _pageLimit;
        
        logDebug('Loaded ${newTours.length} trips, total: ${allTours.length}, hasMore: $hasMore');
        
        if (!isClosed) {
          emit(MyTripToursData(
            tours: allTours,
            bookingStatus: currentState.bookingStatus,
            currentPage: nextPage,
            hasMore: hasMore,
            isLoadingMore: false,
          ));
        }
      },
    );
  }

  Future<void> removeTour(String tourId) async {
    if (state is MyTripToursData) {
      final currentState = state as MyTripToursData;
      final updatedTours = currentState.tours
          .where((tour) => tour.id != tourId)
          .toList();
      
      emit(currentState.copyWith(tours: updatedTours));
    }
  }

  Future<void> refreshTours() async {
    if (state is MyTripToursData) {
      final currentState = state as MyTripToursData;
      await initialize(bookingStatus: currentState.bookingStatus);
    } else {
      await initialize();
    }
  }
}
