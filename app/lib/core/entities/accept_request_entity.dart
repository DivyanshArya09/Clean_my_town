import 'package:app/features/requests/presentation/models/request_model.dart';

class AcceptRequestEnity {
  String? notificationTitle;
  String? notificationBodyText;
  String docId;
  String fcmToken;
  final VolunteerModel volunteer;
  AcceptRequestEnity(
      {this.notificationTitle = 'Your Cleaning Request Has Been Accepted!',
      this.notificationBodyText,
      required this.docId,
      required this.fcmToken,
      required this.volunteer});

  AcceptRequestEnity copwith(
      {String? notificationTitle,
      String? notificationBodyText,
      String? docId,
      String? fcmToken,
      VolunteerModel? volunteer}) {
    return AcceptRequestEnity(
      notificationTitle: notificationTitle ?? this.notificationTitle,
      notificationBodyText: notificationBodyText ?? this.notificationBodyText,
      docId: docId ?? this.docId,
      fcmToken: fcmToken ?? this.fcmToken,
      volunteer: volunteer ?? this.volunteer,
    );
  }

  factory AcceptRequestEnity.toEmpty() {
    return AcceptRequestEnity(
      notificationTitle: '',
      notificationBodyText: '',
      docId: '',
      fcmToken: '',
      volunteer: VolunteerModel.empty(),
    );
  }
}
