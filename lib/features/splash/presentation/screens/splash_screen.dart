import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trip_mate/commons/check_sign_in.dart';
import 'dart:math' as math;
import 'package:trip_mate/core/configs/theme/app_colors.dart';
import 'package:trip_mate/features/profile/presentation/providers/profile_bloc.dart';
import 'package:trip_mate/features/wallet/presentation/providers/wallet_provider.dart';
import 'package:trip_mate/routes/app_route.dart';

class TravelSplashScreen extends StatefulWidget {
  const TravelSplashScreen({super.key});

  @override
  _TravelSplashScreenState createState() => _TravelSplashScreenState();
}

class _TravelSplashScreenState extends State<TravelSplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _rotateController;
  late AnimationController _slideController;
  late AnimationController _pulseController;
  
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _scaleController = AnimationController(
      duration: Duration(milliseconds: 1800),
      vsync: this,
    );
    
    _rotateController = AnimationController(
      duration: Duration(seconds: 8),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeOutCubic,
    ));

    _rotateAnimation = Tween<double>(
      begin: 0.0,
      end: 2.0 * math.pi,
    ).animate(CurvedAnimation(
      parent: _rotateController,
      curve: Curves.linear,
    ));

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _pulseAnimation = Tween<double>(
      begin: 0.9,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _startAnimations();
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    await Future.delayed(const Duration(seconds: 4));
    if(await checkSignIn()){
      context.read<ProfileCubit>().initialize();
      context.read<WalletCubit>().initialize();
      Navigator.of(context).pushNamed(AppRoutes.rootPage);
    }
    else {
      Navigator.of(context).pushNamed(AppRoutes.onboarding);
    }
  }

  void _startAnimations() async {
    await Future.delayed(Duration(milliseconds: 300));
    _fadeController.forward();
    
    await Future.delayed(Duration(milliseconds: 400));
    _scaleController.forward();
    _slideController.forward();
    
    await Future.delayed(Duration(milliseconds: 800));
    _rotateController.repeat();
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    _rotateController.dispose();
    _slideController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary.withOpacity(0.95),
              AppColors.primaryDark.withOpacity(0.9),
              AppColors.black,
            ],
          ),
        ),
        child: Stack(
          children: [
            _buildBackgroundElements(),
            
            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Globe with modern design
                  _buildModernGlobe(),
                  
                  const SizedBox(height: 60),
                  
                  // App title and subtitle
                  _buildTitleSection(),
                  
                  const SizedBox(height: 80),
                  
                  // Loading indicator
                  _buildLoadingSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundElements() {
    return Stack(
      children: [
        // Animated circles in background
        Positioned(
          top: -100,
          right: -100,
          child: AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withOpacity(0.1 * _pulseAnimation.value),
                ),
              );
            },
          ),
        ),
        Positioned(
          bottom: -80,
          left: -80,
          child: AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.secondary.withOpacity(0.08 * _pulseAnimation.value),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildModernGlobe() {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _scaleAnimation,
        _rotateAnimation,
        _pulseAnimation,
      ]),
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Transform.rotate(
            angle: _rotateAnimation.value,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primary.withOpacity(0.8),
                    AppColors.primaryDark,
                    AppColors.success.withOpacity(0.6),
                  ],
                  stops: [0.0, 0.6, 1.0],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.6),
                    blurRadius: 40,
                    spreadRadius: 10,
                  ),
                  BoxShadow(
                    color: AppColors.secondary.withOpacity(0.3),
                    blurRadius: 60,
                    spreadRadius: 15,
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Continents
                  Positioned(
                    top: 20,
                    left: 18,
                    child: Container(
                      width: 28,
                      height: 22,
                      decoration: BoxDecoration(
                        color: AppColors.success.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 15,
                    right: 22,
                    child: Container(
                      width: 18,
                      height: 14,
                      decoration: BoxDecoration(
                        color: AppColors.success.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 22,
                    left: 28,
                    child: Container(
                      width: 25,
                      height: 18,
                      decoration: BoxDecoration(
                        color: AppColors.success.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 28,
                    right: 32,
                    child: Container(
                      width: 14,
                      height: 12,
                      decoration: BoxDecoration(
                        color: AppColors.success.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  // Glow effect
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.white.withOpacity(0.2),
                        width: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTitleSection() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Column(
          children: [
            Text(
              'TripMate',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.w800,
                color: AppColors.white,
                letterSpacing: 2,
                shadows: [
                  Shadow(
                    offset: const Offset(0, 4),
                    blurRadius: 20,
                    color: AppColors.primary.withOpacity(0.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Khám phá thế giới',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.white.withOpacity(0.85),
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              width: 60,
              height: 3,
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingSection() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        children: [
          SizedBox(
            width: 50,
            height: 50,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.secondary),
              strokeWidth: 3.5,
              backgroundColor: AppColors.white.withOpacity(0.15),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Đang chuẩn bị hành trình...',
            style: TextStyle(
              color: AppColors.white.withOpacity(0.8),
              fontSize: 15,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}
