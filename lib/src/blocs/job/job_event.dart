import 'package:equatable/equatable.dart';
import 'package:hand_bill_manger/src/data/model/account_package/job_company_model.dart';
import 'package:hand_bill_manger/src/data/model/account_package/job_user_model.dart';
import 'package:hand_bill_manger/src/data/model/company.dart';
import 'package:hand_bill_manger/src/data/model/user.dart';

abstract class JobEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// fetch all
class FetchUsersJobsEvent extends JobEvent {
  final Company company;
  int? categoryId;
  int? subcategoryId;

  FetchUsersJobsEvent(
      {required this.company, this.categoryId, this.subcategoryId});
}

// fetch my
class FetchMyJobsEvent extends JobEvent {
  final Company company;

  FetchMyJobsEvent({required this.company});
}

// add
class JobAddEvent extends JobEvent {
  final JobCompanyModel model;
  final Company company;

  JobAddEvent({required this.model, required this.company});
}

// remove
class JobRemoveEvent extends JobEvent {
  final JobCompanyModel model;
  final Company company;

  JobRemoveEvent({required this.company, required this.model});
}

// fetch job categories
class FetchJobsCategoriesEvent extends JobEvent {}

// fetch job subcategories
class FetchJobsSubcategoriesEvent extends JobEvent {
  final int id;

  FetchJobsSubcategoriesEvent({required this.id});
}
