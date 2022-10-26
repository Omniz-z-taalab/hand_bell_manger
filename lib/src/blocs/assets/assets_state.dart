import 'package:equatable/equatable.dart';
import 'package:hand_bill_manger/src/data/model/account_package/assets_model.dart';

abstract class AssetsState extends Equatable {
  const AssetsState();

  @override
  List<Object> get props => [];
}

class AssetsInitialState extends AssetsState {}

class AssetsLoadingState extends AssetsState {}

class AssetsErrorState extends AssetsState {
  final String? error;

  AssetsErrorState({required this.error});
}

// fetch
class MyAssetsSuccessState extends AssetsState {
  final List<AssetsModel>? items;
  final int count;

  MyAssetsSuccessState({required this.items, required this.count});
}

// add
class AssetAddSuccessState extends AssetsState {
  final String message;

  AssetAddSuccessState({required this.message});
}

// remove
class AssetRemoveSuccessState extends AssetsState {
  final String? message;
  final AssetsModel model;

  AssetRemoveSuccessState({required this.message, required this.model});
}
