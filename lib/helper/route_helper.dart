import 'package:e_shopee/screens/html/html_screen.dart';
import 'package:e_shopee/screens/manage_addresses/manage_addresses_screen.dart';
import 'package:e_shopee/utils/html_type.dart';
import 'package:flutter/material.dart';
import 'package:e_shopee/screens/dashboard/dashboard_screen.dart';
import 'package:e_shopee/screens/menu/menu_screen.dart';
import 'package:e_shopee/screens/my_orders/my_orders_screen.dart';
import 'package:e_shopee/screens/profile/profile_screen.dart';
import 'package:e_shopee/screens/sign_in/sign_in_screen.dart';
import 'package:e_shopee/screens/sign_up/sign_up_screen.dart';
import 'package:e_shopee/screens/splash/splash_screen.dart';

class RouteHelper {
  static const String initial = '/';
  static const String address = '/address';
  static const String splash = '/splash';
  static const String signIn = '/signIn';
  static const String signUp = '/signUp';
  static const String profile = '/profile';
  static const String menu = '/menu';
  static const String orders = '/orders';
  static const String html = '/html';

  static String getInitialRoute() => initial;
  static String getSplashRoute() => splash;
  static String getAddressRoute() => address;
  static String getProfileRoute() => profile;
  static String getMenuRoute() => menu;
  static String getOrderRoute() => orders;
  static String getHtmlRoute(HtmlType type) {
    return '/html?type=${type.toString()}';
  }

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => DashboardScreen(pageIndex: 0),
    splash: (context) => SplashScreen(),
    address: (context) => ManageAddressesScreen(),
    signIn: (context) => SignInScreen(),
    signUp: (context) => SignUpScreen(),
    profile: (context) => ProfileScreen(),
    menu: (context) => MenuScreen(),
    orders: (context) => MyOrdersScreen(),
    html: (context) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
      final title = args['title'] as String;
      final htmlContent = args['htmlContent'] as String;
      return HtmlScreen(title: title, htmlContent: htmlContent);
    },
  };
}
