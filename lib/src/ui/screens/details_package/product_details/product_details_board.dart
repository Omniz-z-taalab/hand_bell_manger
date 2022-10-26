import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hand_bill_manger/src/blocs/products/products_bloc.dart';
import 'package:hand_bill_manger/src/common/api_data.dart';
import 'package:hand_bill_manger/src/common/constns.dart';
import 'package:hand_bill_manger/src/data/model/company.dart';
import 'package:hand_bill_manger/src/data/model/local/data_variable.dart';
import 'package:hand_bill_manger/src/data/model/local/images.dart';
import 'package:hand_bill_manger/src/data/model/local/route_argument.dart';
import 'package:hand_bill_manger/src/data/model/product.dart';
import 'package:hand_bill_manger/src/data/model/product/shipping.dart';
import 'package:hand_bill_manger/src/data/model/specifications.dart';
import 'package:hand_bill_manger/src/ui/component/custom/expandable_text.dart';
import 'package:hand_bill_manger/src/ui/component/widgets.dart';
import 'package:hand_bill_manger/src/ui/screens/common/image_full_screen.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';

class ProductDetailsBoard extends StatefulWidget {
  late Product model;

  ProductDetailsBoard({required this.model});

  @override
  _ProductDetailsBoardState createState() => _ProductDetailsBoardState();
}

class _ProductDetailsBoardState extends State<ProductDetailsBoard> {
  late Product _product;
  bool showAll = false;
  int length = 80;
  double radius = 12, marginTop = 16;

  ScrollController? _scrollController;
  static const offsetVisibleThreshold = 100.0;
  late ProductsBloc _productsBloc;

  List<Specifications> _specifications = [];

  List<ImageModel> _imageList = [];
  int _imageIndex = 0;
  late VideoPlayerController _videoPlayerController1;
  ChewieController? _chewieController;
  bool _addVideo = false;
  ShippingData? _shippingData;
  List<DataVariable> _shippingList = [];

  @override
  void initState() {
    _productsBloc = BlocProvider.of<ProductsBloc>(context);

    _scrollController = ScrollController()..addListener(_onScroll);
    getData();
    super.initState();
  }

