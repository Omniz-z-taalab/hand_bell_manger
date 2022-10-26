import 'package:hand_bill_manger/src/data/model/company.dart';

class ShippingModel {
  String? title;
  String? date;
  Company? company;
  String? description;
  String? address;
  String? services;

  ShippingModel(
      {this.title,
      this.date,
      this.company,
      this.description,
      this.address,
      this.services});
}
