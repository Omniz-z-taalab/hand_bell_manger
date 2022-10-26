import 'package:flutter/material.dart';
import 'package:hand_bill_manger/src/common/constns.dart';
import 'package:hand_bill_manger/src/data/model/plan_model.dart';

class PlanWidget extends StatelessWidget {
  final PlanModel model;
  final Function onTap;

  PlanWidget({required this.model, required this.onTap});

  double divWidth = 0;

  @override
  Widget build(BuildContext context) {
    divWidth = MediaQuery.of(context).size.width * 0.6;
    return Container(
        clipBehavior: Clip.hardEdge,
        padding: EdgeInsets.symmetric(vertical: 32),
        decoration: BoxDecoration(
            color: Color(0xffffffff), borderRadius: BorderRadius.circular(32)),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                  decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.horizontal(right: Radius.circular(12)),
                      gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            Color(0xfffc00ff),
                            Color(0xff00dbde),
                          ])),
                  child: Text(model.name!,
                      style: TextStyle(
                          fontSize: 18,
                          color: Color(0xffffffff),
                          fontWeight: FontWeight.bold))),
              SizedBox(height: 12),
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                RichText(
                    softWrap: false,
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        style: TextStyle(
                            fontSize: 38,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                        children: [
                          TextSpan(text: "\$", style: TextStyle(fontSize: 22)),
                          TextSpan(text: model.price.toString()),
                        ])),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Expanded(flex: 2, child: SizedBox()),
                  Expanded(
                      child: Transform.translate(
                          offset: Offset(0, -8),
                          child: Text("/Per Year",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: textLiteColor,
                                  fontWeight: FontWeight.normal)))),
                ])
              ]),
              // SizedBox(height: 24),
              Expanded(
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: ListView(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _rowItem(
                                label: "Products", count: model.numProducts.toString()),
                            _rowItem(label: "Images", count: model.numImages.toString()),
                            _rowItem(label: "Videos", count: model.numVideos.toString()),
                            _rowItem(label: "Jobs", count: model.numJobs.toString()),
                            _rowItem(label: "Offers", count: model.numOffers.toString()),
                            _rowItem(label: "Assets", count: model.numAssets.toString()),
                          ]))),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                InkWell(
                    onTap: () => onTap(),
                    child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 24),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(900),
                            color: Color(0xffA16AF2)),
                        child: Text("BUY NOW",
                            style: TextStyle(
                                fontSize: 17,
                                color: Colors.white,
                                fontWeight: FontWeight.w500)))),
              ]),
            ]));
  }

  Widget _rowItem({required String label, required String count}) {
    double icSize = 24;
    return Padding(
        padding: EdgeInsets.only(bottom: 8),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                    height: icSize,
                    width: icSize,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(900),
                        color: Color(0xff00d4af)),
                    child: Center(
                        child: Text(count.toString(),
                            style: TextStyle(
                                fontSize: 12,
                                color: Color(0xffffffff),
                                fontWeight: FontWeight.w500)))),
                SizedBox(width: 16),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text(label,
                          style: TextStyle(
                            fontSize: 15,
                            color: textDarkColor,
                            // fontWeight: FontWeight.w500,
                          ))
                    ])),
              ]),
          SizedBox(height: 6),
          Container(height: 0.5, width: divWidth, color: Color(0xffe0e0e0))
        ]));
  }
}
