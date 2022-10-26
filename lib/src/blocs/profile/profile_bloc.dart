import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hand_bill_manger/src/blocs/global_bloc/global_bloc.dart';
import 'package:hand_bill_manger/src/blocs/profile/profile_event.dart';
import 'package:hand_bill_manger/src/blocs/profile/profile_state.dart';
import 'package:hand_bill_manger/src/data/response/profile/edit_profile_response_.dart';
import 'package:hand_bill_manger/src/repositories/auth_repository.dart';
import 'package:hand_bill_manger/src/repositories/profile_repository.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileRepository profileRepository = ProfileRepository();

  bool isFetching = false;
  bool refreshHomePage = true;

  AuthRepository authRepository = AuthRepository();
  late GlobalBloc globalBloc;

  ProfileBloc({required BuildContext context}) : super(ProfileInitialState()) {
    globalBloc = BlocProvider.of<GlobalBloc>(context);
  }

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    // fetch profile
    if (event is FetchProfileEvent) {
      yield* _mapFetchProfileToState(event);
    }
    // edit profile info
    if (event is EditProfileInfoEvent) {
      yield* _mapEditProfileInfoToState(event);
    }
    // add profile images
    if (event is AddProfileImagesEvent) {
      yield* _mapAddProfileImagesToState(event);
    }
    // remove profile images
    if (event is RemoveProfileImageEvent) {
      yield* _mapRemoveProfileImagesToState(event);
    }
    // add profile video
    if (event is AddProfileVideoEvent) {
      yield* _mapAddProfileVideoToState(event);
    }
    // remove profile video
    if (event is RemoveProfileVideoEvent) {
      yield* _mapRemoveProfileVideoToState(event);
    }
    // add logo
    if (event is AddLogoEvent) {
      yield* _mapAddLogoToState(event);
    }
    // remove logo
    if (event is RemoveLogoEvent) {
      yield* _mapRemoveLogoToState(event);
    }

    // change password
    if (event is ChangePasswordEvent) {
      yield* _mapChangePasswordToState(event);
    }
  }

  Stream<ProfileState> _mapFetchProfileToState(FetchProfileEvent event) async* {
    yield ProfileLoadingState();
    try{
      final response = await profileRepository.fetchProfileData(company: event.company);
      if (response!.status!=null&&response.status!) {
        globalBloc.company = response.data;
        authRepository.setCurrentUser(response.data);
        yield ProfileSuccessState(
            company: response.data, message: response.message);
      } else {
        globalBloc.company!.setActive = false;
        yield ProfileErrorState(error: response.message.toString());
      }
    }catch(e){
      globalBloc.company!.setActive = false;
      yield ProfileErrorState(error: "Error Happen");
    }
  }

  // edit info
  Stream<ProfileState> _mapEditProfileInfoToState(
      EditProfileInfoEvent event) async* {
    print("first: ${event.company!.firstPhone}");
    yield ProfileLoadingState();
    EditProfileResponse? response =
        await profileRepository.editProfileInfo(company: event.company!);
    if (response!.status!) {
      globalBloc.company = response.data;
      authRepository.setCurrentUser(response.data);
      yield EditProfileSuccessState(
          company: response.data, message: response.message);
    } else {
      yield ProfileErrorState(error: response.message!);
    }
  }

  //  add images
  Stream<ProfileState> _mapAddProfileImagesToState(
      AddProfileImagesEvent event) async* {
    yield ProfileLoadingState();

    final response = await profileRepository.addProfileImages(
        company: event.company!, images: event.images);

    if (response!.status!) {
      yield AddProfileImageSuccessState(
          message: response.message, images: response.data!);
    } else {
      yield ProfileErrorState(error: response.message!);
    }
  }

  //  remove image
  Stream<ProfileState> _mapRemoveProfileImagesToState(
      RemoveProfileImageEvent event) async* {
    yield ProfileLoadingState();

    final response = await profileRepository.removeImage(
        company: event.company!, id: event.id);

    if (response!.status!) {
      yield RemoveProfileImageSuccessState(
          message: response.message, id: event.id);
    } else {
      yield ProfileErrorState(error: response.message!);
    }
  }

  //  add video
  Stream<ProfileState> _mapAddProfileVideoToState(
      AddProfileVideoEvent event) async* {
    yield ProfileLoadingState();

    final response = await profileRepository.addProfileVideo(
        company: event.company!, video: event.video);

    if (response!.status!) {
      yield AddProfileVideoSuccessState(
          message: response.message, videoModel: response.data!);
    } else {
      yield ProfileErrorState(error: response.message!);
    }
  }

  //  remove video
  Stream<ProfileState> _mapRemoveProfileVideoToState(
      RemoveProfileVideoEvent event) async* {
    yield ProfileLoadingState();

    final response = await profileRepository.removeVideo(
        company: event.company!, id: event.id);

    if (response!.status!) {
      yield RemoveProfileVideoSuccessState(
          message: response.message, id: event.id);
    } else {
      yield ProfileErrorState(error: response.message!);
    }
  }

  // add logo
  Stream<ProfileState> _mapAddLogoToState(AddLogoEvent event) async* {
    yield ProfileLoadingState();

    final response = await profileRepository.addLogo(
        company: event.company!, file: event.file);

    if (response!.status!) {
      yield AddLogoSuccessState(
          message: response.message, logo: response.data!);
    } else {
      yield ProfileErrorState(error: response.message!);
    }
  }

  // remove logo
  Stream<ProfileState> _mapRemoveLogoToState(RemoveLogoEvent event) async* {
    yield ProfileLoadingState();

    final response = await profileRepository.removeLogo(
        company: event.company!, id: event.id);

    if (response!.status!) {
      yield RemoveLogoSuccessState(message: response.message, id: event.id);
    } else {
      yield ProfileErrorState(error: response.message!);
    }
  }

  Stream<ProfileState> _mapChangePasswordToState(
      ChangePasswordEvent event) async* {
    yield ProfileLoadingState();

    final response = await profileRepository.changePassword(
        company: event.company!,
        currentPass: event.currentPassword,
        newPass: event.newPassword);

    if (response!.status!) {
      yield ChangePasswordSuccessState(message: response.message);
    } else {
      yield ProfileErrorState(error: response.message!);
    }
  }
}
