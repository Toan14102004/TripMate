import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:trip_mate/features/home/domain/models/tour_detail_model.dart';
import 'package:trip_mate/features/home/domain/models/hashtag_model.dart';
import 'package:trip_mate/features/home/domain/models/review_model.dart';
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
  final List<HashtagModel> hashtags;
  final List<ReviewModel> reviews;

  const TourDetailSuccess(this.tourDetail, this.hashtags, this.reviews);

  @override
  List<Object?> get props => [tourDetail, hashtags, reviews];
}

class TourDetailError extends TourDetailState {
  final String message;

  const TourDetailError(this.message);

  @override
  List<Object?> get props => [message];
}

class ReviewSubmitting extends TourDetailState {
  final TourDetailModel tourDetail;
  final List<HashtagModel> hashtags;
  final List<ReviewModel> reviews;

  const ReviewSubmitting(this.tourDetail, this.hashtags, this.reviews);

  @override
  List<Object?> get props => [tourDetail, hashtags, reviews];
}

class ReviewSubmitted extends TourDetailState {
  final TourDetailModel tourDetail;
  final List<HashtagModel> hashtags;
  final List<ReviewModel> reviews;

  const ReviewSubmitted(this.tourDetail, this.hashtags, this.reviews);

  @override
  List<Object?> get props => [tourDetail, hashtags, reviews];
}

// Cubit
class TourDetailCubit extends Cubit<TourDetailState> {
  TourDetailCubit() : super(const TourDetailInitial());

  Future<void> fetchTourDetail(int tourId) async {
    emit(const TourDetailLoading());
    try {
      final tourDetail = await sl<HomeRepository>().getTourDetail(tourId);
      final hashtags = await sl<HomeRepository>().getTourHashtags(tourId);
      final reviews = await sl<HomeRepository>().getTourReviews(tourId);
      
      emit(TourDetailSuccess(tourDetail, hashtags, reviews));
    } catch (e) {
      emit(TourDetailError(e.toString()));
    }
  }

  Future<void> submitReview({
    required int tourId,
    required int userId,
    required int rating,
    required String comment,
  }) async {
    if (state is! TourDetailSuccess) return;
    
    final currentState = state as TourDetailSuccess;
    emit(ReviewSubmitting(currentState.tourDetail, currentState.hashtags, currentState.reviews));
    
    try {
      final newReview = await sl<HomeRepository>().submitReview(
        tourId: tourId,
        userId: userId,
        rating: rating,
        comment: comment,
      );
      
      final updatedReviews = [newReview, ...currentState.reviews];
      emit(ReviewSubmitted(currentState.tourDetail, currentState.hashtags, updatedReviews));
      
      // Return to success state after a short delay
      await Future.delayed(const Duration(milliseconds: 500));
      emit(TourDetailSuccess(currentState.tourDetail, currentState.hashtags, updatedReviews));
    } catch (e) {
      emit(TourDetailError(e.toString()));
      await Future.delayed(const Duration(milliseconds: 500));
      emit(TourDetailSuccess(currentState.tourDetail, currentState.hashtags, currentState.reviews));
    }
  }
}
