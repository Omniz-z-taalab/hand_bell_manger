
import 'package:hand_bill_manger/src/common/api_data.dart';

class VideoModel {
  int? _id;
  String? _order;
  String? _modelId;
  String? _description;
  String? _modelType;
  String? _url;
  String? _createdAt;
  String? _updatedAt;

  int? get id => _id;

  String? get order => _order;

  String? get modelId => _modelId;

  String? get description => _description;

  String? get modelType => _modelType;

  String? get url => _url;

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;

  VideoModel(
      {int? id,
      String? order,
      String? modelId,
      String? description,
      String? modelType,
      String? url,
      String? createdAt,
      String? updatedAt}) {
    _id = id;
    _order = order;
    _modelId = modelId;
    _description = description;
    _modelType = modelType;
    _url = url;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  VideoModel.fromJson(dynamic json) {
    _id = json["id"];
    _order = json["order"];
    _modelId = json["model_id"];
    _description = json["description"];
    _modelType = json["model_type"];
    _url = APIData.domainLink + json["url"];
    _createdAt = json["created_at"];
    _updatedAt = json["updated_at"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["order"] = _order;
    map["model_id"] = _modelId;
    map["description"] = _description;
    map["model_type"] = _modelType;
    map["url"] = _url;
    map["created_at"] = _createdAt;
    map["updated_at"] = _updatedAt;
    return map;
  }
}
