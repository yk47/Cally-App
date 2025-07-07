// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../repository/auth_repository.dart';
import '../../core/repositories/user_repository.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => AuthBloc(
            authRepository: AuthRepository(),
            userRepository: UserRepository(),
          ),
      child: const _RegisterScreenBody(),
    );
  }
}

class _RegisterScreenBody extends StatefulWidget {
  const _RegisterScreenBody();

  @override
  State<_RegisterScreenBody> createState() => _RegisterScreenBodyState();
}

class _RegisterScreenBodyState extends State<_RegisterScreenBody> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _mobileController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _mobileController.dispose();
    super.dispose();
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
    required Function(String) onChanged,
    TextInputType? keyboardType,
    bool isPassword = false,
    Widget? prefix,
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
        onChanged: onChanged,
        keyboardType: keyboardType,
        obscureText: isPassword,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
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
          prefixIcon: prefix,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is AuthFailure) {
            debugPrint('Auth failure: ${state.error}');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error), backgroundColor: Colors.red),
            );
          } else if (state is OtpSent) {
            debugPrint('OTP sent response: ${state.message}');
            // Remove any previous SnackBars
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            // Navigate directly to OTP screen, do not show loading screen
            context.push(
              '/otp',
              extra: {
                'phoneNumber': '+91${_mobileController.text}',
                'email': _emailController.text,
              },
            );
          } else if (state is OtpFailure) {
            debugPrint('OTP send failed: ${state.error}');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error), backgroundColor: Colors.red),
            );
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 24),
                // Logo
                Center(
                  child: Image.asset(
                    'assets/images/Logo.png',
                    width: 180,
                    height: 48,
                    fit: BoxFit.contain,
                    errorBuilder:
                        (context, error, stackTrace) =>
                            const SizedBox(height: 48),
                  ),
                ),
                const SizedBox(height: 40),
                // Form Card
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 24,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFD9D9D9)),
                  ),
                  child: BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      if (state is! RegisterFormState &&
                          state is! AuthLoading) {
                        return const SizedBox.shrink();
                      }
                      final isLoading = state is AuthLoading;
                      final RegisterFormState formState =
                          state is RegisterFormState
                              ? state
                              : RegisterFormState();
                      return Column(
                        children: [
                          const Text(
                            'Welcome!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                              fontFamily: 'Inter',
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Please register to continue',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black87,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Name
                          _buildTextField(
                            controller: _nameController,
                            hintText: 'Name',
                            assetIconPath: 'assets/icons/person.png',
                            onChanged: (value) {
                              context.read<AuthBloc>().add(
                                UpdateNameEvent(value),
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          // Email
                          _buildTextField(
                            controller: _emailController,
                            hintText: 'Email address',
                            assetIconPath: 'assets/icons/mail.png',
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (value) {
                              context.read<AuthBloc>().add(
                                UpdateEmailEvent(value),
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          // Password
                          _buildTextField(
                            controller: _passwordController,
                            hintText: 'Password',
                            assetIconPath: 'assets/icons/lock.png',
                            isPassword: true,
                            onChanged: (value) {
                              context.read<AuthBloc>().add(
                                UpdatePasswordEvent(value),
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          // Mobile number with Indian flag and +91 as prefix, icon on right
                          _buildTextField(
                            controller: _mobileController,
                            hintText: '',
                            assetIconPath: 'assets/icons/whatsapp.png',
                            keyboardType: TextInputType.phone,
                            prefix: Padding(
                              padding: const EdgeInsets.only(
                                left: 12,
                                right: 8,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    'assets/icons/indian_flag.png',
                                    width: 24,
                                    height: 24,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(
                                              Icons.flag,
                                              size: 24,
                                              color: Colors.grey,
                                            ),
                                  ),
                                  const SizedBox(width: 6),
                                  const Text(
                                    '+91',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onChanged: (value) {
                              context.read<AuthBloc>().add(
                                UpdateMobileNumberEvent(value),
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          // Mobile number plain field (not password)
                          _buildTextField(
                            controller: _mobileController,
                            hintText: 'Mobile Number',
                            assetIconPath: 'assets/icons/phone.png',
                            keyboardType: TextInputType.phone,
                            onChanged: (value) {
                              context.read<AuthBloc>().add(
                                UpdateMobileNumberEvent(value),
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Transform.scale(
                                scale: 1.1,
                                child: Checkbox(
                                  value: formState.isTermsAccepted,
                                  onChanged: (value) {
                                    context.read<AuthBloc>().add(
                                      ToggleTermsEvent(value ?? false),
                                    );
                                  },
                                  activeColor: const Color(0xFF4285F4),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  side: const BorderSide(
                                    color: Color(0xFFD9D9D9),
                                    width: 1,
                                  ),
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Align(
                                alignment: Alignment.center,
                                child: RichText(
                                  text: TextSpan(
                                    text: 'I agree to the ',
                                    style: const TextStyle(
                                      color: Colors.black87,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'Terms and Conditions',
                                        style: const TextStyle(
                                          color: Color(0xFF4285F4),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Already have an account? ',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  // Navigate to login screen
                                  context.push('/login');
                                },
                                child: const Text(
                                  'Sign In',
                                  style: TextStyle(
                                    color: Color(0xFF2563EB),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed:
                                  isLoading || !formState.isFormValid
                                      ? null
                                      : () {
                                        context.read<AuthBloc>().add(
                                          RegisterEvent(
                                            name: _nameController.text,
                                            email: _emailController.text,
                                            password: _passwordController.text,
                                            countryCode: formState.countryCode,
                                            mobileNumber:
                                                _mobileController.text,
                                          ),
                                        );
                                      },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2563EB),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
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
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                        ),
                                      )
                                      : const Text(
                                        'Sign Up',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
