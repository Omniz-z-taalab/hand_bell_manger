import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hand_bill_manger/src/blocs/global_bloc/global_bloc.dart';
import 'package:hand_bill_manger/src/repositories/offer_repository.dart';

import 'offers_event.dart';
import 'offers_state.dart';

class OffersBloc extends Bloc<OffersEvent, OffersState> {
  String tag = "OfferBloc";

  OffersRepository _offersRepository = OffersRepository();
  int page = 1;
  bool isFetching = true;

  OffersBloc({required BuildContext context}) : super(OffersInitialState()) {
    _offersRepository.company = BlocProvider.of<GlobalBloc>(context).company;
  }

  @override
  Stream<OffersState> mapEventToState(OffersEvent event) async* {
    if (event is FetchMyOffersEvent) {
      yield* _mapFetchMyOffers(event);
    }
    if (event is OfferAddEvent) {
      yield* _mapAddOffers(event);
    }
    if (event is OfferRemoveEvent) {
      yield* _mapRemoveOffers(event);
    }
  }

  //fetch
  Stream<OffersState> _mapFetchMyOffers(FetchMyOffersEvent event) async* {
    yield OffersLoadingState();
    final response = await _offersRepository.getMyOffersData(
        page: event.page, company: event.company);

    if (response.status!) {
      final items = response.data;
      yield MyOffersSuccessState(items: items, count: response.count!);
      page++;
      isFetching = false;
    } else {
      yield OffersErrorState(error: response.message);
      isFetching = false;
    }
  }

  // add
  Stream<OffersState> _mapAddOffers(OfferAddEvent event) async* {
    yield OffersLoadingState();
    final response = await _offersRepository.addOffer(
        model: event.model, company: event.company, images: event.images);

    if (response!.status!) {
      yield OfferAddSuccessState(message: response.message!);
      isFetching = false;
    } else {
      yield OffersErrorState(error: response.message);
      isFetching = false;
    }
  }

  // remove
  Stream<OffersState> _mapRemoveOffers(OfferRemoveEvent event) async* {
    yield OffersLoadingState();
    final response = await _offersRepository.removeOffer(
        model: event.model, company: event.company);

    if (response!.status!) {
      yield OfferRemoveSuccessState(
          message: response.message!, model: event.model);
      isFetching = false;
    } else {
      yield OffersErrorState(error: response.message);
      isFetching = false;
    }
  }
}
