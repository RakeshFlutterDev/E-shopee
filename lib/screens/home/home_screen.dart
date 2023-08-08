import 'package:e_shopee/helper/size_config.dart';
import 'package:flutter/material.dart';


import 'components/body.dart';
import 'components/home_screen_drawer.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = "/home";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      drawer: HomeScreenDrawer(),
      body: Body(),
    );
  }
}
