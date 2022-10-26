import 'package:hand_bill_manger/src/data/model/account_package/auction_model.dart';
import 'package:hand_bill_manger/src/data/model/account_package/shipping_model.dart';

class ShippingResponse {
  bool? _status;
  List<ShippingModel>? _data;
  String? _message;

  bool? get status => _status;

  List<ShippingModel>? get data => _data;

  String? get message => _message;

  ShippingResponse({bool? status, List<ShippingModel>? data, String? message}) {
    _status = status;
    _data = data;
    _message = message;
  }

  ShippingResponse.fromJson(dynamic json) {
    _status = json["status"];
    if (json["data"] != null) {
      _data = [];
      json["data"].forEach((v) {
        // _data!.add(NotificationModel.fromJson(v));
      });
    }
    _message = json["message"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["success"] = _status;

    map["message"] = _message;
    return map;
  }
}
