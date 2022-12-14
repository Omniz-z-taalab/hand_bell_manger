import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:hand_bill_manger/src/common/constns.dart';
import 'package:hand_bill_manger/src/data/model/chats/chat.dart';
import 'package:hand_bill_manger/src/data/model/company.dart';

class MessageWidget extends StatelessWidget {
  final Chat model;
  final Company company;

  MessageWidget({required this.model, required this.company});

  final double radius = 900;

  // Color mainColor = mainColor;

  @override
  Widget build(BuildContext context) {
    return company.id == model.userId
        ? SendMessageLayout(context)
        : RecivedMessageLayout(context);
  }

  Widget SendMessageLayout(context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Row(
            // mainAxisSize: MainAxisSize.min,
            // textDirection: ui.TextDirection.ltr,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                  child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                      decoration: BoxDecoration(
                          color: Color(0xff2D71D9),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(radius),
                              topRight: Radius.circular(radius),
                              bottomLeft: Radius.circular(radius))),
                      child: Text(model.text.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                              color: Colors.white),
                          textAlign: TextAlign.end)))
            ]));
  }

  Widget RecivedMessageLayout(context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Row(
            textDirection: ui.TextDirection.ltr,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                  child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                      decoration: BoxDecoration(
                          color: Color(0xffffffff),
                          border: Border.all(color: Color(0xffeeeeee)),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(radius),
                              topRight: Radius.circular(radius),
                              bottomRight: Radius.circular(radius))),
                      child: Text(model.text.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                              color: textDarkColor))))
            ]));
  }
}
