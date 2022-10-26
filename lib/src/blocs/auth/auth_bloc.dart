import 'dart:async';
import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hand_bill_manger/src/blocs/global_bloc/global_bloc.dart';
import 'package:hand_bill_manger/src/data/model/company.dart';
import 'package:hand_bill_manger/src/data/model/plan_model.dart';
import 'package:hand_bill_manger/src/data/response/auth/login_response_.dart';
import 'package:hand_bill_manger/src/data/response/auth/register_response_.dart';
import 'package:hand_bill_manger/src/data/response/common_response.dart';
import 'package:hand_bill_manger/src/repositories/auth_repository.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  String tag = "AuthBloc";
  AuthRepository authRepository = AuthRepository();

  late FirebaseMessaging _firebaseMessaging;
  late GlobalBloc globalBloc;
  late Company _company;

  AuthBloc({required BuildContext context}) : super(AuthInitial()) {
    globalBloc = BlocProvider.of<GlobalBloc>(context);
  }

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    await authInit();

    // fetch countries
    if (event is FetchCountriesEvent) {
      yield* _mapFetchCountries(event);
    }
    if (event is LoginEvent) {
      yield* _mapLoginWithEmailToState(event);
    }
    if (event is RegisterButtonPressed) {
      yield* _mapRegisterToState(event);
    }
    if (event is RestPasswordEvent) {
      yield* _mapRestPasswordToState(event);
    }
    if (event is ForgetPasswordEvent) {
      yield* _mapSendVerificationCodeToState(event);
    }
    if (event is CheckVerificationCodeEvent) {
      yield* _mapCheckVerificationCodeToState(event);
    }

    if (event is FetchPlansEvent) {
      yield* _mapGetPlansToState(event);
    }
    if (event is ChosePlansEvent) {
      yield* _mapChosePlansToState(event);
    }
  }

  late String _deviceToken;

  authInit() async {
    _company = Company();
    _firebaseMessaging = FirebaseMessaging.instance;
    await _firebaseMessaging.getToken().then((String? deviceToken) {
      _deviceToken = deviceToken!;
      _company.deviceToken = deviceToken;
    }).catchError((e) {
      print("$tag $e");
    });
  }

  // fetch countries
  Stream<AuthState> _mapFetchCountries(FetchCountriesEvent event) async* {
    yield AuthLoading();

    final response = await authRepository.fetchCountriesData();

    if (response!.status!) {
      yield CountriesSuccessState(items: response.data!);
    } else {
      yield AuthFailure(error: response.message.toString());
    }
  }

  // login
  Stream<AuthState> _mapLoginWithEmailToState(LoginEvent event) async* {
    yield AuthLoading();

    _company.email = event.email;
    _company.password = event.password;
    LoginResponse? response;
    try {
      if (_company.deviceToken == null) {
        yield AuthFailure(error: "not device token");
        return;
      } else {
        response = await authRepository.login(company: _company);
        log("token ${_company.deviceToken}");
        if (response!.status!) {
          globalBloc.company = response.data;
          authRepository.setCurrentUser(response.data);
          yield LoginSuccess(message: response.message, company: response.data);
        } else {
          yield AuthFailure(error: response.message);
        }
      }
    } catch (err, stack) {
      yield AuthFailure(error: err.toString());
      print(err.toString() + stack.toString());
    }
  }

  // register
  Stream<AuthState> _mapRegisterToState(RegisterButtonPressed event) async* {
    yield AuthLoading();
    _company.password = event.company.name;

    _company.email = event.company.email;
    _company.password = event.company.password;
    _company.password = event.company.firstPhone;

    _company.password = event.company.country;

    _company.password = event.company.natureActivity;

    RegisterResponse? response;
    event.company.deviceToken = _deviceToken;
    try {
      if (event.company.deviceToken == null) {
        yield AuthFailure(error: "not device token");
        return;
      } else {
        response = await authRepository.register(company: event.company);
        if (response!.status!) {
          yield RegisterSuccess(
              message: response.message, company: response.data!);
        } else {
          yield AuthFailure(error: response.message);
        }
      }
    } catch (err) {
      yield AuthFailure(error: err.toString());
    }
  }

  //  rest password
  Stream<AuthState> _mapRestPasswordToState(RestPasswordEvent event) async* {
    yield AuthLoading();
    try {
      final response = await authRepository.restPassword(
          code: event.code, newPassword: event.newPassword);
      if (response!.status!) {
        yield RestPasswordSuccess(message: response.message);
      } else {
        yield AuthFailure(error: response.message);
      }
    } catch (e) {
      yield AuthFailure(error: e.toString());
    }
  }

  //  forget password
  Stream<AuthState> _mapSendVerificationCodeToState(
      ForgetPasswordEvent event) async* {
    yield AuthLoading();
    try {
      CommonResponse? response =
          await authRepository.forgetPassword(event.email);
      if (response!.status!) {
        yield ForgetPasswordSuccess(message: response.message);
      } else {
        yield AuthFailure(error: response.message);
      }
    } catch (e) {
      yield AuthFailure(error: e.toString());
    }
  }

  Stream<AuthState> _mapCheckVerificationCodeToState(
      CheckVerificationCodeEvent event) async* {
    yield AuthLoading();
    try {
      final response = await authRepository.checkVerificationCode(event.code);
      if (response!.status!) {
        yield CheckVerificationCodeSuccess(
            message: response.message, company: response.data!);
      } else {
        yield AuthFailure(error: response.message);
      }
    } catch (e) {
      yield AuthFailure(error: e.toString());
    }
  }

  PlanModel? planModel;
  Stream<AuthState> _mapGetPlansToState(FetchPlansEvent event) async* {
    yield AuthLoading();
    try {
      if (planModel == null) {
        final response = await authRepository.getPlans(
            natureOfActivity: event.natureOfActivity);
        if (response!.status!) {
          yield GetPlansSuccess(items: response.data!);
          planModel = response.data!.first;
          emit(state);
        } else {
          yield AuthFailure(error: response.message);
        }
      }
    } catch (e) {
      yield AuthFailure(error: e.toString());
    }
  }

  Stream<AuthState> _mapChosePlansToState(ChosePlansEvent event) async* {
    yield AuthLoading();
    try {
      final response =
          await authRepository.chosePlans(company: event.company, id: event.id);
      if (response!.status!) {
        yield ChosePlansSuccess(message: response.message);
      } else {
        yield AuthFailure(error: response.message);
      }
    } catch (e) {
      yield AuthFailure(error: e.toString());
    }
  }
}
