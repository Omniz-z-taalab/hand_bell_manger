
import 'package:hand_bill_manger/src/data/model/account_package/job_category_model.dart';

class JobsCategoriesResponse {
  List<JobCategoryModel>? _data;
  bool? _status;
  String? _message;

  List<JobCategoryModel>? get data => _data;

  bool? get status => _status;

  String? get message => _message;

  JobsCategoriesResponse(
      {List<JobCategoryModel>? data, bool? status, String? message}) {
    _data = data;
    _status = status;
    _message = message;
  }

  JobsCategoriesResponse.fromJson(dynamic json) {
    if (json["data"] != null) {
      _data = [];
      json["data"].forEach((v) {
        _data?.add(JobCategoryModel.fromJson(v));
      });
    }
    _status = json["status"];
    _message = json["message"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_data != null) {
      map["data"] = _data?.map((v) => v.toJson()).toList();
    }
    map["status"] = _status;
    map["message"] = _message;
    return map;
  }
}
