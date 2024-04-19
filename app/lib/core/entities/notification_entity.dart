class NotificationEntity {
  String title;
  String body;
  String token;

  NotificationEntity(
      {required this.title, required this.body, required this.token});

  NotificationEntity copyWith({
    String? title,
    String? body,
    String? token,
  }) {
    return NotificationEntity(
      title: title ?? this.title,
      body: body ?? this.body,
      token: token ?? this.token,
    );
  }

  Map<String, String> toMap() {
    return {'title': title, 'body': body, 'token': token};
  }
}
