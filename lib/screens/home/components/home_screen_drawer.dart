import 'package:e_shopee/components/async_progress_dialog.dart';
import 'package:e_shopee/helper/utils.dart';
import 'package:e_shopee/screens/about_developer/about_developer_screen.dart';
import 'package:e_shopee/screens/change_display_picture/change_display_picture_screen.dart';
import 'package:e_shopee/screens/change_email/change_email_screen.dart';
import 'package:e_shopee/screens/change_password/change_password_screen.dart';
import 'package:e_shopee/screens/change_phone/change_phone_screen.dart';
import 'package:e_shopee/screens/edit_product/edit_product_screen.dart';
import 'package:e_shopee/screens/manage_addresses/manage_addresses_screen.dart';
import 'package:e_shopee/screens/my_orders/my_orders_screen.dart';
import 'package:e_shopee/screens/my_products/my_products_screen.dart';
import 'package:e_shopee/services/auth/auth_service.dart';
import 'package:e_shopee/services/database/user_database_helper.dart';
import 'package:e_shopee/utils/constants.dart';
import 'package:e_shopee/utils/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../change_display_name/change_display_name_screen.dart';

class HomeScreenDrawer extends StatelessWidget {
  const HomeScreenDrawer({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: ListView(
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
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        } else if (snapshot.hasError) {
                          final error = snapshot.error;
                          // Handle the error if necessary
                          return Center(
                            child: Image.asset('assets/images/placeholder.jpg', height:80,width:80, fit: BoxFit.cover,),
                          );
                        } else {
                          final imageUrl = snapshot.data;
                          final hasData = imageUrl != null && imageUrl.isNotEmpty;

                          return Container(
                            width: 100,
                            height: 100,
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
            Divider(color: kTextColor,),
            buildEditAccountExpansionTile(context),
            ListTile(
              leading: Icon(Icons.edit_location),
              title: Text(
                "Manage Addresses",
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
                    final future = AuthService()
                        .sendVerificationEmailToCurrentUser();
                    await showDialog(
                      context: context,
                      builder: (context) {
                        return AsyncProgressDialog(
                          future,
                          message: Text("Resending verification email",style:josefinRegular),
                        );
                      },
                    );
                  }
                  return;
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ManageAddressesScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.edit_location),
              title: Text(
                "My Orders",
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
                    final future = AuthService()
                        .sendVerificationEmailToCurrentUser();
                    await showDialog(
                      context: context,
                      builder: (context) {
                        return AsyncProgressDialog(
                          future,
                          message: Text("Resending verification email",style: josefinRegular,),
                        );
                      },
                    );
                  }
                  return;
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyOrdersScreen(),
                  ),
                );
              },
            ),
            buildSellerExpansionTile(context),
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
                    builder: (context) => AboutDeveloperScreen(),
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
                    await ConfirmationDialog(context, "Confirm Sign out ?");
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
  }*/

  ExpansionTile buildEditAccountExpansionTile(BuildContext context) {
    return ExpansionTile(
      leading: Icon(Icons.person),
      title: Text(
        "Edit Account",
        style: josefinRegular,
      ),
      children: [
        ListTile(
          title: Text(
            "Change Display Picture",
            style: josefinRegular
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
            style:josefinRegular
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
                final future = AuthService()
                    .sendVerificationEmailToCurrentUser();
                await showDialog(
                  context: context,
                  builder: (context) {
                    return AsyncProgressDialog(
                      future,
                      message: Text("Resending verification email",style: josefinRegular,),
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
                final future = AuthService()
                    .sendVerificationEmailToCurrentUser();
                await showDialog(
                  context: context,
                  builder: (context) {
                    return AsyncProgressDialog(
                      future,
                      message: Text("Resending verification email",style: josefinRegular,),
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
  }
}
