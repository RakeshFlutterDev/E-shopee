import 'package:e_shopee/helper/size_config.dart';
import 'package:e_shopee/screens/change_display_name/components/change_display_name_form.dart';
import 'package:e_shopee/utils/constants.dart';
import 'package:e_shopee/utils/dimensions.dart';
import 'package:e_shopee/utils/styles.dart';
import 'package:flutter/material.dart';

class ChangeDisplayNameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(
          "Change Display Name",
          style: josefinMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(screenPadding)),
          child: Column(
            children: [
              SizedBox(height: SizeConfig.screenHeight! * 0.04),
              ChangeDisplayNameForm(),
            ],
          ),
        ),
      ),
    );
  }
}
