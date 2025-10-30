import 'package:flutter/material.dart';
import 'dart:async';
import 'package:trip_mate/core/configs/theme/app_colors.dart';

class TravelErrorScreen extends StatefulWidget {
  final String? errorMessage;
  final VoidCallback? onRetry;
  final VoidCallback? onGoBack;
  
  const TravelErrorScreen({
    super.key,
    this.errorMessage,
    this.onRetry,
    this.onGoBack,
  });

  @override
  State<TravelErrorScreen> createState() => _TravelErrorScreenState();
}

class _TravelErrorScreenState extends State<TravelErrorScreen>
    with TickerProviderStateMixin {
  late AnimationController _shakeController;
  late AnimationController _pulseController;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _rotateController;
  
  late Animation<double> _shakeAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    
    // Animation controllers
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _rotateController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();

    // Animations
    _shakeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _shakeController,
      curve: Curves.elasticOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.elasticOut,
    ));

    _rotateAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * 3.14159,
    ).animate(_rotateController);

    // Start animations
    _fadeController.forward();
    _slideController.forward();
    
    // Shake animation after a delay
    Timer(const Duration(milliseconds: 500), () {
      _shakeController.forward();
    });
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _pulseController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  void _triggerShake() {
    _shakeController.reset();
    _shakeController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.error,
              AppColors.error.withOpacity(0.8),
              AppColors.error.withOpacity(0.6),
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Background floating elements (error-themed)
            _buildBackgroundShapes(),
            
            // Main content
            Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Error icon container
                      AnimatedBuilder(
                        animation: _shakeAnimation,
                        builder: (context, child) {
                          double shake = 0;
                          if (_shakeController.isAnimating) {
                            shake = 8 * (0.5 - (_shakeAnimation.value - 0.5).abs());
                          }
                          
                          return Transform.translate(
                            offset: Offset(shake, 0),
                            child: AnimatedBuilder(
                              animation: _pulseAnimation,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: _pulseAnimation.value,
                                  child: Container(
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
                                          color: Colors.black.withOpacity(0.3),
                                          blurRadius: 20,
                                          offset: const Offset(0, 10),
                                        ),
                                        BoxShadow(
                                          color: AppColors.error.withOpacity(0.2),
                                          blurRadius: 30,
                                          offset: const Offset(0, 0),
                                        ),
                                      ],
                                    ),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        // Broken plane icon
                                        const Icon(
                                          Icons.flight_land,
                                          size: 50,
                                          color: Colors.white70,
                                        ),
                                        // Error overlay
                                        Positioned(
                                          right: 20,
                                          top: 20,
                                          child: Container(
                                            width: 35,
                                            height: 35,
                                            decoration: BoxDecoration(
                                              color: Colors.red.shade600,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: Colors.white,
                                                width: 2,
                                              ),
                                            ),
                                            child: const Icon(
                                              Icons.close,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                      
                      const SizedBox(height: 40),
                      
                      // Error title
                      const Text(
                        'Oops! Có lỗi xảy ra',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Error message
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Text(
                          widget.errorMessage ?? 
                          'Không thể kết nối đến máy chủ.\nVui lòng kiểm tra kết nối mạng.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                            height: 1.5,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 50),
                      
                      // Error code (rotating)
                      AnimatedBuilder(
                        animation: _rotateAnimation,
                        builder: (context, child) {
                          return Transform.rotate(
                            angle: _rotateAnimation.value,
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 2,
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  '404',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      
                      const SizedBox(height: 60),
                      
                      // Action buttons
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Column(
                          children: [
                            // Retry button
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  _triggerShake();
                                  widget.onRetry?.call();
                                },
                                icon: const Icon(Icons.refresh, color: Colors.white),
                                label: const Text(
                                  'Thử lại',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white.withOpacity(0.2),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    side: BorderSide(
                                      color: Colors.white.withOpacity(0.3),
                                      width: 1,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            
                            const SizedBox(height: 16),
                            
                            // Go back button
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  widget.onGoBack ?? Navigator.of(context).pop();
                                },
                                icon: Icon(
                                  Icons.arrow_back, 
                                  color: Colors.white.withOpacity(0.8),
                                ),
                                label: Text(
                                  'Quay lại',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                    color: Colors.white.withOpacity(0.3),
                                    width: 1,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
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
        // Floating error shapes
        Positioned(
          top: 120,
          left: 30,
          child: _buildFloatingErrorShape(50, const Duration(seconds: 4)),
        ),
        Positioned(
          top: 200,
          right: 50,
          child: _buildFloatingErrorShape(70, const Duration(seconds: 6)),
        ),
        Positioned(
          bottom: 220,
          left: 60,
          child: _buildFloatingErrorShape(40, const Duration(seconds: 5)),
        ),
        Positioned(
          bottom: 320,
          right: 40,
          child: _buildFloatingErrorShape(60, const Duration(seconds: 7)),
        ),
        // Error cloud
        Positioned(
          top: 180,
          right: 120,
          child: _buildErrorCloud(),
        ),
        // Warning triangles
        Positioned(
          top: 80,
          right: 20,
          child: _buildWarningTriangle(30),
        ),
        Positioned(
          bottom: 150,
          left: 20,
          child: _buildWarningTriangle(25),
        ),
      ],
    );
  }

  Widget _buildFloatingErrorShape(double size, Duration duration) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: duration,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(
            5 * (0.5 - (value - 0.5).abs()),
            15 * (0.5 - (value - 0.5).abs()),
          ),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.15),
                width: 1,
              ),
            ),
            child: Center(
              child: Icon(
                Icons.error_outline,
                color: Colors.white.withOpacity(0.3),
                size: size * 0.4,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorCloud() {
    return Container(
      width: 90,
      height: 35,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 8,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.06),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            left: 12,
            top: 0,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.06),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            left: 35,
            top: 3,
            child: Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.06),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 10,
            child: Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.06),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Lightning bolt in the cloud
          Positioned(
            left: 30,
            top: 8,
            child: Icon(
              Icons.flash_on,
              color: Colors.yellow.withOpacity(0.3),
              size: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWarningTriangle(double size) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(seconds: 3),
      builder: (context, value, child) {
        return Transform.rotate(
          angle: value * 0.2,
          child: Container(
            width: size,
            height: size,
            child: CustomPaint(
              painter: TrianglePainter(
                color: Colors.yellow.withOpacity(0.2),
                borderColor: Colors.yellow.withOpacity(0.3),
              ),
            ),
          ),
        );
      },
    );
  }
}

class TrianglePainter extends CustomPainter {
  final Color color;
  final Color borderColor;

  TrianglePainter({required this.color, required this.borderColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
    canvas.drawPath(path, borderPaint);

    // Draw exclamation mark
    final textPainter = TextPainter(
      text: TextSpan(
        text: '!',
        style: TextStyle(
          color: borderColor,
          fontSize: size.width * 0.4,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        (size.width - textPainter.width) / 2,
        size.height * 0.3,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
