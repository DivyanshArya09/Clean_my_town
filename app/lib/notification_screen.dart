import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  Future<void> requestPermission() async {
    NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    }

    if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    }

    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      print('User denied permission');
    }
  }

  //! this method is going to be on the spash screen
  Future<void> getDeviceToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    print('Device Token:=============================> $token');
  }

  @override
  void initState() {
    requestPermission();
    getDeviceToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Screen'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          "push notifications with firebase",
        ),
      ),
    );
  }
}
