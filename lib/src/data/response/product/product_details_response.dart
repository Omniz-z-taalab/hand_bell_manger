import 'package:hand_bill_manger/src/data/model/product.dart';

class ProductDetailsResponse {
  bool? _status;
  Product? _data;
  String? _message;

  bool? get status => _status;

  Product? get data => _data;

  String? get message => _message;

  ProductDetailsResponse({bool? status, Product? data, String? message}) {
    _status = status;
    _data = data;
    _message = message;
  }

  ProductDetailsResponse.fromJson(dynamic json) {
    _status = json["status"];
    _data = json["data"] != null ? Product.fromJson(json["data"]) : null;
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
