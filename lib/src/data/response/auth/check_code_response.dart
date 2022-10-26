import 'package:hand_bill_manger/src/data/model/company.dart';

class CheckCodeResponse {
  bool? _status;
  List<Company>? _data;
  String? _message;

  bool? get status => _status;

  List<Company>? get data => _data;

  String? get message => _message;

  CheckCodeResponse({bool? status, List<Company>? data, String? message}) {
    _status = status;
    _data = data;
    _message = message;
  }

  CheckCodeResponse.fromJson(dynamic json) {
    _status = json["status"];
    if (json["data"] != null) {
      _data = [];
      json["data"].forEach((v) {
        _data?.add(Company.fromJson(v));
      });
    }
    _message = json["message"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = _status;
    if (_data != null) {
      map["data"] = _data?.map((v) => v.toJson()).toList();
    }
    map["message"] = _message;
    return map;
  }
}
