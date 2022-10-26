import 'package:flutter/material.dart';

class PackageModel {
  int? id;
  String? name;
  double? price;
  Color? color;
  int? productCount;
  int? imageCount;
  int? jobsCount;
  int? assetsCount;
  int? offersCount;
  int? videoCount;
  int? auctionCount;

  PackageModel(
      {this.id,
      this.name,
      this.price,
      this.color,
      this.productCount,
      this.imageCount,
      this.videoCount,
      this.jobsCount,
      this.assetsCount,
      this.offersCount,
      this.auctionCount});

  static fromJson(json) {}

  toJson() {}
}
