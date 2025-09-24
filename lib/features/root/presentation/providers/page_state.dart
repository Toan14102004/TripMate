// ignore_for_file: must_be_immutable
abstract class PageState {}

final class PageInitial extends PageState {
  int selectedIndex = 0;
  PageInitial({
    required this.selectedIndex,
  });
}
