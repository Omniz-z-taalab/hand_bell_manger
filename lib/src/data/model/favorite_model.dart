import 'package:hand_bill_manger/src/data/model/product.dart';

class FavoriteModel {
  int? _id;
  int? _productId;
  int? _userId;
  String? _createdAt;
  String? _updatedAt;
  Product? _product;

  int? get id => _id;

  int? get productId => _productId;

  int? get userId => _userId;

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;

  Product? get product => _product;

  FavoriteModel(
      {int? id,
      int? productId,
      int? userId,
      String? createdAt,
      String? updatedAt,
      Product? product}) {
    _id = id;
    _productId = productId;
    _userId = userId;
    _createdAt = createdAt;
    _updatedAt = updatedAt;

    _product = product;
  }

  FavoriteModel.fromJson(dynamic json) {
    _id = json["id"];
    _productId = json["food_id"];
    _userId = json["user_id"];
    _createdAt = json["created_at"];
    _updatedAt = json["updated_at"];

    _product = json["food"] != null ? Product.fromJson(json["food"]) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["food_id"] = _productId;
    map["user_id"] = _userId;
    map["created_at"] = _createdAt;
    map["updated_at"] = _updatedAt;

    if (_product != null) {
      map["food"] = _product!.toJson();
    }

    return map;
  }
}
