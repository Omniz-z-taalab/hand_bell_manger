import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hand_bill_manger/src/blocs/global_bloc/global_bloc.dart';
import 'package:hand_bill_manger/src/repositories/auction_repository.dart';

import 'aucations_event.dart';
import 'aucations_state.dart';

class AuctionsBloc extends Bloc<AuctionsEvent, AuctionsState> {
  String tag = "AuctionBloc";

  AuctionsRepository _auctionsRepository = AuctionsRepository();
  int page = 1;
  bool isFetching = true;

  AuctionsBloc({required BuildContext context})
      : super(AuctionsInitialState()) {
    _auctionsRepository.company = BlocProvider.of<GlobalBloc>(context).company;
  }

  @override
  Stream<AuctionsState> mapEventToState(AuctionsEvent event) async* {
    if (event is FetchMyAuctionsEvent) {
      yield* _mapFetchMyAuctions(event);
    }
    if (event is AuctionAddEvent) {
      yield* _mapAddAuctions(event);
    }
    if (event is AuctionRemoveEvent) {
      yield* _mapRemoveAuctions(event);
    }
    // close
    if (event is AuctionCloseEvent) {
      yield* _mapCloseAuctions(event);
    }
  }

  // fetch
  Stream<AuctionsState> _mapFetchMyAuctions(FetchMyAuctionsEvent event) async* {
    yield AuctionsLoadingState();
    final response = await _auctionsRepository.getAuctionsData(
        page: page, company: event.company);

    if (response.status!) {
      final items = response.data;
      yield MyAuctionsSuccessState(items: items);
      page++;
      isFetching = false;
    } else {
      yield AuctionsErrorState(error: response.message);
      isFetching = false;
    }
  }

  // add
  Stream<AuctionsState> _mapAddAuctions(AuctionAddEvent event) async* {
    yield AuctionsLoadingState();
    final response = await _auctionsRepository.addAuction(
        model: event.model,
        company: event.company,
        images: event.images,
        video: event.video);

    if (response!.status!) {
      yield AuctionAddSuccessState(message: response.message!);
      isFetching = false;
    } else {
      yield AuctionsErrorState(error: response.message);
      isFetching = false;
    }
  }

  // remove
  Stream<AuctionsState> _mapRemoveAuctions(AuctionRemoveEvent event) async* {
    yield AuctionsLoadingState();
    final response = await _auctionsRepository.removeAuction(
        model: event.model, company: event.company);

    if (response!.status!) {
      yield AuctionRemoveSuccessState(
          message: response.message!, model: event.model);
      isFetching = false;
    } else {
      yield AuctionsErrorState(error: response.message);
      isFetching = false;
    }
  }

  // close
  Stream<AuctionsState> _mapCloseAuctions(AuctionCloseEvent event) async* {
    yield AuctionsLoadingState();
    final response = await _auctionsRepository.closeAuction(
        id: event.id, company: event.company);

    if (response!.status!) {
      yield AuctionCloseSuccessState(message: response.message!);
    } else {
      yield AuctionsErrorState(error: response.message);
    }
  }
}
