import 'package:e_shopee/components/custom_app_bar.dart';
import 'package:e_shopee/components/custom_image.dart';
import 'package:e_shopee/components/portion_widget.dart';
import 'package:e_shopee/helper/route_helper.dart';
import 'package:e_shopee/services/auth/auth_service.dart';
import 'package:e_shopee/services/database/user_database_helper.dart';
import 'package:e_shopee/utils/constants.dart';
import 'package:e_shopee/utils/dimensions.dart';
import 'package:e_shopee/utils/html_type.dart';
import 'package:e_shopee/utils/images.dart';
import 'package:e_shopee/utils/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Profile',
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(color: kPrimaryLightColor),
              child: Padding(
                padding: EdgeInsets.only(
                  left: Dimensions.paddingSizeOverLarge, right: Dimensions.paddingSizeOverLarge,
                  top: 10, bottom: Dimensions.paddingSizeOverLarge,
                ),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color:kPrimaryColor,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(1),
                      child: ClipOval(
                        child: FutureBuilder<String>(
                          future: UserDatabaseHelper().displayPictureForCurrentUser,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(kPrimaryLightColor),
                                  ),
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return Center(
                                child: CustomImage(
                                  placeholder: Images.guestIconLight,
                                  height: 80,
                                  width: 80,
                                  fit: BoxFit.cover, image: snapshot.data ?? '',
                                ),
                              );
                            } else {
                              return CustomImage(
                                image: snapshot.data ?? '',
                                height: 80,
                                width: 80,
                                fit: BoxFit.cover,
                                placeholder: Images.guestIconLight,
                              );
                            }
                          },
                        ),
                      ),
                    ),
                    SizedBox(width: Dimensions.paddingSizeDefault),
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        StreamBuilder<User?>(
                          stream: AuthService().userChanges,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              final user = snapshot.data;
                              return Row(
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${user?.displayName ?? "No Name"}",
                                        style: josefinMedium.copyWith(color: kBlackColor),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            }
                          },
                        ),
                      ]),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: Dimensions.paddingSizeSmall,),
            Expanded(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Ink(
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                              child: Text(
                                'General',
                                style: josefinMedium.copyWith(color: kPrimaryColor.withOpacity(0.8)),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 5)],
                              ),
                              padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeDefault),
                              margin: EdgeInsets.all(Dimensions.paddingSizeDefault),
                              child: Column(
                                children: [
                                  PortionWidget(icon:Images.profileIcon, title: 'Profile',route: RouteHelper.getProfileRoute()),
                                  PortionWidget(icon:Images.profileIcon, title: 'My Address',route: RouteHelper.getAddressRoute()),
                                  //PortionWidget(icon:Images.profileIcon, title: 'Language',route: RouteHelper.getProfileRoute()),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                            child: Text(
                              'Help & Support',
                              style: josefinMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).primaryColor.withOpacity(0.5)),
                            ),
                          ),
                            Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 5)],
                              ),
                              padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeDefault),
                              margin: EdgeInsets.all(Dimensions.paddingSizeDefault),
                              child: Column(
                                children: [
                                  PortionWidget(icon:Images.profileIcon, title: 'Contact Us',route: RouteHelper.getProfileRoute()),
                                  PortionWidget(icon:Images.profileIcon, title: 'Privacy Policy',route: RouteHelper.getHtmlRoute(HtmlType.privacyPolicy)),
                                  PortionWidget(icon:Images.profileIcon, title: 'Shipping Policy',route: RouteHelper.getHtmlRoute(HtmlType.shippingPolicy)),
                                  PortionWidget(icon:Images.profileIcon, title: 'Refund Policy',route: RouteHelper.getHtmlRoute(HtmlType.refundPolicy)),
                                  PortionWidget(icon:Images.profileIcon, title: 'Terms & Condition',route: RouteHelper.getHtmlRoute(HtmlType.termsAndCondition)),
                                  PortionWidget(icon:Images.profileIcon, title: 'About Us',route: RouteHelper.getHtmlRoute(HtmlType.aboutUs)),
                                  //PortionWidget(icon:Images.profileIcon, title: 'Language',route: RouteHelper.getProfileRoute()),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
            ))
          ],
        ),
      ),
    );
  }
}
