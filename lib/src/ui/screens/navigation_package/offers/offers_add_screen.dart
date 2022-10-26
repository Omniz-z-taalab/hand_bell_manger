import 'dart:io';

import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hand_bill_manger/src/blocs/global_bloc/global_bloc.dart';
import 'package:hand_bill_manger/src/blocs/offer/offers_bloc.dart';
import 'package:hand_bill_manger/src/blocs/offer/offers_event.dart';
import 'package:hand_bill_manger/src/blocs/offer/offers_state.dart';
import 'package:hand_bill_manger/src/common/constns.dart';
import 'package:hand_bill_manger/src/data/model/account_package/offer_model.dart';
import 'package:hand_bill_manger/src/data/model/company.dart';
import 'package:hand_bill_manger/src/data/model/local/route_argument.dart';
import 'package:hand_bill_manger/src/ui/component/custom/custom_button.dart';
import 'package:hand_bill_manger/src/ui/component/custom/custom_text_filed_enter.dart';
import 'package:hand_bill_manger/src/ui/component/custom/image_widget.dart';
import 'package:hand_bill_manger/src/ui/component/custom/regular_app_bar.dart';
import 'package:hand_bill_manger/src/ui/component/widgets.dart';
import 'package:image_picker/image_picker.dart';

class OfferAddScreen extends StatefulWidget {
  static const routeName = "/PatentedAddScreen";
  final RouteArgument? routeArgument;

  OfferAddScreen({this.routeArgument});

  @override
  _OfferAddScreenState createState() => _OfferAddScreenState();
}

class _OfferAddScreenState extends State<OfferAddScreen> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _oldPriceController = TextEditingController();
  TextEditingController _newPriceController = TextEditingController();
  TextEditingController _minimumQuantityController = TextEditingController();

  late OfferModel _model;

  final ImagePicker _picker = ImagePicker();
  int _maxImages = 3;
  List<Object> _images = [];
  int _imageIndex = 0;

  double _radius = 8, _marginTop = 16;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState>? _formKey;
  late OffersBloc _offersBloc;

  bool _loading = false;
  late Company _company;

  @override
  void initState() {
    _offersBloc = BlocProvider.of<OffersBloc>(context);
    _company = BlocProvider.of<GlobalBloc>(context).company!;
    _formKey = new GlobalKey<FormState>();
    if (widget.routeArgument != null) {
      _model = widget.routeArgument!.param;
      _titleController.text = _model.title!;
      _descriptionController.text = _model.description.toString();
      _oldPriceController.text = _model.oldPrice.toString();
      _newPriceController.text = _model.newPrice.toString();
      _images.addAll(_model.images!);
    } else {
      _model = OfferModel();
      // _titleController.text = "New Offer now";
      // _descriptionController.text = "get new offer fast 50%";
      // _oldPriceController.text = "200";
      // _newPriceController.text = "100";
      // _minimumQuantityController.text = "100";
    }
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    _onAddButtonPressed() {
      if (!_company.profileCompleted()) {
        displaySnackBar(
            title: "Complete your profile", scaffoldKey: _scaffoldKey);
      } else {
        if (_formKey!.currentState!.validate()) {
          _model.title = _titleController.text;
          _model.description = _descriptionController.text.toString();
          _model.oldPrice = double.tryParse(_oldPriceController.text);
          _model.newPrice = double.tryParse(_newPriceController.text);
          _model.minQuantity = int.parse(_minimumQuantityController.text);
          if (_images.length == 0) {
            displaySnackBar(
                title: "you must select one image", scaffoldKey: _scaffoldKey);
          } else {
            _offersBloc.add(OfferAddEvent(
                model: _model, company: _company, images: _images));
          }
        }
      }
    }

    Size size = MediaQuery.of(context).size;
    return Scaffold(
        key: _scaffoldKey,
        appBar: RegularAppBar(
            label: _model.id == null ? "Add Offer" : "Edit Offer"),
        body: BlocBuilder<OffersBloc, OffersState>(builder: (context, state) {
          if (state is OffersLoadingState) {
            _loading = true;
          }
          if (state is OffersErrorState) {
            SchedulerBinding.instance!.addPostFrameCallback((_) {
              displaySnackBar(title: state.error!, scaffoldKey: _scaffoldKey);
            });
            _loading = false;
          }
          if (state is OfferAddSuccessState) {
            SchedulerBinding.instance!.addPostFrameCallback((_) {
              displaySnackBar(title: state.message, scaffoldKey: _scaffoldKey);
            });
            _images.clear();
            _titleController.clear();
            _descriptionController.clear();
            _oldPriceController.clear();
            _newPriceController.clear();
            _minimumQuantityController.clear();
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
                        child: _label(label: "Images")),
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
                                  _label(label: "Title"),
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
                                  _label(label: "Description"),
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
                                  _label(label: "Old Price"),
                                  SizedBox(height: _marginTop),
                                  CustomTextFormFieldEnter(
                                      controller: _oldPriceController,
                                      hintText: "Enter old price",
                                      validator: (input) {
                                        if (input.toString().length < 2) {
                                          return "enter old price";
                                        }
                                        return null;
                                      }),
                                  SizedBox(height: _marginTop),
                                  _label(label: "New price"),
                                  SizedBox(height: _marginTop),
                                  CustomTextFormFieldEnter(
                                      controller: _newPriceController,
                                      hintText: "Enter new price",
                                      validator: (input) {
                                        if (input.toString().length < 2) {
                                          return "enter new price";
                                        }
                                        return null;
                                      }),
                                  SizedBox(height: _marginTop),
                                  _label(label: "Minimum quantity"),
                                  SizedBox(height: _marginTop),
                                  CustomTextFormFieldEnter(
                                      controller: _minimumQuantityController,
                                      hintText: "Enter minimum quantity",
                                      validator: (input) {
                                        if (input.toString().length < 2) {
                                          return "enter minimum quantity";
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
                          onPress: () => _onAddButtonPressed())
                    ]),
                    SizedBox(height: 80)
                  ]));
        }));
  }

  Widget _label({required String label}) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Text(label,
            style: TextStyle(
                fontSize: 13,
                color: Colors.black,
                fontWeight: FontWeight.bold)));
  }
}
