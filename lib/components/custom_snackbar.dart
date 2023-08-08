import 'package:e_shopee/helper/responsive_helper.dart';
import 'package:e_shopee/utils/dimensions.dart';
import 'package:e_shopee/utils/styles.dart';
import 'package:flutter/material.dart';

void showCustomSnackBar(BuildContext context, String? message, {bool isError = true}) {
  if (message != null && message.isNotEmpty) {
    final bool isMobile = ResponsiveHelper.isMobile(context);
    final double screenWidth = MediaQuery.of(context).size.width;
    final double snackBarMargin = isMobile ? Dimensions.paddingSizeSmall : screenWidth * 0.7;

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      dismissDirection: DismissDirection.horizontal,
      margin: EdgeInsets.only(
        right: snackBarMargin,
        top: Dimensions.paddingSizeSmall,
        bottom: Dimensions.paddingSizeSmall,
        left: Dimensions.paddingSizeSmall,
      ),
      duration: const Duration(seconds: 3),
      backgroundColor: isError ? Colors.red : Colors.green,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      content: Text(message, style: josefinRegular.copyWith(color: Colors.white)),
    ));
  }
}