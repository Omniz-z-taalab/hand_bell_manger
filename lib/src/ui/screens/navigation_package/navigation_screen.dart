import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hand_bill_manger/src/blocs/auth/auth_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hand_bill_manger/src/blocs/auth/auth_event.dart';
import 'package:hand_bill_manger/src/blocs/global_bloc/global_bloc.dart';
import 'package:hand_bill_manger/src/blocs/profile/profile_bloc.dart';
import 'package:hand_bill_manger/src/blocs/profile/profile_event.dart';
import 'package:hand_bill_manger/src/common/api_data.dart';
import 'package:hand_bill_manger/src/common/constns.dart';
import 'package:hand_bill_manger/src/common/global.dart';
import 'package:hand_bill_manger/src/data/model/company.dart';
import 'package:hand_bill_manger/src/data/model/local/drawer_model.dart';
import 'package:hand_bill_manger/src/ui/component/custom/my_app_bar.dart';
import 'package:hand_bill_manger/src/ui/component/custom_dialogs.dart';
import 'package:hand_bill_manger/src/ui/component/items/drawer_item_widget.dart';
import 'package:hand_bill_manger/src/ui/screens/auth/auth_screen.dart';
import 'package:hand_bill_manger/src/ui/screens/navigation_package/agent/agents_screen.dart';
import 'package:hand_bill_manger/src/ui/screens/navigation_package/asstes/my_assets_screen.dart';
import 'package:hand_bill_manger/src/ui/screens/navigation_package/finance/finance_screen.dart';
import 'package:hand_bill_manger/src/ui/screens/navigation_package/sponsored/sponsord_screen.dart';
import 'auctions/my_auctions_screen.dart';
import 'edit_account_screen.dart';
import 'help/help_center_screen.dart';
import 'jobs/users_jobs_screen.dart';
import 'my_products/products_screen.dart';
import 'offers/my_offers_screen.dart';

class NavigationScreen extends StatefulWidget {
  static const routeName = "/NavigationScreen";
  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  double imgSize = 90, marginTop = 8, icSize = 40;
  late Company _company;
  List<DrawerModel> _items = [];
  late String _avatar = placeholder_concat;
  late GlobalBloc _globalBloc;
  late AuthBloc _authBloc;
  late ProfileBloc _profileBloc;

