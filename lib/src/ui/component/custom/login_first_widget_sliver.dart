import 'package:flutter/material.dart';

import 'package:hand_bill_manger/src/ui/screens/auth/auth_screen.dart';

import 'custom_button.dart';

class EmptyDataWidget extends StatelessWidget {
  String label;
  bool showLoginBtn;
  double paddingHor;

  EmptyDataWidget(
      {required this.label, this.showLoginBtn = false, this.paddingHor = 0});

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: paddingHor),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(label,
                    style: Theme.of(context).textTheme.headline5,
                    textAlign: TextAlign.center),
                SizedBox(height: 24),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  showLoginBtn
                      ? CustomButton(
                          title: "sign in",
                          verticalPadding: 16,
                          horizontalPadding: 40,
                          radius: 90,
                          onPress: () {
                            Navigator.pushReplacementNamed(
                                context, AuthScreen.routeName);
                          })
                      : SizedBox()
                ])
              ],
            )));
  }
}
