import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hand_bill_manger/src/blocs/ads/ads_bloc.dart';
import 'package:hand_bill_manger/src/blocs/ads/ads_event.dart';
import 'package:hand_bill_manger/src/blocs/ads/ads_state.dart';
import 'package:hand_bill_manger/src/blocs/global_bloc/global_bloc.dart';
import 'package:hand_bill_manger/src/data/model/account_package/ad_model.dart';
import 'package:hand_bill_manger/src/data/model/company.dart';
import 'package:hand_bill_manger/src/ui/component/custom/login_first_widget_sliver.dart';
import 'package:hand_bill_manger/src/ui/component/custom/regular_app_bar.dart';
import 'package:hand_bill_manger/src/ui/component/custom/widgets.dart';
import 'package:hand_bill_manger/src/ui/component/widgets.dart';
import 'package:hand_bill_manger/src/ui/screens/navigation_package/sponsored/component/ad_widget.dart';

class MyAds extends StatefulWidget {
  static const routeName = "/MyAds";

  @override
  _MyAdsState createState() => _MyAdsState();
}

class _MyAdsState extends State<MyAds> {
  List<AdsModel>? _items;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late AdsBloc _adsBloc;
  ScrollController? _scrollController;
  static const offsetVisibleThreshold = 50.0;
  bool loading = false;
  late Company _company;

  @override
  void initState() {
    _company = BlocProvider.of<GlobalBloc>(context).company!;
    _adsBloc = BlocProvider.of<AdsBloc>(context);
    _adsBloc.page = 1;
    _adsBloc.add(FetchMyAdsEvent(company: _company));
    _scrollController = ScrollController()..addListener(_onScroll);
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

    if (offset + offsetVisibleThreshold >= max && !_adsBloc.isFetching) {
      setState(() {
        _adsBloc.isFetching = true;
      });
      _adsBloc.add(FetchMyAdsEvent(company: _company));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: RegularAppBar(label: "My Ads"),
        backgroundColor: Color(0xffeeeeee),
        body: RefreshIndicator(onRefresh: () async {
          if (_items != null) {
            // _items!.clear();
            // _items = null;
          }

          _adsBloc.page = 1;
          _adsBloc.add(FetchMyAdsEvent(company: _company));
        }, child: BlocBuilder<AdsBloc, AdsState>(builder: (context, state) {
          if (state is AdsErrorState) {
            _items = [];
            SchedulerBinding.instance!.addPostFrameCallback((_) {
              displaySnackBar(title: state.error!, scaffoldKey: _scaffoldKey);
            });
          }

          if (state is MyAdsSuccessState) {
            if (_items == null) {
              _items = [];
              _items!.addAll(state.items!);
            } else {
              _items!.addAll(state.items!);
            }
          }
          if (state is AdsRemoveSuccessState) {
            if (_items != null) {
              _items!.removeWhere((element) => element.id == state.id);
            }
            SchedulerBinding.instance!.addPostFrameCallback((_) {
              displaySnackBar(title: state.message!, scaffoldKey: _scaffoldKey);
            });
          }

          return CustomScrollView(
              physics: BouncingScrollPhysics(),
              controller: _scrollController,
              slivers: [
                _items == null
                    ? LoadingSliver()
                    : _items!.length == 0
                        ? EmptyDataWidget(label: "ads is empty")
                        : SliverToBoxAdapter(
                            child: ListView.separated(
                                physics: BouncingScrollPhysics(),
                                primary: false,
                                shrinkWrap: true,
                                itemCount: _items!.length,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (context, index) {
                                  return AdWidget(
                                      model: _items![index],
                                      onRemoveTap: () =>
                                          _deleteItem(_items![index].id!));
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
                                padding: EdgeInsets.symmetric(vertical: 40),
                                child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2)))
                            : SizedBox()))
              ]);
        })));
  }

  void _deleteItem(int id) {
    _adsBloc.add(AdsRemoveEvent(company: _company, id: id));
  }
}
