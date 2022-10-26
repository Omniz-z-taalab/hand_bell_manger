import 'package:hand_bill_manger/src/data/model/sub_sub_category.dart';

class SubCategoryModel {
  int? id;
  String? name;
  List<SubSubCategoryModel> ?subSubList;

  SubCategoryModel({int? id, String? name,  List<SubSubCategoryModel> ?subSubList}) {
    this.id = id;
    this.name = name;
    this.subSubList = subSubList;
  }
}
