import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trip_mate/commons/helpers/is_dark_mode.dart';
import 'package:trip_mate/commons/log.dart';
import 'package:trip_mate/core/app_global.dart';
import 'package:trip_mate/core/configs/theme/app_colors.dart';
import 'package:trip_mate/features/profile/presentation/providers/profile_bloc.dart';
import 'package:trip_mate/features/profile/presentation/providers/profile_state.dart';
import 'package:trip_mate/features/root/presentation/providers/page_bloc.dart';
import 'package:trip_mate/features/root/presentation/providers/page_state.dart';
import 'package:trip_mate/features/root/presentation/widgets/my_drawer.dart';
import 'package:trip_mate/services/fcm/fcm_service.dart';

final GlobalKey<ScaffoldState> rootScaffoldKey = GlobalKey<ScaffoldState>();

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  _RootScreenState createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _slideAnimation;

  StreamSubscription? _profileSubscription;
  bool _fcmInitialized = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _slideAnimation = Tween<double>(
      begin: -10.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));
    
    _listenToProfileChanges();
  }

  void _listenToProfileChanges() {
    _profileSubscription = context.read<ProfileCubit>().stream.listen((state) {
      if (state is ProfileData && !_fcmInitialized && mounted) {
        _fcmInitialized = true;
        _initFCM(state.userId.toString());
      }
    });

    // Kiểm tra ngay lập tức nếu đã có data
    final currentState = context.read<ProfileCubit>().state;
    if (currentState is ProfileData && !_fcmInitialized) {
      _fcmInitialized = true;
      _initFCM(currentState.userId.toString());
    }
  }

  Future<void> _initFCM(String userId) async {
    try {
      final fcmService = FCMService();
      fcmService.stopListening();
      await fcmService.startListening(
        context: context,
        userId: userId,
        onNotificationTapped: _showMessageDialog,
      );
      if (mounted) {
        logDebug('FCM khởi tạo thành công');
      }
    } catch (e) {
      logDebug('Lỗi FCM: $e');
    }
  }

  void _showMessageDialog(RemoteMessage message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(message.notification?.title ?? 'Thông báo'),
        content: Text(message.notification?.body ?? 'Có tin nhắn mới'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('OK')),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PageCubit, PageState>(
      builder: (context, state) {
        if (state is PageInitial) {
          return Scaffold(
            key: rootScaffoldKey,
            drawer: const MyDrawer(),
            backgroundColor: context.isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
            body: Stack(
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.1, 0),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: IndexedStack(
                    key: ValueKey(state.selectedIndex),
                    index: state.selectedIndex,
                    children: context.read<PageCubit>().pages,
                  ),
                ),
              ],
            ),
            bottomNavigationBar: _buildAnimatedBottomNav(state),
          );
        } else {
          return Scaffold(
            backgroundColor: context.isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
            body: const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildAnimatedBottomNav(PageInitial state) {
    return Container(
      height: 76,
      decoration: BoxDecoration(
        color: context.isDarkMode ? AppColors.black : AppColors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 16,
            offset: const Offset(0, -4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(
            index: 0,
            icon: Icons.home_outlined,
            activeIcon: Icons.home,
            label: 'Home',
            isSelected: state.selectedIndex == 0,
            state: state,
          ),
          _buildNavItem(
            index: 1,
            icon: Icons.map_outlined,
            activeIcon: Icons.map,
            label: 'My Trips',
            isSelected: state.selectedIndex == 1,
            state: state,
          ),
          _buildNavItem(
            index: 2,
            icon: Icons.bookmark_outline,
            activeIcon: Icons.bookmark,
            label: 'Saved',
            isSelected: state.selectedIndex == 2,
            state: state,
          ),
          _buildNavItem(
            index: 3,
            icon: Icons.person_outline,
            activeIcon: Icons.person,
            label: 'Profile',
            isSelected: state.selectedIndex == 3,
            state: state,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required bool isSelected,
    required PageState state,
  }) {
    return GestureDetector(
      onTap: () {
        if (!isSelected) {
          _animationController.forward().then((_) {
            _animationController.reset();
          });
          context.read<PageCubit>().changePage(index: index);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? (AppGlobal.navigatorKey.currentContext!.isDarkMode ? AppColors.primaryDark : AppColors.primaryLight) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.scale(
                  scale: isSelected ? _scaleAnimation.value : 1.0,
                  child: Transform.translate(
                    offset: isSelected ? Offset(0, _slideAnimation.value) : Offset.zero,
                    child: Icon(
                      isSelected ? activeIcon : icon,
                      color: isSelected ? (AppGlobal.navigatorKey.currentContext!.isDarkMode ? AppColors.black : AppColors.primary)  : AppColors.grey400,
                      size: 24,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 3),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: isSelected ? 1.0 : 0.7,
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? (AppGlobal.navigatorKey.currentContext!.isDarkMode ? AppColors.black : AppColors.primary) : AppColors.grey500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
