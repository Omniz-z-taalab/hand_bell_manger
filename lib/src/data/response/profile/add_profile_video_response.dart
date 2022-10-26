import 'package:hand_bill_manger/src/data/model/local/images.dart';

import 'package:hand_bill_manger/src/data/model/local/images.dart';

import 'package:hand_bill_manger/src/data/model/local/images.dart';

import 'package:hand_bill_manger/src/data/model/local/images.dart';
import 'package:hand_bill_manger/src/data/model/local/video_model.dart';
import 'package:hand_bill_manger/src/data/model/local/video_model.dart';
import 'package:hand_bill_manger/src/data/model/local/video_model.dart';

class AddProfileVideoResponse {
  bool? _status;
  VideoModel? _data;
  String? _message;

  bool? get status => _status;

  VideoModel? get data => _data;

  String? get message => _message;

  AddProfileVideoResponse(
      {bool? status, VideoModel? data, String? message}) {
    _status = status;
    _data = data;
    _message = message;
  }

  AddProfileVideoResponse.fromJson(dynamic json) {
    _status = json["status"];
    _data = json["data"] != null ? VideoModel.fromJson(json["data"]) : null;
    _message = json["message"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = _status;
    // if (_data != null) {
    //   map["data"] = _data?.map((v) => v.toJson()).toList();
    // }
    map["message"] = _message;
    return map;
  }
}
