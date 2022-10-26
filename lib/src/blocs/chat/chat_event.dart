// part of 'chat_bloc.dart';
//
// abstract class ChatEvent extends Equatable {
//   const ChatEvent();
//
//   @override
//   List<Object> get props => [];
// }
//
// class FetchConversationEvent extends ChatEvent {
//   final Company company;
//
//   FetchConversationEvent({required this.company});
// }
//
// class FetchChatsEvent extends ChatEvent {
//   final ConversationModel? conversation;
//   final ChatUser? chatUser;
//
//   FetchChatsEvent({required this.conversation, required this.chatUser});
// }
//
// class AddMessageEvent extends ChatEvent {
//   final ConversationModel? conversation;
//   final String? text;
//   final ChatUser? chatUser;
//
//   AddMessageEvent({this.conversation, this.chatUser, this.text});
// }
