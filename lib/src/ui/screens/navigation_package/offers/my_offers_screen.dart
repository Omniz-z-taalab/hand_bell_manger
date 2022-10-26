import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hand_bill_manger/src/blocs/global_bloc/global_bloc.dart';
import 'package:hand_bill_manger/src/blocs/offer/offers_bloc.dart';
import 'package:hand_bill_manger/src/blocs/offer/offers_event.dart';
import 'package:hand_bill_manger/src/blocs/offer/offers_state.dart';
import 'package:hand_bill_manger/src/common/constns.dart';
import 'package:hand_bill_manger/src/data/model/account_package/offer_model.dart';
import 'package:hand_bill_manger/src/data/model/company.dart';
import 'package:hand_bill_manger/src/ui/component/custom/login_first_widget_sliver.dart';
import 'package:hand_bill_manger/src/ui/component/custom/regular_app_bar.dart';
import 'package:hand_bill_manger/src/ui/component/custom/widgets.dart';
import 'package:hand_bill_manger/src/ui/component/widgets.dart';
import 'package:hand_bill_manger/src/ui/screens/navigation_package/offers/offers_add_screen.dart';

import 'component/offers_widget.dart';

class MyOffersScreen extends StatefulWidget {
  static const routeName = "/OffersScreen";

  @override
  _MyOffersScreenState createState() => _MyOffersScreenState();
}

class _MyOffersScreenState extends State<MyOffersScreen> {
  List<OfferModel>? _items;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late OffersBloc _offersBloc;
  ScrollController? _scrollController;
  static const offsetVisibleThreshold = 50.0;
  bool loading = false;
  late Company _company;
  int page = 1;
  int _itemsCount = 0, _maxItems = 0;

  @override
  void initState() {
    _company = BlocProvider.of<GlobalBloc>(context).company!;
    _maxItems = _company.plan!.numOffers!;
    _offersBloc = BlocProvider.of<OffersBloc>(context);
    _offersBloc.add(FetchMyOffersEvent(company: _company, page: page));
    _scrollController = ScrollController()..addListener(_onScroll);

    print("init page = $page -------------");
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

    if (offset >= max && !_offersBloc.isFetching) {
      setState(() {
        _offersBloc.isFetching = true;
      });
      _offersBloc.add(FetchMyOffersEvent(company: _company, page: page));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: RegularAppBar(
            label: "My Offers",
            widget: Text("$_itemsCount/$_maxItems",
                style: TextStyle(color: textDarkColor))),
        backgroundColor: Color(0xffeeeeee),
        floatingActionButton: FloatingActionButton(
            backgroundColor: mainColorLite,
            onPressed: () {
              if (_items == null) {
                displaySnackBar(
                    title: "loading", scaffoldKey: _scaffoldKey);
              } else if (_itemsCount >= _maxItems) {
                displaySnackBar(
                    title: "You have reach max, update your plan",
                    scaffoldKey: _scaffoldKey);
              } else {
                Navigator.pushNamed(context, OfferAddScreen.routeName);
              }
            },
            child: Icon(Icons.add)),
        body: RefreshIndicator(
            onRefresh: () async {
              if (_items != null) {
                _items!.clear();
                _items = null;
              }

              _offersBloc.page = 1;
              page = 1;
              _offersBloc
                  .add(FetchMyOffersEvent(company: _company, page: page));
            },
            child: BlocListener<OffersBloc, OffersState>(
                listener: (BuildContext context, state) {
                  if (state is OffersErrorState) {
                    setState(() => _items = []);
                    displaySnackBar(
                        title: state.error!, scaffoldKey: _scaffoldKey);
                  }
                  if (state is MyOffersSuccessState) {
                    setState(() {
                      _itemsCount = state.count;
                    });
                    if (_items == null) {
                      _items = [];
                    }
                    _items!.addAll(state.items!);
                    if (state.items!.isNotEmpty) {
                      page++;
                      // print("scroll page = $page -------------");
                    }
                  }
                  if (state is OfferRemoveSuccessState) {
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
                              ? EmptyDataWidget(label: "your offers is empty")
                              : SliverToBoxAdapter(
                                  child: ListView.separated(
                                      physics: BouncingScrollPhysics(),
                                      primary: false,
                                      shrinkWrap: true,
                                      itemCount: _items!.length,
                                      scrollDirection: Axis.vertical,
                                      itemBuilder: (context, index) {
                                        return OfferWidget(
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

  void _deleteItem(OfferModel model) {
    _offersBloc.add(OfferRemoveEvent(company: _company, model: model));
  }
}