  Future<void> initializePlayer(String url) async {
    _videoPlayerController1 = VideoPlayerController.network(url);
    await _videoPlayerController1.initialize();
    _createChewieController();
    setState(() {
      _imageList.insert(0, ImageModel());
      _addVideo = true;
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

  Company _company = Company();
  String? _name = "",
      _flag = "",
      _natureActivity = "",
      _description = "",
      _country = "",
      _mqo = "",
      _price = "";

  getData() async {
    _product = widget.model;
    if (_product.company != null) {
      _name = _product.name;
      _description = _product.description;
      _imageList = _product.images!;
      _country = _product.country!;
      _price = _product.price!;
      _mqo = _product.shippingMqo!;
      _specifications = _product.specifications!;
      _company = _product.company!;
      _flag = _product.flag;
      _natureActivity = _company.natureActivity;
      if (_product.video != null && _addVideo == false) {
        initializePlayer(_product.video!.url!);
      }
      if (_product.shippingData != null) {
        _shippingData = _product.shippingData;
        if (_shippingList.length > 0) {
          _shippingList.clear();
          _shippingData!.toJson().forEach((key, value) {
            if (value != null) {
              _shippingList.add(DataVariable(
                  key: toBeginningOfSentenceCase(key.replaceAll("_", " ")),
                  value: value.toString()));
            }
          });
        } else {
          _shippingData!.toJson().forEach((key, value) {
            if (value != null) {
              _shippingList.add(DataVariable(
                  key: key.replaceAll("_", " "), value: value.toString()));
            }
          });
        }
      }
    }
    setState(() {});
  }

  void _onScroll() {
    final max = _scrollController!.position.maxScrollExtent;
    final offset = _scrollController!.offset;

    if (offset + offsetVisibleThreshold >= max && !_productsBloc.isFetching) {
      setState(() {
        _productsBloc.isFetching = true;
      });
      // _productsBloc
      //   ..add(FetchProductsBySubCategoryEvent(
      //       subcategoryId: _model.categoryId!, user: _user));
    }
  }

  @override
  void dispose() {
    _scrollController!.dispose();
    if (_chewieController != null) {
      _videoPlayerController1.dispose();
      _chewieController!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SliverToBoxAdapter(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          Container(
              height: size.height * 0.4,
              color: Colors.white,
              child: PageView.builder(
                  itemCount: _imageList.length,
                  controller: PageController(viewportFraction: 1),
                  onPageChanged: (int index) {
                    setState(() => _imageIndex = index);
                    if (index == 1 && _chewieController != null) {
                      _videoPlayerController1.pause();
                    }
                  },
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 0 && _chewieController != null) {
                      return Chewie(controller: _chewieController!);
                    } else {
                      return InkWell(
                        onTap: () => Navigator.pushNamed(
                            context, ImageFullScreen.routeName,
                            arguments: RouteArgument(param: _imageList[index].url)),
                        child: CachedNetworkImage(
                            imageUrl: _imageList[index].url!,
                            placeholder: (context, url) => Center(
                                heightFactor: 1,
                                widthFactor: 1,
                                child: CircularProgressIndicator(
                                    color: mainColorLite, strokeWidth: 2)),
                            errorWidget: (context, url, error) =>
                                new Icon(Icons.error, color: mainColorLite)),
                      );
                    }
                  })),
          Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: marginTop),
                    _imageList.isEmpty
                        ? SizedBox()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                                DotsIndicator(
                                    dotsCount: _imageList.length,
                                    position: _imageIndex.toDouble(),
                                    decorator: DotsDecorator(
                                        color: Color(0x26000000),
                                        activeColor: Color(0x80000000),
                                        size: const Size.square(4.0),
                                        activeSize: const Size(10.0, 4.0),
                                        activeShape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0))))
                              ]),
                    SizedBox(height: marginTop),
                    Row(
                      children: [
                        Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                              Text(_name.toString(),
                                  style: TextStyle(
                                      color: textDarkColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500)),
                              SizedBox(height: marginTop),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    RichText(
                                        text: TextSpan(
                                            style: TextStyle(
                                                color: textDarkColor,
                                                fontSize: 14),
                                            children: [
                                          TextSpan(
                                              text: "MOQ : ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13)),
                                          TextSpan(text: _mqo.toString()),
                                          TextSpan(text: " Pieces")
                                        ])),
                                  ]),
                            ])),
                      ],
                    ),
                    SizedBox(height: marginTop),
                    Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                  color: Color(0xfff5f5f5),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Color(0xffeeeeee))),
                              child: Row(children: [
                                Text("Unit Price",
                                    style: TextStyle(
                                        color: textDarkColor, fontSize: 14)),
                                SizedBox(width: 4),
                                Text("$_price \$ US",
                                    style: TextStyle(
                                        color: textDarkColor, fontSize: 14)),
                              ])),
                          Expanded(
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                Icon(Icons.location_on),
                                SizedBox(width: 8),
                                Text(_country.toString(),
                                    style: TextStyle(
                                        fontSize: 14, color: textDarkColor)),
                              ]))
                        ]),
                    SizedBox(height: marginTop)
                  ])),
          Container(
              margin: EdgeInsets.only(bottom: 16),
              width: double.infinity,
              height: 8,
              color: Color(0xffeeeeee)),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                        onTap: () {
                          // _videoPlayerController1.pause();
                          // Navigator.pushNamed(context, CompanyScreen.routeName,
                          //     arguments: RouteArgument(param: _company));
                        },
                        child: SizedBox(
                            height: 60,
                            child: Row(children: [
                              AspectRatio(
                                  aspectRatio: 1 / 1,
                                  child: Container(
                                      clipBehavior: Clip.hardEdge,
                                      decoration: BoxDecoration(
                                          color: Color(0xffeeeeee),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                              color: Color(0xffe0e0e0))),
                                      child: CachedNetworkImage(
                                          imageUrl: _company.logo == null
                                              ? placeholder_concat
                                              : APIData.domainLink +
                                                  _company.logo!.url!,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              Transform.scale(
                                                  scale: 0.4,
                                                  child:
                                                      CircularProgressIndicator(
                                                          color: mainColorLite,
                                                          strokeWidth: 2)),
                                          errorWidget: (context, url, error) =>
                                              new Icon(Icons.error)))),
                              SizedBox(width: 16),
                              Expanded(
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                    Text("${_company.name}",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: textDarkColor,
                                          // fontWeight: FontWeight.w500
                                        ),
                                        maxLines: 1),
                                    Text("VERIFIED MEMBER",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: textDarkColor,
                                          // fontWeight: FontWeight.w500
                                        ),
                                        maxLines: 1)
                                  ])),
                              Container(
                                  height: 24,
                                  width: 24,
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4)),
                                  child: CachedNetworkImage(
                                      imageUrl: _flag ?? imageFlag,
                                      placeholder: (context, url) =>
                                          Transform.scale(
                                              scale: 0.4,
                                              child: CircularProgressIndicator(
                                                  color: mainColorLite,
                                                  strokeWidth: 2)),
                                      errorWidget: (context, url, error) =>
                                          new Icon(Icons.error,
                                              color: mainColorLite))),
                            ]))),

                    // SizedBox(height: 16),
                  ])),
          _shippingData == null
              ? SizedBox()
              : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  _divider(),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Packaging and Shipping",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.start),
                            SizedBox(height: 16),
                            ListView.builder(
                                primary: false,
                                shrinkWrap: true,
                                itemCount: _shippingList.length,
                                itemBuilder:
                                    (BuildContext context, int index) =>
                                        ShippingRowWidget(
                                            model: _shippingList[index],
                                            index: index))
                          ]))
                ]),
          _divider(),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Specifications",
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.start),
                    SizedBox(height: 16),
                    ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: _specifications.length,
                        itemBuilder: (BuildContext context, int index) =>
                            DataRowWidget(
                                model: _specifications[index], index: index))
                  ])),
          _divider(),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Description",
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.start),
                    SizedBox(height: 16),
                    ExpandableTextWidget(text: _description.toString())
                  ])),
          SizedBox(height: 80)
        ]));
  }

  Widget _divider() {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 16),
        width: double.infinity,
        height: 8,
        color: Color(0xffeeeeee));
  }
}

