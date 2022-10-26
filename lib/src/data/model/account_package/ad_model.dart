import 'dart:io';

import 'package:hand_bill_manger/src/common/api_data.dart';

class AdsModel {
  int? _id;
  String? _status;
  String? _type;
  String? _expirationDate;
  String? _companyId;
  String? _modelId;
  String? _image;
  String? _name;
  String? _createdAt;
  String? _updatedAt;
  File? _file;

  int? get id => _id;

  String? get status => _status;

  String? get type => _type;

  String? get expirationDate => _expirationDate;

  String? get companyId => _companyId;

  String? get modelId => _modelId;

  String? get image => _image;

  String? get name => _name;

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;

  File? get file => _file;

  AdsModel(
      {int? id,
      String? status,
      String? type,
      String? expirationDate,
      String? companyId,
      String? modelId,
      String? image,
      String? name,
      String? createdAt,
      String? updatedAt,
      File? file}) {
    _id = id;
    _status = status;
    _type = type;
    _expirationDate = expirationDate;
    _companyId = companyId;
    _modelId = modelId;
    _image = image;
    _name = name;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _file = file;
  }

  AdsModel.fromJson(dynamic json) {
    _id = json["id"];
    _status = json["status"];
    _type = json["type"];
    _expirationDate = json["expiration_date"];
    _companyId = json["company_id"];
    _modelId = json["model_id"];
    _image = APIData.domainLink + json["image"];
    _name = json["name"];
    _createdAt = json["created_at"];
    _updatedAt = json["updated_at"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["status"] = _status;
    map["type"] = _type;
    map["expiration_date"] = _expirationDate;
    map["company_id"] = _companyId;
    map["model_id"] = _modelId;
    map["image"] = _image;
    map["name"] = _name;
    map["created_at"] = _createdAt;
    map["updated_at"] = _updatedAt;
    return map;
  }

  set file(File? value) {
    _file = value;
  }
}

// class AdsModel {
//   int? id;
//   String? title;
//   String? image;
//   String? adType;
//   String? time;
//   String? status;
//   File? file;
//
//   AdsModel(
//       {this.id,
//       this.title,
//       this.image,
//       this.adType,
//       this.time,
//       this.status,
//       this.file});
// }
