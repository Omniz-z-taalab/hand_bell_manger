import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hand_bill_manger/src/blocs/help/help_bloc.dart';
import 'package:hand_bill_manger/src/blocs/help/help_event.dart';
import 'package:hand_bill_manger/src/blocs/help/help_state.dart';
import 'package:hand_bill_manger/src/common/constns.dart';
import 'package:hand_bill_manger/src/data/model/account_package/agent_model.dart';
import 'package:hand_bill_manger/src/ui/component/custom/regular_app_bar.dart';
import 'package:hand_bill_manger/src/ui/screens/navigation_package/help/help_center_response.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../component/custom/login_first_widget_sliver.dart';

class HelpCenterScreen extends StatefulWidget {
  static const routeName = "/HelpCenterScreen";

  @override
  _HelpCenterScreenState createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late HelpBloc _helpBloc;
  late List<UserData>? mail;
  ScrollController? _scrollController;
  static const offsetVisibleThreshold = 50.0;
  bool loading = false;

  @override
  void initState() {
    _helpBloc = BlocProvider.of<HelpBloc>(context);

    _helpBloc..add(FetchAgentEvent());
    _helpBloc..add(FetchEmailEvent());

    _scrollController = ScrollController()..addListener(_onScroll);

    super.initState();
  }

  void _onScroll() {
    final max = _scrollController!.position.maxScrollExtent;
    final offset = _scrollController!.offset;

    if (offset + offsetVisibleThreshold >= max && !_helpBloc.isFetching) {
      setState(() {
        _helpBloc.isFetching = true;
      });
      _helpBloc.add(FetchAgentEvent());
    }
  }

  @override
  void dispose() {
    _scrollController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HelpBloc, HelpState>(
      listener: (context, state) {
        if (state is HelpSuccessEmails) {
             mail = state.mails;
      }},
      builder: (context, state) {
        return Scaffold(
            key: _scaffoldKey,
            appBar: RegularAppBar(label: "Help Center"),
            body: ListView.separated(
                itemBuilder: (BuildContext context, int index) =>
                    buildTaskItem(mail![index]),
                separatorBuilder: (BuildContext context, int index) => SizedBox(
                      height: 12,
                    ),
                itemCount: mail!.length));
      },
    );
  }
}
Widget buildTaskItem(UserData model) => Padding(padding: EdgeInsets.all(2),
child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
  Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${model.email}',
                      style:
                      TextStyle(fontSize: 16, color: Colors.black)),
                  SizedBox(height: 16),

                ]),
            Icon(model.icon != null? model.icon : Icons.email, color: Colors.black26,
            )
          ])),
  Container(
      height: 6, decoration: BoxDecoration(color: Color(0xffeeeeee)))
]),);


class ContactWidget extends StatelessWidget {
  final List<UserData>? data;

  ContactWidget({required this.data});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => launchEmailSubmission(data.toString()),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('$data',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black)),
                          SizedBox(height: 16),
                          Text('$data',
                              style: TextStyle(fontSize: 16, color: mainColor))
                        ]),
                    Icon(
                      Icons.email,
                      color: Color(0xffBDBDBD),
                      // color: mainColor,
                    )
                  ])),
          Container(
              height: 6, decoration: BoxDecoration(color: Color(0xffeeeeee)))
        ]));
  }

  void launchEmailSubmission(String email) async {
    final Uri params = Uri(scheme: 'mailto', path: email, queryParameters: {
      // 'subject': 'Default Subject',
      // 'body': 'Default body'
    });
    String url = params.toString();
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }
}
