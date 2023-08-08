import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationHelper {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showOrderPlacedNotification(BuildContext context) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'order_channel',
      'Order Notifications',
      channelDescription: 'E-Shopee',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      'Order Placed',
      'Your order has been successfully placed!',
      NotificationDetails(android: androidPlatformChannelSpecifics),
      payload: 'order_placed',
    );
  }
}
