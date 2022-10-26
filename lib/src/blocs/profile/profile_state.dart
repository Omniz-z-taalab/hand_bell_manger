import 'package:equatable/equatable.dart';
import 'package:hand_bill_manger/src/data/model/company.dart';
import 'package:hand_bill_manger/src/data/model/local/images.dart';
import 'package:hand_bill_manger/src/data/model/local/video_model.dart';

abstract class ProfileState extends Equatable {
  @override
  List<Object> get props => [];
}

class ProfileInitialState extends ProfileState {}

class ProfileLoadingState extends ProfileState {}

class ProfileSuccessState extends ProfileState {
  final Company? company;
  final String? message;

  ProfileSuccessState({required this.company, required this.message});
}

class ProfileErrorState extends ProfileState {
  final String error;

  ProfileErrorState({required this.error});
}



// edit profile info
class EditProfileSuccessState extends ProfileState {
  final Company? company;
  final String? message;

  EditProfileSuccessState({required this.company, required this.message});
}

// add profile images
class AddProfileImageSuccessState extends ProfileState {
  final String? message;
  final List<SaveImageModel> images;

  AddProfileImageSuccessState({required this.message, required this.images});

  @override
  List<Object> get props => [images];
}

// remove profile images
class RemoveProfileImageSuccessState extends ProfileState {
  final String? message;
  final int id;

  RemoveProfileImageSuccessState({required this.message, required this.id});
}

// add profile video
class AddProfileVideoSuccessState extends ProfileState {
  final String? message;
  final VideoModel videoModel;

  AddProfileVideoSuccessState(
      {required this.message, required this.videoModel});
}

// remove profile video
class RemoveProfileVideoSuccessState extends ProfileState {
  final String? message;
  final int id;

  RemoveProfileVideoSuccessState({required this.message, required this.id});
}

// add logo
class AddLogoSuccessState extends ProfileState {
  final String? message;
  final SaveImageModel logo;

  AddLogoSuccessState({required this.message,required this.logo});
}

// remove logo
class RemoveLogoSuccessState extends ProfileState {
  final String? message;
  final int id;

  RemoveLogoSuccessState({required this.message, required this.id});
}

// change password
class ChangePasswordSuccessState extends ProfileState {
  final String? message;

  ChangePasswordSuccessState({required this.message});
}
