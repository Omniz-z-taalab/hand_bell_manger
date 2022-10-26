import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hand_bill_manger/src/common/api_data.dart';
import 'package:hand_bill_manger/src/common/constns.dart';
import 'package:hand_bill_manger/src/data/model/account_package/job_company_model.dart';
import 'package:hand_bill_manger/src/data/model/chats/conversation.dart';
import 'package:hand_bill_manger/src/data/model/local/route_argument.dart';
import 'package:hand_bill_manger/src/ui/component/custom/expandable_text.dart';
import 'package:hand_bill_manger/src/ui/component/custom/regular_app_bar.dart';
import 'package:hand_bill_manger/src/ui/screens/common/image_full_screen.dart';
import 'package:hand_bill_manger/src/ui/screens/navigation_package/chat/inbox_screen.dart';
import 'package:hand_bill_manger/src/ui/screens/navigation_package/jobs/jobs_add_screen.dart';
import 'package:timeago/timeago.dart' as timeago;

class JobCompanyDetailsScreen extends StatefulWidget {
  static const routeName = "/JobCompanyDetailsScreen";
  final RouteArgument routeArgument;

  JobCompanyDetailsScreen({required this.routeArgument});

  @override
  _JobCompanyDetailsScreenState createState() =>
      _JobCompanyDetailsScreenState();
}

class _JobCompanyDetailsScreenState extends State<JobCompanyDetailsScreen> {
  late JobCompanyModel _model;

  bool _isMy = true;

  @override
  void initState() {
    _model = widget.routeArgument.param;
    _isMy = widget.routeArgument.check!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: RegularAppBar(label: 'Details'),

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
                                  param: APIData.domainLink +
                                      _model.company!.logo!.url!)),
                          child: AspectRatio(
                              aspectRatio: 1 / 1,
                              child: Container(
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    border:
                                        Border.all(color: Color(0xffe0e0e0))),
                                child: CachedNetworkImage(
                                    imageUrl: _model.company!.logo == null
                                        ? placeholder_concat
                                        : APIData.domainLink +
                                            _model.company!.logo!.url!,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(_model.company!.name.toString(),
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 14)),
                                    SizedBox(height: 8),
                                    Text(
                                        _model.company!.leftDataOfCompanies!
                                            .address
                                            .toString(),
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
          ])),
      // floatingActionButton: FloatingActionButton(
      //     backgroundColor: mainColorLite,
      //     onPressed: () {
      //       if (_isMy) {
      //         Navigator.pushNamed(context, JobAddScreen.routeName,
      //             arguments: RouteArgument(param: _model));
      //       } else {
      //         Navigator.pushNamed(context, InboxScreen.routeName,
      //             arguments: RouteArgument(param: Conversation()));
      //       }
      //     },
      //     child: Icon(_isMy ? Icons.edit_outlined : Icons.chat_outlined)),
    );
  }

  Widget _divider() {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        width: double.infinity,
        height: 2,
        color: Color(0xffeeeeee));
  }
}