class ShippingRowWidget extends StatelessWidget {
  final int index;
  final DataVariable model;

  ShippingRowWidget({required this.model, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: index.isEven ? Color(0xfff5f5f5) : Color(0xfffafafa),
            border: Border.all(
                color: index.isEven ? Color(0xffeeeeee) : Color(0xffffff))),
        child: Row(children: [
          Expanded(
              child: Text(model.key!,
                  style: TextStyle(
                      fontSize: 14,
                      color: textDarkColor,
                      fontWeight: FontWeight.w500))),
          SizedBox(width: 16),
          Expanded(
              child: Text(model.value!,
                  style: TextStyle(fontSize: 14, color: textDarkColor)))
        ]));
  }
}

class DataRowWidget extends StatelessWidget {
  final Specifications model;
  final int index;

  DataRowWidget({required this.model, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: index.isEven ? Color(0xfff5f5f5) : Color(0xfffafafa),
            border: Border.all(
                color: index.isEven ? Color(0xffeeeeee) : Color(0xffffff))),
        child: Row(children: [
          Expanded(
              child: Text(model.key ?? "",
                  style: TextStyle(
                      fontSize: 14,
                      color: textDarkColor,
                      fontWeight: FontWeight.w500))),
          SizedBox(width: 16),
          Expanded(
              child: Text(model.value ?? "",
                  style: TextStyle(fontSize: 14, color: textDarkColor)))
        ]));
  }
}
