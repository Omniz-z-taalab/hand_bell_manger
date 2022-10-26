import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:hand_bill_manger/src/common/api_data.dart';
import 'package:hand_bill_manger/src/common/global.dart';
import 'package:hand_bill_manger/src/data/model/company.dart';
import 'package:hand_bill_manger/src/data/response/auth/login_response_.dart';
import 'package:hand_bill_manger/src/data/response/auth/plan_respons.dart';
import 'package:hand_bill_manger/src/data/response/auth/register_response_.dart';
import 'package:hand_bill_manger/src/data/response/common_response.dart';
import 'package:hand_bill_manger/src/data/response/profile/countries_response.dart';

class AuthRepository {
  String tag = "AuthRepository";
  var _dio = Dio();

  // fetch countries
  Future<CountriesResponse?> fetchCountriesData() async {
    Map<String, String> queryParameters = {"secret": APIData.secretKey};
    Response response;
    CountriesResponse? countriesResponse;
    try {
      response = await _dio.get(APIData.getCountries,
          queryParameters: queryParameters);
      countriesResponse = CountriesResponse.fromJson(response.data);
    } catch (error, stackTrace) {
      print("$tag error $error  stackTrace $stackTrace");
    }
    return countriesResponse;
  }

  Future<LoginResponse?> login({required Company company}) async {
    FormData formData = new FormData.fromMap({
      "secret": APIData.secretKey,
      "email": company.email,
      "device_token": company.deviceToken,
      "password": company.password,
    });
    LoginResponse? loginResponse;
    late Response response;
    try {
      response = await _dio.post(APIData.login, data: formData);
      loginResponse = LoginResponse.fromJson(response.data);

      // log("${jsonEncode(response.data)}");
    } catch (error, stackTrace) {
      print("$tag ${response.statusCode}");
      print("$tag error $error , stackTrace: $stackTrace ");
    }
    return loginResponse;
  }

  Future<RegisterResponse?> register({required Company company}) async {
    FormData formData = new FormData.fromMap({
      "secret": APIData.secretKey,
      "email": company.email,
      "password": company.password,
      "confirm_password": company.confirmpassword,
      "name": company.name,
      "device_token": company.deviceToken,
      "country": company.country,
      "phone": company.firstPhone,
      "nature_activity": company.natureActivity
    });
    RegisterResponse? registerResponse;
    Response? response;
    // try {
    response = await _dio.post(
      APIData.register,
      data: formData,
    );
    log("\nregister ${jsonEncode(response.data)}");
    registerResponse = RegisterResponse.fromJson(response.data);
    // } catch (error, stackTrace) {
    //   print("$tag ${response!.statusCode}");
    //   print("$tag error $error , stackTrace: $stackTrace ");
    // }
    return registerResponse;
  }

  // Future<RegisterResponse?> register({required Company company}) async {
  //   Map<String, dynamic> _map = {"secret": APIData.secretKey};
  //   _map.addAll(company.toJson());
  //   FormData formData = new FormData.fromMap(_map);
  //   log("dataRegister: ${company.toJson()}");
  //   RegisterResponse? registerResponse;
  //   late Response response;
  //   try {
  //     response = await _dio.post(APIData.register, data: formData,
  //     options: Options(followRedirects: false,
  //       // will not throw errors
  //       validateStatus: (status) => true,));
  //     log("registerResponse: ${response.toString()}");
  //     registerResponse = RegisterResponse.fromJson(response.data);
  //   } catch (error, stackTrace) {
  //     print("$tag error $error , stackTrace: $stackTrace ");
  //   }
  //   return registerResponse;
  // }

  Future<CommonResponse?> restPassword(
      {required String code, required String newPassword}) async {
    FormData formData = new FormData.fromMap(
        {"secret": APIData.secretKey, "code": code, "password": newPassword});

    Response response;
    CommonResponse? commonResponse;

    try {
      response = await _dio.post(APIData.restPassword, data: formData);

      // log("${jsonEncode(response.data)}");
      commonResponse = CommonResponse.fromJson(response.data);
    } catch (error, stackTrace) {
      print("error $error , stackTrace: $stackTrace ");
    }
    return commonResponse;
  }

  Future<CommonResponse?> forgetPassword(String email) async {
    FormData formData =
        new FormData.fromMap({"secret": APIData.secretKey, "email": email});

    Response response = await _dio.post(APIData.forgetPassword, data: formData);

    late CommonResponse commonResponse;
    try {
      if (response.statusCode == 200) {
        commonResponse = CommonResponse.fromJson(response.data);
      }
    } catch (error, stackTrace) {
      print("error $error , stackTrace: $stackTrace ");
    }
    return commonResponse;
  }

  Future<LoginResponse?> checkVerificationCode(String code) async {
    FormData formData =
        new FormData.fromMap({"secret": APIData.secretKey, "code": code});

    Response response =
        await _dio.post(APIData.checkVerificationCode, data: formData);
    log("checkVerificationCode: ${response.data}");
    late LoginResponse checkCodeResponse;
    try {
      if (response.statusCode == 200) {
        checkCodeResponse = LoginResponse.fromJson(response.data);
      }
    } catch (error, stackTrace) {
      print("error $error , stackTrace: $stackTrace ");
    }
    return checkCodeResponse;
  }

  Future<PlanResponse?> getPlans({required String natureOfActivity}) async {
    Map<String, String> queryParameters = {
      "secret": APIData.secretKey,
      "nature_activity": natureOfActivity
    };
    Response response =
        await _dio.get(APIData.getPlans, queryParameters: queryParameters);
    log("getPlans: ${response.data}");
    late PlanResponse plansResponse;
    try {
      if (response.statusCode == 200) {
        plansResponse = PlanResponse.fromJson(response.data);
      }
    } catch (error, stackTrace) {
      print("error $error , stackTrace: $stackTrace ");
    }
    return plansResponse;
  }

  Future<CommonResponse?> chosePlans(
      {required Company company, required int id}) async {
    _dio.options.headers["Authorization"] =
        "Bearer " + company.apiToken.toString();
    _dio.options.headers["Accept"] = "application/json";
    FormData formData =
        new FormData.fromMap({"secret": APIData.secretKey, "plan": id});

    Response response = await _dio.post(APIData.chosePlans, data: formData);

    late CommonResponse commonResponse;
    try {
      commonResponse = CommonResponse.fromJson(response.data);
      log("chosePlans: ${response.data}");
    } catch (error, stackTrace) {
      print("error $error , stackTrace: $stackTrace ");
    }
    return commonResponse;
  }

  Future<bool> logging() async {
    currentUser = (await storage.read(key: "currentUser"));
    bool result = true ? currentUser != null : currentUser == null;

    return result;
  }

  void setCurrentUser(jsonString) async {
    try {
      String value = json.encode(jsonString);
      await storage.write(key: "currentUser", value: value);
    } catch (error, stacktarce) {
      print('error $error , stacktarce $stacktarce');
    }
  }

  Future<Company?> getCurrentUser() async {
    Company? company;
    String? sName;
    sName = await storage.read(key: "currentUser");
    if (sName != null) {
      company = Company.fromJson(json.decode(sName));
      // print("$tag  currentUser = ${json.decode(sName)}");
    } else {
      company = null;
    }

    return company;
  }

  removeCurrentUser() async {
    await storage.delete(key: "currentUser");
    // await storage.delete(key: "firstTime");
  }
}
