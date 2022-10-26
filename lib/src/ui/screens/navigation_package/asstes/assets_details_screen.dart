import 'package:cached_network_image/cached_network_image.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:hand_bill_manger/src/common/api_data.dart';
import 'package:hand_bill_manger/src/common/constns.dart';
import 'package:hand_bill_manger/src/data/model/account_package/assets_model.dart';
import 'package:hand_bill_manger/src/data/model/local/route_argument.dart';
import 'package:hand_bill_manger/src/ui/component/custom/expandable_text.dart';
import 'package:hand_bill_manger/src/ui/component/custom/regular_app_bar.dart';
import 'package:hand_bill_manger/src/ui/screens/common/image_full_screen.dart';
import 'package:hand_bill_manger/src/ui/screens/navigation_package/asstes/asstes_add_screen.dart';

class AssetsDetailsScreen extends StatefulWidget {
  static const routeName = "/AssetsDetailsScreen";
  final RouteArgument routeArgument;

  AssetsDetailsScreen({required this.routeArgument});

  @override
  _AssetsDetailsScreenState createState() => _AssetsDetailsScreenState();
}

class _AssetsDetailsScreenState extends State<AssetsDetailsScreen> {
  late AssetsModel _model;
  double _marginVer = 16;

  int _imageIndex = 0;

  @override
  void initState() {
    _model = widget.routeArgument.param;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height * 0.3;
    return Scaffold(
      appBar: RegularAppBar(label: "Assets Details"),
      body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(children: [
                  SizedBox(
                      height: height,
                      width: double.infinity,
                      child: PageView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: _model.images!.length,
                          scrollDirection: Axis.horizontal,
                          controller: PageController(viewportFraction: 1),
                          onPageChanged: (int index) {
                            setState(() => _imageIndex = index);
                          },
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                                onTap: () => Navigator.pushNamed(
                                    context, ImageFullScreen.routeName,
                                    arguments: RouteArgument(
                                        param: _model.images![index].thump)),
                                child: CachedNetworkImage(
                                    // fit: BoxFit.cover,
                                    imageUrl: _model.images![index].thump!,
                                    placeholder: (context, url) => FittedBox(
                                        child: Transform.scale(
                                            scale: 0.2,
                                            child: CircularProgressIndicator(
                                                color: mainColorLite,
                                                strokeWidth: 2))),
                                    errorWidget: (context, url, error) =>
                                        new Icon(Icons.error,
                                            color: mainColorLite)));
                          })),
                  Positioned(
                      bottom: 8,
                      right: 0,
                      left: 0,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            DotsIndicator(
                                dotsCount: _model.images!.length,
                                position: _imageIndex.toDouble(),
                                decorator: DotsDecorator(
                                    color: Color(0x4DFFFFFF),
                                    activeColor: Color(0xB3FFFFFF),
                                    size: const Size.square(4.0),
                                    activeSize: const Size(10.0, 4.0),
                                    activeShape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0))))
                          ])),
                ]),
                SizedBox(height: 8),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: _marginVer * 0.5),
                          Text(_model.title ?? "",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17)),
                          SizedBox(height: _marginVer),
                          ExpandableTextWidget(text: _model.description!),
                          _divider(),
                          SizedBox(
                              height: 60,
                              child: Row(children: [
                                AspectRatio(
                                    aspectRatio: 1 / 1,
                                    child: Container(
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image:
                                                    CachedNetworkImageProvider(
                                                        _model.company!
                                                                    .logo ==
                                                                null
                                                            ? placeholder
                                                            : APIData
                                                                    .domainLink +
                                                                _model
                                                                    .company!
                                                                    .logo!
                                                                    .url!),
                                                fit: BoxFit.cover),
                                            color: Color(0xffffffff),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border: Border.all(
                                                color: Color(0xffe0e0e0))))),
                                SizedBox(width: 16),
                                Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Seller",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: textDarkColor,
                                              fontWeight: FontWeight.w500)),
                                      Text(_model.company!.name!,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: textDarkColor,
                                          )),
                                    ]),
                              ])),
                          // SizedBox(height: _marginVer),
                          _divider(),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                    child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                      Text("Price : ",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold)),
                                      Text("${_model.price} \$",
                                          style: TextStyle(
                                              color: textLiteColor,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold)),
                                    ])),
                                SizedBox(width: 8),
                                Expanded(
                                    child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                      Text("Property type : ",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold)),
                                      Expanded(
                                          child: Text("${_model.propertyType}",
                                              style: TextStyle(
                                                  color: textLiteColor,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold)))
                                    ]))
                              ]),
                          SizedBox(height: 8),
                          Row(children: [
                            Expanded(
                                child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                  Text("Phone : ",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(width: 4),
                                  Expanded(
                                      child: Text(
                                          "${_model.company!.firstPhone}",
                                          style: TextStyle(
                                              color: textLiteColor,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold)))
                                ]))
                          ]),
                          SizedBox(height: 8),
                          Row(children: [
                            Expanded(
                                child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                  Text("Location : ",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(width: 4),
                                  Expanded(
                                      child: Text(
                                          "${_model.company!.leftDataOfCompanies!.address}",
                                          style: TextStyle(
                                              color: textLiteColor,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold)))
                                ]))
                          ]),
                          SizedBox(height: 80)
                        ]))
              ])),
      // floatingActionButton: FloatingActionButton(
      //     backgroundColor: mainColorLite,
      //     onPressed: () => Navigator.pushNamed(
      //         context, AssetsAddScreen.routeName,
      //         arguments: RouteArgument(param: _model)),
      //     child: Icon(Icons.edit, color: Colors.white)),
    );
  }

  Widget _divider() {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 16, horizontal: 0),
        width: double.infinity,
        height: 2,
        color: Color(0xffeeeeee));
  }
}
