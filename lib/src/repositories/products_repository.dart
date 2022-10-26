import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:hand_bill_manger/src/common/api_data.dart';
import 'package:hand_bill_manger/src/data/model/company.dart';
import 'package:hand_bill_manger/src/data/model/product.dart';
import 'package:hand_bill_manger/src/data/response/common_response.dart';
import 'package:hand_bill_manger/src/data/response/home/featured_product_response.dart';
import 'package:hand_bill_manger/src/data/response/product/my_product_response.dart';
import 'package:hand_bill_manger/src/data/response/product/categories_product_response.dart';
import 'package:hand_bill_manger/src/data/response/product/product_details_response.dart';

class ProductsRepository {
  String tag = "ProductsRepository";
  Dio _dio = Dio();
  Company? company;

  // featured product
  Future<FeaturedProductsResponse> getFeaturedProducts(
      {required Company company, required int page}) async {
    _dio.options.headers["Authorization"] =
        "Bearer " + company.apiToken.toString();
    _dio.options.headers["Accept"] = "application/json";
    Map<String, String> queryParams = ({"secret": '${APIData.secretKey}'});

    late FeaturedProductsResponse featuredProductsResponse;
    try {
      Response response = await _dio.get(APIData.getFeaturedProduct,
          queryParameters: queryParams);
      featuredProductsResponse =
          FeaturedProductsResponse.fromJson(response.data);
    } catch (error, stackTrace) {
      print("$tag error : $error , stackTrace:  $stackTrace");
    }
    return featuredProductsResponse;
  }

  //  product categories
  Future<CategoriesProductResponse> getCategoriesProducts(
      {required Company company}) async {
    _dio.options.headers["Authorization"] =
        "Bearer " + company.apiToken.toString();
    _dio.options.headers["Accept"] = "application/json";
    Map<String, String> queryParams = ({"secret": '${APIData.secretKey}'});

    late CategoriesProductResponse productCategoriesResponse;
    try {
      Response response = await _dio.get(APIData.getProductCategories,
          queryParameters: queryParams);
      productCategoriesResponse =
          CategoriesProductResponse.fromJson(response.data);
    } catch (error, stackTrace) {
      print("$tag error : $error , stackTrace:  $stackTrace");
    }
    return productCategoriesResponse;
  }

  // products
  Future<MyProductResponse> getProductsByCategory(
      {required Company company,
      required int page,
      required int categoryId}) async {
    _dio.options.headers["Authorization"] =
        "Bearer " + company.apiToken.toString();
    _dio.options.headers["Accept"] = "application/json";
    Map<String, String> queryParams =
        ({"secret": APIData.secretKey, "category_id": categoryId.toString()});

    late MyProductResponse myProductResponse;
    Response response;
    try {
      response = await _dio.get(APIData.getProductsByCategory,
          queryParameters: queryParams);
      myProductResponse = MyProductResponse.fromJson(response.data);

      log("$categoryId ${jsonEncode(response.data)}");
    } catch (error, stackTrace) {
      print("$tag error : $error , stackTrace:  $stackTrace");
    }
    return myProductResponse;
  }

  // remove featured product
  Future<CommonResponse?> removeFeatureProduct(
      {required Product model, required Company company}) async {
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
      response = await _dio.delete(APIData.removeFeatureProduct,
          queryParameters: queryParameters);

      log("${jsonEncode(response.data)}");

      commonResponse = CommonResponse.fromJson(response.data);
    } catch (error, stackTrace) {
      print("$tag error : $error , stackTrace:  $stackTrace");
    }
    return commonResponse;
  }

  // remove product
  Future<CommonResponse?> removeProduct(
      {required Product model, required Company company}) async {
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
      response = await _dio.delete(APIData.removeProduct,
          queryParameters: queryParameters);

      log("${jsonEncode(response.data)}");

      commonResponse = CommonResponse.fromJson(response.data);
    } catch (error, stackTrace) {
      print("$tag error : $error , stackTrace:  $stackTrace");
    }
    return commonResponse;
  }

  // details
  Future<ProductDetailsResponse> getProductDetail({required int id}) async {
    Map<String, String> queryParameters = {"secret": APIData.secretKey};

    late ProductDetailsResponse productDetailResponse;
    try {
      Response response = await _dio.get('${APIData.productDetails}/$id',
          queryParameters: queryParameters);

      productDetailResponse = ProductDetailsResponse.fromJson(response.data);

      log("pp ${jsonEncode(response.data)}");
    } catch (error, stackTrace) {
      print("$tag =>  error : $error , stackTrace : $stackTrace");
    }
    return productDetailResponse;
  }
}
