import 'package:equatable/equatable.dart';
import 'package:hand_bill_manger/src/data/model/account_package/job_category_model.dart';
import 'package:hand_bill_manger/src/data/model/account_package/job_company_model.dart';
import 'package:hand_bill_manger/src/data/model/account_package/job_user_model.dart';

abstract class JobsState extends Equatable {
  const JobsState();

  @override
  List<Object> get props => [];
}

class JobInitialState extends JobsState {}

class JobLoadingState extends JobsState {}

class JobErrorState extends JobsState {
  final String? error;

  JobErrorState({required this.error});
}

// fetch users jobs
class AllJobSuccessState extends JobsState {
  final List<JobUserModel>? items;

  AllJobSuccessState({required this.items});
}

// fetch my jobs
class MyJobSuccessState extends JobsState {
  final List<JobCompanyModel>? items;
  final int count;

  MyJobSuccessState({required this.items, required this.count});
}

// add
class JobAddSuccessState extends JobsState {
  final String? message;

  JobAddSuccessState({required this.message});
}

// remove
class JobRemoveSuccessState extends JobsState {
  final String? message;
  final JobCompanyModel model;

  JobRemoveSuccessState({required this.message, required this.model});
}

// get categories
class JobCategoriesSuccessState extends JobsState {
  final List<JobCategoryModel>? items;

  JobCategoriesSuccessState({required this.items});
}

// get subcategories
class JobSubcategoriesSuccessState extends JobsState {
  final List<JobCategoryModel>? items;

  JobSubcategoriesSuccessState({required this.items});
}
