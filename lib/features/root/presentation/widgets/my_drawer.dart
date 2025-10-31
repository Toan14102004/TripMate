import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trip_mate/commons/enum/page_enum.dart';
import 'package:trip_mate/commons/helpers/is_dark_mode.dart';
import 'package:trip_mate/commons/widgets/error_screen.dart';
import 'package:trip_mate/commons/widgets/loading_screen.dart';
import 'package:trip_mate/core/configs/theme/app_colors.dart';
import 'package:trip_mate/features/profile/presentation/providers/profile_bloc.dart';
import 'package:trip_mate/features/profile/presentation/providers/profile_state.dart';
import 'package:trip_mate/features/root/presentation/providers/page_bloc.dart';
import 'package:trip_mate/features/root/presentation/widgets/menu_item.dart';
import 'package:trip_mate/features/root/presentation/widgets/pattern_painter.dart';
import 'dart:math' as math;

import 'package:trip_mate/features/root/presentation/widgets/special_menu_item.dart';
import 'package:trip_mate/features/root/presentation/widgets/wave_painter.dart';
import 'package:trip_mate/routes/app_route.dart';
import 'package:trip_mate/services/location_service.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _headerController;

  late Animation<double> _headerAnimation;
  late Animation<double> _avatarScaleAnimation;

  String _currentCity = "Đang tải...";
  final LocationService _locationService = LocationService();

  @override
  void initState() {
    super.initState();

    _mainController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _headerController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _headerAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _headerController,
        curve: Curves.easeOut,
      ),
    );

    _avatarScaleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: Curves.elasticOut,
      ),
    );

    _mainController.forward();
    _headerController.forward();
    _fetchCity();
  }

  void _fetchCity() async {
    String city = await _locationService.getCurrentCityName();
    setState(() {
      _currentCity = city;
    });
  }

  @override
  void dispose() {
    _mainController.dispose();
    _headerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double customDrawerWidth = screenWidth * 0.85;
    final isDark = context.isDarkMode;
    
    return Drawer(
      width: customDrawerWidth,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A1A2E) : Colors.white,
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            _buildSimplifiedHeader(),

            const SizedBox(height: 20),

            ...List.generate(_menuItems.length, (index) {
              return TweenAnimationBuilder<double>(
                duration: Duration(milliseconds: 600 + (index * 50)),
                tween: Tween(begin: 0.0, end: 1.0),
                curve: Curves.easeOut,
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset((1 - value) * 100, 0),
                    child: Opacity(
                      opacity: value,
                      child: FloatingMenuItem(
                        title: _menuItems[index]['title']!,
                        icon: _menuItems[index]['icon']! as IconData,
                        color: _menuItems[index]['color']! as Color,
                        onTap: _menuItems[index]['action']!,
                        delay: Duration(milliseconds: index * 30),
                      ),
                    ),
                  );
                },
              );
            }),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Divider(
                color: isDark ? Colors.white.withOpacity(0.1) : Colors.grey.withOpacity(0.2),
                thickness: 1,
              ),
            ),

            const SizedBox(height: 20),

            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 800),
              tween: Tween(begin: 0.0, end: 1.0),
              curve: Curves.easeOut,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: SpecialMenuItem(
                    title: 'Sign Out',
                    icon: Icons.logout_rounded,
                    onTap: () => context.read<ProfileCubit>().logout(),
                  ),
                );
              },
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildSimplifiedHeader() {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileData) {
          if (state.email.isEmpty && state.fullname.isEmpty) {
            context.read<ProfileCubit>().initialize();
          }
          return AnimatedBuilder(
            animation: _headerAnimation,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary,
                      AppColors.primary.withOpacity(0.8),
                    ],
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    
                    Center(
                      child: ScaleTransition(
                        scale: _avatarScaleAnimation,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 15,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.white,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.primary.withOpacity(0.3),
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.person_rounded,
                                color: AppColors.primary,
                                size: 35,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Center(
                      child: Column(
                        children: [
                          Text(
                            state.fullname,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),

                          const SizedBox(height: 6),

                          Text(
                            state.email,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white.withOpacity(0.85),
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),

                          const SizedBox(height: 12),

                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.location_on_rounded,
                                  color: Colors.white,
                                  size: 14,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _currentCity,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              );
            },
          );
        } else if (state is ProfileError) {
          return TravelErrorScreen(
            errorMessage: state.message,
            onRetry: () => context.read<ProfileCubit>().initialize(),
            onGoBack: () => Navigator.of(context).pop(),
          );
        }
        return const TravelLoadingScreen();
      },
    );
  }

  List<Map<String, dynamic>> get _menuItems => [
    {
      'title': 'My Profile',
      'icon': Icons.person_outline_rounded,
      'color': AppColors.primary,
      'action':
          () => Navigator.of(
            context,
            rootNavigator: false,
          ).pushNamed(AppRoutes.profilePage),
    },
    {
      'title': 'Notifications',
      'icon': Icons.notifications_none_rounded,
      'color': const Color(0xFFFF9800),
      'action': () {},
    },
    {
      'title': 'My Trips',
      'icon': Icons.map_rounded,
      'color': const Color(0xFF4CAF50),
      'action':
          () => context.read<PageCubit>().changePage(
            index: PageEnum.myTrip.index,
          ),
    },
    {
      'title': 'Saved Places',
      'icon': Icons.location_on_outlined,
      'color': const Color(0xFFE53935),
      'action':
          () =>
              context.read<PageCubit>().changePage(index: PageEnum.saved.index),
    },
    {
      'title': 'My Wallet',
      'icon': Icons.account_balance_wallet_outlined,
      'color': AppColors.primary,
      'action': () {},
    },
    {
      'title': 'Invite Friends',
      'icon': Icons.group_outlined,
      'color': const Color(0xFFE91E63),
      'action': () {},
    },
    {
      'title': 'Help & Support',
      'icon': Icons.help_outline_rounded,
      'color': const Color(0xFF009688),
      'action': () {},
    },
  ];
}
