import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hand_bill_manger/src/blocs/global_bloc/global_bloc.dart';
import 'package:hand_bill_manger/src/blocs/profile/profile_bloc.dart';
import 'package:hand_bill_manger/src/blocs/profile/profile_event.dart';
import 'package:hand_bill_manger/src/blocs/profile/profile_state.dart';
import 'package:hand_bill_manger/src/common/api_data.dart';
import 'package:hand_bill_manger/src/common/constns.dart';
import 'package:hand_bill_manger/src/data/model/company.dart';
import 'package:hand_bill_manger/src/data/model/left_data_of_companies.dart';
import 'package:hand_bill_manger/src/data/model/local/images.dart';
import 'package:hand_bill_manger/src/data/model/local/route_argument.dart';
import 'package:hand_bill_manger/src/data/model/local/video_model.dart';
import 'package:hand_bill_manger/src/ui/component/custom/custom_button.dart';
import 'package:hand_bill_manger/src/ui/component/custom/custom_icon_btn.dart';
import 'package:hand_bill_manger/src/ui/component/custom/custom_text_filed_enter.dart';
import 'package:hand_bill_manger/src/ui/component/custom/image_widget.dart';
import 'package:hand_bill_manger/src/ui/component/custom/regular_app_bar.dart';
import 'package:hand_bill_manger/src/ui/component/custom/widgets.dart';
import 'package:hand_bill_manger/src/ui/component/widgets.dart';
import 'package:hand_bill_manger/src/ui/screens/common/image_full_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';

class EditAccountScreen extends StatefulWidget {
  static const routeName = "/editAccountScreen";

