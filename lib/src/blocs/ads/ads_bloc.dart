import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hand_bill_manger/src/blocs/global_bloc/global_bloc.dart';
import 'package:hand_bill_manger/src/repositories/ads_repository.dart';

import 'ads_event.dart';
import 'ads_state.dart';

class AdsBloc extends Bloc<AdsEvent, AdsState> {
  String tag = "AdBloc";

  AdsRepository _adsRepository = AdsRepository();
  int page = 1;
  bool isFetching = true;

  AdsBloc({required BuildContext context}) : super(AdsInitialState()) {
    _adsRepository.company = BlocProvider.of<GlobalBloc>(context).company;
  }

  @override
  Stream<AdsState> mapEventToState(AdsEvent event) async* {
    // get ads coast
    if (event is GetAdsCoastEvent) {
      yield* _mapGetAdsCoast(event);
    }
    if (event is FetchMyAdsEvent) {
      yield* _mapFetchMyAds();
    }
    if (event is AdsAddEvent) {
      yield* _mapAddAds(event);
    }
    if (event is AdsRemoveEvent) {
      yield* _mapRemoveAds(event);
    }
  }

  // get ads coast
  Stream<AdsState> _mapGetAdsCoast(GetAdsCoastEvent event) async* {
    yield AdsLoadingState();
    final response = await _adsRepository.getAdsCoast(company: event.company);

    if (response.status!) {
      yield AdsCoastSuccessState(
          model: response.data!, message: response.message!);
    } else {
      yield AdsErrorState(error: response.message);
    }
  }

  //fetch
  Stream<AdsState> _mapFetchMyAds() async* {
    yield AdsLoadingState();
    final response = await _adsRepository.getMyAdsData(page: page);

    if (response.status!) {
      final items = response.data;
      yield MyAdsSuccessState(items: items);
      page++;
      isFetching = false;
    } else {
      yield AdsErrorState(error: response.message);
      isFetching = false;
    }
  }

  // add
  Stream<AdsState> _mapAddAds(AdsAddEvent event) async* {
    yield AdsLoadingState();
    final response =
        await _adsRepository.addAds(model: event.model, company: event.company);

    if (response!.status!) {
      yield AdsAddSuccessState(message: response.message!);
      isFetching = false;
    } else {
      yield AdsErrorState(error: response.message);
      isFetching = false;
    }
  }

  // remove
  Stream<AdsState> _mapRemoveAds(AdsRemoveEvent event) async* {
    yield AdsLoadingState();
    final response =
        await _adsRepository.removeAds(id: event.id, company: event.company);

    if (response!.status!) {
      yield AdsRemoveSuccessState(message: response.message!, id: event.id);
      isFetching = false;
    } else {
      yield AdsErrorState(error: response.message);
      isFetching = false;
    }
  }
}
