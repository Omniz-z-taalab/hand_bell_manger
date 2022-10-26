import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hand_bill_manger/src/common/constns.dart';
import 'package:hand_bill_manger/src/data/model/account_package/assets_model.dart';
import 'package:hand_bill_manger/src/data/model/local/route_argument.dart';
import 'package:hand_bill_manger/src/ui/screens/navigation_package/asstes/assets_details_screen.dart';

class AssetsWidget extends StatelessWidget {
  final AssetsModel model;
  final Function? onRemoveTap;

  AssetsWidget({required this.model, this.onRemoveTap});

  final double marginVer = 16, marginBetween = 8;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height * 0.25;
    return InkWell(
        onTap: () {
          Navigator.pushNamed(context, AssetsDetailsScreen.routeName,
              arguments: RouteArgument(param: model));
        },
        child: Container(
            decoration: BoxDecoration(color: Colors.white),
            child: Column(mainAxisSize: MainAxisSize.max, children: [
              Stack(children: [
                CachedNetworkImage(
                    imageUrl: model.images![0].thump!,
                    placeholder: (context, url) => Container(
                        height: height,
                        child: Center(
                            heightFactor: 1,
                            widthFactor: 1,
                            child: CircularProgressIndicator(
                                color: mainColorLite, strokeWidth: 2))),
                    errorWidget: (context, url, error) =>
                        new Icon(Icons.error, color: mainColorLite)),
                Positioned(
                    top: 12,
                    right: 12,
                    child: InkWell(
                        onTap: () => onRemoveTap!(),
                        child: Container(
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                                color: Color(0x26000000),
                                borderRadius: BorderRadius.circular(100)),
                            child: Center(
                                child:
                                    Icon(Icons.close, color: Colors.white)))))
              ]),
              Container(
                  color: Color(0xfffafafa), height: 2, width: double.infinity),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(model.title.toString(),
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                                fontWeight: FontWeight.bold),
                            maxLines: 3),
                        SizedBox(height: 12),
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
                                            color: textLiteColor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold)),
                                    Text("${model.price} \$",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
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
                                            color: textLiteColor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold)),
                                    Text("${model.propertyType}",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold)),
                                  ]))
                            ]),
                        SizedBox(height: 10),
                        Row(children: [
                          Expanded(
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                Text("Location : ",
                                    style: TextStyle(
                                        color: textLiteColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(width: 4),
                                Expanded(
                                    child: Text(
                                        "${model.company!.leftDataOfCompanies!.address}",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold)))
                              ]))
                        ])
                      ]))
            ])));
  }
}
