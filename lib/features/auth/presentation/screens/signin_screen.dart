// animated_sign_in_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trip_mate/commons/widgets/loading_screen.dart';
import 'package:trip_mate/commons/widgets/logo.dart';
import 'package:trip_mate/core/configs/theme/app_colors.dart';
import 'package:trip_mate/features/auth/presentation/providers/sign_in/sign_in_provider.dart';
import 'package:trip_mate/features/auth/presentation/providers/sign_in/sign_in_state.dart';
import 'package:trip_mate/features/auth/presentation/widgets/auth_widget.dart';

import 'package:trip_mate/routes/app_route.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen>
    with TickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late AnimationController _slideController;
  late AnimationController _fadeController;
  late AnimationController _floatingController;
  late AnimationController _rippleController;
  final ScrollController _scrollController = ScrollController();

  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _floatingAnimation;

  double _logoScale = 1.0;

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _floatingController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _scrollController.addListener(_onScroll);

    _rippleController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Initialize animations
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));

    _floatingAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, -0.1),
    ).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );

    // Start animations
    _startAnimations();
  }

  void _onScroll() {
    double scrollOffset = _scrollController.offset;
    double maxScroll = 250.0;

    double newScale;

    if (scrollOffset <= 0) {
      newScale =
          1.0 + (-scrollOffset / 50.0);
      newScale = newScale.clamp(
        1.0,
        1.5,
      );
    } else {
      newScale = (1.0 - (scrollOffset / maxScroll) * 0.5).clamp(
        0,
        1.0,
      );
    }

    if (_logoScale != newScale) {
      setState(() {
        _logoScale = newScale;
      });
    }
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _fadeController.forward();
    _slideController.forward();

    _floatingController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _slideController.dispose();
    _fadeController.dispose();
    _floatingController.dispose();
    _rippleController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignInCubit(),
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 84, 116, 255),
                Color(0xFF4facfe),
                Color(0xFF00f2fe),
              ],
              stops: [0.0, 0.5, 1.0],
            ),
          ),
          child: SafeArea(
            child: BlocBuilder<SignInCubit, SignInState>(
              builder: (context, state) {
                final cubit = context.read<SignInCubit>();
                if (state is SignInInitial) {
                  return Stack(
                    children: [
                      // Floating background elements
                      _buildFloatingElements(),

                      // Main content
                      SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        controller: _scrollController,
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          children: [
                            const SizedBox(height: 40),

                            // Animated Logo
                            AnimatedScale(
                              scale: _logoScale,
                              duration: const Duration(milliseconds: 20),
                              curve: Curves.bounceIn,
                              child: const Logo(),
                            ),

                            const SizedBox(height: 60),

                            // Main form container
                            SlideTransition(
                              position: _slideAnimation,
                              child: FadeTransition(
                                opacity: _fadeAnimation,
                                child: Container(
                                  padding: const EdgeInsets.all(32),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.95),
                                    borderRadius: BorderRadius.circular(24),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 20,
                                        offset: const Offset(0, 10),
                                      ),
                                    ],
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Title
                                      const Center(
                                        child: Text(
                                          'Welcome',
                                          style: TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF2D3748),
                                          ),
                                        ),
                                      ),

                                      const SizedBox(height: 8),

                                      const Center(
                                        child: Text(
                                          'Sign in to continue your journey',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),

                                      const SizedBox(height: 40),

                                      // Form
                                      Form(
                                        key: _formKey,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Email Field
                                            buildAnimatedTextField(
                                              controller: _emailController,
                                              label: 'Email',
                                              hint: 'Enter your email',
                                              icon: Icons.email_outlined,
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter your email';
                                                }
                                                return null;
                                              },
                                              onChanged: (p0) {
                                                cubit.onChangedEmail(p0);
                                              },
                                            ),

                                            const SizedBox(height: 24),

                                            // Password Field
                                            buildAnimatedTextField(
                                              onChanged: (p0) {
                                                cubit.onChangedPass(p0);
                                              },
                                              controller: _passwordController,
                                              label: 'Password',
                                              hint: 'Enter your password',
                                              icon: Icons.lock_outline,
                                              obscureText:
                                                  !state.isPasswordVisible,
                                              suffixIcon: IconButton(
                                                icon: Icon(
                                                  state.isPasswordVisible
                                                      ? Icons.visibility_off
                                                      : Icons.visibility,
                                                  color: const Color(
                                                    0xFF667eea,
                                                  ),
                                                ),
                                                onPressed: () {
                                                  cubit
                                                      .togglePasswordVisibility(
                                                        !state
                                                            .isPasswordVisible,
                                                      );
                                                },
                                              ),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter your password';
                                                }
                                                return null;
                                              },
                                            ),
                                          ],
                                        ),
                                      ),

                                      const SizedBox(height: 20),

                                      // Remember Me & Forgot Password
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Transform.scale(
                                                scale: 1.2,
                                                child: Checkbox(
                                                  value: state.rememberMe,
                                                  onChanged: (value) {
                                                    cubit.toggleRememberMe(
                                                      value ?? false,
                                                    );
                                                  },
                                                  activeColor: const Color(
                                                    0xFF667eea,
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          4,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                              const Text(
                                                'Remember Me',
                                                style: TextStyle(
                                                  color: Color(0xFF4A5568),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).pushNamed(AppRoutes.resetPassword);
                                            },
                                            child: const Text(
                                              'Forgot Password?',
                                              style: TextStyle(
                                                color: Color(0xFF667eea),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 32),

                                      // Sign In Button
                                      buildAnimatedButton(
                                        onPressed:
                                            state is SignInLoading
                                                ? null
                                                : () {
                                                  if (_formKey.currentState!
                                                      .validate()) {
                                                    cubit.signIn();
                                                  }
                                                },
                                        isLoading: state is SignInLoading,
                                        title: "Sign In"
                                      ),

                                      const SizedBox(height: 32),

                                      // Divider
                                      const Row(
                                        children: [
                                          Expanded(
                                            child: Divider(color: Colors.grey),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 16,
                                            ),
                                            child: Text(
                                              'or continue with',
                                              style: TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Divider(color: Colors.grey),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 24),

                                      // Social Login Buttons
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          _buildSocialButton(
                                            icon: Icons.facebook,
                                            color: const Color(0xFF1877F2),
                                            onPressed:
                                                state is SignInLoading
                                                    ? null
                                                    : cubit.signInWithFacebook,
                                          ),
                                          _buildSocialButton(
                                            icon: Icons.g_mobiledata,
                                            color: const Color(0xFFDB4437),
                                            onPressed:
                                                state is SignInLoading
                                                    ? null
                                                    : cubit.signInWithGoogle,
                                          ),
                                          _buildSocialButton(
                                            icon: Icons.apple,
                                            color: Colors.black,
                                            onPressed:
                                                state is SignInLoading
                                                    ? null
                                                    : cubit.signInWithApple,
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 32),

                                      // Sign Up Link
                                      Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Text(
                                              "Don't have an account? ",
                                              style: TextStyle(
                                                color: Color(0xFF4A5568),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.of(
                                                  context,
                                                ).pushReplacementNamed(
                                                  AppRoutes.signup,
                                                );
                                              },
                                              child: const Text(
                                                'Sign Up',
                                                style: TextStyle(
                                                  color: Color(0xFF667eea),
                                                  fontWeight: FontWeight.w600,
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
                    ],
                  );
                }
                return const TravelLoadingScreen();
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingElements() {
    return Stack(
      children: [
        Positioned(
          top: 100,
          left: -50,
          child: SlideTransition(
            position: _floatingAnimation,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
        Positioned(
          top: 200,
          right: -30,
          child: SlideTransition(
            position: _floatingAnimation,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.white.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 150,
          left: -20,
          child: SlideTransition(
            position: _floatingAnimation,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required Color color,
    required VoidCallback? onPressed,
  }) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: color, size: 28),
      ),
    );
  }
}
