import 'package:hand_bill_manger/src/data/model/plan_model.dart';

class PlanResponse {
  List<PlanModel>? _data;
  bool? _status;
  String? _message;

  List<PlanModel>? get data => _data;
  bool? get status => _status;
  String? get message => _message;

  PlanResponse({
      List<PlanModel>? data,
      bool? status, 
      String? message}){
    _data = data;
    _status = status;
    _message = message;
}

  PlanResponse.fromJson(dynamic json) {
    if (json["data"] != null) {
      _data = [];
      json["data"].forEach((v) {
        _data?.add(PlanModel.fromJson(v));
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

