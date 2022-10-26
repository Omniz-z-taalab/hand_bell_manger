import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hand_bill_manger/src/common/constns.dart';
import 'package:hand_bill_manger/src/data/model/account_package/offer_model.dart';
import 'package:hand_bill_manger/src/data/model/local/route_argument.dart';
import 'package:hand_bill_manger/src/ui/screens/navigation_package/offers/offers_details_screen.dart';

class OfferWidget extends StatelessWidget {
  final OfferModel model;
  final Function? onRemoveTap;

  final double marginVer = 16, marginBetween = 8;
  double? _save;

  OfferWidget({required this.model, this.onRemoveTap}) {
    _save = (model.oldPrice)! - (model.newPrice)!;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height * 0.3;
    return InkWell(
        onTap: () {
          Navigator.pushNamed(context, OfferDetailsScreen.routeName,
              arguments: RouteArgument(param: model));
        },
        child: Container(
            decoration: BoxDecoration(color: Colors.white),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Stack(children: [
                CachedNetworkImage(
                    imageUrl:  model.images!.isEmpty?placeholder_concat: model.images![0].thump!,
                    fit: BoxFit.cover,
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(model.title.toString(),
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                                fontWeight: FontWeight.bold),
                            maxLines: 3),
                        SizedBox(height: marginBetween),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Price : ",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold)),
                                    RichText(
                                        text: TextSpan(
                                            style: TextStyle(
                                                color: Color(0xffDD2C00),
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold),
                                            children: [
                                          TextSpan(
                                              text: model.oldPrice.toString(),
                                              style: TextStyle(
                                                  decoration: TextDecoration
                                                      .lineThrough)),
                                          TextSpan(text: " \$")
                                        ]))
                                  ]),
                              RichText(
                                  text: TextSpan(
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: textDarkColor,
                                          fontWeight: FontWeight.bold),
                                      children: [
                                    TextSpan(
                                        text: "Minimum quantity : ",
                                        style: TextStyle(color: Colors.black)),
                                    TextSpan(
                                        text: model.minQuantity.toString()),
                                  ]))
                            ]),
                        SizedBox(height: marginBetween),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("With Deal : ",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold)),
                                    Text("${model.newPrice} \$",
                                        style: TextStyle(
                                            color: Color(0xff4CAF50),
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold))
                                  ]),
                              SizedBox(width: 8),
                              RichText(
                                  text: TextSpan(
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: textDarkColor,
                                          fontWeight: FontWeight.bold),
                                      children: [
                                    TextSpan(
                                        text: "You Save : ",
                                        style: TextStyle(color: Colors.black)),
                                    TextSpan(text: _save!.toStringAsFixed(2)),
                                    TextSpan(text: " \$")
                                  ]))
                            ])
                      ]))
            ])));
  }
}
