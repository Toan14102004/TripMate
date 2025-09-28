import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:trip_mate/core/configs/theme/app_colors.dart';
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
  late AnimationController _handsController;
  late AnimationController _auraController;
  late AnimationController _pulseController;
  
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;
  late Animation<double> _handsAnimation;
  late Animation<double> _auraAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    
    // Khởi tạo các AnimationController
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _scaleController = AnimationController(
      duration: Duration(milliseconds: 2500),
      vsync: this,
    );
    
    _rotateController = AnimationController(
      duration: Duration(seconds: 10),
      vsync: this,
    );
    
    _handsController = AnimationController(
      duration: Duration(milliseconds: 3000),
      vsync: this,
    );
    
    _auraController = AnimationController(
      duration: Duration(seconds: 4),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );

    // Tạo các animation
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    _rotateAnimation = Tween<double>(
      begin: 0.0,
      end: 2.0 * math.pi,
    ).animate(CurvedAnimation(
      parent: _rotateController,
      curve: Curves.linear,
    ));

    _handsAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _handsController,
      curve: Curves.easeInOutCubic,
    ));

    _auraAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _auraController,
      curve: Curves.easeOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    // Bắt đầu animations
    _startAnimations();
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    await Future.delayed(const Duration(seconds: 4));
    if(await checkSignIn()){
      Navigator.of(context).pushNamed(AppRoutes.rootPage);
    }
    else {
      Navigator.of(context).pushNamed(AppRoutes.onBoarding);
    }
    Navigator.of(context).pushNamed(AppRoutes.onboarding);
  }

  void _startAnimations() async {
    await Future.delayed(Duration(milliseconds: 300));
    _fadeController.forward();
    
    await Future.delayed(Duration(milliseconds: 500));
    _scaleController.forward();
    _handsController.forward();
    
    await Future.delayed(Duration(milliseconds: 1000));
    _rotateController.repeat();
    _auraController.repeat();
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    _rotateController.dispose();
    _handsController.dispose();
    _auraController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0F172A), 
              Color(0xFF1E293B), 
              Color(0xFF334155), 
              Color(0xFF475569),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Stars background
            ...List.generate(30, (index) => _buildStar(index)),
            
            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Two hands holding Earth with aura
                  AnimatedBuilder(
                    animation: Listenable.merge([
                      _scaleAnimation,
                      _handsAnimation,
                    ]),
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _scaleAnimation.value,
                        child: Transform.translate(
                          offset: Offset(0, -10 * math.sin(_handsAnimation.value * math.pi)),
                          child: _buildHandsWithEarthAndAura(),
                        ),
                      );
                    },
                  ),
                  
                  const SizedBox(height: 80),
                  
                  // App title
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      children: [
                        Text(
                          'Tralto',
                          style: TextStyle(
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                            letterSpacing: 3,
                            shadows: [
                              Shadow(
                                offset: const Offset(0, 4),
                                blurRadius: 15,
                                color: const Color(0xFF3B82F6).withOpacity(0.6),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          'Thế giới trong vòng tay bạn',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white70,
                            fontStyle: FontStyle.italic,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 100),
                  
                  // Loading indicator
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      children: [
                        SizedBox(
                          width: 40,
                          height: 40,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3B82F6)),
                            strokeWidth: 3,
                            backgroundColor: AppColors.white.withOpacity(0.1),
                          ),
                        ),
                        const SizedBox(height: 25),
                        const Text(
                          'Đang khởi tạo hành trình...',
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 16,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHandsWithEarthAndAura() {
    return SizedBox(
      width: 300,
      height: 280,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Aura effects - outer rings
          ...List.generate(4, (index) => _buildAuraRing(index)),
          
          // Left hand
          AnimatedBuilder(
            animation: _handsAnimation,
            builder: (context, child) {
              return Positioned(
                left: 20 + (10 * _handsAnimation.value),
                bottom: 40,
                child: Transform.rotate(
                  angle: -0.3 + (0.1 * math.sin(_handsAnimation.value * math.pi)),
                  child: Icon(
                    Icons.back_hand,
                    size: 90,
                    color: AppColors.white.withOpacity((0.4 + 0.3 * _handsAnimation.value).clamp(0.0, 1.0)),
                  ),
                ),
              );
            },
          ),
          
          // Right hand
          AnimatedBuilder(
            animation: _handsAnimation,
            builder: (context, child) {
              return Positioned(
                right: 20 + (10 * _handsAnimation.value),
                bottom: 40,
                child: Transform.rotate(
                  angle: 0.3 + (0.1 * math.sin(_handsAnimation.value * math.pi)),
                  child: Transform.scale(
                    scaleX: -1,
                    child: Icon(
                      Icons.back_hand,
                      size: 90,
                      color: AppColors.white.withOpacity((0.4 + 0.3 * _handsAnimation.value).clamp(0.0, 1.0)),
                    ),
                  ),
                ),
              );
            },
          ),
          
          // Earth with rotation and pulse
          AnimatedBuilder(
            animation: Listenable.merge([_rotateAnimation, _pulseAnimation]),
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Transform.rotate(
                  angle: _rotateAnimation.value,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const RadialGradient(
                        colors: [
                          Color(0xFF10B981), // Emerald
                          Color(0xFF059669), // Dark emerald
                          Color(0xFF3B82F6), // Blue
                          Color(0xFF1E40AF), // Dark blue
                        ],
                        stops: [0.0, 0.3, 0.7, 1.0],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF3B82F6).withOpacity(0.6),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                        BoxShadow(
                          color: Color(0xFF10B981).withOpacity(0.4),
                          blurRadius: 50,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // Continents with more detail
                        Positioned(
                          top: 18,
                          left: 15,
                          child: Container(
                            width: 25,
                            height: 18,
                            decoration: BoxDecoration(
                              color: Color(0xFF065F46),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 12,
                          right: 20,
                          child: Container(
                            width: 15,
                            height: 12,
                            decoration: BoxDecoration(
                              color: Color(0xFF065F46),
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 45,
                          right: 12,
                          child: Container(
                            width: 20,
                            height: 15,
                            decoration: BoxDecoration(
                              color: Color(0xFF065F46),
                              borderRadius: BorderRadius.circular(7),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 20,
                          left: 25,
                          child: Container(
                            width: 22,
                            height: 16,
                            decoration: BoxDecoration(
                              color: Color(0xFF065F46),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 25,
                          right: 30,
                          child: Container(
                            width: 12,
                            height: 10,
                            decoration: BoxDecoration(
                              color: Color(0xFF065F46),
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                        // Cloud effects
                        Positioned(
                          top: 30,
                          left: 10,
                          child: Container(
                            width: 30,
                            height: 8,
                            decoration: BoxDecoration(
                              color: AppColors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          
          // Energy particles around earth
          ...List.generate(8, (index) => _buildEnergyParticle(index)),
        ],
      ),
    );
  }

  Widget _buildAuraRing(int index) {
    return AnimatedBuilder(
      animation: _auraAnimation,
      builder: (context, child) {
        double baseSize = 120.0 + (index * 40);
        double animatedSize = baseSize + (20 * math.sin((_auraAnimation.value + index * 0.25) * 2 * math.pi));
        double opacity = ((0.8 - index * 0.15) * (0.5 + 0.5 * math.sin(_auraAnimation.value * 2 * math.pi))).clamp(0.0, 1.0);
        
        return Container(
          width: animatedSize,
          height: animatedSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Color(0xFF3B82F6).withOpacity(opacity * 0.6),
              width: 2,
            ),
            gradient: RadialGradient(
              colors: [
                Colors.transparent,
                Color(0xFF3B82F6).withOpacity(opacity * 0.1),
                Color(0xFF10B981).withOpacity(opacity * 0.2),
                Colors.transparent,
              ],
              stops: [0.0, 0.7, 0.9, 1.0],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEnergyParticle(int index) {
    return AnimatedBuilder(
      animation: _auraAnimation,
      builder: (context, child) {
        double angle = (index * 45.0) * (math.pi / 180);
        double radius = 80 + (15 * math.sin(_auraAnimation.value * 2 * math.pi + index));
        double x = radius * math.cos(angle + _auraAnimation.value * math.pi);
        double y = radius * math.sin(angle + _auraAnimation.value * math.pi);
        
        return Transform.translate(
          offset: Offset(x, y),
          child: Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: index % 2 == 0 ? Color(0xFF3B82F6) : Color(0xFF10B981),
              boxShadow: [
                BoxShadow(
                  color: (index % 2 == 0 ? Color(0xFF3B82F6) : Color(0xFF10B981)).withOpacity(0.8),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStar(int index) {
    return AnimatedBuilder(
      animation: _auraAnimation,
      builder: (context, child) {
        double opacity = (0.5 + 0.4 * math.sin((_auraAnimation.value + index * 0.1) * 2 * math.pi)).clamp(0.0, 1.0);
        
        return Positioned(
          left: (index * 37) % MediaQuery.of(context).size.width.toInt().toDouble(),
          top: (index * 41) % MediaQuery.of(context).size.height.toInt().toDouble(),
          child: Opacity(
            opacity: opacity,
            child: Container(
              width: 2 + (index % 3),
              height: 2 + (index % 3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.white.withOpacity(0.5),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}