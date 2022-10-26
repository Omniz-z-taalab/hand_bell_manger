import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hand_bill_manger/src/blocs/auth/auth_bloc.dart';
import 'package:hand_bill_manger/src/blocs/auth/auth_event.dart';
import 'package:hand_bill_manger/src/blocs/auth/auth_state.dart';
import 'package:hand_bill_manger/src/data/model/company.dart';
import 'package:hand_bill_manger/src/data/model/local/route_argument.dart';
import 'package:hand_bill_manger/src/data/model/plan_model.dart';
import 'package:hand_bill_manger/src/ui/component/custom/regular_app_bar.dart';
import 'package:hand_bill_manger/src/ui/component/widgets.dart';
import 'package:hand_bill_manger/src/ui/screens/auth/chose_plans/component/plan_widget.dart';
import 'package:hand_bill_manger/src/ui/screens/auth/login_screen.dart';

class ChosePlanScreen extends StatefulWidget {
  static const routeName = "/ChosePlanScreen";
  RouteArgument routeArgument;

  ChosePlanScreen({required this.routeArgument});

  @override
  _ChosePlanScreenState createState() => _ChosePlanScreenState();
}

class _ChosePlanScreenState extends State<ChosePlanScreen> {
  late AuthBloc _authBloc;
  List<PlanModel>? _items;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  late Company _company;

  @override
  void initState() {
    _company = widget.routeArgument.param;
    _authBloc = BlocProvider.of<AuthBloc>(context);
    // print("wwww ${_company.natureActivity}");
    _authBloc.add(FetchPlansEvent(natureOfActivity: _company.natureActivity!));
    // _company = BlocProvider.of<GlobalBloc>(context).company!;
    super.initState();
  }

  void _chosePlan(PlanModel model) {
    _authBloc.add(ChosePlansEvent(company: _company, id: model.id!));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        key: _scaffoldKey,
        appBar: RegularAppBar(label: "Chose Plans"),
        body: BlocListener<AuthBloc, AuthState>(
            listener: (BuildContext context, state) {
              if (state is AuthFailure) {
                setState(() {
                  _items = [];
                });
                displaySnackBar(title: state.error!, scaffoldKey: _scaffoldKey);
              }
              if (state is GetPlansSuccess) {
                if (_items == null) {
                  setState(() {
                    _items = [];
                    _items!.addAll(state.items);
                  });
                }
              }
              if (state is ChosePlansSuccess) {
                Fluttertoast.showToast(msg: state.message!);
                Navigator.pushReplacementNamed(context, LoginScreen.routeName);
              }
            },
            child: SingleChildScrollView(
                child: Column(children: [
              Container(
                  height: size.height - size.height * 0.11,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                        Color(0xfffc00ff),
                        Color(0xff00dbde),
                      ])),
                  child: CarouselSlider.builder(
                      itemCount: _items == null ? 6 : _items!.length,
                      itemBuilder: (BuildContext context, int index, int idx) {
                        if (_items != null) {
                          return PlanWidget(
                              model: _items![index],
                              onTap: () => _chosePlan(_items![index]));
                        }
                        return SizedBox();
                      },
                      options: CarouselOptions(
                          viewportFraction: 0.8,
                          // initialPage: 0,
                          enlargeCenterPage: true,
                          height: size.height * 0.7,
                          scrollDirection: Axis.horizontal,
                          // autoPlay: true,
                          enableInfiniteScroll: true,
                          autoPlayInterval: Duration(milliseconds: 4000),
                          autoPlayCurve: Curves.easeOutSine)))
            ]))));
  }
}
