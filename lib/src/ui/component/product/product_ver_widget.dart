import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hand_bill_manger/src/common/constns.dart';
import 'package:hand_bill_manger/src/data/model/company.dart';
import 'package:hand_bill_manger/src/data/model/local/route_argument.dart';
import 'package:hand_bill_manger/src/data/model/product.dart';
import 'package:hand_bill_manger/src/data/model/user.dart';
import 'package:hand_bill_manger/src/ui/screens/details_package/product_details/product_details_screen.dart';

class ProductVerWidget extends StatelessWidget {
  final Product model;
  final Company? company;
  final bool isHome;

  ProductVerWidget(
      {required this.model, required this.company, this.isHome = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(onTap: () {
      Navigator.pushNamed(context, ProductDetailsScreen.routeName,
          arguments: RouteArgument(param: model.id));
    }, child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Container(
          clipBehavior: Clip.hardEdge,
          height: constraints.maxWidth,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Color(0xffeeeeee), width: 1.5),
              boxShadow: [
                BoxShadow(
                    color: Color(0xfff5f5f5), blurRadius: 3, spreadRadius: 3)
              ]),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Stack(children: [
              Container(
                height: constraints.maxWidth * 0.65,
                width: constraints.maxWidth,
                child: CachedNetworkImage(
                    imageUrl: isHome ?model.images![0].url! : model.images![0].url!,
                    placeholder: (context, url) => Center(
                        heightFactor: 1,
                        widthFactor: 1,
                        child: CircularProgressIndicator(
                            color: mainColorLite, strokeWidth: 1)),
                    errorWidget: (context, url, error) =>
                        new Icon(Icons.error, color: mainColorLite)),
              ),

              Positioned(
                  top: 8,
                  right: 8,
                  child: InkWell(
                      onTap: () {},
                      child: Container(
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(90),
                              border: Border.all(color: Color(0xffeeeeee)),
                              color: Color(0x80ffffff)),
                          child: Icon(Icons.close,
                              color: mainColorLite, size: 18))))
            ]),
            Expanded(
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              child: Text(model.name!,
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.black),
                                  textAlign: TextAlign.start,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis)),
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
                                    ]))
                              ]))
                        ])))
          ]));
    }));
  }
}
