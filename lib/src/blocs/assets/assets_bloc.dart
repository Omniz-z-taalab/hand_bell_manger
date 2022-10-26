import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hand_bill_manger/src/blocs/global_bloc/global_bloc.dart';
import 'package:hand_bill_manger/src/repositories/assets_repository.dart';

import 'assets_event.dart';
import 'assets_state.dart';

class AssetsBloc extends Bloc<AssetsEvent, AssetsState> {
  String tag = "AssetBloc";

  AssetsRepository _assetsRepository = AssetsRepository();
  int page = 1;
  bool isFetching = true;

  AssetsBloc({required BuildContext context}) : super(AssetsInitialState()) {
    _assetsRepository.company = BlocProvider.of<GlobalBloc>(context).company;
  }

  @override
  Stream<AssetsState> mapEventToState(AssetsEvent event) async* {
    if (event is FetchMyAssetsEvent) {
      yield* _mapFetchMyAssets(event);
    }
    if (event is AssetAddEvent) {
      yield* _mapAddAssets(event);
    }
    if (event is AssetRemoveEvent) {
      yield* _mapRemoveAssets(event);
    }
  }

  // fetch
  Stream<AssetsState> _mapFetchMyAssets(FetchMyAssetsEvent event) async* {
    yield AssetsLoadingState();
    final response = await _assetsRepository.getAssetsData(
        page: page, company: event.company);

    if (response.status!) {
      final items = response.data;
      yield MyAssetsSuccessState(items: items,count: response.count!);
      page++;
      isFetching = false;
    } else {
      yield AssetsErrorState(error: response.message);
      isFetching = false;
    }
  }

  Stream<AssetsState> _mapAddAssets(AssetAddEvent event) async* {
    yield AssetsLoadingState();
    final response = await _assetsRepository.addAsset(
        model: event.model, company: event.company, images: event.images);

    if (response!.status!) {
      yield AssetAddSuccessState(message: response.message!);
      isFetching = false;
    } else {
      yield AssetsErrorState(error: response.message);
      isFetching = false;
    }
  }

  // remove
  Stream<AssetsState> _mapRemoveAssets(AssetRemoveEvent event) async* {
    yield AssetsLoadingState();
    final response = await _assetsRepository.removeAsset(
        model: event.model, company: event.company);

    if (response!.status!) {
      yield AssetRemoveSuccessState(
          message: response.message!, model: event.model);
      isFetching = false;
    } else {
      yield AssetsErrorState(error: response.message);
      isFetching = false;
    }
  }
}
