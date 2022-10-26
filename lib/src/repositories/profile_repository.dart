import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:hand_bill_manger/src/common/api_data.dart';
import 'package:hand_bill_manger/src/data/model/company.dart';
import 'package:hand_bill_manger/src/data/response/common_response.dart';
import 'package:hand_bill_manger/src/data/response/profile/add_profile_image_response.dart';
import 'package:hand_bill_manger/src/data/response/profile/add_profile_video_response.dart';
import 'package:hand_bill_manger/src/data/response/profile/change_profile_logo_response.dart';
import 'package:hand_bill_manger/src/data/response/profile/edit_profile_response_.dart';
import 'package:hand_bill_manger/src/data/response/profile/profile_response.dart';

class ProfileRepository {
  var tag = "ProfileRepository";
  var _dio = Dio();

  Future<ProfileResponse?> fetchProfileData({required Company company}) async {
    _dio.options.headers["Authorization"] =
        "Bearer " + company.apiToken.toString();
    _dio.options.headers["Accept"] = "application/json";
    Map<String, String> queryParameters = {"secret": APIData.secretKey};
    Response response;
    ProfileResponse? profileResponse;
    try {
      response = await _dio.get(APIData.companyProfile,
          queryParameters: queryParameters);
      profileResponse = ProfileResponse.fromJson(response.data);
      log("fetchProfileData: ${jsonEncode(response.data)}");
    } catch (error, stackTrace) {
      print("$tag error $error  stackTrace $stackTrace");
    }
    return profileResponse;
  }

  // add images
  Future<AddProfileImageResponse?> addProfileImages(
      {required Company company, required List<Object> images}) async {
    _dio.options.headers["Authorization"] =
        "Bearer " + company.apiToken.toString();
    _dio.options.headers["Accept"] = "application/json";
    FormData? formData;

    if (images.length == 1) {
      File file1 = images[0] as File;
      formData = FormData.fromMap({
        "secret": APIData.secretKey,
        "first_company_image": await MultipartFile.fromFile(file1.path,
            filename: file1.path.split('/').last)
      });
    } else if (images.length == 2) {
      File file1 = images[0] as File;
      File file2 = images[1] as File;
      formData = FormData.fromMap({
        "secret": APIData.secretKey,
        "first_company_image": await MultipartFile.fromFile(file1.path,
            filename: file1.path.split('/').last),
        "second_company_image": await MultipartFile.fromFile(file2.path,
            filename: file2.path.split('/').last),
      });
    } else if (images.length == 3) {
      File file1 = images[0] as File;
      File file2 = images[1] as File;
      File file3 = images[2] as File;
      formData = FormData.fromMap({
        "secret": APIData.secretKey,
        "first_company_image": await MultipartFile.fromFile(file1.path,
            filename: file1.path.split('/').last),
        "second_company_image": await MultipartFile.fromFile(file2.path,
            filename: file2.path.split('/').last),
        "third_company_image": await MultipartFile.fromFile(file3.path,
            filename: file3.path.split('/').last),
      });
    } else if (images.length == 4) {
      File file1 = images[0] as File;
      File file2 = images[1] as File;
      File file3 = images[2] as File;
      File file4 = images[3] as File;
      formData = FormData.fromMap({
        "secret": APIData.secretKey,
        "first_company_image": await MultipartFile.fromFile(file1.path,
            filename: file1.path.split('/').last),
        "second_company_image": await MultipartFile.fromFile(file2.path,
            filename: file2.path.split('/').last),
        "third_company_image": await MultipartFile.fromFile(file3.path,
            filename: file3.path.split('/').last),
        "fourth_company_image": await MultipartFile.fromFile(file4.path,
            filename: file4.path.split('/').last),
      });
    } else if (images.length == 5) {
      File file1 = images[0] as File;
      File file2 = images[1] as File;
      File file3 = images[2] as File;
      File file4 = images[3] as File;
      File file5 = images[4] as File;
      formData = FormData.fromMap({
        "secret": APIData.secretKey,
        "first_company_image": await MultipartFile.fromFile(file1.path,
            filename: file1.path.split('/').last),
        "second_company_image": await MultipartFile.fromFile(file2.path,
            filename: file2.path.split('/').last),
        "third_company_image": await MultipartFile.fromFile(file3.path,
            filename: file3.path.split('/').last),
        "fourth_company_image": await MultipartFile.fromFile(file4.path,
            filename: file4.path.split('/').last),
        "fifth_company_image": await MultipartFile.fromFile(file5.path,
            filename: file5.path.split('/').last),
      });
    }

    Response response;

    AddProfileImageResponse? addProfileImageResponse;

    try {
      response = await _dio.post(APIData.addCompanyImages, data: formData);

      log("${jsonEncode(response.data)}");

      addProfileImageResponse = AddProfileImageResponse.fromJson(response.data);
    } catch (error, stackTrace) {
      print("$tag error : $error , stackTrace:  $stackTrace");
    }
    return addProfileImageResponse;
  }

  // remove image
  Future<CommonResponse?> removeImage(
      {required int id, required Company company}) async {
    _dio.options.headers["Authorization"] =
        "Bearer " + company.apiToken.toString();
    _dio.options.headers["Accept"] = "application/json";

    Response response;
    CommonResponse? commonResponse;

    Map<String, String> queryParameters = {
      "secret": APIData.secretKey,
      "id": id.toString()
    };
    try {
      response = await _dio.delete(APIData.removeCompanyImages,
          queryParameters: queryParameters);

      log("${jsonEncode(response.data)}");

      commonResponse = CommonResponse.fromJson(response.data);
    } catch (error, stackTrace) {
      print("$tag error : $error , stackTrace:  $stackTrace");
    }
    return commonResponse;
  }

