// ignore_for_file: prefer_const_constructors

import 'dart:async';


import 'package:e_shopee/components/icon_button_with_counter.dart';
import 'package:e_shopee/screens/cart/cart_screen.dart';
import 'package:e_shopee/screens/dashboard/widget/bottom_nav_item.dart';
import 'package:e_shopee/screens/favorite/favorite_screen.dart';
import 'package:e_shopee/screens/home/home_screen.dart';
import 'package:e_shopee/screens/my_orders/my_orders_screen.dart';
import 'package:e_shopee/screens/profile/profile_screen.dart';
import 'package:e_shopee/utils/constants.dart';
import 'package:e_shopee/utils/dimensions.dart';
import 'package:e_shopee/utils/styles.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  static const String routeName = "/initialScreen";

  final int pageIndex;
  const DashboardScreen({super.key, required this.pageIndex});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late PageController _pageController;
  int _pageIndex = 0;
  late List<Widget> _screens;
  GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();
  bool _canExit = false;

  @override
  void initState() {
    super.initState();

    _pageIndex = widget.pageIndex;

    _pageController = PageController(initialPage: widget.pageIndex);

    _screens = [
      HomeScreen(),
      FavoriteScreen(),
      CartScreen(),
      MyOrdersScreen(),
      ProfileScreen(),
    ];

    Future.delayed(Duration(seconds: 1), () {
      setState(() {});
    });

    /*if(GetPlatform.isMobile) {
      NetworkInfo.checkConnectivity(_scaffoldKey.currentContext);
    }*/
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_pageIndex != 0) {
          _setPage(0);
          return false;
        } else {
          if(_canExit) {
            return true;
          }else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Back press again to exit', style: josefinRegular.copyWith(color: Colors.white)),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
              margin: EdgeInsets.all(Dimensions.paddingSizeSmall),
            ));
            _canExit = true;
            Timer(Duration(seconds: 2), () {
              _canExit = false;
            });
            return false;
          }
        }
      },
      child: Scaffold(
        key: _scaffoldKey,

        floatingActionButton: FloatingActionButton(
          elevation: 5,
          backgroundColor: _pageIndex == 2 ? kPrimaryColor : Theme.of(context).cardColor,
          onPressed: () => _setPage(2),
          child: IconButtonWithCounter(
            numOfItems: 0, // Replace this with the actual number of items in the cart
            press:()=> _setPage(2),
          ),
       //   Icon(Icons.shopping_cart_outlined,color: Colors.grey,size: 35,),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

        bottomNavigationBar: BottomAppBar(
          elevation: 5,
          notchMargin: 5,
          clipBehavior: Clip.antiAlias,
          shape: CircularNotchedRectangle(),

          child: Padding(
            padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
            child: Row(children: [
              BottomNavItem(iconData: Icons.home_filled, isSelected: _pageIndex == 0, onTap: () => _setPage(0)),
              BottomNavItem(iconData: Icons.favorite, isSelected: _pageIndex == 1, onTap: () => _setPage(1)),
              Expanded(child: SizedBox()),
              BottomNavItem(iconData: Icons.shopping_bag, isSelected: _pageIndex == 3, onTap: () => _setPage(3)),
              BottomNavItem(iconData: Icons.person, isSelected: _pageIndex == 4, onTap:  () => _setPage(4)),
            ]),
          ),
        ),
        body: PageView.builder(
          controller: _pageController,
          itemCount: _screens.length,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return _screens[index];
          },
        ),
      ),
    );
  }

  void _setPage(int pageIndex) {
    setState(() {
      _pageController.jumpToPage(pageIndex);
      _pageIndex = pageIndex;
    });
  }
}