  @override
  _EditAccountScreenState createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends State<EditAccountScreen> {
  late double imgSize;
  late double marginVer;
  late Company _company;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _whatsAppController = TextEditingController();
  TextEditingController _commercialRegisterController = TextEditingController();
  TextEditingController _taxCardController = TextEditingController();
  TextEditingController _servicesController = TextEditingController();
  TextEditingController _administrationAddressController =
  TextEditingController();
  TextEditingController _aboutController = TextEditingController();
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _secondEmailController = TextEditingController();

  TextEditingController _websiteController = TextEditingController();
  TextEditingController _facebookController = TextEditingController();
  TextEditingController _twitterController = TextEditingController();
  TextEditingController _instagramController = TextEditingController();
  TextEditingController _currentPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  int _maxImages = 0,
      _maxVideo = 0;
  List<Object> _images = [];
  int _imageIndex = 0;
  Object? _logo;
  List<Object> _videos = [];
  late VideoPlayerController _videoPlayerController1;
  ChewieController? _chewieController;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState>? _profileFormKey;
  GlobalKey<FormState>? _passwordFormKey;

  bool _loadingInfo = false,
      _loadingImages = false,
      _loadingVideo = false,
      _loadingLogo = false,
      _loadingChangePassword = false;

  late ProfileBloc _profileBloc;
  late GlobalBloc _globalBloc;

  late LeftDataOfCompanies _leftDataOfCompanies;

  String _dateTime = "Enter date of establish";
  DateTime currentTime = DateTime.now();

  bool update = true;
  @override
  void initState() {
    _profileBloc = BlocProvider.of<ProfileBloc>(context);
    _globalBloc = BlocProvider.of<GlobalBloc>(context);
    _company = BlocProvider.of<GlobalBloc>(context).company!;
    if (_company.plan != null) {
      _maxImages = _company.plan!.numImages!;
      _maxVideo = _company.plan!.numVideos!;
    }
    _profileBloc.add(FetchProfileEvent(company: _company));
    Timer(Duration(seconds: 3),(){
      update = false;
    });
    _profileFormKey = new GlobalKey<FormState>();
    _passwordFormKey = new GlobalKey<FormState>();
    _logo = SaveImageModel(url: placeholder_concat);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    marginVer = MediaQuery.of(context).size.height * 0.025;
    imgSize = MediaQuery.of(context).size.width * 0.26;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        key: _scaffoldKey,
        appBar: RegularAppBar(label: "Edit information"),
        body: BlocListener<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is ProfileSuccessState) {
              if(update==true){
                displaySnackBar(
                    scaffoldKey: _scaffoldKey, title: state.message ?? "");
                _setProfileData(state.company!);
                update=false;
              }
            }

            if (state is EditProfileSuccessState) {
              displaySnackBar(
                  scaffoldKey: _scaffoldKey, title: state.message ?? "");
              setState(() {
                _loadingInfo = false;
              });
            } else if (state is ProfileErrorState) {
              displaySnackBar(scaffoldKey: _scaffoldKey, title: state.error);
              setState(() {
                _loadingInfo = false;
                _loadingImages = false;
                _loadingVideo = false;
                _loadingLogo = false;
                _loadingChangePassword = false;
              });
            }

            // add image
            if (state is AddProfileImageSuccessState) {
              Fluttertoast.showToast(msg: state.message!);
              setState(() {
                _images.clear();
                _images.addAll(state.images);
                _loadingImages = false;
              });
            }
            // remove image
            if (state is RemoveProfileImageSuccessState) {
              displaySnackBar(title: state.message!, scaffoldKey: _scaffoldKey);
              setState(() {
                _images.removeWhere(
                        (element) => (element as ImageModel).id == state.id);
                setState(() {
                  _loadingImages = false;
                  if (_imageIndex == _images.length && _imageIndex != 0) {
                    _imageIndex--;
                  }
                });
              });
            }
            // add video
            if (state is AddProfileVideoSuccessState) {
              Fluttertoast.showToast(msg: state.message!);
              _chewieController!.pause();
              _chewieController = null;
              _videos.clear();
              initializePlayer(state.videoModel);

              _loadingVideo = false;
            }
            // remove video
            if (state is RemoveProfileVideoSuccessState) {
              displaySnackBar(title: state.message!, scaffoldKey: _scaffoldKey);
              setState(() {
                _videos.removeWhere(
                        (element) => (element as VideoModel).id == state.id);
                _chewieController!.pause();
                _chewieController = null;
                _loadingVideo = false;
              });
            }
            // add logo
            if (state is AddLogoSuccessState) {
              Fluttertoast.showToast(msg: state.message!);

              setState(() {
                _loadingLogo = false;
                _globalBloc.company!.logo=state.logo;
              });
            }
            // remove logo
            if (state is RemoveLogoSuccessState) {
              displaySnackBar(title: state.message!, scaffoldKey: _scaffoldKey);
              setState(() {
                _logo = null;
                _loadingLogo = false;
              });
            }
            // change pass
            if (state is ChangePasswordSuccessState) {
              displaySnackBar(
                  scaffoldKey: _scaffoldKey, title: state.message ?? "");
              setState(() => _loadingChangePassword = false);
            }
          },
          child: RefreshIndicator(
              onRefresh: () async {
                // _userNameController.clear();
                // _phoneController.clear();
                // _addressController.clear();
                // _emailController.clear();
                // setState(() {
                //   if (_company != null) {
                //     // _userNameController.text = _user!.name!;
                //     // _phoneController.text = _user!.phone!;
                //     // _addressController.text = _user!.address!;
                //   }
                // });
              },
              child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _images.length == 0
                            ? SizedBox()
                            : Stack(children: [
                          Container(
                            height: size.height * 0.3,
                            width: double.infinity,
                            child: PageView.builder(
                                itemCount: _images.length,
                                controller:
                                PageController(viewportFraction: 1),
                                onPageChanged: (int index) {
                                  setState(() => _imageIndex = index);
                                },
                                itemBuilder:
                                    (BuildContext context, int index) {
                                  if (_images[index] is SaveImageModel) {
                                    SaveImageModel _image =
                                    _images[index] as SaveImageModel;
                                    return ServerImageWidget(
                                        image: APIData.domainLink +
                                            _image.url!,
                                        // fit: BoxFit.cover,
                                        onTap: () {
                                          Navigator.pushNamed(context,
                                              ImageFullScreen.routeName,
                                              arguments: RouteArgument(
                                                  param:
                                                  APIData.domainLink +
                                                      _image.url!));
                                        },
                                        onRemoveTap: () =>
                                            _removeImage(_image.id!));
                                  } else if (_images[index] is File) {
                                    return LocalImageWidget(
                                        image: _images[index] as File,
                                        // onTap: () => getImage(index),
                                        onRemoveTap: () {
                                          setState(() {
                                            _images.removeAt(index);
                                          });
                                        });
                                  }
                                  return SizedBox();
                                }),
                          ),
                          Positioned(
                              bottom: 8,
                              right: 0,
                              left: 0,
                              child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    DotsIndicator(
                                        dotsCount: _images.length,
                                        position: _imageIndex.toDouble(),
                                        decorator: DotsDecorator(
                                            color: Color(0x4DFFFFFF),
                                            activeColor:
                                            Color(0xB3FFFFFF),
                                            size: const Size.square(4.0),
                                            activeSize:
                                            const Size(10.0, 4.0),
                                            activeShape:
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius
                                                    .circular(
                                                    5.0))))
                                  ])),
                        ]),
                        SizedBox(height: marginVer),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              AddImageBtn(
                                  onTap: () => getImage(),
                                  length: _images.length,
                                  max: _maxImages,
                                  label: "Company images",
                                  marginHor: 0),
                              CustomButton(
                                  title: "Add",
                                  radius: 8,
                                  // width: size.width * 0.7,
                                  textStyle: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 14),
                                  onPress: () {
                                    _addImages();
                                  })
                            ]),
                        _loadingImages == false
                            ? SizedBox(height: marginVer)
                            : Container(
                            height: 100,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(height: marginVer),
                                  CircularProgressIndicator(
                                      color: Theme
                                          .of(context)
                                          .accentColor,
                                      strokeWidth: 2)
                                ])),
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Stack(children: [
                                    InkWell(
                                        onTap: () {
                                          // Navigator.pushNamed(
                                          //     context, ImageFullScreen.routeName,
                                          //     arguments:
                                          //         RouteArgument(param: _company.logo));
                                        },
                                        child: Padding(
                                            padding: EdgeInsets.only(right: 12),
                                            child: Card(
                                                clipBehavior: Clip.hardEdge,
                                                elevation: 2,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        12)),
                                                child: Container(
                                                  width: imgSize,
                                                  height: imgSize,
                                                  child: _logo is SaveImageModel
                                                      ? CachedNetworkImage(
                                                      imageUrl: APIData
                                                          .domainLink +
                                                          (_logo as SaveImageModel)
                                                              .url!,
                                                      fit: BoxFit.cover,
                                                      placeholder: (context,
                                                          url) =>
                                                          Transform.scale(
                                                              scale: 0.4,
                                                              child: CircularProgressIndicator(
                                                                  color:
                                                                  mainColorLite,
                                                                  strokeWidth:
                                                                  2)),
                                                      errorWidget: (context,
                                                          url, error) =>
                                                      new Icon(
                                                          Icons.error,
                                                          color: mainColorLite))
                                                      : Image.file(
                                                      _logo as File),
                                                )))),
                                    Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: CustomIconButton(
                                            iconColor: mainColor,
                                            backgroundColor: Colors.white,
                                            radius: 900,
                                            icon: Icons.camera_alt_outlined,
                                            padding: 6,
                                            press: () => selectLogo()))
                                  ]),
                                  Row(
                                    children: [
                                      CustomButton(
                                          title: "Add Company Logo",
                                          radius: 8,
                                          // width: size.width * 0.7,
                                          textStyle: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 14),
                                          onPress: () => _addLogo()),
                                    ],
                                  )
                                ])),
                        _loadingLogo == false
                            ? SizedBox(height: marginVer)
                            : Container(
                            height: 100,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(height: marginVer),
                                  CircularProgressIndicator(
                                      color: Theme
                                          .of(context)
                                          .accentColor,
                                      strokeWidth: 2)
                                ])),
                        _videos.isEmpty
                            ? SizedBox()
                            : Container(
                            height: size.height * 0.3,
                            // margin: EdgeInsets.only(bottom: marginVer),
                            child: Stack(children: [
                              Positioned.fill(
                                  child: Container(
                                      color: Color(0xff000000),
                                      child:
                                      // _videos[0] as File == true
                                      //     ? SizedBox()
                                      //     :
                                      Chewie(
                                          controller:
                                          _chewieController!))),
                              Positioned(
                                  top: 12,
                                  right: 12,
                                  child: InkWell(
                                      onTap: () =>
                                          _removeVideo(video: _videos),
                                      child: Container(
                                          padding: EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                              color: Color(0x26000000),
                                              borderRadius:
                                              BorderRadius.circular(
                                                  100)),
                                          child: Center(
                                              child: Icon(Icons.close,
                                                  color: Colors.white)))))
                            ])),
                        _loadingVideo == false
                            ? SizedBox(height: marginVer)
                            : Container(
                            height: 100,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(height: marginVer),
                                  CircularProgressIndicator(
                                      color: Theme
                                          .of(context)
                                          .accentColor,
                                      strokeWidth: 2)
                                ])),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              AddVideoBtn(
                                  onTap: () => getVideo(),
                                  length: _videos.length,
                                  max: _maxVideo,
                                  label: "Company Video",
                                  marginHor: 0),
                              CustomButton(
                                  title: "Add",
                                  radius: 8,
                                  // width: size.width * 0.7,
                                  textStyle: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 14),
                                  onPress: () {
                                    _addVideo();
                                  }),
                            ]),
                        SizedBox(height: marginVer),
                        Padding(
                            padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                            child: Form(
                                key: _profileFormKey,
                                child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      _editLabel(label: "Name"),
                                      CustomTextFormFieldEnter(
                                          controller: _nameController,
                                          hintText: "Enter name",
                                          validator: (input) {
                                            if (input
                                                .toString()
                                                .length < 4) {
                                              return "enter name";
                                            }
                                            return null;
                                          }),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          _editLabel(label: "Phone Number"),
                                          Padding(
                                              padding: EdgeInsets.fromLTRB(0, 12, 6, 6),
                                              child: Text("company contact!",
                                                style: TextStyle(color: Colors.black38,
                                                fontSize: 10),),
                                          ),
                                        ],
                                      ),
                                      CustomTextFormFieldEnter(
                                          controller: _phoneNumberController,
                                          hintText: "Phone Number",
                                          validator: (input) {
                                            if (input
                                                .toString()
                                                .length < 4) {
                                              return "enter your phone number";
                                            }
                                            return null;
                                          }),
                                      _editLabel(label: "WhatsApp Number"),
                                      CustomTextFormFieldEnter(
                                          controller: _whatsAppController,
                                          hintText: "WhatsApp Number",
                                          validator: (input) {
                                            if (input
                                                .toString()
                                                .length < 4) {
                                              return "enter your whatsApp number";
                                            }
                                            return null;
                                          }),
                                      _editLabel(label: "Commercial Register"),
                                      CustomTextFormFieldEnter(
                                          controller:
                                          _commercialRegisterController,
                                          hintText: "Enter commercial register",
                                          validator: (input) {
                                            if (input
                                                .toString()
                                                .length < 4) {
                                              return "enter commercial register";
                                            }
                                            return null;
                                          }),
                                      _editLabel(label: "Tax card"),
                                      CustomTextFormFieldEnter(
                                          controller: _taxCardController,
                                          hintText: "Enter tax card",
                                          validator: (input) {
                                            if (input
                                                .toString()
                                                .length < 4) {
                                              return "enter Tax card";
                                            }
                                            return null;
                                          }),
                                      _editLabel(label: "Company Activity"),
                                      CustomTextFormFieldEnter(
                                          controller: _servicesController,
                                          hintText: "Enter activity",
                                          validator: (input) {
                                            if (input
                                                .toString()
                                                .length < 4) {
                                              return "enter activity";
                                            }
                                            return null;
                                          }),
                                      _editLabel(label: "Address"),
                                      CustomTextFormFieldEnter(
                                          controller: _addressController,
                                          hintText: "Enter address",
                                          validator: (input) {
                                            if (input
                                                .toString()
                                                .length < 4) {
                                              return "enter address";
                                            }
                                            return null;
                                          }),
                                      _editLabel(label: "About company"),
                                      CustomTextFormFieldEnter(
                                          controller: _aboutController,
                                          hintText: "Enter about company",
                                          validator: (input) {
                                            if (input
                                                .toString()
                                                .length < 4) {
                                              return "enter about company";
                                            }
                                            return null;
                                          }),
                                      _editLabel(
                                          label: "Date of Establishment"),
                                      InkWell(
                                          onTap: () {
                                            DatePicker.showDatePicker(context,
                                                showTitleActions: true,
                                                minTime: DateTime(1950, 3, 5),
                                                maxTime: currentTime,
                                                theme: DatePickerTheme(
                                                    headerColor: mainColorLite,
                                                    backgroundColor:
                                                    Colors.white,
                                                    itemStyle: TextStyle(
                                                        color: textDarkColor,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        fontSize: 18),
                                                    doneStyle: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16)),
                                                onConfirm: (date) {
                                                  setState(() {
                                                    _dateTime = DateFormat(
                                                        'dd-MM-yyyy')
                                                        .format(DateTime
                                                        .fromMillisecondsSinceEpoch(
                                                        date
                                                            .millisecondsSinceEpoch,
                                                        isUtc: true));
                                                    // date.toString();
                                                  });
                                                });
                                          },
                                          child: Row(
                                            children: [
                                              Expanded(
                                                  child: Container(
                                                      padding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: 12,
                                                          vertical: 16),
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(12),
                                                          border: Border.all(
                                                              color: Color(
                                                                  0xffeeeeee))),
                                                      child: Text(_dateTime,
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color:
                                                              textDarkColor))))
                                            ],
                                          )),
                                      Padding(
                                          padding:
                                          EdgeInsets.fromLTRB(12, 20, 6, 6),
                                          child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text("optional",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        // fontWeight: FontWeight.w500,
                                                        fontSize: 14)),
                                                Container(
                                                    height: 0.5,
                                                    width: MediaQuery.of(context).size.width * 0.1,
                                                    color: mainColorLite)
                                              ])),
                                      _editLabel(
                                          label: "Administration address"),
                                      CustomTextFormFieldEnter(
                                          controller:
                                          _administrationAddressController,
                                          hintText:
                                          "Enter administration address"),
                                      _editLabel(label: "Company email"),
                                      CustomTextFormFieldEnter(
                                          controller: _secondEmailController,
                                          hintText: "Enter company email"),
                                      _editLabel(label: "Website"),
                                      CustomTextFormFieldEnter(
                                          controller: _websiteController,
                                          hintText: "Enter website link"),
                                      _editLabel(label: "Facebook page"),
                                      CustomTextFormFieldEnter(
                                          controller: _facebookController,
                                          hintText: "Enter facebook page"),
                                      _editLabel(label: "Twitter aac"),
                                      CustomTextFormFieldEnter(
                                          controller: _twitterController,
                                          hintText: "Enter twitter aac"),
                                      _editLabel(label: "Instagram aac"),
                                      CustomTextFormFieldEnter(
                                          controller: _instagramController,
                                          hintText: "Enter instagram aac"),
                                    ]))),
                        _loadingInfo == false
                            ? SizedBox(height: marginVer)
                            : Container(
                            height: 100,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(height: marginVer),
                                  CircularProgressIndicator(
                                      color: Theme
                                          .of(context)
                                          .accentColor,
                                      strokeWidth: 2)
                                ])),
                        CustomButton(
                            title: "Save Profile",
                            radius: 900,
                            width: size.width * 0.7,
                            textStyle: TextStyle(fontWeight: FontWeight.w500),
                            onPress: () => _updateInfo()),
                        SizedBox(height: marginVer),
                        Container(
                            margin: EdgeInsets.symmetric(vertical: marginVer),
                            height: 8,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Color(0xfff5f5f5),
                                border: Border.symmetric(
                                    horizontal:
                                    BorderSide(color: Color(0xffe0e0e0))))),
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Form(
                                key: _passwordFormKey,
                                child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      _editLabel(label: "Current password"),
                                      CustomTextFormFieldEnter(
                                          controller:
                                          _currentPasswordController,
                                          hintText: "current password"),
                                      _editLabel(label: "new password"),
                                      CustomTextFormFieldEnter(
                                          controller: _newPasswordController,
                                          hintText: "new password")
                                    ]))),
                        _loadingChangePassword == false
                            ? SizedBox(height: marginVer * 2)
                            : Container(
                            height: 100,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(height: marginVer),
                                  CircularProgressIndicator(
                                      color: Theme
                                          .of(context)
                                          .accentColor,
                                      strokeWidth: 2)
                                ])),
                        CustomButton(
                              title: "Save password",
                            radius: 900,
                            width: size.width * 0.7,
                            textStyle: TextStyle(fontWeight: FontWeight.w500),
                            onPress: () => _changePassword()),
                        SizedBox(height: 100)
                      ]))),
        ));
  }

  Future<void> initializePlayer(VideoModel videoModel) async {
    _videoPlayerController1 = VideoPlayerController.network(videoModel.url!);
    await _videoPlayerController1.initialize();
    _createChewieController();
    setState(() {
      _videos.add(videoModel);
    });
  }

  void _createChewieController() {
    _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController1,
        // autoPlay: true,
        showControlsOnInitialize: false,
        materialProgressColors: ChewieProgressColors(playedColor: Colors.white),
        looping: true,
        showOptions: false);
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _addressController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    if (_chewieController != null) {
      _chewieController!.pause();
    }
    super.dispose();
  }

  void _updateInfo() {
    if (_profileFormKey!.currentState!.validate()) {
      if (_dateTime == "Enter date of establish") {
        displaySnackBar(
            title: "Enter date of establish", scaffoldKey: _scaffoldKey);
      } else {
        setState((){
          _loadingInfo = true; update=true;
        });
        _leftDataOfCompanies = LeftDataOfCompanies(
            commercialRegister: _commercialRegisterController.text.trim(),
            taxCard: _taxCardController.text.trim(),
            services: _servicesController.text.trim(),
            administrationAddress: _administrationAddressController.text.trim(),
            facebook: _facebookController.text.trim(),
            instagram: _instagramController.text.trim(),
            address: _addressController.text.trim(),
            twitter: _twitterController.text.trim(),
            firstWebsite: _websiteController.text.trim(),
            companyInfo: _aboutController.text.trim(),
            dateCreated: _dateTime,
            firstMobile: _phoneNumberController.text.trim(),
            whatsAppNumber: _whatsAppController.text.trim(),
            // secondPhone: _secondPhoneController.text.trim(),
            secondEmail: _secondEmailController.text.trim());
        _company = Company(
            apiToken: _company.apiToken,
            name: _nameController.text.trim(),
            email: _nameController.text.trim(),
            leftDataOfCompanies: _leftDataOfCompanies);

        _profileBloc.add(EditProfileInfoEvent(company: _company));
      }
    }
  }

  void _addImages() {
    List<Object> _imageFiles = [];
    _images.forEach((element) {
      if (element is File) {
        _imageFiles.add(element);
      }
    });
    if (_imageFiles.isNotEmpty) {
      setState(() => _loadingImages = true);
      _company = _company;
      _profileBloc
          .add(AddProfileImagesEvent(company: _company, images: _imageFiles));
    } else {
      Fluttertoast.showToast(msg: "you must add image first");
    }
  }

  void _removeImage(int id) {
    setState(() => _loadingImages = true);
    _profileBloc.add(RemoveProfileImageEvent(company: _company, id: id));
  }

  void _addVideo() {
    if (_videos.isNotEmpty) {
      setState(() => _loadingVideo = true);

      _profileBloc
          .add(AddProfileVideoEvent(company: _company, video: _videos[0]));
    } else {
      Fluttertoast.showToast(msg: "you must insert one video minimum");
    }
  }

  void _removeVideo({required List<Object> video}) {
    // if from device
    if (video.first is File == true) {
      setState(() {
        _chewieController!.pause();
        _chewieController = null;
        _videos.clear();
      });
    }
    // if from internet
    else if (video.first is VideoModel == true) {
      setState(() => _loadingVideo = true);
      VideoModel _video = video.first as VideoModel;

      _profileBloc
          .add(RemoveProfileVideoEvent(company: _company, id: _video.id!));
    }
  }

  void _addLogo() {
    if (_logo == null) {
      Fluttertoast.showToast(msg: "you must insert image before");
    } else if (_logo is File) {
      setState(() => _loadingLogo = true);

      _profileBloc.add(AddLogoEvent(company: _company, file: _logo as File));
    }
  }

  void _removeLogo({required Object logo}) {
    // if from device
    if (logo is File == true) {
      setState(() {
        _logo = null;
      });
    }
    // if from internet
    else if (logo is ImageModel == true) {
      setState(() => _loadingLogo = true);
      ImageModel _internetLogo = logo as ImageModel;

      _profileBloc.add(
          RemoveProfileVideoEvent(company: _company, id: _internetLogo.id!));
    }
  }

  void _changePassword() {
    if (_passwordFormKey!.currentState!.validate()) {
      setState(() => _loadingChangePassword = true);
      BlocProvider.of<ProfileBloc>(context).add(ChangePasswordEvent(
          company: _company,
          currentPassword: _currentPasswordController.text.trim(),
          newPassword: _newPasswordController.text.trim()));
    }
  }

  void _setProfileData(Company company) {
    setState(() {
      _company = company;
      _images.addAll(_company.images!);
      if (_company.logo == null) {
        _logo = SaveImageModel(url: placeholder_concat);
      } else {
        _logo = _company.logo;
      }
      _maxImages = _company.plan!.numImages!;
      _maxVideo = _company.plan!.numVideos!;

      if (_company.video != null) {
        initializePlayer(_company.video!);
      }
// _logo=
      _nameController.text = _company.name ?? "";
      if (_company.leftDataOfCompanies != null) {
        _commercialRegisterController.text =
            _company.leftDataOfCompanies!.commercialRegister ?? "";
        _taxCardController.text = _company.leftDataOfCompanies!.taxCard ?? "";
        _addressController.text = _company.leftDataOfCompanies!.address ?? "";
        _administrationAddressController.text =
            _company.leftDataOfCompanies!.administrationAddress ?? "";
        _servicesController.text = _company.leftDataOfCompanies!.services ?? "";
        _aboutController.text = _company.leftDataOfCompanies!.companyInfo ?? "";
        _dateTime = _company.leftDataOfCompanies!.dateCreated ?? "";
        // optional
        _secondEmailController.text =
            _company.leftDataOfCompanies!.secondEmail ?? "";
        // _secondPhoneController.text =
        //     _company.leftDataOfCompanies!.secondPhone ?? "";
        _whatsAppController.text = _company.leftDataOfCompanies!.whatsAppNumber ?? "";
        _phoneNumberController.text = _company.leftDataOfCompanies!.firstMobile ?? "";
        _facebookController.text = _company.leftDataOfCompanies!.facebook ?? "";
        _instagramController.text =
            _company.leftDataOfCompanies!.instagram ?? "";
        _twitterController.text = _company.leftDataOfCompanies!.twitter ?? "";
        _websiteController.text =
            _company.leftDataOfCompanies!.firstWebsite ?? "";
      }
    });
  }

  Widget _editLabel({required String label}) {
    return Padding(
        padding: EdgeInsets.fromLTRB(12, 12, 6, 6),
        child: Text(label,
            style: TextStyle(
              // fontSize: 13,
              color: Color(0xff3c63fe),
              // color: Colors.black,
              fontWeight: FontWeight.w500,
            )));
  }

  Future<void> selectLogo() async {
    File? image;

    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    image = File(pickedFile!.path);
    setState(() {
      _logo = image;
    });
  }

  Future<void> getImage() async {
    File? image;
    if (_maxImages > _images.length) {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      image = File(pickedFile!.path);
      setState(() {
        _images.add(image!);
      });
    } else {
      Fluttertoast.showToast(msg: "max images is $_maxImages");
    }
  }

  Future<void> getVideo() async {
    File? video;
    if (_maxVideo > _videos.length) {
      final pickedFile = await _picker.pickVideo(source: ImageSource.gallery);

      video = File(pickedFile!.path);
      setState(() {
        _videos.add(video!);
        _chewieController = ChewieController(
            videoPlayerController: VideoPlayerController.file(video),
            autoPlay: true,
            showControlsOnInitialize: false,
            materialProgressColors:
            ChewieProgressColors(playedColor: Colors.white),
            looping: true,
            showOptions: false);
      });
    } else {
      Fluttertoast.showToast(msg: "max video is $_maxVideo");
    }
  }
}
