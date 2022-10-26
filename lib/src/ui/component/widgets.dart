import 'package:flutter/material.dart';
import 'package:hand_bill_manger/src/common/constns.dart';
import 'package:hand_bill_manger/src/data/model/local/data_variable.dart';

class GradientText extends StatelessWidget {
  final String text;
  final Gradient gradient;
  final TextStyle? style;

  const GradientText({
    Key? key,
    required this.text,
    required this.gradient,
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
        shaderCallback: (Rect bounds) {
          return gradient
              .createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height));
        },
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 6),
            child: Text(text, style: style)));
  }
}

void displaySnackBar({required String title,required scaffoldKey}) {
  final snackBar = SnackBar(content: Text(title));
  scaffoldKey.currentState.showSnackBar(snackBar);
}

class DataRowWidgetCustom extends StatelessWidget {
  final DataVariable model;

  DataRowWidgetCustom({required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(children: [
          Row(children: [
            Expanded(
                child: Text(model.key!,
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.bold))),
            SizedBox(width: 16),
            Expanded(
                child: Text(model.value!,
                    style: TextStyle(
                      fontSize: 14,
                      color: textDarkColor,
                    )))
          ]),
          // SizedBox(height: 16),
          Container(
              margin: EdgeInsets.symmetric(vertical: 16),
              height: 1,
              color: Color(0xffe0e0e0),
              width: double.infinity)
        ]));
  }
}