import 'package:equatable/equatable.dart';
import 'package:hand_bill_manger/src/data/model/account_package/auction_model.dart';
import 'package:hand_bill_manger/src/data/model/company.dart';

abstract class AuctionsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// fetch my auction
class FetchMyAuctionsEvent extends AuctionsEvent {
  final Company company;

  FetchMyAuctionsEvent({required this.company});
}

// add
class AuctionAddEvent extends AuctionsEvent {
  final AuctionModel model;
  final Company company;
  final List<Object> images;
  final Object? video;

  AuctionAddEvent(
      {required this.model,
      required this.company,
      required this.images,
      this.video});
}

// remove
class AuctionRemoveEvent extends AuctionsEvent {
  final AuctionModel model;
  final Company company;

  AuctionRemoveEvent({required this.company, required this.model});
}
// close
class AuctionCloseEvent extends AuctionsEvent {
  final int id;
  final Company company;

  AuctionCloseEvent({required this.company, required this.id});
}
