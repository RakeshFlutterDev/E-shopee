import 'package:e_shopee/components/no_account_text.dart';
import 'package:e_shopee/helper/size_config.dart';
import 'package:e_shopee/screens/sign_in/components/sign_in_form.dart';
import 'package:e_shopee/utils/constants.dart';
import 'package:e_shopee/utils/dimensions.dart';
import 'package:e_shopee/utils/styles.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                colors: [
                  Colors.orange.shade900,
                  Colors.orange.shade800,
                  Colors.orange.shade400,
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Column(
                   children: [
                    SizedBox(height: SizeConfig.screenHeight! * 0.1),
                    Text(
                      "Welcome Back",
                      style: josefinBold.copyWith(fontSize: Dimensions.fontSizeOverLarge,),
                    ),
                    Text(
                      "Sign in with your email and password",
                      style: josefinRegular.copyWith(fontSize: Dimensions.fontSizeSmall,color: kTextColor),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: SizeConfig.screenHeight! * 0.06),
                    Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromRGBO(225, 95, 27, .3),
                              blurRadius: 20,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: SignInForm()
                    ),
                    SizedBox(height: SizeConfig.screenHeight! * 0.08),
                    NoAccountText(),
                    SizedBox(height: getProportionateScreenHeight(120)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
