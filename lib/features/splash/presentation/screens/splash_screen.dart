import 'package:flutter/material.dart';
import 'package:trip_mate/core/configs/theme/app_colors.dart';

class AnimatedSplashScreen extends StatefulWidget {
  const AnimatedSplashScreen({Key? key}) : super(key: key);

  @override
  State<AnimatedSplashScreen> createState() => _AnimatedSplashScreenState();
}

class _AnimatedSplashScreenState extends State<AnimatedSplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _mascotController;
  late AnimationController _waveController;
  late AnimationController _loadingController;
  late AnimationController _floatController;
  late AnimationController _blinkController;

  late Animation<double> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _waveAnimation;
  late Animation<double> _loadingAnimation;
  late Animation<double> _floatAnimation;
  late Animation<double> _blinkAnimation;

  @override
  void initState() {
    super.initState();

    // Animation controllers
    _mascotController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _waveController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _loadingController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _floatController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _blinkController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    // Animations
    _slideAnimation = Tween<double>(begin: 300.0, end: 0.0).animate(
      CurvedAnimation(parent: _mascotController, curve: Curves.elasticOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mascotController,
        curve: const Interval(0.3, 1.0, curve: Curves.bounceOut),
      ),
    );

    _waveAnimation = Tween<double>(
      begin: -0.2, // Bắt đầu ở một góc nhỏ để trông tự nhiên hơn
      end: 0.2, // Góc vẫy
    ).animate(
      CurvedAnimation(
        parent: _waveController,
        curve: Curves.easeInOutSine, // Sử dụng curve khác cho cảm giác mượt mà
      ),
    );

    _loadingAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _loadingController, curve: Curves.easeInOut),
    );

    _floatAnimation = Tween<double>(begin: 0.0, end: 10.0).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    _blinkAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _blinkController, curve: Curves.easeInOut),
    );

    // Start animations
    _startAnimations();
  }

  void _startAnimations() async {
    // Mascot enters
    _mascotController.forward();

    _mascotController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Bắt đầu vẫy tay, lặp lại với reverse: true để tạo hiệu ứng vẫy liên tục
        _waveController.repeat(reverse: true);
        // Bắt đầu nổi và nháy mắt
        _floatController.repeat(reverse: true);
        _blinkController.repeat();
        // Bắt đầu loading
        _loadingController.forward();
      }
    });
    // Navigate after loading completes
    await Future.delayed(const Duration(seconds: 4));
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  @override
  void dispose() {
    _mascotController.dispose();
    _waveController.dispose();
    _loadingController.dispose();
    _floatController.dispose();
    _blinkController.dispose();
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
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF4A90E2), Color(0xFF357ABD), Color(0xFF2E5F8A)],
          ),
        ),
        child: Stack(
          children: [
            // Background particles
            ...List.generate(20, (index) => _buildParticle(index)),

            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Mascot character
                  AnimatedBuilder(
                    animation: Listenable.merge([
                      _mascotController,
                      _floatController,
                      _blinkController,
                    ]),
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(
                          _slideAnimation.value,
                          -_floatAnimation.value,
                        ),
                        child: Transform.scale(
                          scale: _scaleAnimation.value,
                          child: _buildMascot(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 40),

                  // Logo
                  AnimatedBuilder(
                    animation: _mascotController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _scaleAnimation.value,
                        child: _buildLogo(),
                      );
                    },
                  ),

                  const SizedBox(height: 60),

                  // Loading indicator
                  AnimatedBuilder(
                    animation: _loadingController,
                    builder: (context, child) {
                      return _buildLoadingIndicator();
                    },
                  ),
                ],
              ),
            ),

            // Wave hand animation
            AnimatedBuilder(
              animation: _waveAnimation,
              builder: (context, child) {
                if (_waveAnimation.value == 0) return Container();
                return Positioned(
                  top: MediaQuery.of(context).size.height * 0.35,
                  right: MediaQuery.of(context).size.width * 0.25,
                  child: Transform.rotate(
                    angle: _waveAnimation.value * 0.5,
                    child: const Text('👋', style: TextStyle(fontSize: 40)),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMascot() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.9),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Body
          Center(
            child: Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: AppColors.neonGreen,
                shape: BoxShape.circle,
              ),
              child: Stack(
                children: [
                  // Eyes
                  Positioned(
                    top: 20,
                    left: 15,
                    child: AnimatedBuilder(
                      animation: _blinkAnimation,
                      builder: (context, child) {
                        return Container(
                          width: 12,
                          height: _blinkAnimation.value > 0.1 ? 12 : 2,
                          decoration: const BoxDecoration(
                            color: AppColors.black,
                            shape: BoxShape.circle,
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    top: 20,
                    right: 15,
                    child: AnimatedBuilder(
                      animation: _blinkAnimation,
                      builder: (context, child) {
                        return Container(
                          width: 12,
                          height: _blinkAnimation.value > 0.1 ? 12 : 2,
                          decoration: const BoxDecoration(
                            color: AppColors.black,
                            shape: BoxShape.circle,
                          ),
                        );
                      },
                    ),
                  ),
                  // Mouth
                  Positioned(
                    bottom: 25,
                    left: 25,
                    child: Container(
                      width: 30,
                      height: 15,
                      decoration: const BoxDecoration(
                        color: AppColors.black,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                      ),
                    ),
                  ),
                  // Cheeks
                  Positioned(
                    top: 35,
                    left: 5,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.darkGreen.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 35,
                    right: 5,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.darkGreen.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: const BoxDecoration(
                color: Color(0xFFFFB347),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'TRALTO',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Cùng nhau khám phá thế giới nhé ❤️',
          style: TextStyle(
            color: AppColors.white.withOpacity(0.8),
            fontSize: 16,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingIndicator() {
    return Column(
      children: [
        Container(
          width: 200,
          height: 4,
          decoration: BoxDecoration(
            color: AppColors.white.withOpacity(0.3),
            borderRadius: BorderRadius.circular(2),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: 200 * _loadingAnimation.value,
              height: 4,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFB347), Color(0xFFFF8C42)],
                ),
                borderRadius: BorderRadius.circular(2),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFB347).withOpacity(0.5),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Loading...',
          style: TextStyle(
            color: AppColors.white.withOpacity(0.7),
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildParticle(int index) {
    final random = (index * 1234) % 1000 / 1000.0;
    final size = 2.0 + random * 4;
    final left = random * MediaQuery.of(context).size.width;
    final animationDelay = random * 3000;

    return AnimatedBuilder(
      animation: _loadingController,
      builder: (context, child) {
        final progress =
            (_loadingController.value * 3000 + animationDelay) % 3000 / 3000;
        final top = MediaQuery.of(context).size.height * (1 - progress);

        return Positioned(
          left: left,
          top: top,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.6 * (1 - progress)),
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }
}
