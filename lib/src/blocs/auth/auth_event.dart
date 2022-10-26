import 'package:equatable/equatable.dart';
import 'package:hand_bill_manger/src/data/model/company.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

// fetch countries
class FetchCountriesEvent extends AuthEvent {}

// login
class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  const LoginEvent({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

// register

class RegisterButtonPressed extends AuthEvent {
  final Company company;

  RegisterButtonPressed({required this.company});
}

// class RegisterButtonPressed extends AuthEvent {
//   final String name;
//   final String email;
//   final String password;
//   final String country;
//   final String phone;
//   // final String natureactivity;
//   // final String catgID;

//   RegisterButtonPressed(
//       {required this.name,
//       required this.email,
//       required this.password,
//       required this.country,
//       // required this.natureactivity,
//       // required this.catgID,
//       required this.phone});

//   @override
//   List<Object> get props => [
//         name,
//         email,
//         password,
//         country,
//         phone,
//       ];
// }

// rest password

class RestPasswordEvent extends AuthEvent {
  final String code;
  final String newPassword;

  RestPasswordEvent({required this.code, required this.newPassword});

  @override
  List<Object> get props => [code, newPassword];
}

//  verification code

class ForgetPasswordEvent extends AuthEvent {
  final String email;

  ForgetPasswordEvent({required this.email});

  @override
  List<Object> get props => [email];
}

class CheckVerificationCodeEvent extends AuthEvent {
  final String code;

  CheckVerificationCodeEvent({required this.code});

  @override
  List<Object> get props => [code];
}

class FetchPlansEvent extends AuthEvent {
  final String natureOfActivity;

  FetchPlansEvent({required this.natureOfActivity});
}

class ChosePlansEvent extends AuthEvent {
  final Company company;
  final int id;

  ChosePlansEvent({required this.company, required this.id});
}
