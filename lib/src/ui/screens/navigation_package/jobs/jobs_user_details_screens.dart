import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hand_bill_manger/src/blocs/global_bloc/global_bloc.dart';
import 'package:hand_bill_manger/src/common/constns.dart';
import 'package:hand_bill_manger/src/data/model/account_package/job_user_model.dart';
import 'package:hand_bill_manger/src/data/model/chats/chat_user.dart';
import 'package:hand_bill_manger/src/data/model/chats/conversation.dart';
import 'package:hand_bill_manger/src/data/model/chats/conversition_model.dart';
import 'package:hand_bill_manger/src/data/model/company.dart';
import 'package:hand_bill_manger/src/data/model/local/route_argument.dart';
import 'package:hand_bill_manger/src/ui/component/custom/expandable_text.dart';
import 'package:hand_bill_manger/src/ui/component/custom/regular_app_bar.dart';
import 'package:hand_bill_manger/src/ui/screens/common/image_full_screen.dart';
import 'package:hand_bill_manger/src/ui/screens/navigation_package/chat/inbox_screen.dart';
import 'package:timeago/timeago.dart' as timeago;

class JobUserDetailsScreen extends StatefulWidget {
  static const routeName = "/JobUserDetailsScreen";
  final RouteArgument routeArgument;

  JobUserDetailsScreen({required this.routeArgument});

  @override
  _JobUserDetailsScreenState createState() => _JobUserDetailsScreenState();
}

class _JobUserDetailsScreenState extends State<JobUserDetailsScreen> {
  late JobUserModel _model;

  late Company _company;
  late ConversationModel _conversation;
  List<ChatUser> _users = [];

  @override
  void initState() {
    _company = BlocProvider.of<GlobalBloc>(context).company!;
    _model = widget.routeArgument.param;

    _users.add(ChatUser(
        id: _company.id,
        name: _company.name,
        email: _company.email,
        deviceToken: _company.deviceToken,
        thumb: placeholder));
    _users.add(ChatUser(
        id: _model.user!.id,
        name: _model.user!.name,
        email: _model.user!.email,
        deviceToken: _model.user!.deviceToken,
        thumb: _model.user!.image!.url));
    _conversation = ConversationModel(users: _users);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: RegularAppBar(label: 'Details'),
        // floatingActionButton: FloatingActionButton(
        //     backgroundColor: mainColorLite,
        //     onPressed: () {
        //       Navigator.pushNamed(context, InboxScreen.routeName,
        //           arguments: RouteArgument(param: _conversation));
        //     },
        //     child: Icon(Icons.chat_outlined)),
        body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                  padding: EdgeInsets.fromLTRB(16, 24, 16, 0),
                  child: SizedBox(
                      height: size.height * 0.15,
                      child: Row(children: [
                        InkWell(
                            onTap: () => Navigator.pushNamed(
                                context, ImageFullScreen.routeName,
                                arguments: RouteArgument(
                                    param: _model.user!.image!.url)),
                            child: AspectRatio(
                                aspectRatio: 1 / 1,
                                child: Container(
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      border:
                                          Border.all(color: Color(0xffe0e0e0))),
                                  child: CachedNetworkImage(
                                      imageUrl: _model.user!.image!.url ??
                                          placeholder_concat,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          Transform.scale(
                                              scale: 0.4,
                                              child: CircularProgressIndicator(
                                                  color: mainColorLite,
                                                  strokeWidth: 2)),
                                      errorWidget: (context, url, error) =>
                                          new Icon(Icons.error)),
                                ))),
                        SizedBox(width: 16),
                        Expanded(
                            child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(_model.user!.name.toString(),
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 14)),
                                      SizedBox(height: 8),
                                      Text(_model.user!.address.toString(),
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 14)),
                                      SizedBox(height: 8),
                                      Text(timeago.format(_model.dateTime!),
                                          style: TextStyle(
                                              color: Colors.black45,
                                              fontSize: 13)),
                                    ]))),
                      ]))),
              _divider(),
              Padding(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 24),
                  child: Row(children: [
                    Text(_model.title!,
                        style: TextStyle(
                            fontSize: 17,
                            color: Colors.black,
                            fontWeight: FontWeight.w500))
                  ])),
              // SizedBox(height: 16),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Description",
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.w500)),
                        SizedBox(height: 16),
                        ExpandableTextWidget(text: _model.description!)
                      ])),
              SizedBox(height: 100),
            ])));
  }

  Widget _divider() {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        width: double.infinity,
        height: 2,
        color: Color(0xffeeeeee));
  }
}
