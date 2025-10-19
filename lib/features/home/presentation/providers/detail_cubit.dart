import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:trip_mate/features/home/domain/models/tour_detail_model.dart';
import 'package:trip_mate/features/home/domain/repositories/home_repository.dart';
import 'package:trip_mate/service_locator.dart';

// Events
abstract class TourDetailEvent extends Equatable {
  const TourDetailEvent();

  @override
  List<Object?> get props => [];
}

class FetchTourDetailEvent extends TourDetailEvent {
  final int tourId;

  const FetchTourDetailEvent(this.tourId);

  @override
  List<Object?> get props => [tourId];
}

// States
abstract class TourDetailState extends Equatable {
  const TourDetailState();

  @override
  List<Object?> get props => [];
}

class TourDetailInitial extends TourDetailState {
  const TourDetailInitial();
}

class TourDetailLoading extends TourDetailState {
  const TourDetailLoading();
}

class TourDetailSuccess extends TourDetailState {
  final TourDetailModel tourDetail;

  const TourDetailSuccess(this.tourDetail);

  @override
  List<Object?> get props => [tourDetail];
}

class TourDetailError extends TourDetailState {
  final String message;

  const TourDetailError(this.message);

  @override
  List<Object?> get props => [message];
}

// Cubit
class TourDetailCubit extends Cubit<TourDetailState> {
  TourDetailCubit() : super(const TourDetailInitial());

  Future<void> fetchTourDetail(int tourId) async {
    emit(const TourDetailLoading());
    try {
      final tourDetail = await sl<HomeRepository>().getTourDetail(tourId);
      emit(TourDetailSuccess(tourDetail));
    } catch (e) {
      emit(TourDetailError(e.toString()));
    }
  }
}
