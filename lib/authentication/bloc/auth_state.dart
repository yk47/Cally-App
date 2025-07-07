import 'package:equatable/equatable.dart';
import '../../core/models/user_model.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final String message;
  final User? user;

  const AuthSuccess(this.message, {this.user});

  @override
  List<Object?> get props => [message, user];
}

class AuthFailure extends AuthState {
  final String error;

  const AuthFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class OtpSent extends AuthState {
  final String message;
  const OtpSent(this.message);

  @override
  List<Object?> get props => [message];
}

class OtpVerified extends AuthState {
  final String message;
  final User? user;
  const OtpVerified(this.message, {this.user});

  @override
  List<Object?> get props => [message, user];
}

class OtpFailure extends AuthState {
  final String error;
  const OtpFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class RegisterFormState extends AuthState {
  final String name;
  final String email;
  final String password;
  final String countryCode;
  final String mobileNumber;
  final bool isTermsAccepted;
  final bool isNameValid;
  final bool isEmailValid;
  final bool isPasswordValid;
  final bool isMobileValid;
  final bool isFormValid;

  const RegisterFormState({
    this.name = '',
    this.email = '',
    this.password = '',
    this.countryCode = '+91',
    this.mobileNumber = '',
    this.isTermsAccepted = false,
    this.isNameValid = false,
    this.isEmailValid = false,
    this.isPasswordValid = false,
    this.isMobileValid = false,
    this.isFormValid = false,
  });

  RegisterFormState copyWith({
    String? name,
    String? email,
    String? password,
    String? countryCode,
    String? mobileNumber,
    bool? isTermsAccepted,
    bool? isNameValid,
    bool? isEmailValid,
    bool? isPasswordValid,
    bool? isMobileValid,
    bool? isFormValid,
  }) {
    return RegisterFormState(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      countryCode: countryCode ?? this.countryCode,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      isTermsAccepted: isTermsAccepted ?? this.isTermsAccepted,
      isNameValid: isNameValid ?? this.isNameValid,
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      isMobileValid: isMobileValid ?? this.isMobileValid,
      isFormValid: isFormValid ?? this.isFormValid,
    );
  }

  @override
  List<Object?> get props => [
    name,
    email,
    password,
    countryCode,
    mobileNumber,
    isTermsAccepted,
    isNameValid,
    isEmailValid,
    isPasswordValid,
    isMobileValid,
    isFormValid,
  ];
}
