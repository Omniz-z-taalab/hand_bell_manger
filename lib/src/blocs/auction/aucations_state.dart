import 'package:equatable/equatable.dart';
import 'package:hand_bill_manger/src/data/model/account_package/auction_model.dart';

abstract class AuctionsState extends Equatable {
  const AuctionsState();

  @override
  List<Object> get props => [];
}

class AuctionsInitialState extends AuctionsState {}

class AuctionsLoadingState extends AuctionsState {}

class AuctionsErrorState extends AuctionsState {
  final String? error;

  AuctionsErrorState({required this.error});
}

// fetch
class MyAuctionsSuccessState extends AuctionsState {
  final List<AuctionModel>? items;

  MyAuctionsSuccessState({required this.items});
}

// add
class AuctionAddSuccessState extends AuctionsState {
  final String message;

  AuctionAddSuccessState({required this.message});
}

// remove
class AuctionRemoveSuccessState extends AuctionsState {
  final String? message;
  final AuctionModel model;

  AuctionRemoveSuccessState({required this.message, required this.model});
}
// remove
class AuctionCloseSuccessState extends AuctionsState {
  final String message;


  AuctionCloseSuccessState({required this.message});
}
