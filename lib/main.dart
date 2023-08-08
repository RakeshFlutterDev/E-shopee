import 'package:e_shopee/helper/notification_helper.dart';
import 'package:e_shopee/screens/splash/splash_screen.dart';
import 'package:e_shopee/utils/constants.dart';
import 'package:e_shopee/wrappers/auth_wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final NotificationHelper notificationHelper = NotificationHelper();
  await notificationHelper.initializeNotifications();
  runApp(MyApp());
}
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      theme: ThemeData(
        primaryColor: kPrimaryColor,
      ),
      initialRoute: SplashScreen.routeName,
      routes: {
        SplashScreen.routeName: (context) => SplashScreen(),
        AuthWrapper.routeName: (context) => AuthWrapper(),
      },
    );
  }
}
class Get {
  static BuildContext? get context => navigatorKey.currentContext;
  static NavigatorState? get navigator => navigatorKey.currentState;
}
