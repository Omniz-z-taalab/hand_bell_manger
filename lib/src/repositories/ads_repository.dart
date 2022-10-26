import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:hand_bill_manger/src/common/api_data.dart';
import 'package:hand_bill_manger/src/data/model/account_package/ad_model.dart';
import 'package:hand_bill_manger/src/data/model/company.dart';
import 'package:hand_bill_manger/src/data/response/ads/coast_response.dart';
import 'package:hand_bill_manger/src/data/response/ads/my_ads_respons.dart';
import 'package:hand_bill_manger/src/data/response/common_response.dart';

class AdsRepository {
  String tag = "AdsRepository";
  Dio _dio = Dio();
  Company? company;

  // get ads coast
  Future<CoastResponse> getAdsCoast({required Company company}) async {
    _dio.options.headers["Authorization"] =
        "Bearer " + company.apiToken.toString();
    _dio.options.headers["Accept"] = "application/json";

    Map<String, String> queryParams = ({"secret": APIData.secretKey});

    late CoastResponse coastResponse;
    Response response;
    try {
      response =
          await _dio.get(APIData.getAdsCoast, queryParameters: queryParams);
      coastResponse = CoastResponse.fromJson(response.data);
    } catch (error, stackTrace) {
      print("$tag error : $error , stackTrace:  $stackTrace");
    }
    return coastResponse;
  }

  Future<CommonResponse?> addAds(
      {required AdsModel model, required Company company}) async {
    _dio.options.headers["Authorization"] =
        "Bearer " + company.apiToken.toString();
    _dio.options.headers["Accept"] = "application/json";
    FormData formData;
    Map<String, dynamic> _map = {
      "secret": APIData.secretKey,
      "type": model.type
    };
    // banner
    if (model.type == "banner") {
      _map["banner"] = await MultipartFile.fromFile(model.file!.path,
          filename: model.file!.path.split('/').last);
    }
    // product
    else if (model.type == "product") {
      _map['model_id'] = model.id;
    }
    // company get id by token

    formData = FormData.fromMap(_map);
    Response response;

    CommonResponse? commonResponse;

    try {
      response = await _dio.post(APIData.addAds, data: formData);

      log("${jsonEncode(response.data)}");
      commonResponse = CommonResponse.fromJson(response.data);
    } catch (error, stackTrace) {
      print("$tag error : $error , stackTrace:  $stackTrace");
    }
    return commonResponse;
  }

  Future<MyAdsResponse> getMyAdsData({required int page}) async {
    _dio.options.headers["Authorization"] =
        "Bearer " + company!.apiToken.toString();
    _dio.options.headers["Accept"] = "application/json";

    Map<String, String> queryParams =
        ({"secret": APIData.secretKey, "page": "$page", "paginate": "6"});

    late MyAdsResponse offersResponse;
    Response response;
    try {
      response =
          await _dio.get(APIData.getMyAdsData, queryParameters: queryParams);
      offersResponse = MyAdsResponse.fromJson(response.data);
      log("${jsonEncode(response.data)}");
    } catch (error, stackTrace) {
      print("$tag error : $error , stackTrace:  $stackTrace");
    }
    return offersResponse;
  }

  Future<CommonResponse?> removeAds(
      {required int id, required Company company}) async {
    _dio.options.headers["Authorization"] =
        "Bearer " + company.apiToken.toString();
    _dio.options.headers["Accept"] = "application/json";

    Map<String, String> queryParams =
        ({"secret": APIData.secretKey, "id": id.toString()});

    Response response;
    CommonResponse? commonResponse;

    try {
      response =
          await _dio.delete(APIData.removeAds, queryParameters: queryParams);

      log("${jsonEncode(response.data)}");

      commonResponse = CommonResponse.fromJson(response.data);
    } catch (error, stackTrace) {
      print("$tag error : $error , stackTrace:  $stackTrace");
    }
    return commonResponse;
  }
}
