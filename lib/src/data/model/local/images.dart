import 'package:hand_bill_manger/src/common/api_data.dart';
import 'package:hand_bill_manger/src/common/constns.dart';

class ImageModel {
  int? _id;
  String? _modelId;
  String? _description;
  String? _modelType;
  String? _thump;
  String? _icon;
  String? _url;
  String? _createdAt;
  String? _updatedAt;

  int? get id => _id;

  String? get modelId => _modelId;

  String? get description => _description;

  String? get modelType => _modelType;

  String? get thump => _thump;

  String? get icon => _icon;

  String? get url => _url;

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;

  ImageModel(
      {int? id,
      String? modelId,
      String? description,
      String? modelType,
      String? thump,
      String? icon,
      String? url,
      String? createdAt,
      String? updatedAt}) {
    _id = id;
    _modelId = modelId;
    _description = description;
    _modelType = modelType;
    _thump = thump;
    _icon = icon;
    _url = url;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  ImageModel.fromJson(dynamic json) {
    try {
      _id = json["id"];
      _modelId = json["model_id"];
      _description = json["description"];
      _modelType = json["model_type"];
      _thump = json["thump"] == null
          ? placeholder_concat
          : APIData.domainLink + json["thump"];
      _icon = json["icon"] == null
          ? placeholder_concat
          : APIData.domainLink + json["icon"];
      _url = json["url"] == null
          ? placeholder_concat
          : APIData.domainLink + json["url"];
      _createdAt = json["created_at"];
      _updatedAt = json["updated_at"];
    } catch (e) {
      // _thump = APIData.domainLink + json["thump"];
      // _icon = APIData.domainLink + json["icon"];
      // _url = APIData.domainLink + json["url"];
      print(e);
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["model_id"] = _modelId;
    map["description"] = _description;
    map["model_type"] = _modelType;
    map["thump"] = _thump;
    map["icon"] = _icon;
    map["url"] = _url;
    map["created_at"] = _createdAt;
    map["updated_at"] = _updatedAt;
    return map;
  }
}
// for save to local without contation

class SaveImageModel {
  int? _id;
  String? _modelId;
  String? _description;
  String? _modelType;
  String? _thump;
  String? _icon;
  String? _url;
  String? _createdAt;
  String? _updatedAt;

  int? get id => _id;

  String? get modelId => _modelId;

  String? get description => _description;

  String? get modelType => _modelType;

  String? get thump => _thump;

  String? get icon => _icon;

  String? get url => _url;

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;

  SaveImageModel(
      {int? id,
      String? modelId,
      String? description,
      String? modelType,
      String? thump,
      String? icon,
      String? url,
      String? createdAt,
      String? updatedAt}) {
    _id = id;
    _modelId = modelId;
    _description = description;
    _modelType = modelType;
    _thump = thump;
    _icon = icon;
    _url = url;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  SaveImageModel.fromJson(dynamic json) {
    try {
      _id = json["id"];
      _modelId = json["model_id"];
      _description = json["description"];
      _modelType = json["model_type"];
      _thump = json["thump"];
      _icon = json["icon"];
      _url = json["url"];
      _createdAt = json["created_at"];
      _updatedAt = json["updated_at"];
    } catch (e) {
      // _thump = APIData.domainLink + json["thump"];
      // _icon = APIData.domainLink + json["icon"];
      // _url = APIData.domainLink + json["url"];
      print(e);
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["model_id"] = _modelId;
    map["description"] = _description;
    map["model_type"] = _modelType;
    map["thump"] = _thump;
    map["icon"] = _icon;
    map["url"] = _url;
    map["created_at"] = _createdAt;
    map["updated_at"] = _updatedAt;
    return map;
  }
}
