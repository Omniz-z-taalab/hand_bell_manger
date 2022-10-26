import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:hand_bill_manger/src/common/api_data.dart';
import 'package:hand_bill_manger/src/data/model/account_package/assets_model.dart';
import 'package:hand_bill_manger/src/data/model/company.dart';
import 'package:hand_bill_manger/src/data/response/assets/add_asset_response.dart';
import 'package:hand_bill_manger/src/data/response/assets/my_assets_response.dart';
import 'package:hand_bill_manger/src/data/response/common_response.dart';

class AssetsRepository {
  String tag = "AssetsRepository";
  Dio _dio = Dio();
  Company? company;

  Future<MyAssetsResponse> getAssetsData(
      {required int page, required Company company}) async {
    _dio.options.headers["Authorization"] =
        "Bearer " + company.apiToken.toString();
    _dio.options.headers["Accept"] = "application/json";

    Map<String, String> queryParams =
        ({"secret": APIData.secretKey, "page": "$page", "paginate": "6"});

    late MyAssetsResponse assetsResponse;
    try {
      Response response =
          await _dio.get(APIData.getMyAssetData, queryParameters: queryParams);

      assetsResponse = MyAssetsResponse.fromJson(response.data);

      log("${jsonEncode(response.data)}");
    } catch (error, stackTrace) {
      print("$tag error : $error , stackTrace:  $stackTrace");
    }
    return assetsResponse;
  }

  Future<CommonResponse?> addAsset(
      {required AssetsModel model,
      required Company company,
      required List<Object> images}) async {
    _dio.options.headers["Authorization"] =
        "Bearer " + company.apiToken.toString();
    _dio.options.headers["Accept"] = "application/json";

    File file1;
    File file2;
    File file3;
    Map<String, dynamic> _map = {
      "secret": APIData.secretKey,
      "title": model.title,
      "price": model.price,
      "description": model.description,
      "location": model.location,
      "property_type": model.propertyType,
    };
    if (images.length == 1) {
      file1 = images[0] as File;
      _map["first_image_asset"] = await MultipartFile.fromFile(file1.path,
          filename: file1.path.split('/').last);
    } else if (images.length == 2) {
      file1 = images[0] as File;
      file2 = images[1] as File;
      _map["first_image_asset"] = await MultipartFile.fromFile(file1.path,
          filename: file1.path.split('/').last);
      _map["second_image_asset"] = await MultipartFile.fromFile(file2.path,
          filename: file2.path.split('/').last);
    } else if (images.length == 3) {
      file1 = images[0] as File;
      file2 = images[1] as File;
      file3 = images[2] as File;
      _map["first_image_asset"] = await MultipartFile.fromFile(file1.path,
          filename: file1.path.split('/').last);
      _map["second_image_asset"] = await MultipartFile.fromFile(file2.path,
          filename: file2.path.split('/').last);
      _map["third_image_asset"] = await MultipartFile.fromFile(file3.path,
          filename: file3.path.split('/').last);
    }

    FormData formData = FormData.fromMap(_map);

    Response response;

    CommonResponse? commonResponse;

    try {
      response = await _dio.post(APIData.addAsset, data: formData);

      log("${jsonEncode(response.data)}");

      commonResponse = CommonResponse.fromJson(response.data);
    } catch (error, stackTrace) {
      print("$tag error : $error , stackTrace:  $stackTrace");
    }
    return commonResponse;
  }

  Future<CommonResponse?> removeAsset(
      {required AssetsModel model, required Company company}) async {
    _dio.options.headers["Authorization"] =
        "Bearer " + company.apiToken.toString();
    _dio.options.headers["Accept"] = "application/json";
    Map<String, String> queryParameters = {
      "secret": APIData.secretKey,
      "id": model.id.toString()
    };
    Response response;

    CommonResponse? commonResponse;

    try {
      response = await _dio.delete(APIData.removeAsset,
          queryParameters: queryParameters);

      log("${jsonEncode(response.data)}");

      commonResponse = CommonResponse.fromJson(response.data);
    } catch (error, stackTrace) {
      print("$tag error : $error , stackTrace:  $stackTrace");
    }
    return commonResponse;
  }
}
