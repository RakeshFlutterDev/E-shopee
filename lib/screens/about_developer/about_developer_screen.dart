import 'package:e_shopee/helper/size_config.dart';
import 'package:e_shopee/models/app_review_model.dart';
import 'package:e_shopee/screens/about_developer/components/app_review_dialog.dart';
import 'package:e_shopee/services/database/app_review_database_helper.dart';
import 'package:e_shopee/services/firestore_files_access/firestore_files_access_service.dart';
import 'package:e_shopee/utils/constants.dart';
import 'package:e_shopee/utils/dimensions.dart';
import 'package:e_shopee/utils/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';


class AboutDeveloperScreen extends StatefulWidget {
  @override
  State<AboutDeveloperScreen> createState() => _AboutDeveloperScreenState();
}

class _AboutDeveloperScreenState extends State<AboutDeveloperScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(
          "About Developer",style: josefinMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(screenPadding),
            ),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  SizedBox(height: getProportionateScreenHeight(50)),
                  InkWell(
                    onTap: () async {
                      const String linkedInUrl =
                          "https://www.linkedin.com/in/imrb7here";
                      await launchUrl(linkedInUrl);
                    },
                    child: buildDeveloperAvatar(),
                  ),
                  SizedBox(height: getProportionateScreenHeight(30)),
                  Text(
                    '" Rakesh "',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    "Hyderabad",
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: getProportionateScreenHeight(30)),
                  Row(
                    children: [
                      Spacer(),
                      IconButton(
                        icon: SvgPicture.asset(
                          "assets/icons/github_icon.svg",
                          color: kTextColor.withOpacity(0.75),
                        ),
                        color: kTextColor.withOpacity(0.75),
                        iconSize: 40,
                        padding: EdgeInsets.all(16),
                        onPressed: () async {
                          const String githubUrl = "https://github.com/";
                          await launchUrl(githubUrl);
                        },
                      ),
                      IconButton(
                        icon: SvgPicture.asset(
                          "assets/icons/linkedin_icon.svg",
                          color: kTextColor.withOpacity(0.75),
                        ),
                        iconSize: 40,
                        padding: EdgeInsets.all(16),
                        onPressed: () async {
                          const String linkedInUrl = "https://www.linkedin.com/in/";
                          await launchUrl(linkedInUrl);
                        },
                      ),
                      IconButton(
                        icon: SvgPicture.asset(
                          "assets/icons/instagram_icon.svg",
                          color: kTextColor.withOpacity(0.75),
                        ),
                        iconSize: 40,
                        padding: EdgeInsets.all(16),
                        onPressed: () async {
                          const String instaUrl = "https://www.instagram.com";
                          await launchUrl(instaUrl);
                        },
                      ),
                      Spacer(),
                    ],
                  ),
                  SizedBox(height: getProportionateScreenHeight(50)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.thumb_up),
                        color: kTextColor.withOpacity(0.75),
                        iconSize: 50,
                        padding: EdgeInsets.all(16),
                        onPressed: () {
                          submitAppReview(context, liked: true);
                        },
                      ),
                      Text(
                        "Liked the app?",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.thumb_down),
                        padding: EdgeInsets.all(16),
                        color: kTextColor.withOpacity(0.75),
                        iconSize: 50,
                        onPressed: () {
                          submitAppReview(context, liked: false);
                        },
                      ),
                      Spacer(),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDeveloperAvatar() {
    return FutureBuilder<String>(
      future: FirestoreFilesAccess().getDeveloperImage(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircleAvatar(
            radius: SizeConfig.screenWidth! * 0.3,
            backgroundColor: kTextColor.withOpacity(0.75),
          );
        } else if (snapshot.hasError || snapshot.data == null) {
          final error = snapshot.error?.toString() ?? "Error loading image";
          Logger().e(error);
          // If the network image is not available or there's an error, show the asset image as a fallback
          return CircleAvatar(
            radius: SizeConfig.screenWidth! * 0.3,
            backgroundColor: kTextColor.withOpacity(0.75),
            backgroundImage: AssetImage('assets/images/placeholder.jpg'),
          );
        } else {
          final url = snapshot.data!;
          return CircleAvatar(
            radius: SizeConfig.screenWidth! * 0.3,
            backgroundColor: kTextColor.withOpacity(0.75),
            backgroundImage: NetworkImage(url),
          );
        }
      },
    );
  }

  Future<void> launchUrl(String url) async {
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        Logger().i("URL was unable to launch: $url");
      }
    } catch (e) {
      Logger().e("Exception while launching URL: $e");
    }
  }

  Future<void> submitAppReview(BuildContext context, {bool liked = true}) async {
    try {
      AppReview prevReview =
      await AppReviewDatabaseHelper().getAppReviewOfCurrentUser();

      final AppReview result = await showDialog(
        context: context,
        builder: (context) {
          return AppReviewDialog(
            appReview: prevReview,
          );
        },
      );

      result.liked = liked;
      bool reviewAdded = false;
      String? snackbarMessage;
      try {
        reviewAdded = await AppReviewDatabaseHelper().editAppReview(result);
        if (reviewAdded == true) {
          snackbarMessage = "Feedback submitted successfully";
        } else {
          throw "Couldn't add feedback due to an unknown reason";
        }
      } on FirebaseException catch (e) {
        Logger().w("Firebase Exception: $e");
        snackbarMessage = e.toString();
      } catch (e) {
        Logger().w("Unknown Exception: $e");
        snackbarMessage = e.toString();
      } finally {
        Logger().i(snackbarMessage);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(snackbarMessage!),
          ),
        );
      }
    } on FirebaseException catch (e) {
      Logger().w("Firebase Exception: $e");
    } catch (e) {
      Logger().w("Unknown Exception: $e");
    }
  }
}
