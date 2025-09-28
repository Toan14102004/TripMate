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
import 'package:trip_mate/service_locator.dart';
import 'package:trip_mate/services/location_service.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _floatingController;
  late AnimationController _particleController;
  late AnimationController _waveController;

  late Animation<double> _headerAnimation;
  late Animation<double> _avatarScaleAnimation;
  late Animation<double> _waveAnimation;

  String _currentCity = "Đang tải...";
  final LocationService _locationService = LocationService();

  @override
  void initState() {
    super.initState();

    _mainController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _floatingController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _particleController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();

    _waveController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();

    _headerAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.3, 1.0, curve: Curves.bounceOut),
      ),
    );

    _avatarScaleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.5, 1.0, curve: Curves.elasticOut),
      ),
    );

    _waveAnimation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(_waveController);

    _mainController.forward();
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
    _floatingController.dispose();
    _particleController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double customDrawerWidth = screenWidth * 0.9;
    final isDark = context.isDarkMode;
    return Drawer(
      width: customDrawerWidth,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors:
                isDark
                    ? [
                      const Color(0xFF1E3C72),
                      const Color(0xFF2A5298),
                      const Color(0xFF3498DB),
                      const Color(0xFF74B9FF),
                    ]
                    : [
                      const Color(0xFF3498DB),
                      const Color(0xFF74B9FF),
                      const Color.fromARGB(255, 151, 189, 255),
                      const Color.fromARGB(255, 166, 196, 252),
                    ],
          ),
        ),
        child: Stack(
          children: [
            // Animated background particles
            AnimatedBuilder(
              animation: _particleController,
              builder: (context, child) {
                return CustomPaint(
                  painter: ParticlePainter(_particleController.value),
                  size: Size.infinite,
                );
              },
            ),

            // Animated wave background
            AnimatedBuilder(
              animation: _waveController,
              builder: (context, child) {
                return CustomPaint(
                  painter: WavePainter(_waveAnimation.value),
                  size: Size.infinite,
                );
              },
            ),

            // Main content
            ListView(
              padding: EdgeInsets.zero,
              children: [
                // Dynamic animated header
                _buildDynamicHeader(),

                const SizedBox(height: 30),

                // Floating menu items with various effects
                ...List.generate(_menuItems.length, (index) {
                  return TweenAnimationBuilder<double>(
                    duration: Duration(milliseconds: 800 + (index * 100)),
                    tween: Tween(begin: 0.0, end: 1.0),
                    curve: Curves.elasticOut,
                    builder: (context, value, child) {
                      return Transform.translate(
                        offset: Offset((1 - value) * 200, 0),
                        child: Transform.scale(
                          scale: value,
                          child: Opacity(
                            opacity: value.clamp(0.0, 1.0),
                            child: FloatingMenuItem(
                              title: _menuItems[index]['title']!,
                              icon: _menuItems[index]['icon']! as IconData,
                              color: _menuItems[index]['color']! as Color,
                              onTap: _menuItems[index]['action']!,
                              delay: Duration(milliseconds: index * 50),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),

                const SizedBox(height: 40),

                // Animated divider with sparkle effect
                Center(
                  child: AnimatedBuilder(
                    animation: _floatingController,
                    builder: (context, child) {
                      return Container(
                        width: 150,
                        height: 2,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Colors.white.withOpacity(0.8),
                              Colors.yellow.withOpacity(0.6),
                              Colors.white.withOpacity(0.8),
                              Colors.transparent,
                            ],
                            stops: [
                              0.0,
                              0.4 + (_floatingController.value * 0.2),
                              0.5,
                              0.6 + (_floatingController.value * 0.2),
                              1.0,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.5),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 30),

                // Animated logout button
                TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 1000),
                  tween: Tween(begin: 0.0, end: 1.0),
                  curve: Curves.bounceOut,
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

                const SizedBox(height: 50),
              ],
            ),

            // Floating travel icons
            ...List.generate(5, (index) {
              return AnimatedBuilder(
                animation: _floatingController,
                builder: (context, child) {
                  final icons = [
                    Icons.flight,
                    Icons.hotel,
                    Icons.restaurant,
                    Icons.camera_alt,
                    Icons.map,
                  ];
                  final positions = [
                    const Offset(50, 300),
                    const Offset(300, 250),
                    const Offset(80, 450),
                    const Offset(250, 400),
                    const Offset(150, 350),
                  ];

                  return Positioned(
                    left:
                        positions[index].dx +
                        (math.sin(
                              _floatingController.value * 2 * math.pi + index,
                            ) *
                            10),
                    top:
                        positions[index].dy +
                        (math.cos(
                              _floatingController.value * 2 * math.pi + index,
                            ) *
                            15),
                    child: Opacity(
                      opacity: 0.1,
                      child: Icon(icons[index], size: 40, color: Colors.white),
                    ),
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildDynamicHeader() {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileData) {
          if(state.email.isEmpty && state.fullname.isEmpty){
            context.read<ProfileCubit>().initialize();
          }
          return AnimatedBuilder(
            animation: _headerAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _headerAnimation.value,
                child: Stack(
                  children: [
                    // Gradient overlay
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.3),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),

                    // Animated geometric shapes
                    ...List.generate(3, (index) {
                      return AnimatedBuilder(
                        animation: _floatingController,
                        builder: (context, child) {
                          return Positioned(
                            right: 20 + (index * 30),
                            top:
                                40 +
                                (index * 20) +
                                (math.sin(
                                      _floatingController.value * 2 * math.pi +
                                          index,
                                    ) *
                                    10),
                            child: Transform.rotate(
                              angle: _floatingController.value * 2 * math.pi,
                              child: Container(
                                width: 20 + (index * 5),
                                height: 20 + (index * 5),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withOpacity(
                                      (0.3 - (index * 0.1)).clamp(0.0, 1.0),
                                    ),
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }),

                    // User content
                    Padding(
                      padding: const EdgeInsets.all(25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 60),

                          // Animated avatar with pulse effect
                          Center(
                            child: ScaleTransition(
                              scale: _avatarScaleAnimation,
                              child: AnimatedBuilder(
                                animation: _floatingController,
                                builder: (context, child) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.white.withOpacity(0.4),
                                          blurRadius:
                                              20 +
                                              (_floatingController.value * 10),
                                          spreadRadius:
                                              5 +
                                              (_floatingController.value * 3),
                                        ),
                                        BoxShadow(
                                          color: AppColors.blue.withOpacity(
                                            0.3,
                                          ),
                                          blurRadius: 30,
                                          spreadRadius: 10,
                                        ),
                                      ],
                                    ),
                                    child: CircleAvatar(
                                      radius: 45,
                                      backgroundColor: Colors.white,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white.withOpacity(
                                              0.5,
                                            ),
                                            width: 3,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.person_rounded,
                                          color: AppColors.blue,
                                          size: 40,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),

                          const SizedBox(height: 25),

                          // Animated text with typewriter effect
                          Center(
                            child: SingleChildScrollView(
                              physics: const NeverScrollableScrollPhysics(),
                              child: Column(
                                children: [
                                  TweenAnimationBuilder<int>(
                                    duration: const Duration(
                                      milliseconds: 1500,
                                    ),
                                    tween: IntTween(
                                      begin: 0,
                                      end: state.fullname.length,
                                    ),
                                    builder: (context, value, child) {
                                      return Text(
                                        state.fullname.substring(0, value),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 24,
                                          color: Colors.white,
                                          letterSpacing: 1.2,
                                        ),
                                      );
                                    },
                                  ),

                                  const SizedBox(height: 8),

                                  AnimatedBuilder(
                                    animation: _floatingController,
                                    builder: (context, child) {
                                      return Text(
                                        state.email,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white.withOpacity(
                                            (0.8 +
                                                    (_floatingController.value *
                                                        0.2))
                                                .clamp(0.0, 1.0),
                                          ),
                                          fontWeight: FontWeight.w300,
                                        ),
                                      );
                                    },
                                  ),

                                  const SizedBox(height: 15),

                                  // Travel status badge
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 15,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.orange.withOpacity(0.8),
                                          Colors.pink.withOpacity(0.8),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.orange.withOpacity(0.3),
                                          blurRadius: 10,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.location_on,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          "$_currentCity Explorer",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        } else if(state is ProfileError){
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
      'color': Colors.purple,
      'action':
          () => Navigator.of(
            context,
            rootNavigator: false,
          ).pushNamed(AppRoutes.profilePage),
    },
    {
      'title': 'Notifications',
      'icon': Icons.notifications_none_rounded,
      'color': Colors.orange,
      'action': () {},
    },
    {
      'title': 'My Trips',
      'icon': Icons.map_rounded,
      'color': Colors.green,
      'action':
          () => context.read<PageCubit>().changePage(
            index: PageEnum.myTrip.index,
          ),
    },
    {
      'title': 'Saved Places',
      'icon': Icons.location_on_outlined,
      'color': Colors.red,
      'action':
          () =>
              context.read<PageCubit>().changePage(index: PageEnum.saved.index),
    },
    {
      'title': 'My Wallet',
      'icon': Icons.account_balance_wallet_outlined,
      'color': Colors.blue,
      'action': () {},
    },
    {
      'title': 'Invite Friends',
      'icon': Icons.group_outlined,
      'color': Colors.pink,
      'action': () {},
    },
    {
      'title': 'Help & Support',
      'icon': Icons.help_outline_rounded,
      'color': Colors.teal,
      'action': () {},
    },
  ];
}
