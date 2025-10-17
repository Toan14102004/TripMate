import 'package:equatable/equatable.dart';
import 'package:trip_mate/features/my_trip/domain/entities/trip.dart';

class MyTripState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MyTripToursData extends MyTripState {
  final List<Trip> tours;

  MyTripToursData({required this.tours});

  @override
  List<Object?> get props => [tours];

  MyTripToursData copyWith({
    List<Trip>? tours,
  }) {
    return MyTripToursData(
      tours: tours ?? this.tours,
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
