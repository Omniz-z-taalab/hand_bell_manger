import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hand_bill_manger/src/blocs/help/help_bloc.dart';
import 'package:hand_bill_manger/src/blocs/help/help_event.dart';
import 'package:hand_bill_manger/src/blocs/help/help_state.dart';
import 'package:hand_bill_manger/src/data/model/account_package/agent_model.dart';
import 'package:hand_bill_manger/src/ui/component/custom/login_first_widget_sliver.dart';
import 'package:hand_bill_manger/src/ui/component/custom/regular_app_bar.dart';
import 'package:hand_bill_manger/src/ui/component/custom/widgets.dart';
import 'package:hand_bill_manger/src/ui/component/widgets.dart';
import 'package:hand_bill_manger/src/ui/screens/navigation_package/agent/component/agent_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class AgentsScreen extends StatefulWidget {
  static const routeName = "/AgentsScreen";

  @override
  _AgentsScreenState createState() => _AgentsScreenState();
}

class _AgentsScreenState extends State<AgentsScreen> {
  List<AgentModel>? _items;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late HelpBloc _helpBloc;
  ScrollController? _scrollController;
  static const offsetVisibleThreshold = 50.0;
  bool loading = false;

  @override
  void initState() {
    _helpBloc = BlocProvider.of<HelpBloc>(context);

    _helpBloc..add(FetchAgentEvent());

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
    return Scaffold(
        key: _scaffoldKey,
        appBar: RegularAppBar(label: "Our Agents"),
        body: RefreshIndicator(onRefresh: () async {
          if (_items != null) {
            _items!.clear();
            _items = null;
          }

          _helpBloc.page = 1;
          _helpBloc.add(FetchAgentEvent());
        }, child: BlocBuilder<HelpBloc, HelpState>(builder: (context, state) {
          if (state is HelpErrorState) {
            _items = [];
            SchedulerBinding.instance!.addPostFrameCallback((_) {
              displaySnackBar(title: state.error!, scaffoldKey: _scaffoldKey);
            });
          }
          if (state is AgentSuccessState) {
            if (_items == null) {
              _items = [];
              _items!.addAll(state.items!);
            }
          }

          return CustomScrollView(
              physics: BouncingScrollPhysics(),
              controller: _scrollController,
              slivers: [
                _items == null
                    ? LoadingSliver()
                    : _items!.length == 0
                        ? EmptyDataWidget(label: "agent is empty")
                        : SliverToBoxAdapter(
                            child: ListView.separated(
                                physics: BouncingScrollPhysics(),
                                // padding: EdgeInsets.symmetric(vertical: 16),
                                primary: false,
                                shrinkWrap: true,
                                itemCount: _items!.length,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (context, index) {
                                  return AgentWidget(
                                      model: _items![index],
                                      onTap: () => launchEmailSubmission(
                                          _items![index].email!));
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) =>
                                        Container(
                                            height: 6,
                                            color: Color(0xffeeeeee)))),
                SliverToBoxAdapter(child: SizedBox(height: 100)),
                SliverToBoxAdapter(
                    child: Container(
                        child: loading == true
                            ? Padding(
                                padding: EdgeInsets.symmetric(vertical: 40),
                                child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2)))
                            : SizedBox()))
              ]);
        })));
  }

  void launchEmailSubmission(String email) async {
    if (Platform.isAndroid) {
      final Uri params = Uri(scheme: 'mailto', path: email, queryParameters: {
        // 'subject': 'Default Subject',
        // 'body': 'Default body'
      });
      String url = params.toString();
      if (await canLaunch(url)) {
      } else {
        print('Could not launch $url');
      }
    } else if (Platform.isIOS) {
      String url = "message://$email";
      if (await canLaunch(url)) {
      } else {
        print('Could not launch $url');
      }
    }
  }
}
