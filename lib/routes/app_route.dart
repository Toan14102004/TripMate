import 'package:flutter/material.dart';
class AppRoutes {
  // Khai báo tên các route dưới dạng hằng số
  //static const String started_page = '/started_page';
  // onGenerateRoute dùng để định nghĩa các route động
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      // case displayed_song:
      //   final args = settings.arguments as SongEntity;
      //   return MaterialPageRoute(
      //     builder: (context) =>
      //         SongPlayer(displayed_song: args, isnewSong: true),
      //   );
      default:
    }
    return null;
  }

  // Khai báo các route tĩnh
  static Map<String, WidgetBuilder> routes = {
    // started_page: (context) => const GetStartedPage(),
  };
}
