class CategoryProduct {
  int? _id;
  String? _name;
  bool? _selected;

  int? get id => _id;

  String? get name => _name;

  bool? get selected => _selected;

  CategoryProduct({int? id, String? name, bool? selected}) {
    _id = id;
    _name = name;
    _selected = selected;
  }

  CategoryProduct.fromJson(dynamic json) {
    _id = json["id"];
    _name = json["name"];
    _selected = false;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["name"] = _name;
    return map;
  }

  set selected(bool ?value) {
    _selected = value;
  }
}
