import 'package:flutter/material.dart';
import 'package:hand_bill_manger/src/common/constns.dart';

class CustomTextFormField extends StatefulWidget {
  bool isPassword;
  String? hintText;
  bool isEmail;

  TextEditingController? controller;
  var validator;
  IconData? icon;
  Function(String?)? onSave;
  TextInputType? inputType;

  CustomTextFormField(
      {this.isPassword = false,
      this.isEmail = false,
      this.hintText,
      this.controller,
      this.validator,
      this.icon,
      this.inputType,
      this.onSave});

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  Color fillColor = Colors.white;

  Color borderColor = Color(0xffe0e0e0);

  // Color borderColor = Color(0x802f84ed);

  Color iconColor = Color(0xff707070);
  double icSize = 32;
  bool hide = false;

  @override
  void initState() {
    super.initState();
    hide = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(color: Colors.black),
      obscureText: hide,
      // inputFormatters: [],
      keyboardType:
          widget.isEmail ? TextInputType.emailAddress : TextInputType.text,
      decoration: InputDecoration(
          prefixIcon: widget.icon == null ? SizedBox() : Icon(widget.icon),
          border: new UnderlineInputBorder(
              borderSide: new BorderSide(color: borderColor)),
          enabledBorder: new UnderlineInputBorder(
              borderSide: new BorderSide(color: borderColor)),
          // contentPadding: EdgeInsets.all(0),
          hintText: widget.hintText,
          hintStyle: TextStyle(color: textLiteColor)),
      controller: widget.controller,
      validator: widget.validator,
      onSaved: (input) => widget.onSave!(input),
    );
  }
}
