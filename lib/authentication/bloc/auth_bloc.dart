import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../repository/auth_repository.dart';
import '../../core/repositories/user_repository.dart';
import '../../core/models/user_model.dart';

class SendOtpEvent extends AuthEvent {
  final String email;
  const SendOtpEvent(this.email);

  @override
  List<Object?> get props => [email];
}

class VerifyOtpEvent extends AuthEvent {
  final String email;
  final String otp;
  const VerifyOtpEvent({required this.email, required this.otp});

  @override
  List<Object?> get props => [email, otp];
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  final UserRepository? userRepository;
  User? _tempUser; // Store user temporarily during registration flow

  AuthBloc({required this.authRepository, this.userRepository})
    : super(const RegisterFormState()) {
    on<UpdateNameEvent>(_onUpdateName);
    on<UpdateEmailEvent>(_onUpdateEmail);
    on<UpdatePasswordEvent>(_onUpdatePassword);
    on<UpdateCountryCodeEvent>(_onUpdateCountryCode);
    on<UpdateMobileNumberEvent>(_onUpdateMobileNumber);
    on<ToggleTermsEvent>(_onToggleTerms);
    on<RegisterEvent>(_onRegister);
    on<LoginEvent>(_onLogin);
    on<SendOtpEvent>(_onSendOtp);
    on<VerifyOtpEvent>(_onVerifyOtp);
  }

  void _onUpdateName(UpdateNameEvent event, Emitter<AuthState> emit) {
    if (state is RegisterFormState) {
      final currentState = state as RegisterFormState;
      final isNameValid = _validateName(event.name);
      final newState = currentState.copyWith(
        name: event.name,
        isNameValid: isNameValid,
      );
      emit(newState.copyWith(isFormValid: _isFormValid(newState)));
    }
  }

  void _onUpdateEmail(UpdateEmailEvent event, Emitter<AuthState> emit) {
    if (state is RegisterFormState) {
      final currentState = state as RegisterFormState;
      final isEmailValid = _validateEmail(event.email);
      final newState = currentState.copyWith(
        email: event.email,
        isEmailValid: isEmailValid,
      );
      emit(newState.copyWith(isFormValid: _isFormValid(newState)));
    }
  }

  void _onUpdatePassword(UpdatePasswordEvent event, Emitter<AuthState> emit) {
    if (state is RegisterFormState) {
      final currentState = state as RegisterFormState;
      final isPasswordValid = _validatePassword(event.password);
      final newState = currentState.copyWith(
        password: event.password,
        isPasswordValid: isPasswordValid,
      );
      emit(newState.copyWith(isFormValid: _isFormValid(newState)));
    }
  }

  void _onUpdateCountryCode(
    UpdateCountryCodeEvent event,
    Emitter<AuthState> emit,
  ) {
    if (state is RegisterFormState) {
      final currentState = state as RegisterFormState;
      final newState = currentState.copyWith(countryCode: event.countryCode);
      emit(newState.copyWith(isFormValid: _isFormValid(newState)));
    }
  }

  void _onUpdateMobileNumber(
    UpdateMobileNumberEvent event,
    Emitter<AuthState> emit,
  ) {
    if (state is RegisterFormState) {
      final currentState = state as RegisterFormState;
      final isMobileValid = _validateMobile(event.mobileNumber);
      final newState = currentState.copyWith(
        mobileNumber: event.mobileNumber,
        isMobileValid: isMobileValid,
      );
      emit(newState.copyWith(isFormValid: _isFormValid(newState)));
    }
  }

  void _onToggleTerms(ToggleTermsEvent event, Emitter<AuthState> emit) {
    if (state is RegisterFormState) {
      final currentState = state as RegisterFormState;
      final newState = currentState.copyWith(isTermsAccepted: event.isAccepted);
      emit(newState.copyWith(isFormValid: _isFormValid(newState)));
    }
  }

  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      debugPrint('Registering user: name=${event.name}, email=${event.email}');

      // First register the user
      final registerResult = await authRepository.register(
        username: event.name,
        email: event.email,
        password: event.password,
      );

