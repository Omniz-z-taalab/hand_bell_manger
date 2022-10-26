import 'package:hand_bill_manger/src/data/model/category.dart';

class CategoryResponse {
  bool? _status;
  List<CategoryModel>? _data;
  String? _message;

  bool? get status => _status;

  List<CategoryModel>? get data => _data;

  String? get message => _message;

  CategoryResponse({bool? status, List<CategoryModel>? data, String? message}) {
    _status = status;
    _data = data;
    _message = message;
  }

  CategoryResponse.fromJson(dynamic json) {
    _status = json["status"];
    if (json["data"] != null) {
      _data = [];
      // json["data"].forEach((v) {
      //   _data!.add(CategoryModel.fromJson(v));
      // });
    }
    _message = json["message"];
  }
}
