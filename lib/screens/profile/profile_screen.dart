import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shopee/components/async_progress_dialog.dart';
import 'package:e_shopee/components/custom_app_bar.dart';
import 'package:e_shopee/helper/utils.dart';
import 'package:e_shopee/screens/about_developer/about_developer_screen.dart';
import 'package:e_shopee/screens/html/html_screen.dart';
import 'package:e_shopee/screens/menu/menu_screen.dart';
import 'package:e_shopee/services/auth/auth_service.dart';
import 'package:e_shopee/services/database/user_database_helper.dart';
import 'package:e_shopee/utils/constants.dart';
import 'package:e_shopee/utils/html_type.dart';
import 'package:e_shopee/utils/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'profile_update_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserDatabaseHelper _userDatabaseHelper = UserDatabaseHelper();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          title:'Profile',
        ),
        body: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(children: [
                Container(
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(1),
                  child: ClipOval(
                    child: FutureBuilder<String?>(
                      future: Future.delayed(Duration(seconds: 5), () => UserDatabaseHelper().displayPictureForCurrentUser),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Container(
                            width: 80, height: 80,
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
                          final error = snapshot.error;
                          print(error);
                          return Center(
                            child: Image.asset('assets/images/placeholder.jpg', height:80,width:80, fit: BoxFit.cover,),
                          );
                        } else {
                          final imageUrl = snapshot.data;
                          final hasData = imageUrl != null && imageUrl.isNotEmpty;

                          return Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: hasData
                                  ? DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(imageUrl),
                              )
                                  : DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage("assets/images/placeholder.jpg"),
                              ),
                            ),
                            child: !hasData ? Center(child: CircularProgressIndicator()) : null,
                          );
                        }
                      },
                    ),
                  ),
                ),
                SizedBox(width: 10,),
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
            Divider(thickness: 2,color: Theme.of(context).disabledColor,),
           // buildEditAccountExpansionTile(context),
           //  ListTile(
           //    leading: Icon(Icons.edit_location),
           //    title: Text(
           //      "Manage Addresses",
           //      style: josefinRegular
           //    ),
           //    onTap: () async {
           //      bool allowed = AuthService().currentUserVerified;
           //      if (!allowed) {
           //        final reverify = await ConfirmationDialog(context,
           //            "You haven't verified your email address. This action is only allowed for verified users.",
           //            positiveResponse: "Resend Email",
           //            negativeResponse: "Go back");
           //        if (reverify) {
           //          final future =
           //              AuthService().sendVerificationEmailToCurrentUser();
           //          await showDialog(
           //            context: context,
           //            builder: (context) {
           //              return AsyncProgressDialog(
           //                future,
           //                message: Text("Resending verification email"),
           //              );
           //            },
           //          );
           //        }
           //        return;
           //      }
           //      Navigator.push(
           //        context,
           //        MaterialPageRoute(
           //          builder: (context) => PolicyViewerScreen(),
           //        ),
           //      );
           //    },
           //  ),
            ListTile(
              leading: Icon(Icons.edit),
              title: Text(
                "Update Profile",
                style: josefinRegular,
              ),
              onTap: () async {
                bool allowed = AuthService().currentUserVerified;
                if (!allowed) {
                  final reverify = await ConfirmationDialog(context,
                      "You haven't verified your email address. This action is only allowed for verified users.",
                      positiveResponse: "Resend Email",
                      negativeResponse: "Go back");
                  if (reverify) {
                    final future =
                        AuthService().sendVerificationEmailToCurrentUser();
                    await showDialog(
                      context: context,
                      builder: (context) {
                        return AsyncProgressDialog(
                          future,
                          message: Text("Resending verification email"),
                        );
                      },
                    );
                  }
                  return;
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileUpdateScreen(),
                  ),
                );
              },
            ),
           // buildSellerExpansionTile(context),
            ListTile(
              leading: Icon(Icons.security),
              title: Text(
                "Privacy Policy",
                style: josefinRegular,
              ),
              onTap: () async {
                final htmlContent = await _userDatabaseHelper.fetchPolicyContent(HtmlType.privacyPolicy);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HtmlScreen(
                      title: 'Privacy Policy',
                      htmlContent: htmlContent,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.list_alt),
              title: Text(
                "Terms & Conditions",
                style: josefinRegular,
              ),
              onTap: () async {
                final htmlContent = await _userDatabaseHelper.fetchPolicyContent(HtmlType.termsAndCondition);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HtmlScreen(
                      title: 'Terms & Conditions',
                      htmlContent: htmlContent,
                    ),
                  ),
                );
              },
            ), ListTile(
              leading: Icon(Icons.fire_truck),
              title: Text(
                "Shipping Policy",
                style: josefinRegular,
              ),
              onTap: () async {
                final htmlContent = await _userDatabaseHelper.fetchPolicyContent(HtmlType.shippingPolicy);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HtmlScreen(
                      title: 'Shipping Policy',
                      htmlContent: htmlContent,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.money),
              title: Text(
                "Refund Policy",
                style: josefinRegular,
              ),
              onTap: () async {
                final htmlContent = await _userDatabaseHelper.fetchPolicyContent(HtmlType.refundPolicy);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HtmlScreen(
                      title: 'Refund Policy',
                      htmlContent: htmlContent,
                    ),
                  ),
                );
              },
            ), ListTile(
              leading: Icon(Icons.person),
              title: Text(
                "About Us",
                style: josefinRegular,
              ),
              onTap: () async {
                final htmlContent = await _userDatabaseHelper.fetchPolicyContent(HtmlType.aboutUs);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HtmlScreen(
                      title: 'About Us',
                      htmlContent: htmlContent,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text(
                "About Developer",
                style: josefinRegular,
              ),
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MenuScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text(
                "Sign out",
                style: josefinRegular,
              ),
              onTap: () async {
                final confirmation =
                    await ConfirmationDialog(context, "Are you sure want to Sign out");
                if (confirmation) AuthService().signOut();
              },
            ),
          ],
        ),
      ),
    );
  }

  /*UserAccountsDrawerHeader buildUserAccountsHeader(User user) {
    return UserAccountsDrawerHeader(
      margin: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: kTextColor.withOpacity(0.15),
      ),
      accountEmail: Text(
        user.email ?? "No Email",
        style: TextStyle(
          fontSize: 15,
          color: Colors.black,
        ),
      ),
      accountName: Text(
        user.displayName ?? "No Name",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
      currentAccountPicture: FutureBuilder<String?>(
        future: UserDatabaseHelper().displayPictureForCurrentUser,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return CircleAvatar(
              backgroundImage: AssetImage("assets/images/placeholder.jpg"),
            );
          } else {
            // Check if snapshot.data is not null and is of type String
            if (snapshot.data is String) {
              String imageUrl = snapshot.data!;

              if (imageUrl.isNotEmpty) {
                return CircleAvatar(
                  backgroundImage: NetworkImage(imageUrl),
                );
              }
            }
            return CircleAvatar(
              backgroundImage: AssetImage("assets/images/placeholder.jpg"),
            );
          }
        },
      ),
    );
  }

  ExpansionTile buildEditAccountExpansionTile(BuildContext context) {
    return ExpansionTile(
      textColor: kPrimaryColor,
      leading: Icon(Icons.person,),
      title: Text(
        "Edit Account",
        style: josefinRegular,
      ),
      children: [
        ListTile(
          title: Text(
            "Change Display Picture",
            style:josefinRegular
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangeDisplayPictureScreen(),
                ));
          },
        ),
        ListTile(
          title: Text(
            "Change Display Name",
            style: josefinRegular
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangeDisplayNameScreen(),
                ));
          },
        ),
        ListTile(
          title: Text(
            "Change Phone Number",
            style: josefinRegular
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangePhoneScreen(),
                ));
          },
        ),
        ListTile(
          title: Text(
            "Change Email",
            style: josefinRegular
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangeEmailScreen(),
                ));
          },
        ),
        ListTile(
          title: Text(
            "Change Password",
            style: josefinRegular
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangePasswordScreen(),
                ));
          },
        ),
      ],
    );
  }

  Widget buildSellerExpansionTile(BuildContext context) {
    return ExpansionTile(
      leading: Icon(Icons.business),
      title: Text(
        "I am Seller",
        style: josefinRegular,
      ),
      backgroundColor: kPrimaryColor,
      children: [
        ListTile(
          title: Text(
            "Add New Product",
            style: josefinRegular
          ),
          onTap: () async {
            bool allowed = AuthService().currentUserVerified;
            if (!allowed) {
              final reverify = await ConfirmationDialog(context,
                  "You haven't verified your email address. This action is only allowed for verified users.",
                  positiveResponse: "Resend Email",
                  negativeResponse: "Go back");
              if (reverify) {
                final future =
                    AuthService().sendVerificationEmailToCurrentUser();
                await showDialog(
                  context: context,
                  builder: (context) {
                    return AsyncProgressDialog(
                      future,
                      message: Text("Resending verification email"),
                    );
                  },
                );
              }
              return;
            }
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => EditProductScreen()));
          },
        ),
        ListTile(
          title: Text(
            "Manage My Products",
            style:josefinRegular
          ),
          onTap: () async {
            bool allowed = AuthService().currentUserVerified;
            if (!allowed) {
              final reverify = await ConfirmationDialog(context,
                  "You haven't verified your email address. This action is only allowed for verified users.",
                  positiveResponse: "Resend Email",
                  negativeResponse: "Go back");
              if (reverify) {
                final future =
                    AuthService().sendVerificationEmailToCurrentUser();
                await showDialog(
                  context: context,
                  builder: (context) {
                    return AsyncProgressDialog(
                      future,
                      message: Text("Resending verification email"),
                    );
                  },
                );
              }
              return;
            }
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MyProductsScreen(),
              ),
            );
          },
        ),
      ],
    );
  }*/
}
