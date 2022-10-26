import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hand_bill_manger/src/data/model/company.dart';
import 'package:hand_bill_manger/src/repositories/global_repository.dart';

part 'global_event.dart';

part 'global_state.dart';

class GlobalBloc extends Bloc<GlobalEvent, GlobalState> {
  Company? company;
  final GlobalRepository globalRepository = GlobalRepository();

  GlobalBloc() : super(GlobalInitial());

  @override
  Stream<GlobalState> mapEventToState(
    GlobalEvent event,
  ) async* {
    if (event is StartAppEvent) {
      yield* _mapStartAppToState(event);
    }
    if (event is UserStatusChangeEvent) {
      yield* _mapUserStatusChangeToState(event);
    }
  }

  Stream<GlobalState> _mapStartAppToState(StartAppEvent event) async* {
    yield GlobalLoading();
    Company? _company;
    _company = await globalRepository.getCurrentCompany();
    if (_company == null) {
      // company = null;
      company = Company();
    } else {
      company = _company;
      log("token ${company!.apiToken}");
    }
  }

  Stream<GlobalState> _mapUserStatusChangeToState(
      UserStatusChangeEvent event) async* {
    yield GlobalLoading();
    Company? _company = await globalRepository.getCurrentCompany();
    if (_company == null) {
      company = null;
      yield UserStatusChangeSuccess();
    } else {
      company = _company;
      yield UserStatusChangeSuccess();
    }
  }
}
