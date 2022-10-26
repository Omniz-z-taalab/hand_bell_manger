import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hand_bill_manger/src/common/constns.dart';
import 'package:hand_bill_manger/src/data/model/account_package/ad_model.dart';

class AdWidget extends StatelessWidget {
  late final AdsModel model;
  final Function? onRemoveTap;

  AdWidget({required this.model, this.onRemoveTap});

  final double marginBetween = 8;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height * 0.18;

    return Container(
        decoration: BoxDecoration(color: Color(0xffffffff)),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Stack(children: [
            CachedNetworkImage(
                imageUrl: model.image!,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                    height: height,
                    width: double.infinity,
                    color: Color(0xffeeeeee),
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
                            child: Icon(Icons.close, color: Colors.white)))))
          ]),
          Container(
              color: Color(0xfffafafa), height: 2, width: double.infinity),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    model.name == null
                        ? SizedBox()
                        : Text(model.name.toString(),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Type : ",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold)),
                                RichText(
                                    text: TextSpan(
                                        style: TextStyle(
                                            color: textDarkColor, fontSize: 13),
                                        children: [
                                      TextSpan(text: model.type.toString()),
                                    ]))
                              ]),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Status : ",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold)),
                                Text("${model.status}",
                                    style: TextStyle(
                                        color: textDarkColor, fontSize: 13))
                              ]),
                        ]),
                    SizedBox(height: marginBetween),
                  ]))
        ]));
  }
}
