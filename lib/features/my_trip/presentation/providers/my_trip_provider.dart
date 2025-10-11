// TODO: MyTrip 기능에 대한 Provider를 구현하세요.
import 'package:flutter/material.dart';
import '../../domain/entities/trip.dart';
import '../../domain/usecases/get_my_trips.dart';

class MyTripProvider extends ChangeNotifier {
  final GetMyTrips getMyTripsUseCase;

  MyTripProvider({required this.getMyTripsUseCase});

  bool _isLoading = false;
  List<Trip> _trips = [];

  bool get isLoading => _isLoading;
  List<Trip> get trips => _trips;

  Future<void> loadTrips() async {
    _isLoading = true;
    notifyListeners();

    _trips = await getMyTripsUseCase.call();

    _isLoading = false;
    notifyListeners();
  }
}
