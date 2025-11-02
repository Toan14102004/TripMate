// animated_sign_in_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trip_mate/commons/widgets/loading_screen.dart';
import 'package:trip_mate/commons/widgets/logo.dart';
import 'package:trip_mate/core/configs/theme/app_colors.dart';
import 'package:trip_mate/features/auth/presentation/providers/sign_in/sign_in_provider.dart';
import 'package:trip_mate/features/auth/presentation/providers/sign_in/sign_in_state.dart';
import 'package:trip_mate/features/auth/presentation/widgets/auth_widget.dart';
import 'package:trip_mate/features/security/presentation/screens/new_password_screen.dart';

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
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));

    _startAnimations();
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _slideController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignInCubit(),
      child: Scaffold(
        backgroundColor: AppColors.lightBackground,
        body: SafeArea(
          child: BlocBuilder<SignInCubit, SignInState>(
            builder: (context, state) {
              final cubit = context.read<SignInCubit>();
              if (state is SignInInitial) {
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: const Logo(),
                      ),
                      const SizedBox(height: 40),
                      SlideTransition(
                        position: _slideAnimation,
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.shadow,
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Text(
                                    'Welcome Back',
                                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                      color: AppColors.black,
                                      fontWeight: FontWeight.w700,
                                    ) ?? const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Center(
                                  child: Text(
                                    'Sign in to continue your journey',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: AppColors.grey500,
                                    ) ?? const TextStyle(fontSize: 14, color: Colors.grey),
                                  ),
                                ),
                                const SizedBox(height: 28),
                                Form(
                                  key: _formKey,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      buildAnimatedTextField(
                                        controller: _emailController,
                                        label: 'Email',
                                        hint: 'Enter your email',
                                        icon: Icons.email_outlined,
                                        keyboardType: TextInputType.emailAddress,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter your email';
                                          }
                                          return null;
                                        },
                                        onChanged: (p0) {
                                          cubit.onChangedEmail(p0);
                                        },
                                      ),
                                      const SizedBox(height: 18),
                                      buildAnimatedTextField(
                                        onChanged: (p0) {
                                          cubit.onChangedPass(p0);
                                        },
                                        controller: _passwordController,
                                        label: 'Password',
                                        hint: 'Enter your password',
                                        icon: Icons.lock_outline,
                                        obscureText: !state.isPasswordVisible,
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            state.isPasswordVisible
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                            color: AppColors.primary,
                                            size: 20,
                                          ),
                                          onPressed: () {
                                            cubit.togglePasswordVisibility(!state.isPasswordVisible);
                                          },
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter your password';
                                          }
                                          return null;
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 14),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Checkbox(
                                          value: state.rememberMe,
                                          onChanged: (value) {
                                            cubit.toggleRememberMe(value ?? false);
                                          },
                                          activeColor: AppColors.primary,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                        ),
                                        Text(
                                          'Remember Me',
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            color: AppColors.grey600,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => const NewPasswordScreen(),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        'Forgot Password?',
                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                buildAnimatedButton(
                                  onPressed: state is SignInLoading
                                      ? null
                                      : () {
                                        if (_formKey.currentState!.validate()) {
                                          cubit.signIn();
                                        }
                                      },
                                  isLoading: state is SignInLoading,
                                  title: "Sign In",
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Divider(color: AppColors.grey200),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 12),
                                      child: Text(
                                        'or continue with',
                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: AppColors.grey500,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Divider(color: AppColors.grey200),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _buildSocialButton(
                                      icon: Icons.facebook,
                                      color: const Color(0xFF1877F2),
                                      onPressed: state is SignInLoading ? null : cubit.signInWithFacebook,
                                    ),
                                    _buildSocialButton(
                                      icon: Icons.g_mobiledata,
                                      color: const Color(0xFFDB4437),
                                      onPressed: state is SignInLoading ? null : cubit.signInWithGoogle,
                                    ),
                                    _buildSocialButton(
                                      icon: Icons.apple,
                                      color: AppColors.black,
                                      onPressed: state is SignInLoading ? null : cubit.signInWithApple,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Don't have an account? ",
                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: AppColors.grey600,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).pushReplacementNamed(AppRoutes.signup);
                                        },
                                        child: Text(
                                          'Sign Up',
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            color: AppColors.primary,
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
                );
              }
              return const TravelLoadingScreen();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required Color color,
    required VoidCallback? onPressed,
  }) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.grey200),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: color, size: 22),
      ),
    );
  }
}
