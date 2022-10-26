import 'package:equatable/equatable.dart';
import 'package:hand_bill_manger/src/data/model/account_package/ad_model.dart';
import 'package:hand_bill_manger/src/data/model/company.dart';

abstract class AdsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// get ads coast
class GetAdsCoastEvent extends AdsEvent {
  final Company company;

  GetAdsCoastEvent({required this.company});
}

// fetch
class FetchMyAdsEvent extends AdsEvent {
  final Company company;

  FetchMyAdsEvent({required this.company});
}

// add
class AdsAddEvent extends AdsEvent {
  final AdsModel model;
  final Company company;

  AdsAddEvent({required this.model, required this.company});
}

// remove
class AdsRemoveEvent extends AdsEvent {
  final int id;
  final Company company;

  AdsRemoveEvent({required this.company, required this.id});
}
