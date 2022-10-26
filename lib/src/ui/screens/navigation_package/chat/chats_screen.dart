// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:hand_bill_manger/src/blocs/chat/chat_bloc.dart';
// import 'package:hand_bill_manger/src/blocs/global_bloc/global_bloc.dart';
// import 'package:hand_bill_manger/src/common/constns.dart';
// import 'package:hand_bill_manger/src/data/model/chats/chat_user.dart';
// import 'package:hand_bill_manger/src/data/model/chats/conversition_model.dart';
// import 'package:hand_bill_manger/src/data/model/company.dart';
// import 'package:hand_bill_manger/src/ui/component/custom/login_first_widget_sliver.dart';
// import 'package:hand_bill_manger/src/ui/component/custom/regular_app_bar.dart';
// import 'component/conversaition_empty_widget.dart';
// import 'component/conversation_widget.dart';
//
// class ChatsScreen extends StatefulWidget {
//   static const routeName = "/chatsScreen";
//
//   @override
//   _ChatsScreenState createState() => _ChatsScreenState();
// }
//
// class _ChatsScreenState extends State<ChatsScreen> {
//   late ChatBloc _chatBloc;
//   bool loading = true;
//   late Company _company;
//
//   @override
//   void initState() {
//     _chatBloc = BlocProvider.of<ChatBloc>(context);
//     _company = BlocProvider.of<GlobalBloc>(context).company!;
//
//     getUser();
//
//     super.initState();
//   }
//
//   getUser() {
//     _chatBloc..add(FetchConversationEvent(company: _company));
//     FirebaseFirestore.instance
//         .collection("conversations")
//         .where("visible_to_users", arrayContains: _company.id)
//         .get()
//         .then((value) {
//       print("vvvvvvv ${value.docs[0].data()}");
//     });
//     setState(() {
//       loading = false;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: RegularAppBar(label: "Chats"),
//         body: BlocBuilder<ChatBloc, ChatState>(
//             builder: (BuildContext context, state) {
//           if (state is GetConversationSuccessState) {}
//           return CustomScrollView(slivers: [
//             loading == true
//                 ? EmptyDataWidget(
//                     label: "there_are_no_conversations_you_must_register_first",
//                     paddingHor: 16,
//                     showLoginBtn: true)
//                 : SliverToBoxAdapter(
//                     child: StreamBuilder(
//                         stream: _chatBloc.conversations,
//                         builder: (BuildContext context,
//                             AsyncSnapshot<QuerySnapshot> snapshot) {
//                           print("ddddd   ${snapshot.data?.size}");
//                           switch (snapshot.connectionState) {
//                             case ConnectionState.waiting:
//                               return shimmer();
//                             default:
//                               if (snapshot.data != null) {
//                                 return snapshot.data!.size == 0
//                                     ? Container(
//                                         padding: EdgeInsets.symmetric(
//                                             horizontal: 16),
//                                         height:
//                                             MediaQuery.of(context).size.height *
//                                                 0.8,
//                                         child: Center(
//                                             child: Text("No message received",
//                                                 style: TextStyle(
//                                                     fontSize: 18,
//                                                     height: 1.5,
//                                                     fontWeight:
//                                                         FontWeight.normal,
//                                                     color: textLiteColor),
//                                                 textAlign: TextAlign.center)))
//                                     : ListView.separated(
//                                         physics: BouncingScrollPhysics(),
//                                         padding:
//                                             EdgeInsets.symmetric(vertical: 16),
//                                         primary: false,
//                                         shrinkWrap: true,
//                                         itemCount: snapshot.data!.size,
//                                         itemBuilder: (context, index) {
//                                           ConversationModel _conversation =
//                                               ConversationModel.fromJson(
//                                                   snapshot.data!.docs[index]
//                                                       .data());
//                                           return ConversationWidget(
//                                               model: _conversation,
//                                               user: ChatUser(id: _company.id));
//                                         },
//                                         separatorBuilder:
//                                             (BuildContext context, int index) =>
//                                                 SizedBox(height: 16));
//                               } else {
//                                 return shimmer();
//                               }
//                           }
//                         }))
//           ]);
//         }));
//   }
//
//   Widget shimmer() {
//     return ListView.separated(
//         primary: false,
//         shrinkWrap: true,
//         padding: EdgeInsets.symmetric(vertical: 16),
//         itemCount: 4,
//         itemBuilder: (context, index) => ConversationEmptyWidget(),
//         separatorBuilder: (BuildContext context, int index) =>
//             SizedBox(height: 16));
//   }
// }
