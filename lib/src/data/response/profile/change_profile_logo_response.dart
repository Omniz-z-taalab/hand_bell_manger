import 'package:hand_bill_manger/src/data/model/local/images.dart';

class ChangeProfileLogoResponse {
  bool? _status;
  SaveImageModel? _data;
  String? _message;

  bool? get status => _status;

  SaveImageModel? get data => _data;

  String? get message => _message;

  ChangeProfileLogoResponse(
      {bool? status, SaveImageModel? data, String? message}) {
    _status = status;
    _data = data;
    _message = message;
  }

  ChangeProfileLogoResponse.fromJson(dynamic json) {
    _status = json["status"];
    _data = json["data"] != null ? SaveImageModel.fromJson(json["data"]) : null;
    _message = json["message"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = _status;
    if (_data != null) {
      map["data"] = _data?.toJson();
    }
    map["message"] = _message;
    return map;
  }
}
