import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hand_bill_manger/src/repositories/help_repository.dart';

import '../../data/model/user.dart';
import '../../ui/screens/navigation_package/help/help_center_response.dart';
import 'help_event.dart';
import 'help_state.dart';

class HelpBloc extends Bloc<HelpEvent, HelpState> {
  String tag = "HelpBloc";

  HelpRepository _helpRepository = HelpRepository();
  int page = 1;
  bool isFetching = true;

  HelpBloc({required BuildContext context}) : super(HelpInitialState());

  @override
  Stream<HelpState> mapEventToState(HelpEvent event) async* {
    if (event is FetchAgentEvent) {
      yield* _mapFetchAgent();
    }
    if (event is FetchEmailEvent) {
      yield* fetchEmails();
    }
  }

  Stream<HelpState> _mapFetchAgent() async* {
    yield HelpLoadingState();
    final response = await _helpRepository.getAgentData(page: page);

    if (response.status!) {
      final items = response.data;
      print(items);
      print('lslslslslslslsslslsl');
      yield AgentSuccessState(items: items);
      page++;
      isFetching = false;
    } else {
      yield HelpErrorState(error: response.message);
      isFetching = false;
    }
  }

  Stream<HelpState> fetchEmails() async* {
    yield HelpLoadingEmails();
    final response = await _helpRepository.fetchEmails();
    if (response?.data! != null) {
      final email = response!.data;

      yield HelpSuccessEmails(mails: email);
    }
  }
}
