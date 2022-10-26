import 'package:flutter/material.dart';
import 'package:hand_bill_manger/src/common/constns.dart';
import 'package:hand_bill_manger/src/ui/component/custom/custom_button.dart';
import 'package:hand_bill_manger/src/ui/screens/auth/login_screen.dart';
import 'package:hand_bill_manger/src/ui/screens/auth/register_screen.dart';

class AuthScreen extends StatefulWidget {
  static const routeName = "/authScreen";

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Container(
      height: size.height,
      color: Colors.white,
      child: Column(children: [
        Expanded(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
              Transform.scale(
                  scale: 0.5, child: Image.asset("assets/images/hb_logo.jpeg"))
            ])),
        Container(
            height: size.height * 0.30,
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomButton(
                      title: "Login",
                      color: mainColorLite,
                      borderColor: mainColorLite,
                      borderWidth: 1,
                      textStyle: TextStyle(color: Colors.white),
                      radius: 900,
                      onPress: () =>
                          Navigator.pushNamed(context, LoginScreen.routeName)),
                  SizedBox(height: 24),
                  CustomButton(
                      title: "Register",
                      color: Colors.transparent,
                      textStyle: TextStyle(color: mainColorLite),
                      borderColor: mainColorLite,
                      radius: 900,
                      onPress: () => Navigator.pushNamed(
                          context, RegisterScreen.routeName)),
                  SizedBox(height: 16),

                ]))
      ]),
    ));
  }
}
