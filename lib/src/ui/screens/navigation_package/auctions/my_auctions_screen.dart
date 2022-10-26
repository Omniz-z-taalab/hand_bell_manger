import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hand_bill_manger/src/blocs/auction/aucations_bloc.dart';
import 'package:hand_bill_manger/src/blocs/auction/aucations_event.dart';
import 'package:hand_bill_manger/src/blocs/auction/aucations_state.dart';
import 'package:hand_bill_manger/src/blocs/global_bloc/global_bloc.dart';
import 'package:hand_bill_manger/src/common/constns.dart';
import 'package:hand_bill_manger/src/data/model/account_package/auction_model.dart';
import 'package:hand_bill_manger/src/data/model/company.dart';
import 'package:hand_bill_manger/src/ui/component/custom/login_first_widget_sliver.dart';
import 'package:hand_bill_manger/src/ui/component/custom/regular_app_bar.dart';
import 'package:hand_bill_manger/src/ui/component/widgets.dart';
import 'package:hand_bill_manger/src/ui/screens/navigation_package/auctions/auction_add_edit_screen.dart';

import 'component/auction_empty_widget.dart';
import 'component/auctions_widget.dart';

class MyAuctionsScreen extends StatefulWidget {
  static const routeName = "/AuctionsScreen";

  @override
  _MyAuctionsScreenState createState() => _MyAuctionsScreenState();
}

class _MyAuctionsScreenState extends State<MyAuctionsScreen> {
  List<AuctionModel>? _items;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late AuctionsBloc _auctionsBloc;
  ScrollController? _scrollController;
  static const offsetVisibleThreshold = 50.0;
  bool loading = false;
  late Company _company;

  @override
  void initState() {
    _company = BlocProvider.of<GlobalBloc>(context).company!;

    _auctionsBloc = BlocProvider.of<AuctionsBloc>(context);
    _scrollController = ScrollController()..addListener(_onScroll);
    _auctionsBloc.page = 1;
    _auctionsBloc.add(FetchMyAuctionsEvent(company: _company));

    super.initState();
  }

  @override
  void dispose() {
    _scrollController!.dispose();
    // _items = null;
    super.dispose();
  }

  void _onScroll() {
    final max = _scrollController!.position.maxScrollExtent;
    final offset = _scrollController!.offset;

    if (offset + offsetVisibleThreshold >= max && !_auctionsBloc.isFetching) {
      setState(() {
        _auctionsBloc.isFetching = true;
      });
      _auctionsBloc.add(FetchMyAuctionsEvent(company: _company));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: RegularAppBar(label: "My Auctions"),
        backgroundColor: Color(0xffeeeeee),
        floatingActionButton: FloatingActionButton(
            backgroundColor: mainColorLite,
            onPressed: () =>
                Navigator.pushNamed(context, AuctionAddEditScreen.routeName),
            child: Icon(Icons.add)),
        body: RefreshIndicator(
            onRefresh: () async {
              if (_items != null) {
                _items!.clear();
                _items = null;
              }

              _auctionsBloc.page = 1;
              _auctionsBloc.add(FetchMyAuctionsEvent(company: _company));
            },
            child: BlocListener<AuctionsBloc, AuctionsState>(
                listener: (BuildContext context, state) {
                  if (state is AuctionsErrorState) {
                    _items = [];

                    displaySnackBar(
                        title: state.error!, scaffoldKey: _scaffoldKey);
                  }
                  if (state is MyAuctionsSuccessState) {
                    if (_items == null) {
                      _items = [];
                    }
                    setState(() {
                      _items!.addAll(state.items!);
                    });
                  }

                  if (state is AuctionRemoveSuccessState) {
                    if (_items != null) {
                      setState(() {
                        _items!.removeWhere(
                            (element) => element.id == state.model.id);
                      });
                    }

                    displaySnackBar(
                        title: state.message!, scaffoldKey: _scaffoldKey);
                  }
                },
                child: CustomScrollView(
                    physics: BouncingScrollPhysics(),
                    controller: _scrollController,
                    slivers: [
                      _items == null
                          ? SliverToBoxAdapter(
                              child: ListView.separated(
                                  physics: BouncingScrollPhysics(),
                                  primary: false,
                                  shrinkWrap: true,
                                  itemCount: 3,
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (context, index) =>
                                      AuctionEmptyWidget(),
                                  separatorBuilder:
                                      (BuildContext context, int index) =>
                                          Container(
                                              height: 10,
                                              color: Color(0xffeeeeee))))
                          : _items!.length == 0
                              ? EmptyDataWidget(label: "Your Auction is empty")
                              : SliverToBoxAdapter(
                                  child: ListView.separated(
                                      physics: BouncingScrollPhysics(),
                                      primary: false,
                                      shrinkWrap: true,
                                      itemCount: _items!.length,
                                      scrollDirection: Axis.vertical,
                                      itemBuilder: (context, index) {
                                        return AuctionWidget(
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

  void _deleteItem(AuctionModel model) {
    _auctionsBloc.add(AuctionRemoveEvent(company: _company, model: model));
  }

}
