import 'package:flutter/material.dart';
import '../../../../routes/app_route.dart';
import '../widgets/home_appbar.dart';
import '../widgets/search_bar.dart';
import '../widgets/category_list.dart';
import '../widgets/package_section.dart';
import '../widgets/popular_package_section.dart';
import '../widgets/top_package_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // void _onItemTapped(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //     if (index == 3) { // Nếu chọn tab Settings
  //       Navigator.pushNamed(context, AppRoutes.settings);
  //       // Reset lại selectedIndex sau khi chuyển hướng
  //       Future.delayed(Duration.zero, () {
  //         setState(() {
  //           _selectedIndex = 0;
  //         });
  //       });
  //     }
  //   });
  // }
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 1) { // 👉 My Trip tab
        Navigator.pushNamed(context, AppRoutes.myTrip);
        Future.delayed(Duration.zero, () {
          setState(() {
            _selectedIndex = 0; // reset lại về Home khi quay về
          });
        });
      } else if (index == 3) { // 👉 Settings tab
        Navigator.pushNamed(context, AppRoutes.settings);
        Future.delayed(Duration.zero, () {
          setState(() {
            _selectedIndex = 0;
          });
        });
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              HomeAppBar(),
              SizedBox(height: 20),
              Text(
                "Explore The\nBeautiful World! ✈️",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              SearchBarWidget(),
              SizedBox(height: 20),
              CategoryList(),
              SizedBox(height: 24),
              PackageSection(),
              SizedBox(height: 24),
              PopularPackageSection(),
              SizedBox(height: 24),
              TopPackageSection(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.airplane_ticket), label: "My Trip"),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: "Saved"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),
    );
  }
}