  // add video
  Future<AddProfileVideoResponse?> addProfileVideo(
      {required Company company, required Object video}) async {
    _dio.options.headers["Authorization"] =
        "Bearer " + company.apiToken.toString();
    _dio.options.headers["Accept"] = "application/json";
    FormData? formData;

    File _video = video as File;
    formData = FormData.fromMap({
      "secret": APIData.secretKey,
      "company_video": await MultipartFile.fromFile(_video.path,
          filename: _video.path.split('/').last)
    });

    Response response;

    AddProfileVideoResponse? addProfileVideoResponse;

    try {
      response = await _dio.post(APIData.addCompanyVideo, data: formData);

      log("${jsonEncode(response.data)}");

      addProfileVideoResponse = AddProfileVideoResponse.fromJson(response.data);
    } catch (error, stackTrace) {
      print("$tag error : $error , stackTrace:  $stackTrace");
    }
    return addProfileVideoResponse;
  }

  // remove video
  Future<CommonResponse?> removeVideo(
      {required int id, required Company company}) async {
    _dio.options.headers["Authorization"] =
        "Bearer " + company.apiToken.toString();
    _dio.options.headers["Accept"] = "application/json";

    Response response;
    CommonResponse? commonResponse;

    Map<String, String> queryParameters = {
      "secret": APIData.secretKey,
      "id": id.toString()
    };
    try {
      response = await _dio.delete(APIData.removeCompanyVideo,
          queryParameters: queryParameters);

      log("${jsonEncode(response.data)}");

      commonResponse = CommonResponse.fromJson(response.data);
    } catch (error, stackTrace) {
      print("$tag error : $error , stackTrace:  $stackTrace");
    }
    return commonResponse;
  }

  // add logo
  Future<ChangeProfileLogoResponse?> addLogo(
      {required Company company, required File file}) async {
    _dio.options.headers["Authorization"] =
        "Bearer " + company.apiToken.toString();
    _dio.options.headers["Accept"] = "application/json";
    FormData? formData;
    formData = FormData.fromMap({
      "secret": APIData.secretKey,
      "logo": await MultipartFile.fromFile(file.path,
          filename: file.path.split('/').last)
    });

    Response response;
    ChangeProfileLogoResponse? changeProfileLogoResponse;

    try {
      response = await _dio.post(APIData.addCompanyLogo, data: formData);

      log("${jsonEncode(response.data)}");

      changeProfileLogoResponse = ChangeProfileLogoResponse.fromJson(response.data);
    } catch (error, stackTrace) {
      print("$tag error : $error , stackTrace:  $stackTrace");
    }
    return changeProfileLogoResponse;
  }

  // remove logo
  Future<CommonResponse?> removeLogo(
      {required int id, required Company company}) async {
    _dio.options.headers["Authorization"] =
        "Bearer " + company.apiToken.toString();
    _dio.options.headers["Accept"] = "application/json";

    Response response;
    CommonResponse? commonResponse;

    Map<String, String> queryParameters = {
      "secret": APIData.secretKey,
      "id": id.toString()
    };
    try {
      response = await _dio.delete(APIData.removeCompanyLogo,
          queryParameters: queryParameters);

      log("${jsonEncode(response.data)}");

      commonResponse = CommonResponse.fromJson(response.data);
    } catch (error, stackTrace) {
      print("$tag error : $error , stackTrace:  $stackTrace");
    }
    return commonResponse;
  }

  Future<EditProfileResponse?> editProfileInfo(
      {required Company company}) async {
    _dio.options.headers["Authorization"] =
        "Bearer " + company.apiToken.toString();
    _dio.options.headers["Accept"] = "application/json";

    Map<String, dynamic> _map = {
      "secret": APIData.secretKey,
      "name": company.name
    };

    company.leftDataOfCompanies!.toJson().forEach((key, value) {
      if (value != null) {
        _map[key] = value;
      }
    });

    FormData formData = FormData.fromMap(_map);
    print("first: ${formData.fields.toString()}");
    Response response;
    EditProfileResponse? editProfileResponse;

    try {
      response = await _dio.post(APIData.editProfile, data: formData);

      log("edit profile: ${jsonEncode(response.data)}");
      editProfileResponse = EditProfileResponse.fromJson(response.data);
    } catch (error, stackTrace) {
      print("$tag error $error  stackTrace $stackTrace");
    }
    return editProfileResponse;
  }

  Future<CommonResponse?> changePassword(
      {required Company company,
      required String currentPass,
      required String newPass}) async {
    FormData formData;

    formData = FormData.fromMap({
      "secret": APIData.secretKey,
      "current_password": currentPass,
      "new_password": newPass
    });
    _dio.options.headers["Authorization"] =
        "Bearer " + company.apiToken.toString();
    _dio.options.headers["Accept"] = "application/json";
    Response response;

    CommonResponse? forgetPasswordResponse;

    try {
      response = await _dio.post(APIData.changePassword, data: formData);
      log("${jsonEncode(response.data)}");
      forgetPasswordResponse = CommonResponse.fromJson(response.data);
    } catch (error, stackTrace) {
      print("$tag error $error  stackTrace $stackTrace");
    }
    return forgetPasswordResponse;
  }
}
