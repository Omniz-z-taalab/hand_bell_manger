import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hand_bill_manger/src/common/constns.dart';
import 'package:hand_bill_manger/src/data/model/local/route_argument.dart';
import 'package:hand_bill_manger/src/data/model/product.dart';
import 'package:hand_bill_manger/src/data/model/user.dart';
import 'package:hand_bill_manger/src/ui/screens/details_package/product_details/product_details_screen.dart';

class ProductAdWidget extends StatelessWidget {
  final Product model;
  final bool isHome;
  final Function? onTap;

  ProductAdWidget({required this.model, this.isHome = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => onTap!(),
        child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          return Container(
              width: constraints.maxHeight,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(color: Color(0xfff5f5f5), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                        color: Color(0xfff5f5f5),
                        blurRadius: 3,
                        spreadRadius: 3)
                  ]),
              child: Column(children: [
                Stack(children: [
                  Container(
                    clipBehavior: Clip.hardEdge,
                    height: constraints.maxHeight * 0.6,
                    width: constraints.maxHeight,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
                    child: CachedNetworkImage(
                        imageUrl: isHome
                            ? model.images![0].url!
                            : model.images![0].thump!,
                        placeholder: (context, url) => Center(
                            heightFactor: 1,
                            widthFactor: 1,
                            child: CircularProgressIndicator(
                                color: mainColorLite, strokeWidth: 1)),
                        errorWidget: (context, url, error) =>
                            new Icon(Icons.error)),
                  ),
                  Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(90),
                              border: Border.all(color: Color(0xffeeeeee)),
                              color: model.selected!
                                  ? mainColorLite
                                  : Color(0x99ffffff)),
                          child: Icon(Icons.check,
                              color: model.selected!
                                  ? Colors.white
                                  : mainColorLite,
                              size: 18)))
                ]),
                Expanded(
                    child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                  child: Text(model.name!,
                                      style:
                                          Theme.of(context).textTheme.headline1,
                                      textAlign: TextAlign.start,
                                      maxLines: 2)),
                              Expanded(
                                  child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  RichText(
                                      text: TextSpan(
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                          children: [
                                        TextSpan(text: model.price.toString()),
                                        TextSpan(
                                            text: " \$",
                                            style: TextStyle(
                                                color: Colors.deepOrange))
                                      ])),
                                  Container(
                                      height: 24,
                                      width: 24,
                                      clipBehavior: Clip.hardEdge,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4)),
                                      child: CachedNetworkImage(
                                          imageUrl: model.flag ?? imageFlag,
                                          placeholder: (context, url) =>
                                              Transform.scale(
                                                  scale: 0.4,
                                                  child:
                                                      CircularProgressIndicator(
                                                          color: mainColorLite,
                                                          strokeWidth: 2)),
                                          errorWidget: (context, url, error) =>
                                              new Icon(Icons.error,
                                                  color: mainColorLite))),
                                ],
                              ))
                            ])))
              ]));
        }));
  }
}
