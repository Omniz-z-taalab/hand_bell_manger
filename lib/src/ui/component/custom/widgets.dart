import 'package:flutter/material.dart';
import 'package:hand_bill_manger/src/common/constns.dart';

class AddImageBtn extends StatelessWidget {
  final Function onTap;
  final int length, max;
  final double marginHor;
  final String label;

  AddImageBtn(
      {required this.onTap,
      required this.length,
      required this.max,
      this.marginHor = 16,
      required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: marginHor),
        child: Row(children: [
          InkWell(
              onTap: () => onTap(),
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  decoration: BoxDecoration(
                      color: Color(0xffffffff),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Color(0xffe0e0e0))),
                  child: Row(children: [
                    Icon(Icons.add_photo_alternate_outlined,
                        color: mainColorLite),
                    SizedBox(width: 12),
                    Text("$label   $length/$max",
                        style: TextStyle(color: textDarkColor))
                  ])))
        ]));
  }
}

class AddVideoBtn extends StatelessWidget {
  final Function onTap;
  final int length, max;
  final double marginHor;
  final String label;

  AddVideoBtn(
      {required this.onTap,
      required this.length,
      required this.max,
      required this.label,
      this.marginHor = 16});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: marginHor),
        child: Row(children: [
          InkWell(
              onTap: () => onTap(),
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  decoration: BoxDecoration(
                      color: Color(0xffffffff),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Color(0xffe0e0e0))),
                  child: Row(children: [
                    Icon(Icons.video_call_rounded, color: mainColorLite),
                    SizedBox(width: 12),
                    Text("$label  $length/$max",
                        style: TextStyle(color: textDarkColor))
                  ])))
        ]));
  }
}

class LoadingSliver extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [CircularProgressIndicator(strokeWidth: 2)]));
  }
}
