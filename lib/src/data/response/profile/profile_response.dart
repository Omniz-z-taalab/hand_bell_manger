
import 'package:hand_bill_manger/src/data/model/company.dart';

class ProfileResponse {
  bool? _status;
  Company? _data;
  String? _message;

  bool? get status => _status;

  Company? get data => _data;

  String? get message => _message;

  ProfileResponse({bool? status, Company? data, String? message}) {
    _status = status;
    _data = data;
    _message = message;
  }

  ProfileResponse.fromJson(dynamic json) {
    _status = json["status"];
    _data = json["data"] != null ? Company.fromJson(json["data"]) : null;
    _message = json["message"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = _status;
    if (_data != null) {
      map["data"] = _data!.toJson();
    }
    map["message"] = _message;
    return map;
  }
}
