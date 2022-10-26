import 'package:equatable/equatable.dart';
import 'package:hand_bill_manger/src/data/model/account_package/offer_model.dart';

abstract class OffersState extends Equatable {
  const OffersState();

  @override
  List<Object> get props => [];
}

class OffersInitialState extends OffersState {}

class OffersLoadingState extends OffersState {}

class OffersErrorState extends OffersState {
  final String? error;

  OffersErrorState({required this.error});
}

// fetch
class MyOffersSuccessState extends OffersState {
  final List<OfferModel>? items;
  final int count;

  MyOffersSuccessState({required this.items, required this.count});
}

// add
class OfferAddSuccessState extends OffersState {
  final String message;

  OfferAddSuccessState({required this.message});
}

// remove
class OfferRemoveSuccessState extends OffersState {
  final String? message;
  final OfferModel model;

  OfferRemoveSuccessState({required this.message, required this.model});
}
