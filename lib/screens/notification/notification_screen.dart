import 'package:e_shopee/components/custom_app_bar.dart';
import 'package:e_shopee/utils/constants.dart';
import 'package:e_shopee/utils/dimensions.dart';
import 'package:e_shopee/utils/styles.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  final List<String> notifications = [
    // "New message from John",
    // "Reminder: Today's meeting at 3 PM",
    // "You have a new follower",
    // "Your order has been shipped",
    // "Upcoming event: Conference at 10 AM",
    // "Payment successful",
  ];

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // Replace this with the actual condition to check if there are notifications or not
  bool hasNotification = false;

  @override
  void initState() {
    super.initState();
    // Check if there are notifications in the list
    if (widget.notifications.isNotEmpty) {
      hasNotification = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Notifications",isBackButtonExist: true,onBackPressed: ()=>Navigator.pop(context),
      ),
      body: widget.notifications.isNotEmpty
          ? ListView.builder(
        itemCount: widget.notifications.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.notifications),
            title: Text(widget.notifications[index]),
            onTap: () {
              // Handle tapping on a notification
              // You can navigate to a detail screen or perform any desired action.
            },
          );
        },
      ) : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_off,
              color: kTextColor,
              size: 50,
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              "Notifications not found",
              style: josefinRegular.copyWith(color: kTextColor),
            ),
          ],
        ),
      ),
    );
  }
}
