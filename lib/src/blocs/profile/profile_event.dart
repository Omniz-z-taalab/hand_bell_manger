import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:hand_bill_manger/src/data/model/company.dart';
import 'package:hand_bill_manger/src/data/model/country_model.dart';
import 'package:hand_bill_manger/src/data/model/local/images.dart';

abstract class ProfileEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// fetch profile
class FetchProfileEvent extends ProfileEvent {
  final Company company;

  FetchProfileEvent({required this.company});

  @override
  List<Object> get props => [company];
}

// edit info
class EditProfileInfoEvent extends ProfileEvent {
  final Company? company;

  EditProfileInfoEvent({required this.company});

  @override
  List<Object?> get props => [company];
}

// add images
class AddProfileImagesEvent extends ProfileEvent {
  final Company? company;
  final List<Object> images;

  AddProfileImagesEvent({required this.company, required this.images});

  @override
  List<Object?> get props => [company];
}

// remove video
class RemoveProfileImageEvent extends ProfileEvent {
  final Company? company;
  final int id;

  RemoveProfileImageEvent({required this.company, required this.id});
}

// add video
class AddProfileVideoEvent extends ProfileEvent {
  final Company? company;
  final Object video;

  AddProfileVideoEvent({required this.company, required this.video});
}

// remove video
class RemoveProfileVideoEvent extends ProfileEvent {
  final Company? company;
  final int id;

  RemoveProfileVideoEvent({required this.company, required this.id});
}

// add logo
class AddLogoEvent extends ProfileEvent {
  final Company? company;
  final File file;
  ImageModel? logo;

  AddLogoEvent({required this.company, required this.file, this.logo});
}

// remove logo
class RemoveLogoEvent extends ProfileEvent {
  final Company? company;
  final int id;

  RemoveLogoEvent({required this.company, required this.id});
}

// change pass
class ChangePasswordEvent extends ProfileEvent {
  final Company? company;
  final String currentPassword;
  final String newPassword;

  ChangePasswordEvent(
      {required this.company,
      required this.currentPassword,
      required this.newPassword});

  @override
  List<Object?> get props => [company];
}
