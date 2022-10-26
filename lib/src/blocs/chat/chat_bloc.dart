// import 'dart:async';
// import 'dart:developer';
//
// import 'package:bloc/bloc.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// import 'package:equatable/equatable.dart';
// import 'package:flutter/material.dart';
// import 'package:hand_bill_manger/src/data/model/chats/chat.dart';
// import 'package:hand_bill_manger/src/data/model/chats/chat_user.dart';
// import 'package:hand_bill_manger/src/data/model/chats/conversation.dart';
// import 'package:hand_bill_manger/src/data/model/chats/conversition_model.dart';
// import 'package:hand_bill_manger/src/data/model/company.dart';
// import 'package:hand_bill_manger/src/data/model/user.dart';
// import 'package:hand_bill_manger/src/repositories/chat_ropository.dart';
//
// part 'chat_event.dart';
//
// part 'chat_state.dart';
//
// class ChatBloc extends Bloc<ChatEvent, ChatState> {
//   ChatRepository chatRepository = ChatRepository();
//
//   ChatBloc() : super(ChatInitial());
//   ConversationModel? conversation;
//   Stream<QuerySnapshot>? chats;
//   Stream<QuerySnapshot>? conversations;
//
//   @override
//   Stream<ChatState> mapEventToState(
//     ChatEvent event,
//   ) async* {
//     if (event is FetchConversationEvent) {
//       yield* _mapGetConversations(event);
//     }
//
//     if (event is FetchChatsEvent) {
//       yield* _mapGetChats(event);
//     }
//
//     if (event is AddMessageEvent) {
//       yield* _mapAddMessage(event);
//     }
//   }
//
//   Stream<ChatState> _mapGetConversations(FetchConversationEvent event) async* {
//     chatRepository.getUserConversions(event.company).then((_conversations) {
//       conversations = _conversations;
//     });
//     yield GetConversationSuccessState(conversation: conversations);
//   }
//
//   Stream<ChatState> _mapGetChats(FetchChatsEvent event) async* {
//     event.conversation!.readByUsers!.add(event.chatUser!.id.toString());
//     chatRepository.getChats(event.conversation!).then((_chats) {
//       chats = _chats;
//     });
//   }
//
//   Stream<ChatState> _mapAddMessage(AddMessageEvent event) async* {
//     ConversationModel _conversation = event.conversation!;
//     Chat _chat = new Chat(event.text,
//         DateTime.now().toUtc().millisecondsSinceEpoch, event.chatUser!.id);
//     if (_conversation.id == null) {
//       _conversation.id = UniqueKey().toString();
//       createConversation(_conversation, event.chatUser!);
//     }
//     _conversation.message = event.text;
//     _conversation.time = _chat.time;
//     // _conversation.readByUsers = [event.company!.id.toString()];
//
//     bool send = await chatRepository.addMessage(
//         conversation: _conversation, chat: _chat);
//
//     // log("cccc ${_conversation.company!.name}");
//
//     if (send) {
//       yield AddMessageSuccessState();
//       _conversation.users!.forEach((_user) {
//         if (_user.id != event.chatUser!.id) {
//           chatRepository.sendFcmMessage(
//               body: event.text,
//               title: "message from" + " " + event.chatUser!.name!,
//               user: _user);
//         }
//       });
//       // chatRepository.sendFcmMessage(
//       //     body: event.text,
//       //     title: "message from" + " " + event.chatUser!.name!,
//       //     user: event.chatUser!);
//
//       print("sendddddd");
//     } else {
//       print("faillllllll");
//     }
//   }
//
//   createConversation(ConversationModel _conversation, ChatUser chatUser) async {
//     // _conversation.company = company;
//     // _conversation.users!.insert(0, user);
//     _conversation.readByUsers = [chatUser.id.toString()];
//     _conversation.time =
//         DateTime.now().toUtc().millisecondsSinceEpoch;
//     conversation = _conversation;
//     await chatRepository.createConversation(conversation!).then((value) {
//       add(FetchChatsEvent(conversation: conversation, chatUser: chatUser));
//     });
//   }
//
//   orderSnapshotByTime(AsyncSnapshot snapshot) {
//     final docs = snapshot.data.documents;
//     // docs.sort((QueryDocumentSnapshot a, QueryDocumentSnapshot b) {
//     //   var time1 = a.get('time');
//     //   var time2 = b.get('time');
//     //   return time2.compareTo(time1) as int?;
//     // });
//     return docs;
//   }
// }
