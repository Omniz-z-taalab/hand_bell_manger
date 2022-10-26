import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hand_bill_manger/src/common/constns.dart';
import 'package:hand_bill_manger/src/data/model/local/drawer_model.dart';

class DrawerItemWidget extends StatelessWidget {
  final DrawerModel model;

  DrawerItemWidget({required this.model});

  final double icSize = 30;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: model.onTap,
        child: Card(
            elevation: 5,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      model.icon.endsWith("svg")
                          ? SvgPicture.asset(model.icon,
                              height: icSize, width: icSize)
                          : Image.asset(model.icon,
                              height: icSize, width: icSize),
                      Text(model.title,
                          style: TextStyle(
                              color: textDarkColor,
                              fontWeight: FontWeight.bold),
                          maxLines: 1)
                    ]))));
  }
}
