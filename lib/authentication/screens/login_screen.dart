// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../repository/auth_repository.dart';
import '../../core/repositories/user_repository.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => AuthBloc(
            authRepository: AuthRepository(),
            userRepository: UserRepository(),
          ),
      child: const _LoginScreenBody(),
    );
  }
}

class _LoginScreenBody extends StatefulWidget {
  const _LoginScreenBody();

  @override
  State<_LoginScreenBody> createState() => _LoginScreenBodyState();
}

class _LoginScreenBodyState extends State<_LoginScreenBody> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            debugPrint('Login success: ${state.message}');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Welcome back ${state.user?.name ?? 'User'}!'),
                backgroundColor: Colors.green,
              ),
            );
            Future.delayed(const Duration(milliseconds: 300), () {
              context.go('/onboarding');
            });
          } else if (state is AuthFailure) {
            debugPrint('Login failure: ${state.error}');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error), backgroundColor: Colors.red),
            );
          }
        },
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        const SizedBox(height: 24),
                        // Logo and subtitle
                        Center(
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/images/Logo.png',
                                width: 180,
                                height: 48,
                                fit: BoxFit.contain,
                                errorBuilder:
                                    (context, error, stackTrace) =>
                                        const SizedBox(height: 48),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        // Card
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            margin: EdgeInsets.zero,
                            padding: const EdgeInsets.symmetric(
                              vertical: 36,
                              horizontal: 18,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: const Color(0xFFD9D9D9),
                              ),
                            ),
                            child: Column(
                              children: [
                                // Center content
                                Expanded(
                                  child: Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Text(
                                          'Welcome',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontFamily: 'Inter',
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        const Text(
                                          'Please sign-in to continue',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Color(0xFF8E8E93),
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        const SizedBox(height: 28),
                                        _buildTextField(
                                          controller: _emailController,
                                          hintText: 'Email address',
                                          assetIconPath:
                                              'assets/icons/mail.png',
                                          keyboardType:
                                              TextInputType.emailAddress,
                                        ),
                                        const SizedBox(height: 16),
                                        _buildTextField(
                                          controller: _passwordController,
                                          hintText: 'Password',
                                          assetIconPath:
                                              'assets/icons/lock.png',
                                          isPassword: true,
                                        ),
                                        const SizedBox(height: 8),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: GestureDetector(
                                            onTap: () {},
                                            child: const Text(
                                              'Forgot Password?',
                                              style: TextStyle(
                                                color: Color(0xFF222222),
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                // Bottom section pinned to the bottom of the white container
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Don't have an account? ",
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        // Go to register screen
                                        context.push('/register');
                                      },
                                      child: const Text(
                                        'Sign Up',
                                        style: TextStyle(
                                          color: Color(0xFF2563EB),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  height: 48,
                                  child: BlocBuilder<AuthBloc, AuthState>(
                                    builder: (context, state) {
                                      final isLoading = state is AuthLoading;
                                      final canLogin =
                                          _emailController.text.isNotEmpty &&
                                          _passwordController.text.isNotEmpty;

                                      return ElevatedButton(
                                        onPressed:
                                            isLoading || !canLogin
                                                ? null
                                                : () {
                                                  context.read<AuthBloc>().add(
                                                    LoginEvent(
                                                      email:
                                                          _emailController.text
                                                              .trim(),
                                                      password:
                                                          _passwordController
                                                              .text,
                                                    ),
                                                  );
                                                },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(
                                            0xFF2563EB,
                                          ),
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          elevation: 0,
                                          disabledBackgroundColor: const Color(
                                            0xFFE5E7EB,
                                          ),
                                        ),
                                        child:
                                            isLoading
                                                ? const SizedBox(
                                                  height: 20,
                                                  width: 20,
                                                  child: CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                          Color
                                                        >(Colors.white),
                                                  ),
                                                )
                                                : const Text(
                                                  'Sign In',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                      );
                                    },
                                  ),
                                ),
                              ],
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
        ),
      ),
    );
  }

  Widget _assetIcon(String assetName) {
    return Image.asset(
      assetName,
      width: 22,
      height: 22,
      errorBuilder:
          (context, error, stackTrace) =>
              const Icon(Icons.error_outline, color: Colors.grey),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required String assetIconPath,
    bool isPassword = false,
    TextInputType? keyboardType,
  }) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD9D9D9)),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        onChanged:
            (value) => setState(() {}), // Trigger rebuild for button state
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Color(0xFFBDBDBD),
            fontWeight: FontWeight.w400,
          ),
          border: InputBorder.none,
          isCollapsed: true,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 18,
            horizontal: 16,
          ),
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 16),
            child: _assetIcon(assetIconPath),
          ),
          suffixIconConstraints: const BoxConstraints(
            minWidth: 32,
            minHeight: 32,
          ),
        ),
      ),
    );
  }
}
