import 'package:e_shopee/helper/size_config.dart';
import 'package:e_shopee/screens/sign_in/sign_in_screen.dart';
import 'package:e_shopee/screens/sign_up/components/sign_up_form.dart';
import 'package:e_shopee/utils/constants.dart';
import 'package:e_shopee/utils/dimensions.dart';
import 'package:e_shopee/utils/styles.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                child: Column(children: [
                  SizedBox(height: SizeConfig.screenHeight! * 0.02),
                  Text(
                    "Register Account",
                    style: josefinBold.copyWith(
                      fontSize: Dimensions.fontSizeOverLarge,
                    ),
                  ),
                  Text(
                    "Complete your details or continue \nwith social media",
                    style: josefinRegular.copyWith(
                        fontSize: Dimensions.fontSizeSmall, color: kTextColor),
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
                      child: SignUpForm(),
                  ),
                  SizedBox(height: Dimensions.paddingSizeLarge),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account ? ", style: josefinRegular),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignInScreen()));
                        },
                        child: Text(
                          "Sign In",
                          style: josefinRegular.copyWith(color: kPrimaryColor),
                        ),
                      ),
                      SizedBox(height: Dimensions.paddingSizeOverLarge),
                    ],
                  ),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