  @override
  void initState() {
    _company = BlocProvider.of<GlobalBloc>(context).company!;
    _profileBloc = BlocProvider.of<ProfileBloc>(context);
    _authBloc = BlocProvider.of<AuthBloc>(context);
    _authBloc.add(FetchPlansEvent(natureOfActivity: _company.natureActivity!));
    // _company.natureActivity = "shipping";
    // _items.add(DrawerModel(
    //     title: "Chats",
    //     icon: "assets/icons/account/chat.svg",
    //     onTap: () =>Navigator.pushNamed(context, ChatsScreen.routeName)));
    _items.add(DrawerModel(
        title: "Finance",
        icon: "assets/icons/account/asset.svg",
        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context)=>FinanceScreen()))));
    _items.add(DrawerModel(
        title: "Jobs",
        icon: "assets/icons/account/briefcase.svg",
        onTap: () => Navigator.pushNamed(context, UsersJobsScreen.routeName)));
    if (_company.natureActivity == "Supplier") {
      _items.add(DrawerModel(
          title: "My Products",
          icon: "assets/icons/account/online_shop.svg",
          onTap: () => Navigator.pushNamed(context, MyProductsScreen.routeName)));
      _items.add(DrawerModel(
          title: "My Auctions",
          icon: "assets/icons/account/auction.svg",
          onTap: () => Navigator.pushNamed(context, MyAuctionsScreen.routeName)));
      _items.add(DrawerModel(
          title: "My Offers",
          icon: "assets/icons/account/sale.svg",
          onTap: () => Navigator.pushNamed(context, MyOffersScreen.routeName)));
      _items.add(DrawerModel(
          title: "My Assets",
          icon: "assets/icons/account/buy.svg",
          onTap: () => Navigator.pushNamed(context, MyAssetsScreen.routeName)));
    } else if (_company.natureActivity == "shipping") {}
    _items.add(DrawerModel(
        title: "Sponsored Ad",
        icon: "assets/icons/account/ads.svg",
        onTap: () => Navigator.of(context).pushNamed(SponsoredScreen.routeName)));
    _items.add(DrawerModel(
        title: "Help center",
        icon: "assets/icons/help.png",
        onTap: () => Navigator.of(context).pushNamed(HelpCenterScreen.routeName)));
    _items.add(DrawerModel(
        title: "Agents",
        icon: "assets/icons/account/call_center.svg",
        onTap: () => Navigator.of(context).pushNamed(AgentsScreen.routeName)));
    _items.add(DrawerModel(
        title: "Logout",
        icon: "assets/icons/account/exit.svg",
        onTap: () {
          // AuthRepository _a =AuthRepository();
          // _a.removeCurrentUser();
          storage.deleteAll();
          Navigator.pushReplacementNamed(context, AuthScreen.routeName);
        }));
    if(_profileBloc.refreshHomePage==true){
      Timer(Duration(seconds: 4), (){
        setState(() {
          _profileBloc.refreshHomePage = false;
        });
      });
    }
    super.initState();
  }


  @override
  void didChangeDependencies() {
    _globalBloc = BlocProvider.of<GlobalBloc>(context);
    _company = BlocProvider.of<GlobalBloc>(context).company!;
    _authBloc = BlocProvider.of<AuthBloc>(context);
    _profileBloc = BlocProvider.of<ProfileBloc>(context);
    _authBloc.add(FetchPlansEvent(natureOfActivity: _company.natureActivity!));
    _profileBloc.add(FetchProfileEvent(company: _company));
    if (_globalBloc.company!.logo != null) {
      _avatar = APIData.domainLink + _globalBloc.company!.logo!.url!;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: MyAppBar(),
        // backgroundColor: Color(0xffeeeeee),
        backgroundColor: Color(0xfff5f5f5),
        body: RefreshIndicator(
            onRefresh: () async {
              if (_globalBloc.company!.logo != null) {
                setState(() {
                  _avatar = APIData.domainLink + _globalBloc.company!.logo!.url!;
                });
              }
            },
            child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                          height: size.height * 0.12,
                          margin: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 8),
                          child: Row(
                              children: [
                                AspectRatio(
                                    aspectRatio: 1 / 1,
                                    child: Card(
                                        clipBehavior: Clip.hardEdge,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(900)),
                                        child: CachedNetworkImage(
                                            imageUrl: _avatar,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) =>
                                                Transform.scale(
                                                    scale: 0.4,
                                                    child:
                                                    CircularProgressIndicator(
                                                        color:
                                                        mainColorLite)),
                                            errorWidget: (context, url,
                                                error) =>
                                            new Icon(Icons.error,
                                                color: mainColorLite)))),
                                SizedBox(width: 10),
                                Expanded(
                                    child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                              padding: EdgeInsets.only(right: 60),
                                              child: RichText(
                                                  text: TextSpan(
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14,
                                                          fontWeight:
                                                          FontWeight.w500),
                                                      children: [
                                                        TextSpan(text: _company.name),
                                                      ]))),
                                          SizedBox(height: 4),
                                          InkWell(
                                              onTap: (){
                                                Navigator.pushNamed(
                                                    context, EditAccountScreen.routeName);
                                              },
                                              child: Row(children: [
                                                Text("Company information",
                                                    style: TextStyle(
                                                      // fontSize: 13,
                                                        color: textLiteColor)),
                                                Icon(Icons.keyboard_arrow_right,
                                                    color: iconColors, size: 18),
                                              ])),

                                          if(_authBloc.planModel!=null)...[
                                            SizedBox(height: 10,),
                                            GestureDetector(
                                              onTap: (){
                                                CustomDialogs.planDetailsDialog(context,_globalBloc.company!.plan!,"${_company.expirationDate}");
                                              },
                                              child: Row(
                                                children: [
                                                  RichText(
                                                    text: TextSpan(
                                                        children: [
                                                          TextSpan(text: "Plan: ",style: TextStyle(color: Colors.black38,fontSize: 30.sp)),
                                                          TextSpan(text: "${_globalBloc.company!.plan!.name}",style: TextStyle(color: Colors.blue)),
                                                        ]),
                                                  ),
                                                  SizedBox(width: 5,),
                                                  Tooltip(
                                                    preferBelow: false,
                                                    message: "Plan details",
                                                    child: Icon(Icons.info,color: Colors.blue.withOpacity(0.8),
                                                      size: 19,),
                                                  ),
                                                ],
                                              ),
                                            ),

                                          ],
                                        ])),
                              ])),

                      // SizedBox(height: 8),
                      _company.active!=null&&
                          _company.active == true?
                      GridView.count(
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 16),
                            childAspectRatio: 1 / 0.55,
                            crossAxisCount: 2,
                            crossAxisSpacing: 2,
                            mainAxisSpacing: 2,
                            shrinkWrap: true,
                            primary: false,
                            children: List.generate(_items.length, (index) {
                              return DrawerItemWidget(model: _items[index]);
                            })):
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          DrawerItemWidget(
                              model:DrawerModel(
                                  title: "Help center",
                                  icon: "assets/icons/help.png",
                                  onTap: () => Navigator.of(context).pushNamed(HelpCenterScreen.routeName))),
                          Divider(thickness: 1,),
                          SizedBox(height: 20,),
                          Text("Your not active now please contact with support",
                           style: TextStyle(fontSize: 12,color: Colors.black38),),
                        ],
                      ),

                      SizedBox(height: 80),
                    ]),
            )),
    );
  }
}
