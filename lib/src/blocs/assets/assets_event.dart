import 'package:equatable/equatable.dart';
import 'package:hand_bill_manger/src/data/model/account_package/assets_model.dart';
import 'package:hand_bill_manger/src/data/model/company.dart';

abstract class AssetsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// fetch my asset
class FetchMyAssetsEvent extends AssetsEvent {
  final Company company;

  FetchMyAssetsEvent({required this.company});
}

// add
class AssetAddEvent extends AssetsEvent {
  final AssetsModel model;
  final Company company;
  final List<Object> images;

  AssetAddEvent(
      {required this.model, required this.company, required this.images});
}

// remove
class AssetRemoveEvent extends AssetsEvent {
  final AssetsModel model;
  final Company company;

  AssetRemoveEvent({required this.company, required this.model});
}
