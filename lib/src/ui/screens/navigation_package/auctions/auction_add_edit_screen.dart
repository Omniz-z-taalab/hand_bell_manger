import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hand_bill_manger/src/blocs/auction/aucations_bloc.dart';
import 'package:hand_bill_manger/src/blocs/auction/aucations_event.dart';
import 'package:hand_bill_manger/src/blocs/auction/aucations_state.dart';
import 'package:hand_bill_manger/src/blocs/global_bloc/global_bloc.dart';
import 'package:hand_bill_manger/src/data/model/account_package/auction_model.dart';
import 'package:hand_bill_manger/src/data/model/company.dart';
import 'package:hand_bill_manger/src/data/model/local/route_argument.dart';
import 'package:hand_bill_manger/src/data/model/local/video_model.dart';
import 'package:hand_bill_manger/src/ui/component/custom/custom_button.dart';
import 'package:hand_bill_manger/src/ui/component/custom/custom_text_filed_enter.dart';
import 'package:hand_bill_manger/src/ui/component/custom/image_widget.dart';
import 'package:hand_bill_manger/src/ui/component/custom/regular_app_bar.dart';
import 'package:hand_bill_manger/src/ui/component/custom/widgets.dart';
import 'package:hand_bill_manger/src/ui/component/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class AuctionAddEditScreen extends StatefulWidget {
  static const routeName = "/AuctionsAddScreen";
  final RouteArgument? routeArgument;

  AuctionAddEditScreen({this.routeArgument});

  @override
  _AuctionAddEditScreenState createState() => _AuctionAddEditScreenState();
}

