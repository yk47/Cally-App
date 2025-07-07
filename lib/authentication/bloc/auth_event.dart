import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class RegisterEvent extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final String countryCode;
  final String mobileNumber;

  const RegisterEvent({
    required this.name,
    required this.email,
    required this.password,
    required this.countryCode,
    required this.mobileNumber,
  });

  @override
  List<Object?> get props => [name, email, password, countryCode, mobileNumber];
}

class UpdateNameEvent extends AuthEvent {
  final String name;

  const UpdateNameEvent(this.name);

  @override
  List<Object?> get props => [name];
}

class UpdateEmailEvent extends AuthEvent {
  final String email;

  const UpdateEmailEvent(this.email);

  @override
  List<Object?> get props => [email];
}

class UpdatePasswordEvent extends AuthEvent {
  final String password;

  const UpdatePasswordEvent(this.password);

  @override
  List<Object?> get props => [password];
}

class UpdateCountryCodeEvent extends AuthEvent {
  final String countryCode;

  const UpdateCountryCodeEvent(this.countryCode);

  @override
  List<Object?> get props => [countryCode];
}

class UpdateMobileNumberEvent extends AuthEvent {
  final String mobileNumber;

  const UpdateMobileNumberEvent(this.mobileNumber);

  @override
  List<Object?> get props => [mobileNumber];
}

class ToggleTermsEvent extends AuthEvent {
  final bool isAccepted;

  const ToggleTermsEvent(this.isAccepted);

  @override
  List<Object?> get props => [isAccepted];
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  const LoginEvent({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}
