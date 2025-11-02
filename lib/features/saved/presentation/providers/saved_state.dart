import 'package:equatable/equatable.dart';
import 'package:trip_mate/features/saved/domain/models/saved_tour_model.dart';

class SavedState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SavedToursData extends SavedState {
  final List<SavedTourModel> tours;
  final int currentPage;
  final bool hasMore;
  final bool isLoadingMore;

  SavedToursData({
    required this.tours,
    this.currentPage = 1,
    this.hasMore = true,
    this.isLoadingMore = false,
  });

  @override
  List<Object?> get props => [tours, currentPage, hasMore, isLoadingMore];

  SavedToursData copyWith({
    List<SavedTourModel>? tours,
    int? currentPage,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return SavedToursData(
      tours: tours ?? this.tours,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class SavedLoading extends SavedState {}

// ignore: must_be_immutable
class SavedError extends SavedState {
  String message;
  
  SavedError({required this.message});
  
  @override
  List<Object?> get props => [message];
}