class _AuctionAddEditScreenState extends State<AuctionAddEditScreen> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _priceController = TextEditingController();

  late AuctionModel _model;

  final ImagePicker _picker = ImagePicker();
  List<Object> _images = [];
  int _imageIndex = 0;

  double _radius = 8, _marginVer = 16;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late GlobalKey<FormState> _formKey;
  bool _loading = false;

  late AuctionsBloc _auctionsBloc;
  late Company _company;
  int _maxImages = 3, _maxVideo = 1;

  List<Object> _videos = [];
  // late VideoPlayerController _videoPlayerController1;
  ChewieController? _chewieController;

  @override
  void initState() {
    _auctionsBloc = BlocProvider.of<AuctionsBloc>(context);
    _company = BlocProvider.of<GlobalBloc>(context).company!;
    _formKey = new GlobalKey<FormState>();
    if (widget.routeArgument != null) {
      _model = widget.routeArgument!.param;
      _titleController.text = _model.title!;
      _descriptionController.text = _model.description!;
      _priceController.text = _model.price.toString();

      _images.addAll(_model.images!);
    } else {
      _model = AuctionModel();
      // _titleController.text = "New product";
      // _descriptionController.text = "best product in world";
      // _priceController.text = "1000";
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        key: _scaffoldKey,
        appBar: RegularAppBar(
            label: _model.id == null ? "Add Auction" : "Edit Auction"),
        body:
            BlocBuilder<AuctionsBloc, AuctionsState>(builder: (context, state) {
          if (state is AuctionsErrorState) {
            SchedulerBinding.instance!.addPostFrameCallback((_) {
              displaySnackBar(title: state.error!, scaffoldKey: _scaffoldKey);
            });
            _loading = false;
          }
          if (state is AuctionAddSuccessState) {
            SchedulerBinding.instance!.addPostFrameCallback((_) {
              displaySnackBar(title: state.message, scaffoldKey: _scaffoldKey);
            });
            if (_chewieController != null) {
              _chewieController!.pause();
            }
            _images.clear();
            _titleController.clear();
            _descriptionController.clear();
            _priceController.clear();
            _videos.clear();
            _loading = false;
          }

          return SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                      if (_images[index] is String) {
                                        return ServerImageWidget(
                                            image: _images[index].toString(),
                                            // onTap: () => getImage(index),
                                            onRemoveTap: () =>
                                                removeImage(index));
                                      }
                                      if (_images[index] is File) {
                                        return LocalImageWidget(
                                            image: _images[index] as File,
                                            // onTap: () => getImage(index),
                                            onRemoveTap: () =>
                                                removeImage(index));
                                      }
                                      return SizedBox();
                                    })),
                            Positioned(
                                bottom: 8,
                                right: 0,
                                left: 0,
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      DotsIndicator(
                                          dotsCount: _images.length,
                                          position: _imageIndex.toDouble(),
                                          decorator: DotsDecorator(
                                              color: Color(0x4DFFFFFF),
                                              activeColor: Color(0xB3FFFFFF),
                                              size: const Size.square(4.0),
                                              activeSize: const Size(10.0, 4.0),
                                              activeShape:
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5.0))))
                                    ])),
                          ]),
                    SizedBox(height: _marginVer),
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: _label(label: "Images")),
                    SizedBox(height: _marginVer),
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AddImageBtn(
                                  onTap: () => getImage(),
                                  length: _images.length,
                                  max: _maxImages,
                                  label: "Select images",
                                  marginHor: 0),
                            ])),
                    SizedBox(height: _marginVer),
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: _label(label: "Video")),
                    SizedBox(height: _marginVer),
                    _videos.isEmpty
                        ? SizedBox()
                        : Container(
                            height: size.height * 0.3,
                            margin: EdgeInsets.only(bottom: _marginVer),
                            child: Stack(children: [
                              Positioned.fill(
                                  child: Container(
                                      color: Color(0xff000000),
                                      child:
                                          // _videos[0] as File == true
                                          //     ? SizedBox()
                                          //     :
                                          Chewie(
                                              controller: _chewieController!))),
                              Positioned(
                                  top: 12,
                                  right: 12,
                                  child: InkWell(
                                      onTap: () => _removeVideo(video: _videos),
                                      child: Container(
                                          padding: EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                              color: Color(0x26000000),
                                              borderRadius:
                                                  BorderRadius.circular(100)),
                                          child: Center(
                                              child: Icon(Icons.close,
                                                  color: Colors.white)))))
                            ])),
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AddVideoBtn(
                                  onTap: () => getVideo(),
                                  length: _videos.length,
                                  max: _maxVideo,
                                  label: "Select Video",
                                  marginHor: 0),
                            ])),
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Form(
                            key: _formKey,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  SizedBox(height: _marginVer),
                                  _label(label: "Title"),
                                  SizedBox(height: _marginVer),
                                  CustomTextFormFieldEnter(
                                      controller: _titleController,
                                      hintText: "Enter title",
                                      validator: (input) {
                                        if (input.toString().length < 4) {
                                          return "title is short";
                                        }
                                        return null;
                                      }),
                                  SizedBox(height: _marginVer),
                                  _label(label: "Description"),
                                  SizedBox(height: _marginVer),
                                  CustomTextFormFieldEnter(
                                      controller: _descriptionController,
                                      hintText: "Enter description",
                                      validator: (input) {
                                        if (input.toString().length < 4) {
                                          return "enter description";
                                        }
                                        return null;
                                      }),
                                  SizedBox(height: _marginVer),
                                  _label(label: "Price"),
                                  SizedBox(height: _marginVer),
                                  CustomTextFormFieldEnter(
                                      controller: _priceController,
                                      hintText: "Enter price",
                                      validator: (input) {
                                        if (input.toString().isEmpty) {
                                          return "enter price";
                                        }
                                        return null;
                                      }),
                                ]))),
                    _loading == false
                        ? SizedBox(height: 40)
                        : Container(
                            height: 100,
                            width: double.infinity,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(height: 16),
                                  CircularProgressIndicator(
                                      color: Theme.of(context).accentColor,
                                      strokeWidth: 2)
                                ])),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      CustomButton(
                          title: _model.id == null ? "Add" : "Edit",
                          width: size.width * 0.7,
                          radius: 900,
                          onPress: () => _addAuction())
                    ]),
                    SizedBox(height: 80)
                  ]));
        }));
  }

  void _addAuction() {
    if (_formKey.currentState!.validate()) {
      if (!_company.profileCompleted()) {
        displaySnackBar(
            title: "Complete your profile", scaffoldKey: _scaffoldKey);
      } else if (_images.length == 0) {
        displaySnackBar(
            title: "you must select one image", scaffoldKey: _scaffoldKey);
      } else {
        _model.title = _titleController.text;
        _model.description = _descriptionController.text;
        _model.price = _priceController.text;
        setState(() => _loading = true);
        if (_videos.isEmpty) {
          _auctionsBloc.add(AuctionAddEvent(
              model: _model, company: _company, images: _images));
        } else {
          _auctionsBloc.add(AuctionAddEvent(
              model: _model,
              company: _company,
              images: _images,
              video: _videos[0]));
        }
      }
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
      setState(() => _loading = true);
      // VideoModel _video = video.first as VideoModel;

      // _auctionsBloc
      //     .add(RemoveProfileVideoEvent(company: _company, id: _video.id!));
    }
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

  void removeImage(int index) {
    setState(() {
      _images.removeAt(index);
      if (_imageIndex == _images.length && _imageIndex != 0) {
        _imageIndex--;
      }
    });
  }

  Widget _label({required String label}) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 6),
        child: Text(label,
            style: TextStyle(
                fontSize: 13,
                color: Colors.black,
                fontWeight: FontWeight.bold)));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();

    if (_chewieController != null) {
      _chewieController!.pause();
    }
    super.dispose();
  }
}
