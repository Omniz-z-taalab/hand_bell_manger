import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hand_bill_manger/src/data/model/local/route_argument.dart';
import 'package:hand_bill_manger/src/ui/component/custom/custom_page_route.dart';
import 'package:hand_bill_manger/src/ui/screens/auth/auth_screen.dart';
import 'package:hand_bill_manger/src/ui/screens/auth/chose_plans/chose_plan_screen.dart';
import 'package:hand_bill_manger/src/ui/screens/auth/forget_password_screen.dart';
import 'package:hand_bill_manger/src/ui/screens/auth/login_screen.dart';
import 'package:hand_bill_manger/src/ui/screens/auth/register_screen.dart';
import 'package:hand_bill_manger/src/ui/screens/auth/rest_password_screen.dart';
import 'package:hand_bill_manger/src/ui/screens/auth/verification_screen.dart';
import 'package:hand_bill_manger/src/ui/screens/common/image_full_screen.dart';
import 'package:hand_bill_manger/src/ui/screens/details_package/product_details/product_details_screen.dart';
import 'package:hand_bill_manger/src/ui/screens/navigation_package/agent/agents_screen.dart';
import 'package:hand_bill_manger/src/ui/screens/navigation_package/asstes/assets_details_screen.dart';
import 'package:hand_bill_manger/src/ui/screens/navigation_package/asstes/asstes_add_screen.dart';
import 'package:hand_bill_manger/src/ui/screens/navigation_package/asstes/my_assets_screen.dart';
import 'package:hand_bill_manger/src/ui/screens/navigation_package/auctions/auction_add_edit_screen.dart';
import 'package:hand_bill_manger/src/ui/screens/navigation_package/auctions/auction_details_screen.dart';
import 'package:hand_bill_manger/src/ui/screens/navigation_package/auctions/my_auctions_screen.dart';
import 'package:hand_bill_manger/src/ui/screens/navigation_package/chat/chats_screen.dart';
import 'package:hand_bill_manger/src/ui/screens/navigation_package/chat/inbox_screen.dart';
import 'package:hand_bill_manger/src/ui/screens/navigation_package/edit_account_screen.dart';
import 'package:hand_bill_manger/src/ui/screens/navigation_package/help/help_center_screen.dart';
import 'package:hand_bill_manger/src/ui/screens/navigation_package/jobs/jobs_add_screen.dart';
import 'package:hand_bill_manger/src/ui/screens/navigation_package/jobs/jobs_company_details_screens.dart';
import 'package:hand_bill_manger/src/ui/screens/navigation_package/jobs/jobs_user_details_screens.dart';
import 'package:hand_bill_manger/src/ui/screens/navigation_package/jobs/my_jobs_screen.dart';
import 'package:hand_bill_manger/src/ui/screens/navigation_package/jobs/users_jobs_screen.dart';
import 'package:hand_bill_manger/src/ui/screens/navigation_package/my_products/products_screen.dart';
import 'package:hand_bill_manger/src/ui/screens/navigation_package/navigation_screen.dart';
import 'package:hand_bill_manger/src/ui/screens/navigation_package/offers/my_offers_screen.dart';
import 'package:hand_bill_manger/src/ui/screens/navigation_package/offers/offers_add_screen.dart';
import 'package:hand_bill_manger/src/ui/screens/navigation_package/offers/offers_details_screen.dart';
import 'package:hand_bill_manger/src/ui/screens/navigation_package/sponsored/my_ads.dart';
import 'package:hand_bill_manger/src/ui/screens/navigation_package/sponsored/sponsord_screen.dart';

class RouteGenerator {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    final args = settings.arguments as RouteArgument?;
    switch (settings.name) {
      case ForgetPasswordScreen.routeName:
        return CustomPageRoute(widget: ForgetPasswordScreen());
      case RestPasswordScreen.routeName:
        return CustomPageRoute(widget: RestPasswordScreen());
      case LoginScreen.routeName:
        return CustomPageRoute(widget: LoginScreen());
      case RegisterScreen.routeName:
        return CustomPageRoute(widget: RegisterScreen());
      case ChosePlanScreen.routeName:
        return CustomPageRoute(widget: ChosePlanScreen(routeArgument: args!));
      case NavigationScreen.routeName:
        return CustomPageRoute(widget: NavigationScreen());
      case AuthScreen.routeName:
        return CustomPageRoute(widget: AuthScreen());
      // case ChatsScreen.routeName:
      //   return CustomPageRoute(widget: ChatsScreen());
      case EditAccountScreen.routeName:
        return CustomPageRoute(widget: EditAccountScreen());
      case SponsoredScreen.routeName:
        return CustomPageRoute(widget: SponsoredScreen());
      case MyAds.routeName:
        return CustomPageRoute(widget: MyAds());
      case HelpCenterScreen.routeName:
        return CustomPageRoute(widget: HelpCenterScreen());
      case AgentsScreen.routeName:
        return CustomPageRoute(widget: AgentsScreen());
      case ProductDetailsScreen.routeName:
        return CustomPageRoute(
            widget: ProductDetailsScreen(routeArgument: args!));
      case MyProductsScreen.routeName:
        return CustomPageRoute(widget: MyProductsScreen());
      // case InboxScreen.routeName:
      //   return CustomPageRoute(widget: InboxScreen(routeArgument: args!));
      case UsersJobsScreen.routeName:
        return CustomPageRoute(widget: UsersJobsScreen());
      case JobCompanyDetailsScreen.routeName:
        return CustomPageRoute(widget: JobCompanyDetailsScreen(routeArgument: args!));
      case JobUserDetailsScreen.routeName:
        return CustomPageRoute(widget: JobUserDetailsScreen(routeArgument: args!));
      case JobAddScreen.routeName:
        return CustomPageRoute(widget: JobAddScreen(routeArgument: args));
      case MyJobsScreen.routeName:
        return CustomPageRoute(widget: MyJobsScreen());
      case MyAuctionsScreen.routeName:
        return CustomPageRoute(widget: MyAuctionsScreen());
      case AuctionDetailsScreen.routeName:
        return CustomPageRoute(
            widget: AuctionDetailsScreen(routeArgument: args!));
      case AuctionAddEditScreen.routeName:
        return CustomPageRoute(
            widget: AuctionAddEditScreen(routeArgument: args));
      case MyOffersScreen.routeName:
        return CustomPageRoute(widget: MyOffersScreen());
      case OfferAddScreen.routeName:
        return CustomPageRoute(widget: OfferAddScreen(routeArgument: args));
      case OfferDetailsScreen.routeName:
        return CustomPageRoute(
            widget: OfferDetailsScreen(routeArgument: args!));
      case MyAssetsScreen.routeName:
        return CustomPageRoute(widget: MyAssetsScreen());
      case AssetsAddScreen.routeName:
        return CustomPageRoute(widget: AssetsAddScreen(routeArgument: args));
      case AssetsDetailsScreen.routeName:
        return CustomPageRoute(
            widget: AssetsDetailsScreen(routeArgument: args!));

      case ImageFullScreen.routeName:
        return CustomPageRoute(widget: ImageFullScreen(routeArgument: args!));
      case VerificationScreen.routeName:
        return CustomPageRoute(
            widget: VerificationScreen(routeArgument: args!));
    }
  }
}