      debugPrint('Registration success: ${registerResult['message']}');

      // Store user temporarily for OTP verification
      _tempUser = registerResult['user'] as User;
      debugPrint('Temp user stored: ${_tempUser?.name}');

      // Try to save user data, but don't fail if it doesn't work
      try {
        if (userRepository != null && _tempUser != null) {
          await userRepository!.saveUser(_tempUser!);
          debugPrint('User data saved successfully');
        }
      } catch (saveError) {
        debugPrint('Failed to save user data: ${saveError.toString()}');
        // Continue with OTP sending even if save fails
      }

      debugPrint('Sending OTP to email: ${event.email}');
      // Send OTP to email
      final otpMessage = await authRepository.sendOtp(email: event.email);
      debugPrint('OTP sent successfully: $otpMessage');
      emit(OtpSent(otpMessage));
    } catch (e, stack) {
      debugPrint('Register/OTP error: ${e.toString()}');
      debugPrint('Stacktrace: ${stack.toString()}');

      // Check if registration was successful but OTP failed
      if (e.toString().contains('OTP')) {
        emit(
          AuthFailure(
            'Registration successful, but failed to send OTP. Please try again.',
          ),
        );
      } else {
        emit(AuthFailure('Registration failed: ${e.toString()}'));
      }
    }
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      debugPrint('Attempting login for email: ${event.email}');

      final loginResult = await authRepository.login(
        email: event.email,
        password: event.password,
      );

      final user = loginResult['user'] as User;
      debugPrint('Login successful for user: ${user.name}');

      // Save user data
      if (userRepository != null) {
        try {
          await userRepository!.saveUser(user);
          debugPrint('User data saved after login');
        } catch (saveError) {
          debugPrint(
            'Failed to save user data after login: ${saveError.toString()}',
          );
        }
      }

      emit(AuthSuccess(loginResult['message'], user: user));
    } catch (e) {
      debugPrint('Login error: ${e.toString()}');
      emit(AuthFailure('Login failed: ${e.toString()}'));
    }
  }

  Future<void> _onSendOtp(SendOtpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final message = await authRepository.sendOtp(email: event.email);
      emit(OtpSent(message));
    } catch (e) {
      emit(OtpFailure('An error occurred: ${e.toString()}'));
    }
  }

  Future<void> _onVerifyOtp(
    VerifyOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final message = await authRepository.verifyOtp(
        email: event.email,
        otp: event.otp,
      );
      debugPrint('OTP verification successful: $message');

      // First try to get user from repository
      User? user;
      if (userRepository != null) {
        user = await userRepository!.getUser();
        debugPrint('User from repository: ${user?.name}');
      }

      // If not found in repository, use temp user
      if (user == null && _tempUser != null) {
        user = _tempUser;
        debugPrint('Using temp user: ${user?.name}');

        // Try to save it again
        if (userRepository != null) {
          try {
            await userRepository!.saveUser(user!);
            debugPrint('Temp user saved successfully');
          } catch (e) {
            debugPrint('Failed to save temp user: ${e.toString()}');
          }
        }
      }

      if (user != null) {
        emit(OtpVerified(message, user: user));
      } else {
        // Create a fallback user if everything fails
        user = User(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: 'User',
          email: event.email,
        );
        debugPrint('Created fallback user');
        emit(OtpVerified(message, user: user));
      }
    } catch (e) {
      emit(OtpFailure('An error occurred: ${e.toString()}'));
    }
  }

  bool _validateName(String name) {
    return name.trim().length >= 2;
  }

  bool _validateEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool _validatePassword(String password) {
    return password.length >= 6;
  }

  bool _validateMobile(String mobile) {
    return RegExp(r'^\d{10}$').hasMatch(mobile);
  }

  bool _isFormValid(RegisterFormState state) {
    return state.isNameValid &&
        state.isEmailValid &&
        state.isPasswordValid &&
        state.isMobileValid &&
        state.isTermsAccepted;
  }
}
