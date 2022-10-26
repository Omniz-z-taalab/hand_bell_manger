// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:hand_bill_manger/src/common/constns.dart';
// import 'package:hand_bill_manger/src/data/model/chats/chat_user.dart';
// import 'package:hand_bill_manger/src/data/model/chats/conversition_model.dart';
// import 'package:hand_bill_manger/src/data/model/local/route_argument.dart';
// import 'package:hand_bill_manger/src/ui/component/custom/swipe_widget.dart';
// import 'package:hand_bill_manger/src/ui/screens/navigation_package/chat/inbox_screen.dart';
// import 'package:intl/intl.dart';
// import 'package:timeago/timeago.dart' as timeago;
//
// class ConversationWidget extends StatelessWidget {
//   final ConversationModel? model;
//   final ChatUser? user;
//   String _name = "";
//   DateTime? time;
//
//   ConversationWidget({this.model, this.user}) {
//     model!.users!.forEach((element) {
//       if (element.id != user!.id) {
//         _name = element.name!;
//       }
//     });
//     time = new DateTime.fromMicrosecondsSinceEpoch(model!.time!);
//   }
//
//   final double _padding = 16;
//
//   @override
//   Widget build(BuildContext context) {
//     double imageSize = MediaQuery.of(context).size.width * 0.15;
//     return OnSlide(
//         items: [
//           ActionItems(
//               backgroudColor: Theme.of(context).backgroundColor,
//               icon: Icon(Icons.delete_outline, color: Colors.black),
//               onPress: () {
//                 // FirebaseFirestore.instance
//                 //     .collection('conversations')
//                 //     .doc(model!.id)
//                 //     .update(model!.toDeletedMap(user: user) as Map<String, Object?>);
//               })
//         ],
//         child: InkWell(
//             onTap: () {
//               Navigator.pushNamed(context, InboxScreen.routeName,
//                   arguments: RouteArgument(param: model));
//             },
//             child: Container(
//                 padding: EdgeInsets.symmetric(horizontal: _padding),
//                 color: Theme.of(context).backgroundColor,
//                 child: Column(children: [
//                   Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Container(
//                             height: imageSize,
//                             width: imageSize,
//                             padding: EdgeInsets.all(imageSize * 0.25),
//                             clipBehavior: Clip.hardEdge,
//                             decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(imageSize),
//                                 border: Border.all(color: Color(0xffeeeeee)),
//                                 color: Colors.white
//                                 // color: mainColor
//                                 ),
//                             child: SvgPicture.asset(
//                                 "assets/icons/account/chat.svg")),
//                         SizedBox(width: _padding),
//                         Expanded(
//                             child: Column(
//                                 mainAxisSize: MainAxisSize.max,
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                               Text(_name,
//                                   style: TextStyle(
//                                       color: textDarkColor,
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.bold),
//                                   maxLines: 1),
//                               SizedBox(height: 6),
//                               Text(model!.message.toString(),
//                                   style: TextStyle(
//                                       color: textDarkColor, fontSize: 13),
//                                   maxLines: 1)
//                             ])),
//                         SizedBox(width: _padding),
//                         Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               Text(
//                                   DateFormat('HH:mm').format(
//                                       DateTime.fromMillisecondsSinceEpoch(
//                                           model!.time!,
//                                           isUtc: true)),
//                                   style: TextStyle(
//                                       color: textDarkColor, fontSize: 12),
//                                   maxLines: 1),
//                               Text(
//                                   DateFormat('dd-MM-yyyy').format(
//                                       DateTime.fromMillisecondsSinceEpoch(
//                                           model!.time!,
//                                           isUtc: true)),
//                                   style: TextStyle(
//                                       color: textDarkColor, fontSize: 12),
//                                   maxLines: 1)
//                             ]),
//                       ]),
//                   Container(
//                       margin: EdgeInsets.only(top: 12),
//                       height: 1,
//                       color: Color(0xffeeeeee),
//                       width: double.infinity)
//                 ]))));
//   }
// }
