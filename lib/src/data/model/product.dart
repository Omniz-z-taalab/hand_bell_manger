import 'package:hand_bill_manger/src/common/api_data.dart';
import 'package:hand_bill_manger/src/common/constns.dart';
import 'package:hand_bill_manger/src/data/model/company.dart';
import 'package:hand_bill_manger/src/data/model/local/images.dart';
import 'package:hand_bill_manger/src/data/model/local/video_model.dart';
import 'package:hand_bill_manger/src/data/model/product/shipping.dart';
import 'package:hand_bill_manger/src/data/model/specifications.dart';

class Product {
  int? _id;
  String? _subSubCategoryId;
  bool? _isFavourite;
  String? _subCategoryId;
  String? _featured;
  String? _shippingMqo;
  String? _categoryId;
  String? _companyId;
  String? _description;
  String? _country;
  String? _price;
  String? _flag;
  String? _name;
  String? _createdAt;
  String? _updatedAt;
  List<ImageModel>? _images;
  VideoModel? _video;
  ShippingData? _shippingData;
  List<Specifications>? _specifications;
  Company? _company;
  bool? _selected;

  int? get id => _id;

  String? get subSubCategoryId => _subSubCategoryId;

  bool? get isFavourite => _isFavourite;

  String? get subCategoryId => _subCategoryId;

  String? get featured => _featured;

  String? get shippingMqo => _shippingMqo;

  String? get categoryId => _categoryId;

  String? get companyId => _companyId;

  String? get description => _description;

  String? get country => _country;

  String? get price => _price;

  String? get flag => _flag;

  String? get name => _name;

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;

  List<ImageModel>? get images => _images;

  VideoModel? get video => _video;

  ShippingData? get shippingData => _shippingData;

  List<Specifications>? get specifications => _specifications;

  Company? get company => _company;

  bool? get selected => _selected;

  Product(
      {int? id,
      String? subSubCategoryId,
      bool? isFavourite,
      String? subCategoryId,
      String? featured,
      String? shippingMqo,
      String? categoryId,
      String? companyId,
      String? description,
      String? country,
      String? price,
      String? flag,
      String? name,
      String? createdAt,
      String? updatedAt,
      List<ImageModel>? images,
      VideoModel? video,
      ShippingData? shippingData,
      List<Specifications>? specifications,
      Company? company,
      bool? selected = false}) {
    _id = id;
    _subSubCategoryId = subSubCategoryId;
    _isFavourite = isFavourite;
    _subCategoryId = subCategoryId;
    _featured = featured;
    _shippingMqo = shippingMqo;
    _categoryId = categoryId;
    _companyId = companyId;
    _description = description;
    _country = country;
    _price = price;
    _flag = flag;
    _name = name;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _images = images;
    _video = video;
    _shippingData = shippingData;
    _specifications = specifications;
    _company = company;
    _selected = selected;
  }

  Product.fromJson(dynamic json) {
    _id = json["id"];
    _subSubCategoryId = json["sub_sub_category_id"];
    _isFavourite = json["is_favourite"];
    _subCategoryId = json["sub_category_id"];
    _featured = json["featured"];
    _shippingMqo = json["shipping_mqo"];
    _categoryId = json["category_id"];
    _companyId = json["company_id"];
    _description = json["description"];
    _country = json["country"];
    _price = json["price"];
    _flag = json["flag"] == null
        ? placeholder_concat
        : APIData.domainLink + json["flag"];
    _name = json["name"];
    _createdAt = json["created_at"];
    _updatedAt = json["updated_at"];
    if (json["images"] != null) {
      _images = [];
      json["images"].forEach((v) {
        _images?.add(ImageModel.fromJson(v));
      });
    }
    _video = json["video"];
    _shippingData = json["shipping_data"] != null
        ? ShippingData.fromJson(json["shipping_data"])
        : null;
    if (json["specifications"] != null) {
      _specifications = [];
      json["specifications"].forEach((v) {
        _specifications?.add(Specifications.fromJson(v));
      });
    }
    _company =
        json["company"] != null ? Company.fromJson(json["company"]) : null;
    _selected = false;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["sub_sub_category_id"] = _subSubCategoryId;
    map["is_favourite"] = _isFavourite;
    map["sub_category_id"] = _subCategoryId;
    map["featured"] = _featured;
    map["shipping_mqo"] = _shippingMqo;
    map["category_id"] = _categoryId;
    map["company_id"] = _companyId;
    map["description"] = _description;
    map["country"] = _country;
    map["price"] = _price;
    map["flag"] = _flag;
    map["name"] = _name;
    map["created_at"] = _createdAt;
    map["updated_at"] = _updatedAt;
    if (_images != null) {
      map["images"] = _images?.map((v) => v.toJson()).toList();
    }
    map["video"] = _video;
    if (_shippingData != null) {
      map["shipping_data"] = _shippingData?.toJson();
    }
    if (_specifications != null) {
      map["specifications"] = _specifications?.map((v) => v.toJson()).toList();
    }
    if (_company != null) {
      map["company"] = _company?.toJson();
    }
    return map;
  }

  set selected(bool? value) {
    _selected = value;
  }
}
