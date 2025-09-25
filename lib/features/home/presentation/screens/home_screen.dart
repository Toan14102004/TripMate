import 'package:flutter/material.dart';
import '../widgets/home_appbar.dart';
import '../widgets/search_bar.dart';
import '../widgets/category_list.dart';
import '../widgets/package_section.dart';
import '../widgets/popular_package_section.dart';
import '../widgets/top_package_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
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