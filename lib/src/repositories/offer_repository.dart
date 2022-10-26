import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:hand_bill_manger/src/common/api_data.dart';
import 'package:hand_bill_manger/src/data/model/account_package/offer_model.dart';
import 'package:hand_bill_manger/src/data/model/company.dart';
import 'package:hand_bill_manger/src/data/response/common_response.dart';
import 'package:hand_bill_manger/src/data/response/offers/my_offers_response.dart';

class OffersRepository {
  String tag = "OffersRepository";
  Dio _dio = Dio();
  Company? company;

  Future<MyOffersResponse> getMyOffersData(
      {required int page, required Company company}) async {
    _dio.options.headers["Authorization"] =
        "Bearer " + company.apiToken.toString();
    _dio.options.headers["Accept"] = "application/json";

    Map<String, String> queryParams =
        ({"secret": APIData.secretKey, "page": "$page", "paginate": "6"});

    late MyOffersResponse offersResponse;
    Response response;
    try {
      response =
          await _dio.get(APIData.getMyOffersData, queryParameters: queryParams);
      offersResponse = MyOffersResponse.fromJson(response.data);

      // log("${jsonEncode(response.data)}");
    } catch (error, stackTrace) {
      print("$tag error : $error , stackTrace:  $stackTrace");
    }
    return offersResponse;
  }

  Future<CommonResponse?> addOffer(
      {required OfferModel model,
      required Company company,
      required List<Object> images}) async {
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
      "description": model.description,
      "min_quantity": model.minQuantity,
      "old_price": model.oldPrice,
      "new_price": model.newPrice,
    };
    if (images.length == 1) {
      file1 = images[0] as File;
      _map["first_image_offer"] = await MultipartFile.fromFile(file1.path,
          filename: file1.path.split('/').last);
    } else if (images.length == 2) {
      file1 = images[0] as File;
      file2 = images[1] as File;
      _map["first_image_offer"] = await MultipartFile.fromFile(file1.path,
          filename: file1.path.split('/').last);
      _map["second_image_offer"] = await MultipartFile.fromFile(file2.path,
          filename: file2.path.split('/').last);
    } else if (images.length == 3) {
      file1 = images[0] as File;
      file2 = images[1] as File;
      file3 = images[2] as File;
      _map["first_image_offer"] = await MultipartFile.fromFile(file1.path,
          filename: file1.path.split('/').last);
      _map["second_image_offer"] = await MultipartFile.fromFile(file2.path,
          filename: file2.path.split('/').last);
      _map["third_image_offer"] = await MultipartFile.fromFile(file3.path,
          filename: file3.path.split('/').last);
    }

    formData = FormData.fromMap(_map);
    Response response;

    CommonResponse? commonResponse;

    try {
      response = await _dio.post(APIData.addOffer, data: formData);

      log("${jsonEncode(response.data)}");

      commonResponse = CommonResponse.fromJson(response.data);
    } catch (error, stackTrace) {
      print("$tag error : $error , stackTrace:  $stackTrace");
    }
    return commonResponse;
  }

  Future<CommonResponse?> removeOffer(
      {required OfferModel model, required Company company}) async {
    _dio.options.headers["Authorization"] =
        "Bearer " + company.apiToken.toString();
    _dio.options.headers["Accept"] = "application/json";

    Response response;
    CommonResponse? commonResponse;

    Map<String, String> queryParameters = {
      "secret": APIData.secretKey,
      "id": model.id.toString()
    };
    try {
      response = await _dio.delete(APIData.removeOffer,
          queryParameters: queryParameters);

      log("${jsonEncode(response.data)}");

      commonResponse = CommonResponse.fromJson(response.data);
    } catch (error, stackTrace) {
      print("$tag error : $error , stackTrace:  $stackTrace");
    }
    return commonResponse;
  }
}
