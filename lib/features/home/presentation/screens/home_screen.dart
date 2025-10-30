import 'package:flutter/material.dart';
import '../../../../routes/app_route.dart';
import '../../../../core/configs/theme/app_colors.dart';
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 3) {
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
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HomeAppBar(),
              const SizedBox(height: 24),
              Text(
                "Explore The\nBeautiful World!",
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: AppColors.black,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ) ?? const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const SearchBarWidget(),
              const SizedBox(height: 24),
              const PackageSection(),
              const SizedBox(height: 24),
              const PopularPackageSection(),
              const SizedBox(height: 24),
              const TopPackageSection(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
