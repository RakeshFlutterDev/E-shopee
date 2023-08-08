import 'package:e_shopee/screens/dashboard/dashboard_screen.dart';
import 'package:e_shopee/screens/sign_in/sign_in_screen.dart';
import 'package:e_shopee/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

class AuthWrapper extends StatelessWidget {
  static const String routeName = "/auth_wrapper";
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthService().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return DashboardScreen(pageIndex: 0);
        } else {
          return SignInScreen();
        }
      },
    );
  }
}
