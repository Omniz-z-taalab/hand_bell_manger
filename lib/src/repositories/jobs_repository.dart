import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:hand_bill_manger/src/common/api_data.dart';
import 'package:hand_bill_manger/src/data/model/account_package/job_company_model.dart';
import 'package:hand_bill_manger/src/data/model/company.dart';
import 'package:hand_bill_manger/src/data/response/common_response.dart';
import 'package:hand_bill_manger/src/data/response/jobs/jobs_categories_response.dart';
import 'package:hand_bill_manger/src/data/response/jobs/my_jobs_response.dart';
import 'package:hand_bill_manger/src/data/response/jobs/users_jobs_response.dart';

class JobsRepository {
  String tag = "JobsRepository";
  Dio _dio = Dio();
  Company? company;

  Future<UsersJobsResponse?> getUsersJobs(
      {required int page,
      required Company company,
      int? categoryId,
      int? subcategoryId}) async {
    _dio.options.headers["Authorization"] =
        "Bearer " + company.apiToken.toString();
    _dio.options.headers["Accept"] = "application/json";

    Map<String, String> queryParams;
    if (categoryId == null || subcategoryId == null) {
      queryParams = ({
        "secret": APIData.secretKey,
        "page": page.toString(),
        "paginate": "6"
      });
    } else {
      queryParams = ({
        "secret": APIData.secretKey,
        "page": page.toString(),
        "paginate": "6",
        "category_id": categoryId.toString(),
        "sub_category_id": subcategoryId.toString()
      });
    }

    late UsersJobsResponse jobsResponse;
    Response response;
    try {
      response =
          await _dio.get(APIData.getUsersJobs, queryParameters: queryParams);
      log("${jsonEncode(response.data)}");
      jobsResponse = UsersJobsResponse.fromJson(response.data);

    } catch (error, stackTrace) {
      print("$tag error : $error , stackTrace:  $stackTrace");
    }
    return jobsResponse;
  }

  Future<JobsCategoriesResponse?> getJobsCategories() async {
    Map<String, String> queryParams = ({"secret": APIData.secretKey});

    late JobsCategoriesResponse jobsCategoriesResponse;
    Response response;
    try {
      response = await _dio.get(APIData.getJobsCategories,
          queryParameters: queryParams);

      log("${jsonEncode(response.data)}");

      jobsCategoriesResponse = JobsCategoriesResponse.fromJson(response.data);
      if (jobsCategoriesResponse.status!) {
        return jobsCategoriesResponse;
      } else {
        return jobsCategoriesResponse;
      }
    } catch (error, stackTrace) {
      print("$tag error : $error , stackTrace:  $stackTrace");
    }
    return jobsCategoriesResponse;
  }

  Future<JobsCategoriesResponse?> getJobsSubCategories(
      {required int id}) async {
    Map<String, String> queryParams =
        ({"secret": APIData.secretKey, "category_id": id.toString()});

    late JobsCategoriesResponse jobsCategoriesResponse;
    Response response;
    try {
      response = await _dio.get(APIData.getJobsSubCategories,
          queryParameters: queryParams);

      log("${jsonEncode(response.data)}");

      jobsCategoriesResponse = JobsCategoriesResponse.fromJson(response.data);
      if (jobsCategoriesResponse.status!) {
        return jobsCategoriesResponse;
      } else {
        return jobsCategoriesResponse;
      }
    } catch (error, stackTrace) {
      print("$tag error : $error , stackTrace:  $stackTrace");
    }
    return jobsCategoriesResponse;
  }

  Future<MyJobsResponse?> getMyJobs(
      {required int page, required Company company}) async {
    _dio.options.headers["Authorization"] =
        "Bearer " + company.apiToken.toString();
    _dio.options.headers["Accept"] = "application/json";
    Map<String, String> queryParams = ({
      "secret": APIData.secretKey,
      "page": page.toString(),
      "paginate": "6"
    });

    late MyJobsResponse myJobsResponse;
    Response response;
    try {
      response =
          await _dio.get(APIData.getMyJobs, queryParameters: queryParams);

      log("${jsonEncode(response.data)}");

      myJobsResponse = MyJobsResponse.fromJson(response.data);
      if (myJobsResponse.status!) {
        return myJobsResponse;
      } else {
        return myJobsResponse;
      }
    } catch (error, stackTrace) {
      print("$tag error : $error , stackTrace:  $stackTrace");
    }
    return myJobsResponse;
  }

  Future<CommonResponse?> addJob(
      {required JobCompanyModel model, required Company company}) async {
    _dio.options.headers["Authorization"] =
        "Bearer " + company.apiToken.toString();
    _dio.options.headers["Accept"] = "application/json";
    FormData formData;

    formData = FormData.fromMap({
      "secret": APIData.secretKey,
      "title": model.title,
      "description": model.description,
      "category_id": model.jobCategoryModel!.id,
      "sub_category_id": model.jobSubCategoryModel!.id,
    });
    Response response;

    CommonResponse? commonResponse;

    try {
      response = await _dio.post(APIData.addJob, data: formData);

      log("${jsonEncode(response.data)}");

      commonResponse = CommonResponse.fromJson(response.data);
    } catch (error, stackTrace) {
      print("$tag error : $error , stackTrace:  $stackTrace");
    }
    return commonResponse;
  }

  Future<CommonResponse?> removeJob(
      {required JobCompanyModel model, required Company company}) async {
    _dio.options.headers["Authorization"] =
        "Bearer " + company.apiToken.toString();
    _dio.options.headers["Accept"] = "application/json";

    Map<String, String> queryParams =
        ({"secret": APIData.secretKey, "id": model.id.toString()});
    Response response;

    CommonResponse? commonResponse;

    try {
      response =
          await _dio.delete(APIData.removeJob, queryParameters: queryParams);

      log("${jsonEncode(response.data)}");

      commonResponse = CommonResponse.fromJson(response.data);
    } catch (error, stackTrace) {
      print("$tag error : $error , stackTrace:  $stackTrace");
    }
    return commonResponse;
  }
}
