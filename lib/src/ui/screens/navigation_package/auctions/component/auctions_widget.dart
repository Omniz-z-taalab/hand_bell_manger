import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hand_bill_manger/src/common/constns.dart';
import 'package:hand_bill_manger/src/data/model/account_package/auction_model.dart';
import 'package:hand_bill_manger/src/data/model/local/route_argument.dart';
import 'package:hand_bill_manger/src/ui/screens/navigation_package/auctions/auction_details_screen.dart';

class AuctionWidget extends StatelessWidget {
  final AuctionModel model;
  final Function onRemoveTap;

  AuctionWidget({required this.model, required this.onRemoveTap});

  final double marginVer = 16, marginBetween = 8;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height * 0.25;
    return InkWell(
        onTap: () {
          Navigator.pushNamed(context, AuctionDetailsScreen.routeName,
              arguments: RouteArgument(param: model));
        },
        child: Container(
            decoration: BoxDecoration(color: Colors.white),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
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
                        onTap: () => onRemoveTap(),
                        child: Container(
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                                color: Color(0x26000000),
                                borderRadius: BorderRadius.circular(100)),
                            child: Center(
                                child:
                                    Icon(Icons.close, color: Colors.white)))))
              ]),
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
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: marginBetween),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(children: [
                                Text("Price : ",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold)),
                                RichText(
                                    text: TextSpan(
                                        style: TextStyle(
                                            color: textDarkColor,
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold),
                                        children: [
                                      TextSpan(text: model.price.toString()),
                                      TextSpan(
                                          text: " \$",
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.deepOrange))
                                    ]))
                              ]),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Status : ",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold)),
                                    Text(model.status.toString(),
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 14)),
                                  ]),
                            ])
                      ]))
            ])));
  }
}
