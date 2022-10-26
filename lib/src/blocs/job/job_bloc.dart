import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hand_bill_manger/src/blocs/global_bloc/global_bloc.dart';
import 'package:hand_bill_manger/src/repositories/jobs_repository.dart';

import 'job_event.dart';
import 'job_state.dart';

class JobsBloc extends Bloc<JobEvent, JobsState> {
  String tag = "JobBloc";

  JobsRepository _jobsRepository = JobsRepository();
  int allPage = 1;
  int myPage = 1;
  bool isFetching = true;

  JobsBloc({required BuildContext context}) : super(JobInitialState()) {
    _jobsRepository.company = BlocProvider.of<GlobalBloc>(context).company;
  }

  @override
  Stream<JobsState> mapEventToState(JobEvent event) async* {
    if (event is FetchUsersJobsEvent) {
      yield* _mapFetchJobs(event);
    }
    if (event is FetchMyJobsEvent) {
      yield* _mapFetchMyJobs(event);
    }
    if (event is JobAddEvent) {
      yield* _mapAddJob(event);
    }
    if (event is JobRemoveEvent) {
      yield* _mapRemoveJob(event);
    }
    // categories
    if (event is FetchJobsCategoriesEvent) {
      yield* _mapFetchJobsCategories(event);
    }
    // subcategories
    if (event is FetchJobsSubcategoriesEvent) {
      yield* _mapFetchJobsSubCategories(event);
    }
  }

  //users jobs
  Stream<JobsState> _mapFetchJobs(FetchUsersJobsEvent event) async* {
    yield JobLoadingState();
    final response = await _jobsRepository.getUsersJobs(
        page: allPage, company: event.company,
        categoryId: event.categoryId,
        subcategoryId: event.subcategoryId);

    if (response!.status!) {
      final items = response.data;
      yield AllJobSuccessState(items: items);
      allPage++;
      isFetching = false;
    } else {
      yield JobErrorState(error: response.message);
      isFetching = false;
    }
  }

  // my jobs
  Stream<JobsState> _mapFetchMyJobs(FetchMyJobsEvent event) async* {
    yield JobLoadingState();
    final response =
        await _jobsRepository.getMyJobs(page: myPage, company: event.company);

    if (response!.status!) {
      final items = response.data;
      yield MyJobSuccessState(items: items, count: response.count!);
      myPage++;
      isFetching = false;
    } else {
      yield JobErrorState(error: response.message);
      isFetching = false;
    }
  }

  Stream<JobsState> _mapFetchJobsCategories(
      FetchJobsCategoriesEvent event) async* {
    yield JobLoadingState();
    final response = await _jobsRepository.getJobsCategories();

    if (response!.status!) {
      final items = response.data;
      yield JobCategoriesSuccessState(items: items);
      isFetching = false;
    } else {
      yield JobErrorState(error: response.message);
      isFetching = false;
    }
  }

  Stream<JobsState> _mapFetchJobsSubCategories(
      FetchJobsSubcategoriesEvent event) async* {
    yield JobLoadingState();
    final response = await _jobsRepository.getJobsSubCategories(id: event.id);

    if (response!.status!) {
      final items = response.data;
      yield JobSubcategoriesSuccessState(items: items);
      isFetching = false;
    } else {
      yield JobErrorState(error: response.message);
      isFetching = false;
    }
  }

  // add jobs
  Stream<JobsState> _mapAddJob(JobAddEvent event) async* {
    yield JobLoadingState();
    final response = await _jobsRepository.addJob(
        model: event.model, company: event.company);

    if (response!.status!) {
      yield JobAddSuccessState(message: response.message!);
      isFetching = false;
    } else {
      yield JobErrorState(error: response.message);
      isFetching = false;
    }
  }

  // remove jobs
  Stream<JobsState> _mapRemoveJob(JobRemoveEvent event) async* {
    yield JobLoadingState();
    final response = await _jobsRepository.removeJob(
        model: event.model, company: event.company);

    if (response!.status!) {
      yield JobRemoveSuccessState(
          message: response.message!, model: event.model);
      isFetching = false;
    } else {
      yield JobErrorState(error: response.message);
      isFetching = false;
    }
  }
}
