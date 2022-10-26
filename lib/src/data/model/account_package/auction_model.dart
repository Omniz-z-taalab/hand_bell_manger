import 'package:hand_bill_manger/src/data/model/company.dart';
import 'package:hand_bill_manger/src/data/model/local/images.dart';
import 'package:hand_bill_manger/src/data/model/local/video_model.dart';

class AuctionModel {
  int? _id;
  String? _status;
  String? _expirationDate;
  String? _companyId;
  String? _description;
  bool? _closed;
  String? _title;
  String? _price;
  String? _createdAt;
  String? _updatedAt;
  List<ImageModel>? _images;
  VideoModel? _video;
  Company? _company;

  int? get id => _id;

  String? get status => _status;

  String? get expirationDate => _expirationDate;

  String? get companyId => _companyId;

  String? get description => _description;

  bool? get closed => _closed;

  String? get title => _title;

  String? get price => _price;

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;

  List<ImageModel>? get images => _images;

  VideoModel? get video => _video;

  Company? get company => _company;

  AuctionModel(
      {int? id,
      String? status,
      String? expirationDate,
      String? companyId,
      String? description,
      bool? closed,
      String? title,
      String? price,
      String? createdAt,
      String? updatedAt,
      List<ImageModel>? images,
      VideoModel? video,
      Company? company}) {
    _id = id;
    _status = status;
    _expirationDate = expirationDate;
    _companyId = companyId;
    _description = description;
    _closed = closed;
    _title = title;
    _price = price;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _images = images;
    _video = video;
    _company = company;
  }

  AuctionModel.fromJson(dynamic json) {
    _id = json["id"];
    _status = json["status"];
    _expirationDate = json["expiration_date"];
    _companyId = json["company_id"];
    _description = json["description"];
    _closed = json["closed"];
    _title = json["title"];
    _price = json["price"];
    _createdAt = json["created_at"];
    _updatedAt = json["updated_at"];
    if (json["images"] != null) {
      _images = [];
      json["images"].forEach((v) {
        _images?.add(ImageModel.fromJson(v));
      });
    }
    _video = json["video"] != null ? VideoModel.fromJson(json["video"]) : null;
    _company =
        json["company"] != null ? Company.fromJson(json["company"]) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["status"] = _status;
    map["expiration_date"] = _expirationDate;
    map["company_id"] = _companyId;
    map["description"] = _description;
    map["closed"] = _closed;
    map["title"] = _title;
    map["price"] = _price;
    map["created_at"] = _createdAt;
    map["updated_at"] = _updatedAt;
    if (_images != null) {
      map["images"] = _images?.map((v) => v.toJson()).toList();
    }
    if (_video != null) {
      map["video"] = _video?.toJson();
    }
    if (_company != null) {
      map["company"] = _company?.toJson();
    }
    return map;
  }

  set price(String? value) {
    _price = value;
  }

  set title(String? value) {
    _title = value;
  }

  set description(String? value) {
    _description = value;
  }

  set closed(bool? value) {
    _closed = value;
  }
}
