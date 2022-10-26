import 'package:flutter/material.dart';
import 'package:hand_bill_manger/src/common/constns.dart';

class AuctionEmptyWidget extends StatelessWidget {
  final double size = 45;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
        aspectRatio: 1.5 / 1,
        child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          return Container(
              color: Colors.white,
              height: constraints.maxHeight,
              width: constraints.maxWidth,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      height: constraints.maxHeight * 0.6,
                      width: constraints.maxWidth,
                      decoration: BoxDecoration(
                          //     borderRadius: BorderRadius.circular(50),
                          color: shimmerColor),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                        child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: constraints.maxWidth * 0.08,
                                vertical: constraints.maxHeight * 0.08),
                            child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      height: constraints.maxHeight * 0.07,
                                      width: constraints.maxWidth * 0.6,
                                      color: shimmerColor),
                                  Container(
                                      height: constraints.maxHeight * 0.07,
                                      width: constraints.maxWidth * 0.3,
                                      color: shimmerColor),
                                ])))
                  ]));
        }));
  }
}
