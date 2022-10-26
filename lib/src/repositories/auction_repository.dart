import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:hand_bill_manger/src/common/api_data.dart';
import 'package:hand_bill_manger/src/data/model/account_package/auction_model.dart';
import 'package:hand_bill_manger/src/data/model/company.dart';
import 'package:hand_bill_manger/src/data/response/auction/my_auction_response.dart';
import 'package:hand_bill_manger/src/data/response/common_response.dart';

class AuctionsRepository {
  String tag = "AuctionsRepository";
  Dio _dio = Dio();
  Company? company;

  Future<MyAuctionResponse> getAuctionsData(
      {required int page, required Company company}) async {
    _dio.options.headers["Authorization"] =
        "Bearer " + company.apiToken.toString();
    _dio.options.headers["Accept"] = "application/json";

    Map<String, String> queryParams =
        ({"secret": APIData.secretKey, "page": "$page", "paginate": "6"});

    late MyAuctionResponse auctionsResponse;
    try {
      Response response = await _dio.get(APIData.getMyAuctionData,
          queryParameters: queryParams);

      auctionsResponse = MyAuctionResponse.fromJson(response.data);

      log("${jsonEncode(response.data)}");
    } catch (error, stackTrace) {
      print("$tag error : $error , stackTrace:  $stackTrace");
    }
    return auctionsResponse;
  }

  Future<CommonResponse?> addAuction(
      {required AuctionModel model,
      required Company company,
      required List<Object> images,
      Object? video}) async {
    _dio.options.headers["Authorization"] =
        "Bearer " + company.apiToken.toString();
    _dio.options.headers["Accept"] = "application/json";
    FormData formData;

    File file1;
    File file2;
    File file3;
    Map<String, dynamic> _map = {
      "secret": APIData.secretKey,
      "title": model.title,
      "price": model.price,
      "description": model.description
    };
    if (images.length == 1) {
      file1 = images[0] as File;
      _map["first_auction_image"] = await MultipartFile.fromFile(file1.path,
          filename: file1.path.split('/').last);
    } else if (images.length == 2) {
      file1 = images[0] as File;
      file2 = images[1] as File;
      _map["first_auction_image"] = await MultipartFile.fromFile(file1.path,
          filename: file1.path.split('/').last);
      _map["second_auction_image"] = await MultipartFile.fromFile(file2.path,
          filename: file2.path.split('/').last);
    } else if (images.length == 3) {
      file1 = images[0] as File;
      file2 = images[1] as File;
      file3 = images[2] as File;
      _map["first_auction_image"] = await MultipartFile.fromFile(file1.path,
          filename: file1.path.split('/').last);
      _map["second_auction_image"] = await MultipartFile.fromFile(file2.path,
          filename: file2.path.split('/').last);
      _map["third_auction_image"] = await MultipartFile.fromFile(file3.path,
          filename: file3.path.split('/').last);
    }

    if (video != null) {
      File _video = video as File;
      _map['auction_video'] = await MultipartFile.fromFile(_video.path,
          filename: _video.path.split('/').last);
    }

    formData = FormData.fromMap(_map);
    Response response;

    CommonResponse? commonResponse;

    try {
      response = await _dio.post(APIData.addAuction, data: formData);

      log("${jsonEncode(response.data)}");

      commonResponse = CommonResponse.fromJson(response.data);
    } catch (error, stackTrace) {
      print("$tag error : $error , stackTrace:  $stackTrace");
    }
    return commonResponse;
  }

  Future<CommonResponse?> removeAuction(
      {required AuctionModel model, required Company company}) async {
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
      response = await _dio.delete(APIData.removeAuction,
          queryParameters: queryParameters);

      log("${jsonEncode(response.data)}");

      commonResponse = CommonResponse.fromJson(response.data);
    } catch (error, stackTrace) {
      print("$tag error : $error , stackTrace:  $stackTrace");
    }
    return commonResponse;
  }

  Future<CommonResponse?> closeAuction(
      {required int id, required Company company}) async {
    _dio.options.headers["Authorization"] =
        "Bearer " + company.apiToken.toString();
    _dio.options.headers["Accept"] = "application/json";
    FormData formData = FormData.fromMap(
        {"secret": APIData.secretKey, "id": id.toString()});
    Response response;

    CommonResponse? commonResponse;

    try {
      response = await _dio.post(APIData.closeAuction, data: formData);

      log("${jsonEncode(response.data)}");

      commonResponse = CommonResponse.fromJson(response.data);
    } catch (error, stackTrace) {
      print("$tag error : $error , stackTrace:  $stackTrace");
    }
    return commonResponse;
  }
}
