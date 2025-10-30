import 'package:equatable/equatable.dart';
import 'package:trip_mate/features/saved/domain/models/saved_tour_model.dart';

class SavedState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SavedToursData extends SavedState {
  final List<SavedTourModel> tours;

  SavedToursData({required this.tours});

  @override
  List<Object?> get props => [tours];

  SavedToursData copyWith({
    List<SavedTourModel>? tours,
  }) {
    return SavedToursData(
      tours: tours ?? this.tours,
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
