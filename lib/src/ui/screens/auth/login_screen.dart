import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hand_bill_manger/src/blocs/auth/auth_bloc.dart';
import 'package:hand_bill_manger/src/blocs/auth/auth_event.dart';
import 'package:hand_bill_manger/src/blocs/auth/auth_state.dart';
import 'package:hand_bill_manger/src/common/constns.dart';
import 'package:hand_bill_manger/src/data/model/local/route_argument.dart';
import 'package:hand_bill_manger/src/ui/component/custom/custom_button.dart';
import 'package:hand_bill_manger/src/ui/component/custom/custom_text_filed.dart';
import 'package:hand_bill_manger/src/ui/component/widgets.dart';
import 'package:hand_bill_manger/src/ui/screens/auth/forget_password_screen.dart';
import 'package:hand_bill_manger/src/ui/screens/auth/register_screen.dart';
import 'package:hand_bill_manger/src/ui/screens/auth/splash_screen.dart';
import 'package:hand_bill_manger/src/ui/screens/auth/verification_screen.dart';
import 'chose_plans/chose_plan_screen.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = "/loginScreen";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  bool  loading = false;
  double marginVer = 24;

  @override
  void initState() {
    // _emailController.text = "himahamed1@gmail.com";
    // _passwordController.text = "123456";
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _onLoginButtonPressed() {
      if (_key.currentState!.validate()) {
        BlocProvider.of<AuthBloc>(context).add(LoginEvent(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim()));
      }
    }
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        body: BlocListener<AuthBloc, AuthState>(
            listener: (BuildContext context, state) {
              if (state is AuthLoading) {
                setState(() => loading = true);
              }
              if (state is AuthFailure) {
                displaySnackBar(
                    scaffoldKey: _scaffoldKey, title: state.error ?? "error");
                setState(() => loading = false);
              }
              if (state is LoginSuccess) {
                setState(() => loading = false);
                if (state.company!.isVerified == true) {
                  if (state.company!.active == true &&
                      state.company!.plan != null) {
                    // Navigator.pushNamedAndRemoveUntil(context,
                    //     NavigationScreen.routeName, ModalRoute.withName('/'));
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context)=> SplashScreen()),
                            (Route<dynamic> route) => false);
                  } else if (state.company!.plan == null) {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context)=> SplashScreen()),
                            (Route<dynamic> route) => false);
                    // Navigator.pushReplacementNamed(
                    //     context, ChosePlanScreen.routeName,
                    //     arguments: RouteArgument(param: state.company));
                  } else {
                    Fluttertoast.showToast(msg: "Waiting agent");
                  }
                } else if (state.company!.isVerified == false) {
                  Navigator.pushReplacementNamed(
                      context, VerificationScreen.routeName,
                      arguments: RouteArgument(param: state.company!.email));
                }
              }
            },
            child: CustomScrollView(physics: BouncingScrollPhysics(), slivers: [
              SliverFillRemaining(
                  child: ListView(children: [
                Container(
                    width: double.infinity,
                    height: size.height * 0.35,
                    child: Transform.scale(
                        scale: 0.5,
                        child: Image.asset("assets/images/hb_logo.jpeg"))),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Form(
                        key: _key,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(children: [
                                Expanded(
                                    child: CustomTextFormField(
                                        hintText: "email",
                                        icon: Icons.alternate_email,
                                        controller: _emailController,
                                        validator: (input) {
                                          if (!input.toString().contains('@')) {
                                            return "enter valid email";
                                          }
                                          return null;
                                        }))
                              ]),
                              SizedBox(height: marginVer),
                              Row(children: [
                                Expanded(
                                    child: CustomTextFormField(
                                        hintText: "password",
                                        icon: Icons.lock_outline_rounded,
                                        controller: _passwordController,
                                        isPassword: true,
                                        validator: (input) =>
                                            input.toString().isEmpty
                                                ? "enter password"
                                                : null))
                              ]),
                              SizedBox(height: marginVer),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CustomButton(
                                        title: "Login",
                                        width: size.width * 0.7,
                                        radius: 900,
                                        onPress: () {
                                          _onLoginButtonPressed();
                                        }),
                                  ]),
                              SizedBox(height: marginVer),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    InkWell(
                                        onTap: () => Navigator.pushNamed(
                                            context,
                                            ForgetPasswordScreen.routeName),
                                        child: Text("Forget password ?",
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: textDarkColor)))
                                  ]),
                            ]))),
                loading == false
                    ? SizedBox()
                    : Container(
                        height: 100,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(height: marginVer),
                              CircularProgressIndicator(
                                  color: Theme.of(context).accentColor,
                                  strokeWidth: 2)
                            ])),
              ]))
            ])),
        bottomNavigationBar: Column(
            mainAxisSize: MainAxisSize.min, children: [
          InkWell(
              onTap: () => Navigator.pushReplacementNamed(
                  context, RegisterScreen.routeName),
              child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  margin: const EdgeInsets.only(bottom: 50),
                  decoration: const BoxDecoration(
                      color: Color(0xfffafafa),
                      border: Border.symmetric(
                          horizontal: BorderSide(color: Color(0xfff5f5f5)))),
                  child: Center(
                      child: Text("don`t have account create new",
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.normal,
                              color: Colors.black)))))
        ]));
  }
}
