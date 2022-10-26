import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hand_bill_manger/src/blocs/global_bloc/global_bloc.dart';
import 'package:hand_bill_manger/src/blocs/job/job_bloc.dart';
import 'package:hand_bill_manger/src/blocs/job/job_event.dart';
import 'package:hand_bill_manger/src/blocs/job/job_state.dart';
import 'package:hand_bill_manger/src/common/constns.dart';
import 'package:hand_bill_manger/src/data/model/account_package/job_company_model.dart';
import 'package:hand_bill_manger/src/data/model/company.dart';
import 'package:hand_bill_manger/src/ui/component/custom/login_first_widget_sliver.dart';
import 'package:hand_bill_manger/src/ui/component/custom/regular_app_bar.dart';
import 'package:hand_bill_manger/src/ui/component/custom/widgets.dart';
import 'package:hand_bill_manger/src/ui/component/widgets.dart';

import 'component/jobs_company_widget.dart';
import 'jobs_add_screen.dart';

class MyJobsScreen extends StatefulWidget {
  static const routeName = "/MyJobsScreen";

  @override
  _MyJobsScreenState createState() => _MyJobsScreenState();
}

class _MyJobsScreenState extends State<MyJobsScreen> {
  List<JobCompanyModel>? _items;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late JobsBloc _jobsBloc;
  late Company? _company;
  ScrollController? _scrollController;
  static const offsetVisibleThreshold = 50.0;
  bool loading = false;
  double iconSize = 24;

  int _itemsCount = 0, _maxItems = 0;

  @override
  void initState() {
    _jobsBloc = BlocProvider.of<JobsBloc>(context);
    _scrollController = ScrollController()..addListener(_onScroll);
    _company = BlocProvider.of<GlobalBloc>(context).company;
    _maxItems = _company!.plan!.numJobs!;
    _jobsBloc.myPage = 1;
    _jobsBloc.add(FetchMyJobsEvent(company: _company!));
    super.initState();
  }

  @override
  void dispose() {
    _scrollController!.dispose();
    super.dispose();
  }

  void _onScroll() {
    final max = _scrollController!.position.maxScrollExtent;
    final offset = _scrollController!.offset;

    if (offset + offsetVisibleThreshold >= max && !_jobsBloc.isFetching) {
      setState(() {
        _jobsBloc.isFetching = true;
      });
      _jobsBloc.add(FetchMyJobsEvent(company: _company!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Color(0xfff5f5f5),
        appBar: RegularAppBar(
          label: "My Jobs",
          widget: Text("$_itemsCount/$_maxItems",
              style: TextStyle(color: textDarkColor)),
        ),
        floatingActionButton: FloatingActionButton(
            backgroundColor: mainColorLite,
            onPressed: () {
              if (_itemsCount < _maxItems) {
                Navigator.pushNamed(context, JobAddScreen.routeName);
              } else {
                SchedulerBinding.instance!.addPostFrameCallback((_) {
                  displaySnackBar(
                      title: "You have reach max, update your plan",
                      scaffoldKey: _scaffoldKey);
                });
              }
            },
            child: Icon(Icons.add)),
        body: RefreshIndicator(
            onRefresh: () async {
              if (_items != null) {
                // _items!.clear();
                // _items = null;
              }
              if (_company != null) {
                _jobsBloc.myPage = 1;
                _jobsBloc.add(FetchMyJobsEvent(company: _company!));
              }
            },
            child: BlocListener<JobsBloc, JobsState>(
                listener: (BuildContext context, state) {
                  if (state is JobErrorState) {
                    _items = [];
                    SchedulerBinding.instance!.addPostFrameCallback((_) {
                      displaySnackBar(
                          title: state.error!, scaffoldKey: _scaffoldKey);
                    });
                  }
                  if (state is MyJobSuccessState) {
                    setState(() => _itemsCount = state.count);

                    if (_items == null) {
                      _items = [];
                      _items!.addAll(state.items!);
                    } else {
                      _items!.addAll(state.items!);
                    }
                  }
                  if (state is JobRemoveSuccessState) {
                    setState(() {
                      _items!.removeWhere(
                          (element) => element.id == state.model.id);
                    });
                    displaySnackBar(
                        title: state.message!, scaffoldKey: _scaffoldKey);
                  }
                },
                child: CustomScrollView(
                    physics: BouncingScrollPhysics(),
                    controller: _scrollController,
                    slivers: [
                      _items == null
                          ? LoadingSliver()
                          : _items!.length == 0
                              ? EmptyDataWidget(label: "Jobs is empty")
                              : SliverToBoxAdapter(
                                  child: ListView.separated(
                                      physics: BouncingScrollPhysics(),
                                      primary: false,
                                      shrinkWrap: true,
                                      itemCount: _items!.length,
                                      scrollDirection: Axis.vertical,
                                      itemBuilder: (context, index) {
                                        return JobCompanyWidget(
                                            model: _items![index],
                                            onRemoveTap: () =>
                                                _deleteItem(_items![index]));
                                      },
                                      separatorBuilder:
                                          (BuildContext context, int index) =>
                                              Container(
                                                  height: 10,
                                                  color: Color(0xffeeeeee)))),
                      SliverToBoxAdapter(child: SizedBox(height: 100)),
                      SliverToBoxAdapter(
                          child: Container(
                              child: loading == true
                                  ? Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 40),
                                      child: Align(
                                          alignment: Alignment.bottomCenter,
                                          child: CircularProgressIndicator(
                                              strokeWidth: 2)))
                                  : SizedBox()))
                    ]))));
  }

  void _deleteItem(JobCompanyModel model) {
    _jobsBloc.add(JobRemoveEvent(company: _company!, model: model));
  }
}
