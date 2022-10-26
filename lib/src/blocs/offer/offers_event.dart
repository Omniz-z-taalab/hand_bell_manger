import 'package:equatable/equatable.dart';
import 'package:hand_bill_manger/src/data/model/account_package/offer_model.dart';
import 'package:hand_bill_manger/src/data/model/company.dart';

abstract class OffersEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// fetch
class FetchMyOffersEvent extends OffersEvent {
  final Company company;
  final int page;

  FetchMyOffersEvent({required this.company, required this.page});
}

// add
class OfferAddEvent extends OffersEvent {
  final OfferModel model;
  final Company company;
  final List<Object> images;

  OfferAddEvent(
      {required this.model, required this.company, required this.images});
}

// remove
class OfferRemoveEvent extends OffersEvent {
  final OfferModel model;
  final Company company;

  OfferRemoveEvent({required this.company, required this.model});
}
