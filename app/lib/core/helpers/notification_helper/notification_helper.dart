import 'dart:convert';

import 'package:http/http.dart' as http;

class NotificationHelper {
  static Future<void> postNotification(
      String title, String body, String token) async {
    try {
      final response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAAJGt39ZY:APA91bEiKjBbR-epKLdqos6l9GJyjvNMMF2jyi5nNmXGrUYxkqxaO_aBBcF41akt9n5vietd9p5rG8n5M75zRkWgR2qEWpn87DaY_1SOL91zu6zQ97ihh6XcpEd_mFFUZuCzh6tHpXis',
        },
        body: jsonEncode(
          {
            'priority': 'high',
            'data': {
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'status': 'done',
              'body': body,
              'title': title,
              'sound': 'default',
            },
            'notification': {
              'body': body,
              'title': title,
              'sound': 'default',
            },
            'to': token,
          },
        ),
      );

      print(
          '==========NOTIFICATION======RESPONSE====================> ${response.body}');
    } catch (e) {
      print(
          '==============NOTIFICATION========ERROR==============================> $e');
    }
  }
}
