import 'package:equatable/equatable.dart';
import 'package:hand_bill_manger/src/data/model/account_package/ad_model.dart';
import 'package:hand_bill_manger/src/data/model/ads/ads_coast_model.dart';

abstract class AdsState extends Equatable {
  const AdsState();

  @override
  List<Object> get props => [];
}

class AdsInitialState extends AdsState {}

class AdsLoadingState extends AdsState {}

class AdsErrorState extends AdsState {
  final String? error;

  AdsErrorState({required this.error});
}

// get ads coast
class AdsCoastSuccessState extends AdsState {
  final AdsCoastModel model;
  final String message;

  AdsCoastSuccessState({required this.model, required this.message});
}

// fetch
class MyAdsSuccessState extends AdsState {
  final List<AdsModel>? items;

  MyAdsSuccessState({required this.items});
}

// add
class AdsAddSuccessState extends AdsState {
  final String message;

  AdsAddSuccessState({required this.message});
}

// remove
class AdsRemoveSuccessState extends AdsState {
  final int id;
  final String? message;

  AdsRemoveSuccessState({required this.message, required this.id});
}
