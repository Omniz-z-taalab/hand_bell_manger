import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hand_bill_manger/src/common/global.dart';
import 'package:hand_bill_manger/src/data/model/company.dart';
import 'package:hand_bill_manger/src/data/model/user.dart';

class GlobalRepository {
  Future<Company?> getCurrentCompany() async {
    Company? myCompany;
    String? sName;
    sName = await storage.read(key: "currentUser");
    if (sName != null) {
      myCompany = Company.fromJson(json.decode(sName));

      // print("$tag  currentUser = ${json.decode(sName)}");
    } else {
      myCompany = null;
    }

    return myCompany;
  }

  final ThemeData liteTheme = ThemeData(
      accentColor: Color(0xff3c63fe),
      primarySwatch: Colors.blue,
      scaffoldBackgroundColor: Color(0xfffafafa),
      brightness: Brightness.light,
      backgroundColor: Color(0xfffafafa),
      // appBarTheme:
      //     AppBarTheme(brightness: Brightness.light, color: Colors.blue),
      textTheme: TextTheme(
        // label
        headline1: TextStyle(
            color: Colors.black, fontSize: 16, fontWeight: FontWeight.normal),
        headline2: TextStyle(
            color: Colors.black, fontSize: 14, fontWeight: FontWeight.normal),
        headline3: TextStyle(
            color: Colors.black, fontSize: 12, fontWeight: FontWeight.normal),
        headline4: TextStyle(
            color: Colors.black, fontSize: 15, fontWeight: FontWeight.normal),
        headline5: TextStyle(
            color: Colors.black, fontSize: 18, fontWeight: FontWeight.normal),
        headline6: TextStyle(
            color: Colors.black, fontSize: 20, fontWeight: FontWeight.normal),
        bodyText1: TextStyle(
            color: Colors.black, fontSize: 13, fontWeight: FontWeight.normal),
        bodyText2: TextStyle(
            color: Colors.white, fontSize: 12, fontWeight: FontWeight.normal),
      ));
}
