import 'package:e_shopee/utils/dimensions.dart';
import 'package:e_shopee/utils/images.dart';
import 'package:e_shopee/utils/styles.dart';
import 'package:e_shopee/wrappers/auth_wrapper.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = "/splash_screen";
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToAuthWrapper();
  }

  void _navigateToAuthWrapper() {
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AuthWrapper()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              Images.logo,
              height: 350,
              width: 450,
              fit: BoxFit.fitHeight,
            ),
            Text(
              'Shopping App',
              style: josefinBold.copyWith(fontSize: Dimensions.fontSizeLarge),
            ),
          ],
        ),
      ),
    );
  }
}
