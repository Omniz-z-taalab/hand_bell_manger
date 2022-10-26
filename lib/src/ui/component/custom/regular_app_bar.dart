import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hand_bill_manger/src/common/constns.dart';

class RegularAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double size = 22;
  late String label;
  Widget? widget;
  TextStyle? textStyle;

  RegularAppBar({required this.label, this.widget, this.textStyle});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.11,
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        color: Colors.white,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                                child: Row(children: [
                              IconButton(
                                  onPressed: () => Navigator.pop(context),
                                  icon: Icon(
                                    Icons.arrow_back,
                                    color: Colors.black,
                                  )),
                              SizedBox(width: 16),
                              Expanded(
                                  child: Text(label,
                                      style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black)
                                          .merge(textStyle),
                                      maxLines: 1))
                            ])),
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: widget)
                          ]))),
              Container(
                  width: double.infinity, color: Color(0xffeeeeee), height: 1.5)
            ]));
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
