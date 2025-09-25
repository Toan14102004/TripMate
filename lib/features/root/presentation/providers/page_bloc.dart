import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:trip_mate/features/home/presentation/screens/home_screen.dart';
import 'package:trip_mate/features/my_trip/presentation/screens/my_trip_screen.dart';
import 'package:trip_mate/features/root/presentation/providers/page_state.dart';
import 'package:trip_mate/features/saved/presentation/screens/saved_screen.dart';
import 'package:trip_mate/features/settings/presentation/screens/settings_screen.dart';

class PageCubit extends Cubit<PageState> {
  int pageindex = 0;
  PageCubit() : super(PageInitial(selectedIndex: 0));
  List<Widget> get pages => [
    const HomeScreen(),
    const MyTripScreen(),
    const SavedScreen(),
    const SettingsScreen()
  ];
  void changePage({required int index}) {
    pageindex = index;
    emit(PageInitial(selectedIndex: index));
  }
}
