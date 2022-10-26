import 'package:hand_bill_manger/src/data/model/ads/ads_coast_model.dart';

class CoastResponse {
  AdsCoastModel? _data;
  bool? _status;
  String? _message;

  AdsCoastModel? get data => _data;

  bool? get status => _status;

  String? get message => _message;

  CoastResponse({AdsCoastModel? data, bool? status, String? message}) {
    _data = data;
    _status = status;
    _message = message;
  }

  CoastResponse.fromJson(dynamic json) {
    _data = json["data"] != null ? AdsCoastModel.fromJson(json["data"]) : null;
    _status = json["status"];
    _message = json["message"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_data != null) {
      map["data"] = _data?.toJson();
    }
    map["status"] = _status;
    map["message"] = _message;
    return map;
  }
}
