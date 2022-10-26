class AdsCoastModel {
  int? _id;
  String? _product;
  String? _company;
  String? _banner;
  String? _createdAt;
  String? _updatedAt;

  int? get id => _id;

  String? get product => _product;

  String? get company => _company;

  String? get banner => _banner;

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;

  AdsCoastModel(
      {int? id,
      String? product,
      String? company,
      String? banner,
      String? createdAt,
      String? updatedAt}) {
    _id = id;
    _product = product;
    _company = company;
    _banner = banner;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  AdsCoastModel.fromJson(dynamic json) {
    _id = json["id"];
    _product = json["product"];
    _company = json["company"];
    _banner = json["banner"];
    _createdAt = json["created_at"];
    _updatedAt = json["updated_at"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["product"] = _product;
    map["company"] = _company;
    map["banner"] = _banner;
    map["created_at"] = _createdAt;
    map["updated_at"] = _updatedAt;
    return map;
  }
}
