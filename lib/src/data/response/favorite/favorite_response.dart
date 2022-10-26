import 'package:hand_bill_manger/src/data/model/favorite_model.dart';

class FavoriteResponse {
  bool? _status;
  List<FavoriteModel>? _data;
  String? _message;

  bool? get status => _status;

  List<FavoriteModel>? get data => _data;

  String? get message => _message;

  FavoriteResponse(
      {bool? status, List<FavoriteModel>? data, String? message}) {
    _status = status;
    _data = data;
    _message = message;
  }

  FavoriteResponse.fromJson(dynamic json) {
    _status = json["status"];
    if (json["data"] != null) {
      _data = [];
      json["data"].forEach((v) {
        _data!.add(FavoriteModel.fromJson(v));
      });
    }
    _message = json["message"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["success"] = _status;
    if (_data != null) {
      map["data"] = _data!.map((v) => v.toJson()).toList();
    }
    map["message"] = _message;
    return map;
  }
}
