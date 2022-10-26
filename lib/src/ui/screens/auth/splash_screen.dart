import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hand_bill_manger/src/blocs/auth/auth_bloc.dart';
import 'package:hand_bill_manger/src/blocs/auth/auth_event.dart';
import 'package:hand_bill_manger/src/blocs/global_bloc/global_bloc.dart';
import 'package:hand_bill_manger/src/data/model/company.dart';
import 'package:hand_bill_manger/src/ui/screens/auth/login_screen.dart';
import 'package:hand_bill_manger/src/ui/screens/navigation_package/navigation_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>  with TickerProviderStateMixin {
  FirebaseMessaging _fcm = FirebaseMessaging.instance;
  AnimationController? _animationController;
  Animation<Offset>? _animation;
  late GlobalBloc _globalBloc;

  @override
  void initState() {
    _globalBloc = BlocProvider.of<GlobalBloc>(context);
    _fcm.requestPermission(sound: true, badge: true, alert: true);
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    _animation = Tween<Offset>(begin: Offset(0.0, 0.9), end: Offset.zero,)
        .animate(_animationController!);
    _animationController?.forward().whenComplete(() {
      // when animation completes, put your code here
    });
    // try{
    //   if(firebaseMessagingBackgroundHandler!=null)
    //     FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    // }catch(e){print(e);}
    super.initState();
  }

  late Company _company;
  late AuthBloc _authBloc;
  @override
  void didChangeDependencies() {
    _globalBloc = BlocProvider.of<GlobalBloc>(context);
    _authBloc = BlocProvider.of<AuthBloc>(context);
    _globalBloc.add(StartAppEvent());
    if(_globalBloc.company!=null){
      _company = _globalBloc.company!;
      if(_company.natureActivity!=null)_authBloc.add(FetchPlansEvent(natureOfActivity: _company.natureActivity!));
    }
    Timer(Duration(seconds: 4), (){
      if (_globalBloc.company==null||_globalBloc.company!.active == null ||
          _globalBloc.company!.active == false) {
        Navigator.pushReplacementNamed(context, LoginScreen.routeName);
      } else {
        Navigator.pushReplacementNamed(context, NavigationScreen.routeName);
      }
    });
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
          child: Stack(
            alignment: Alignment.center,
            fit: StackFit.loose,
            children: [
              Positioned(
                top: height*0.2,
                left: width*0.1,
                child: SlideTransition(
                  position: _animation!,
                  child: AnimatedContainer(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.topLeft,
                    duration: Duration(seconds: 0),
                    child: Image(
                      height: height*0.2+20,
                      width: width*0.8+10,
                      fit: BoxFit.contain,
                      image: AssetImage('assets/images/hb_logo.jpeg'),
                    ),
                  ),
                ),),
              // Align(
              //   alignment: Alignment.center,
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.center,
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       SizedBox(
              //         width: width*0.6,
              //         child: TextLiquidFill(
              //           text: 'Game Station',
              //           waveColor: appColor,
              //           waveDuration: Duration(seconds: 2),
              //           boxBackgroundColor: Colors.white,
              //           textStyle: TextStyle(
              //               fontSize: width*0.07+2,
              //               fontWeight: FontWeight.bold,
              //               color: colorWhite
              //           ),
              //           boxHeight: height*0.09,
              //         ),
              //       ),
              //       SizedBox(height: height*0.03,),
              //       Container(
              //         width: width*0.6,
              //         alignment: Alignment.center,
              //         child: DefaultTextStyle(
              //           style: const TextStyle(
              //             fontSize: 16.0,
              //             color: Colors.white,
              //             fontWeight: FontWeight.bold,
              //           ),
              //           child: AnimatedTextKit(
              //             animatedTexts: [
              //               WavyAnimatedText('Never Play Alone'),
              //             ],
              //             isRepeatingAnimation: false,
              //             onTap: () {
              //               print("Tap Event");
              //             },
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          )
      ),
    );
  }
  Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    try {
      print("${message.toString()}");
    } catch (e) {
      print(e);
    }
  }
}
