import 'package:e_shopee/helper/size_config.dart';
import 'package:e_shopee/screens/change_password/components/change_password_form.dart';
import 'package:e_shopee/utils/constants.dart';
import 'package:e_shopee/utils/dimensions.dart';
import 'package:e_shopee/utils/styles.dart';
import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(
          "Change Password",
          style: josefinMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(screenPadding)),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  ChangePasswordForm(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
