import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double size = 22;
  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.12,
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        color: Colors.white,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset("assets/images/hb_logo.jpeg",
                                height: 32),
                            // InkWell(
                            //     onTap: () => Navigator.pushNamed(
                            //         context, NotificationsScreen.routeName),
                            //     child: SvgPicture.asset(
                            //         "assets/icons/notifications_ic.svg",
                            //         height: size,
                            //         width: size))
                          ]))),
              Container(
                  width: double.infinity, color: Color(0xffeeeeee), height: 1.5)
            ]));
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
