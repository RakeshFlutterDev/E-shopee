import 'package:e_shopee/services/auth/auth_service.dart';
import 'package:e_shopee/services/database/user_database_helper.dart';
import 'package:e_shopee/utils/constants.dart';
import 'package:e_shopee/utils/dimensions.dart';
import 'package:e_shopee/utils/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeHeader extends StatefulWidget {
  final VoidCallback onNotificationBtnPressed;
  const HomeHeader({
    Key? key,
    required this.onNotificationBtnPressed,
  }) : super(key: key);

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  @override
  Widget build(BuildContext context) {
    String greetingMessage = '';
    return Row(
      children: [
         /*IconButton(
             onPressed: () => Scaffold.of(context).openDrawer(),
             icon:Icon(Icons.menu),
         )*/
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: FutureBuilder<String?>(
            future: Future.delayed(Duration(seconds: 5), () => UserDatabaseHelper().displayPictureForCurrentUser),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  width: 60,
                  height: 60,
                  color: kTextColor,
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return Container(
                  width: 60,
                  height: 60,
                  child: Center(
                    child: Image.asset('assets/images/placeholder.jpg', height: 80, width: 80, fit: BoxFit.cover),
                  ),
                );
              } else {
                final imageUrl = snapshot.data;
                final hasData = imageUrl != null && imageUrl.isNotEmpty;

                return Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
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
        SizedBox(width: 8.0),
        Expanded(
          flex: 4,
          child: StreamBuilder<User?>(
            stream: AuthService().userChanges,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                final user = snapshot.data;
                greetingMessage = AuthService().getGreetingMessage();
                return Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hi, ${user?.displayName ?? "No Name"}",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: josefinRegular.copyWith(color: kBlackColor)
                        ),
                        Text(
                          greetingMessage, // Display the greeting message here
                            style: josefinBold.copyWith(fontSize:Dimensions.fontSizeExtraLarge, color: kBlackColor)
                        ),
                      ],
                    ),
                  ],
                );
              }
            },
          ),
        ),
        SizedBox(width: Dimensions.paddingSizeOverLarge),
        Expanded(
          child: IconButton(
            onPressed:widget.onNotificationBtnPressed ,
            icon:Icon(Icons.notifications, size: 45, color: Theme.of(context).textTheme.bodyLarge!.color),
          ),
        ),
      ],
    );
  }
}
