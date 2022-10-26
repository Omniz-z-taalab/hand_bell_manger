import 'package:equatable/equatable.dart';
import 'package:hand_bill_manger/src/data/model/company.dart';
import 'package:hand_bill_manger/src/data/model/country_model.dart';
import 'package:hand_bill_manger/src/data/model/package_model.dart';
import 'package:hand_bill_manger/src/data/model/plan_model.dart';
import 'package:hand_bill_manger/src/data/response/auth/plan_respons.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthFailure extends AuthState {
  final String? error;

  AuthFailure({required this.error});

  @override
  List<Object?> get props => [error];
}

// get countries
class CountriesSuccessState extends AuthState {
  final List<CountryModel> items;

  CountriesSuccessState({required this.items});
}

// login
class LoginSuccess extends AuthState {
  final String? message;
  final Company? company;

  LoginSuccess({this.message, this.company});
}

// register

class RegisterSuccess extends AuthState {
  final String? message;
  final Company company;

  RegisterSuccess({required this.message, required this.company});

  @override
  List<Object?> get props => [message];
}

// rest password

class RestPasswordSuccess extends AuthState {
  final String? message;

  RestPasswordSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}
//  forget password

class ForgetPasswordSuccess extends AuthState {
  final String? message;

  ForgetPasswordSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class CheckVerificationCodeSuccess extends AuthState {
  final String? message;
  final Company company;

  CheckVerificationCodeSuccess({required this.message, required this.company});

  @override
  List<Object?> get props => [message];
}

class GetPlansSuccess extends AuthState {
  final List<PlanModel> items;

  GetPlansSuccess({required this.items});
}

class ChosePlansSuccess extends AuthState {
  final String? message;

  ChosePlansSuccess({required this.message});
}
