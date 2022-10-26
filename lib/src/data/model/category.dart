class CategoryModel {
  int? id;
  String? name;
  bool? selected;

  CategoryModel({int? id, String? name, bool selected = false}) {
    this.id = id;
    this.name = name;
    this.selected = selected;
  }
}
