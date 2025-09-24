import 'package:flutter/material.dart';
import 'dart:async';

class TravelLoadingScreen extends StatefulWidget {
  const TravelLoadingScreen({Key? key}) : super(key: key);

  @override
  State<TravelLoadingScreen> createState() => _TravelLoadingScreenState();
}

class _TravelLoadingScreenState extends State<TravelLoadingScreen>
    with TickerProviderStateMixin {
  late AnimationController _planeController;
  late AnimationController _dotsController;
  late AnimationController _fadeController;
  late Animation<double> _planeAnimation;
  late Animation<double> _dotsAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    // Animation controllers
    _planeController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    
    _dotsController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Animations
    _planeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _planeController,
      curve: Curves.easeInOut,
    ));

    _dotsAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _dotsController,
      curve: Curves.easeInOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    ));

    _fadeController.forward();
    
    // Auto navigate after loading
    Timer(const Duration(seconds: 3), () {
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
    });
  }

  @override
  void dispose() {
    _planeController.dispose();
    _dotsController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF4A90E2),
              Color(0xFF357ABD),
              Color(0xFF1E3A8A),
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Background floating elements
            _buildBackgroundShapes(),
            
            // Main content
            Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo container
                    Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(35),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: AnimatedBuilder(
                        animation: _planeAnimation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(
                              10 * (0.5 - (_planeAnimation.value - 0.5).abs()),
                              -5 * (0.5 - (_planeAnimation.value - 0.5).abs()),
                            ),
                            child: Transform.rotate(
                              angle: 0.1 * (_planeAnimation.value - 0.5),
                              child: const Icon(
                                Icons.flight_takeoff,
                                size: 60,
                                color: Colors.white,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // App name
                    const Text(
                      'TravelApp',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    Text(
                      'Khám phá thế giới',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 1,
                      ),
                    ),
                    
                    const SizedBox(height: 60),
                    
                    // Loading dots
                    SizedBox(
                      width: 80,
                      height: 20,
                      child: AnimatedBuilder(
                        animation: _dotsAnimation,
                        builder: (context, child) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(3, (index) {
                              double delay = index * 0.2;
                              double animValue = (_dotsAnimation.value + delay) % 1.0;
                              double scale = animValue < 0.5 
                                  ? 1.0 + (animValue * 2 * 0.5)
                                  : 1.5 - ((animValue - 0.5) * 2 * 0.5);
                              
                              return Transform.scale(
                                scale: scale,
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.9),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              );
                            }),
                          );
                        },
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    Text(
                      'Đang tải...',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundShapes() {
    return Stack(
      children: [
        // Shape 1
        Positioned(
          top: 100,
          left: 30,
          child: _buildFloatingShape(60, const Duration(seconds: 4)),
        ),
        // Shape 2
        Positioned(
          top: 200,
          right: 50,
          child: _buildFloatingShape(80, const Duration(seconds: 6)),
        ),
        // Shape 3
        Positioned(
          bottom: 200,
          left: 60,
          child: _buildFloatingShape(45, const Duration(seconds: 5)),
        ),
        // Shape 4
        Positioned(
          bottom: 300,
          right: 30,
          child: _buildFloatingShape(70, const Duration(seconds: 7)),
        ),
        // Shape 5 - Cloud-like
        Positioned(
          top: 150,
          right: 100,
          child: _buildCloudShape(),
        ),
      ],
    );
  }

  Widget _buildFloatingShape(double size, Duration duration) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: duration,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 10 * (0.5 - (value - 0.5).abs())),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCloudShape() {
    return Container(
      width: 100,
      height: 40,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 10,
            child: Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            left: 15,
            top: 0,
            child: Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            left: 40,
            top: 5,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 12,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
