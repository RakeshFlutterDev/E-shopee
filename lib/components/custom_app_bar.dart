

import 'dart:io';

import 'package:e_shopee/utils/constants.dart';
import 'package:e_shopee/utils/dimensions.dart';
import 'package:e_shopee/utils/styles.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isBackButtonExist;
  final Function? onBackPressed;
  final bool showCart;
  const CustomAppBar({super.key, required this.title, this.isBackButtonExist = false,  this.onBackPressed, this.showCart = false});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title, style: josefinMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Colors.white)),
      centerTitle: true,
      leading: isBackButtonExist ? IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        color: kPrimaryLightColor,
        onPressed: () {
          onBackPressed!();
        },
      ) : const SizedBox(),
      backgroundColor: kPrimaryColor,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => Size(Dimensions.webMaxWidth, Platform.isWindows ? 70 : 50);
}
