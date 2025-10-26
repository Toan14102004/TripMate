import 'package:equatable/equatable.dart';
import 'package:trip_mate/features/my_trip/domain/entities/trip.dart';

class MyTripState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MyTripToursData extends MyTripState {
  final List<Trip> tours;
  final String bookingStatus;
  final int currentPage;
  final bool hasMore;
  final bool isLoadingMore;

  MyTripToursData({
    required this.tours,
    this.bookingStatus = 'pending',
    this.currentPage = 1,
    this.hasMore = true,
    this.isLoadingMore = false,
  });

  @override
  List<Object?> get props => [tours, bookingStatus, currentPage, hasMore, isLoadingMore];

  MyTripToursData copyWith({
    List<Trip>? tours,
    String? bookingStatus,
    int? currentPage,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return MyTripToursData(
      tours: tours ?? this.tours,
      bookingStatus: bookingStatus ?? this.bookingStatus,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class MyTripLoading extends MyTripState {}

// ignore: must_be_immutable
class MyTripError extends MyTripState {
  String message;
  
  MyTripError({required this.message});
  
  @override
  List<Object?> get props => [message];
}
