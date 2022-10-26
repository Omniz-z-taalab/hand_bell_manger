import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:hand_bill_manger/src/blocs/ads/ads_bloc.dart';
import 'package:hand_bill_manger/src/blocs/assets/assets_bloc.dart';
import 'package:hand_bill_manger/src/blocs/auction/aucations_bloc.dart';
import 'package:hand_bill_manger/src/blocs/auth/auth_bloc.dart';
import 'package:hand_bill_manger/src/blocs/global_bloc/global_bloc.dart';
import 'package:hand_bill_manger/src/blocs/help/help_bloc.dart';
import 'package:hand_bill_manger/src/blocs/job/job_bloc.dart';
import 'package:hand_bill_manger/src/blocs/offer/offers_bloc.dart';
import 'package:hand_bill_manger/src/blocs/products/products_bloc.dart';
import 'package:hand_bill_manger/src/blocs/profile/profile_bloc.dart';
import 'package:hand_bill_manger/src/common/routes.dart';
import 'package:hand_bill_manger/src/helper/helpers.dart';
import 'package:hand_bill_manger/src/repositories/global_repository.dart';
import 'package:hand_bill_manger/src/ui/screens/auth/splash_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations(
  //     [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  var delegate = await LocalizationDelegate.create(
      fallbackLocale: 'en_US', supportedLocales: ['en_US', 'ar']);
  await Firebase.initializeApp();
  runApp(ScreenUtilInit(
    designSize: Size(898.21, 1917.27),
    builder: (context, child) => MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => GlobalBloc()..add(StartAppEvent())),
        BlocProvider(create: (context) => JobsBloc(context: context)),
        BlocProvider(create: (context) => AuctionsBloc(context: context)),
        BlocProvider(create: (context) => OffersBloc(context: context)),
        BlocProvider(create: (context) => ProductsBloc(context: context)),
        // BlocProvider(create: (context) => ChatBloc()),
        BlocProvider(create: (context) => AssetsBloc(context: context)),
        BlocProvider(create: (context) => AuthBloc(context: context)),
        BlocProvider(create: (context) => AdsBloc(context: context)),
        BlocProvider(create: (context) => HelpBloc(context: context)),
        BlocProvider(create: (context) => ProfileBloc(context: context))
      ],
      child: LocalizedApp(delegate, MyApp()),
    ),
  ));
}

class MyApp extends StatelessWidget {
  final GlobalRepository _globalRepository = GlobalRepository();

  @override
  Widget build(BuildContext context) {
    Helper.chaneStatusBarColor(
        statusBarColor: Colors.white, brightness: Brightness.dark);
    // Helper.chaneStatusBarColor(
    //     statusBarColor: mainColorLite, brightness: Brightness.light);
    var localizationDelegate = LocalizedApp.of(context).delegate;

    return BlocBuilder<GlobalBloc, GlobalState>(
        builder: (BuildContext context, state) {
      return LocalizationProvider(
        state: LocalizationProvider.of(context).state,
        child: MaterialApp(
            title: 'Handbill Manger',
            debugShowCheckedModeBanner: false,
            theme: _globalRepository.liteTheme,
            themeMode: ThemeMode.light,
            supportedLocales: [
              const Locale('en'),
              const Locale('ar'),
              const Locale('es'),
              const Locale('de'),
              const Locale('fr'),
              const Locale('el'),
              const Locale('et'),
              const Locale('nb'),
              const Locale('nn'),
              const Locale('pl'),
              const Locale('pt'),
              const Locale('ru'),
              const Locale('hi'),
              const Locale('ne'),
              const Locale('uk'),
              const Locale('hr'),
              const Locale('tr'),
              const Locale('lv'),
              const Locale('lt'),
              const Locale('ku'),
              const Locale.fromSubtags(
                  languageCode: 'zh',
                  scriptCode: 'Hans'), // Generic Simplified Chinese 'zh_Hans'
              const Locale.fromSubtags(
                  languageCode: 'zh',
                  scriptCode: 'Hant'), // Generic traditional Chinese 'zh_Hant'
            ],
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              localizationDelegate
            ],
            // supportedLocales: localizationDelegate.supportedLocales,
            locale: localizationDelegate.currentLocale,
            home: SplashScreen(),
            // home: ServicesCompanyDetailsScreen(routeArgument: RouteArgument(param: 1),),
            onGenerateRoute: RouteGenerator.generateRoute),
      );
      // return MaterialApp(
      //     title: 'Handbill Manger',
      //     debugShowCheckedModeBanner: false,
      //     theme: _globalRepository.liteTheme,
      //     // darkTheme: _globalRepository.liteTheme,
      //     themeMode: ThemeMode.light,
      //     home: SplashScreen(),
      //     // home: AgentsScreen(),
      //     onGenerateRoute: RouteGenerator.generateRoute);
    });
  }
}
