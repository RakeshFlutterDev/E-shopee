import 'package:e_shopee/helper/size_config.dart';
import 'package:e_shopee/screens/change_phone/components/change_phone_number_form.dart';
import 'package:e_shopee/utils/constants.dart';
import 'package:e_shopee/utils/dimensions.dart';
import 'package:e_shopee/utils/styles.dart';
import 'package:flutter/material.dart';

class ChangePhoneScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(
          "Change Phone Number",
          style: josefinMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(screenPadding)),
            child: Column(
              children: [
                ChangePhoneNumberForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
