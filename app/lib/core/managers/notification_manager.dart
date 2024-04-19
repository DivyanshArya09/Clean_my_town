import 'package:app/core/entities/fcm_entity.dart';
import 'package:app/injection_container.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../features/requests/presentation/blocs/request_bloc/request_bloc.dart';

class FCMnotificationManager {
  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'foreground notification channel',
    'High Importance Channel',
    description: 'This channel is to be used for foreground notifications',
    importance: Importance.max,
  );

  static _intializeLocalNotifications() async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings();

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);
  }

  static initializeForegroundNotificationSetup() async {
    await _intializeLocalNotifications();
    FirebaseMessaging.onMessage.listen(showNotification);
  }

  static Future showNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    final _bloc = sl.get<RequestBloc>();

    _bloc.add(GetMyRequestEvent());
    if (notification != null && android != null) {
      await FlutterLocalNotificationsPlugin().show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(_channel.id, _channel.name,
              channelDescription: _channel.description),
        ),
      );
    }
  }

  static Future<void> requestPermission() async {
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
  static Future<FCMUpdateEntity> getDeviceToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    FCMUpdateEntity entity = FCMUpdateEntity(token: token ?? '');

    return entity;
  }
}
