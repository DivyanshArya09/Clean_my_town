class AcceptRequestEnity {
  String? notificationTitle;
  String? notificationBodyText;
  String docId;
  String fcmToken;
  AcceptRequestEnity(
      {this.notificationTitle = 'Your Cleaning Request Has Been Accepted!',
      this.notificationBodyText,
      required this.docId,
      required this.fcmToken});

  AcceptRequestEnity copwith(
      {String? notificationTitle,
      String? notificationBodyText,
      String? docId,
      String? fcmToken}) {
    return AcceptRequestEnity(
      notificationTitle: notificationTitle ?? this.notificationTitle,
      notificationBodyText: notificationBodyText ?? this.notificationBodyText,
      docId: docId ?? this.docId,
      fcmToken: fcmToken ?? this.fcmToken,
    );
  }

  factory AcceptRequestEnity.toEmpty() {
    return AcceptRequestEnity(
      notificationTitle: '',
      notificationBodyText: '',
      docId: '',
      fcmToken: '',
    );
  }
}
