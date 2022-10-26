import 'package:hand_bill_manger/src/data/model/local/images.dart';

import 'package:hand_bill_manger/src/data/model/local/images.dart';

import 'package:hand_bill_manger/src/data/model/local/images.dart';

import 'package:hand_bill_manger/src/data/model/local/images.dart';

class AddProfileImageResponse {
  bool? _status;
  List<SaveImageModel>? _data;
  String? _message;

  bool? get status => _status;

  List<SaveImageModel>? get data => _data;

  String? get message => _message;

  AddProfileImageResponse(
      {bool? status, List<SaveImageModel>? data, String? message}) {
    _status = status;
    _data = data;
    _message = message;
  }

  AddProfileImageResponse.fromJson(dynamic json) {
    _status = json["status"];
    if (json["data"] != null) {
      _data = [];
      json["data"].forEach((v) {
        _data?.add(SaveImageModel.fromJson(v));
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
