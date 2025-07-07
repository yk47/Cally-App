import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';
import '../repository/auth_repository.dart';
import '../../core/repositories/user_repository.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  final String email;
  const OtpVerificationScreen({
    super.key,
    required this.phoneNumber,
    required this.email,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void dispose() {
    for (final c in _otpControllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _onOtpChanged(String value, int index) {
    if (value.length == 1 && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => AuthBloc(
            authRepository: AuthRepository(),
            userRepository: UserRepository(),
          ),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is OtpVerified) {
            debugPrint('OTP verified, user: ${state.user?.name}');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Verification successful! Welcome ${state.user?.name ?? 'User'}',
                ),
                backgroundColor: Colors.green,
              ),
            );
            Future.delayed(const Duration(milliseconds: 300), () {
              // ignore: use_build_context_synchronously
              context.go('/onboarding');
            });
          } else if (state is OtpFailure) {
            debugPrint('OTP verification failed: ${state.error}');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error), backgroundColor: Colors.red),
            );
          }
        },
        child: _OtpVerificationBody(
          phoneNumber: widget.phoneNumber,
          email: widget.email,
          otpControllers: _otpControllers,
          focusNodes: _focusNodes,
          onOtpChanged: _onOtpChanged,
        ),
      ),
    );
  }
}

class _OtpVerificationBody extends StatefulWidget {
  final String phoneNumber;
  final String email;
  final List<TextEditingController> otpControllers;
  final List<FocusNode> focusNodes;
  final void Function(String, int) onOtpChanged;
  const _OtpVerificationBody({
    required this.phoneNumber,
    required this.email,
    required this.otpControllers,
    required this.focusNodes,
    required this.onOtpChanged,
  });

  @override
  State<_OtpVerificationBody> createState() => _OtpVerificationBodyState();
}

class _OtpVerificationBodyState extends State<_OtpVerificationBody> {
  bool get isOtpFilled => widget.otpControllers.every((c) => c.text.isNotEmpty);

  @override
  void initState() {
    super.initState();
    for (final controller in widget.otpControllers) {
      controller.addListener(_onOtpFieldChanged);
    }
  }

  @override
  void dispose() {
    for (final controller in widget.otpControllers) {
      controller.removeListener(_onOtpFieldChanged);
    }
    super.dispose();
  }

  void _onOtpFieldChanged() {
    setState(() {});
  }

  String get otp => widget.otpControllers.map((c) => c.text).join();

  Widget _buildOtpFields() {
    return LayoutBuilder(
      builder: (context, constraints) {
        double totalWidth = constraints.maxWidth;
        double fieldWidth = 44;
        double spacing = 5;
        double maxFieldWidth = (totalWidth - (spacing * 5)) / 6;
        double usedWidth =
            maxFieldWidth < fieldWidth ? maxFieldWidth : fieldWidth;

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(6, (i) {
            return Container(
              width: usedWidth,
              height: 56,
              margin: EdgeInsets.symmetric(horizontal: spacing / 2),
              child: TextField(
                controller: widget.otpControllers[i],
                focusNode: widget.focusNodes[i],
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 1,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2,
                ),
                decoration: InputDecoration(
                  counterText: '',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFF2563EB),
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.zero,
                ),
                onChanged: (value) => widget.onOtpChanged(value, i),
              ),
            );
          }),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                const SizedBox(height: 24),
                // Logo
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
                // White container pinned to bottom, actions at bottom, scrollable if needed
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        physics: const ClampingScrollPhysics(),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight,
                          ),
                          child: Container(
                            width: double.infinity,
                            margin: EdgeInsets.zero,
                            padding: const EdgeInsets.symmetric(
                              vertical: 36,
                              horizontal: 16,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: const Color(0xFFD9D9D9),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Centered OTP content
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 50,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Text(
                                          'Whatsapp OTP Verification',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 26,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontFamily: 'Inter',
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        const Text(
                                          'Please ensure that the email id mentioned is valid as we have sent an OTP to your email.',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Color(0xFF8E8E93),
                                            fontWeight: FontWeight.w400,
                                            fontFamily: 'Inter',
                                          ),
                                        ),
                                        const SizedBox(height: 32),
                                        _buildOtpFields(),
                                        const SizedBox(height: 16),
                                        Text(
                                          widget.phoneNumber,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                // Bottom pinned actions inside white container
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          "Didn't receive OTP code? ",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            context.read<AuthBloc>().add(
                                              SendOtpEvent(widget.email),
                                            );
                                          },
                                          child: const Text(
                                            'Resend OTP',
                                            style: TextStyle(
                                              color: Color(0xFF2563EB),
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 24),
                                    SizedBox(
                                      width: double.infinity,
                                      height: 48,
                                      child: BlocBuilder<AuthBloc, AuthState>(
                                        builder: (context, state) {
                                          final isLoading =
                                              state is AuthLoading;
                                          return ElevatedButton(
                                            onPressed:
                                                isLoading || !isOtpFilled
                                                    ? null
                                                    : () {
                                                      context
                                                          .read<AuthBloc>()
                                                          .add(
                                                            VerifyOtpEvent(
                                                              email:
                                                                  widget.email,
                                                              otp: otp,
                                                            ),
                                                          );
                                                    },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color(
                                                0xFF2563EB,
                                              ),
                                              foregroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              elevation: 0,
                                              disabledBackgroundColor:
                                                  const Color(0xFFE5E7EB),
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
                                                      'Verify',
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
