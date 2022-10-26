import 'dart:io';

import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hand_bill_manger/src/blocs/assets/assets_bloc.dart';
import 'package:hand_bill_manger/src/blocs/assets/assets_event.dart';
import 'package:hand_bill_manger/src/blocs/assets/assets_state.dart';
import 'package:hand_bill_manger/src/blocs/global_bloc/global_bloc.dart';
import 'package:hand_bill_manger/src/common/constns.dart';
import 'package:hand_bill_manger/src/data/model/account_package/assets_model.dart';
import 'package:hand_bill_manger/src/data/model/company.dart';
import 'package:hand_bill_manger/src/data/model/local/route_argument.dart';
import 'package:hand_bill_manger/src/ui/component/custom/custom_button.dart';
import 'package:hand_bill_manger/src/ui/component/custom/custom_text_filed_enter.dart';
import 'package:hand_bill_manger/src/ui/component/custom/image_widget.dart';
import 'package:hand_bill_manger/src/ui/component/custom/regular_app_bar.dart';
import 'package:hand_bill_manger/src/ui/component/widgets.dart';
import 'package:image_picker/image_picker.dart';

class AssetsAddScreen extends StatefulWidget {
  static const routeName = "/AssetsAddScreen";
  final RouteArgument? routeArgument;

  AssetsAddScreen({this.routeArgument});

  @override
  _AssetsAddScreenState createState() => _AssetsAddScreenState();
}

class _AssetsAddScreenState extends State<AssetsAddScreen> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _propertyTypeController = TextEditingController();
  TextEditingController _locationController = TextEditingController();

  late AssetsModel _model;

  final ImagePicker _picker = ImagePicker();
  int _maxImages = 3;
  List<Object> _images = [];
  int _imageIndex = 0;

  double _radius = 8, _marginTop = 16;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState>? _formKey;

  bool _loading = false;
  late AssetsBloc _assetsBloc;
  late Company _company;

  @override
  void initState() {
    _assetsBloc = BlocProvider.of<AssetsBloc>(context);
    _company = BlocProvider.of<GlobalBloc>(context).company!;
    _formKey = new GlobalKey<FormState>();
    if (widget.routeArgument != null) {
      _model = widget.routeArgument!.param;
      _titleController.text = _model.title!;
      _descriptionController.text = _model.description!;
      _priceController.text = _model.price.toString();
      _propertyTypeController.text = _model.propertyType.toString();
      _images.addAll(_model.images!);
    } else {
      _model = AssetsModel();
      // _titleController.text = "New Villa at cairo";
      // _descriptionController.text = "4 room and bathroom";
      // _priceController.text = "20000000";
      // _propertyTypeController.text = "flat";
      // _locationController.text = "cairo";
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        key: _scaffoldKey,
        appBar: RegularAppBar(
            label: _model.id == null ? "Add Asset" : "Edit Asset"),
        body: BlocBuilder<AssetsBloc, AssetsState>(builder: (context, state) {
          // if (state is AssetsLoadingState) {
          //   _loading = true;
          // }
          if (state is AssetsErrorState) {
            SchedulerBinding.instance!.addPostFrameCallback((_) {
              displaySnackBar(title: state.error!, scaffoldKey: _scaffoldKey);
            });
            _loading = false;
          }
          if (state is AssetAddSuccessState) {
            SchedulerBinding.instance!.addPostFrameCallback((_) {
              displaySnackBar(title: state.message, scaffoldKey: _scaffoldKey);
            });
            _images.clear();
            _titleController.clear();
            _descriptionController.clear();
            _priceController.clear();
            _propertyTypeController.clear();
            _locationController.clear();

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
                    SizedBox(height: _marginTop),
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: _jobLabel(label: "Images")),
                    SizedBox(height: _marginTop),
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                  onTap: () => getImage(),
                                  child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 12),
                                      decoration: BoxDecoration(
                                          color: Color(0xffffffff),
                                          borderRadius:
                                              BorderRadius.circular(_radius),
                                          border: Border.all(
                                              color: Color(0xffeeeeee))),
                                      child: Row(children: [
                                        Icon(Icons.add_photo_alternate_outlined,
                                            color: mainColorLite),
                                        SizedBox(width: 12),
                                        Text(
                                            "Add Image    ${(_images.length)}/$_maxImages ",
                                            style:
                                                TextStyle(color: textDarkColor))
                                      ])))
                            ])),
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Form(
                            key: _formKey,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  SizedBox(height: _marginTop),
                                  _jobLabel(label: "Title"),
                                  SizedBox(height: _marginTop),
                                  CustomTextFormFieldEnter(
                                      controller: _titleController,
                                      hintText: "Enter title",
                                      validator: (input) {
                                        if (input.toString().length < 4) {
                                          return "enter title";
                                        }
                                        return null;
                                      }),
                                  SizedBox(height: _marginTop),
                                  _jobLabel(label: "Description"),
                                  SizedBox(height: _marginTop),
                                  CustomTextFormFieldEnter(
                                      controller: _descriptionController,
                                      hintText: "Enter description",
                                      validator: (input) {
                                        if (input.toString().length < 4) {
                                          return "enter description";
                                        }
                                        return null;
                                      }),
                                  SizedBox(height: _marginTop),
                                  _jobLabel(label: "Price"),
                                  SizedBox(height: _marginTop),
                                  CustomTextFormFieldEnter(
                                      controller: _priceController,
                                      hintText: "Enter price",
                                      validator: (input) {
                                        if (input.toString().isEmpty) {
                                          return "enter price";
                                        }
                                        return null;
                                      }),
                                  SizedBox(height: _marginTop),
                                  _jobLabel(label: "Property type"),
                                  SizedBox(height: _marginTop),
                                  CustomTextFormFieldEnter(
                                      controller: _propertyTypeController,
                                      hintText: "Enter Property type",
                                      validator: (input) {
                                        if (input.toString().length < 3) {
                                          return "enter Property type";
                                        }
                                        return null;
                                      }),
                                  SizedBox(height: _marginTop),
                                  _jobLabel(label: "Location"),
                                  SizedBox(height: _marginTop),
                                  CustomTextFormFieldEnter(
                                      controller: _locationController,
                                      hintText: "Enter location",
                                      validator: (input) {
                                        if (input.toString().length < 3) {
                                          return "enter location";
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
                          onPress: () => _addAsset())
                    ]),
                    SizedBox(height: 80)
                  ]));
        }));
  }

  void _addAsset() {
    if (_formKey!.currentState!.validate()) {
      if (!_company.profileCompleted()) {
        displaySnackBar(
            title: "Complete your profile", scaffoldKey: _scaffoldKey);
      } else if (_images.length == 0) {
        displaySnackBar(
            title: "you must select one image", scaffoldKey: _scaffoldKey);
      } else {
        setState(() => _loading = true);
        _model.title = _titleController.text;
        _model.description = _descriptionController.text;
        _model.price = double.tryParse(_priceController.text);
        _model.propertyType = _propertyTypeController.text;
        _model.location = _locationController.text;
        _assetsBloc.add(
            AssetAddEvent(model: _model, company: _company, images: _images));
      }
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
    });
  }

  Widget _jobLabel({required String label}) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 6),
        child: Text(label,
            style: TextStyle(
                fontSize: 13,
                color: Colors.black,
                fontWeight: FontWeight.bold)));
  }
}
