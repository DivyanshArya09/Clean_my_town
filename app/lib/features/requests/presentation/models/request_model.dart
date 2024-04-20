import 'dart:core';

import 'package:app/core/enums/request_enums.dart';
import 'package:equatable/equatable.dart';

class RequestModel extends Equatable {
  final String image;
  final String area;
  final String number;
  final String profilePic;
  final String description;
  final Coordinates coordinates;
  final String title;
  final String dateTime;
  final String user;
  final RequestStatus status;
  final String fullAddress;
  final String? docId;
  final String token;
  final List<VolunteerModel>? volunteers;

  RequestModel({
    required this.image,
    required this.area,
    required this.profilePic,
    required this.description,
    required this.coordinates,
    required this.title,
    required this.user,
    required this.status,
    required this.dateTime,
    this.fullAddress = '',
    this.docId = '',
    this.volunteers,
    required this.token,
    required this.number,
  });

  factory RequestModel.empty() {
    return RequestModel(
      image: '',
      area: '',
      profilePic: '',
      description: '',
      title: '',
      user: '',
      status: RequestStatus.pending,
      coordinates: Coordinates.empty(),
      dateTime: '',
      fullAddress: '',
      docId: '',
      token: '',
      number: '',
    );
  }

  factory RequestModel.fromJson(Map json) {
    print(
        '===========================> ${json['status'].toString().requestStatus}');
    return RequestModel(
      image: json['image'] ?? '',
      area: json['town'] ?? '',
      profilePic: json['profilePic'] ?? '',
      description: json['description'] ?? '',
      coordinates: Coordinates.fromJson(json['location']),
      title: json['title'] ?? '',
      user: json['user'] ?? '',
      status: json['status'].toString().requestStatus,
      dateTime: json['dateTime'] ?? '',
      fullAddress: json['fullAddress'] ?? '',
      docId: json['docId'] ?? '',
      token: json['token'] ?? '',
      number: json['number'] ?? '',
      volunteers: json['volunteers'] != null
          ? List<VolunteerModel>.from(
              json['volunteers'].map((x) => VolunteerModel.fromJson(x)))
          : null,
    );
  }
  RequestModel copyWith(
      {String? title,
      String? description,
      Coordinates? coordinates,
      String? image,
      String? area,
      String? user,
      String? profilePic,
      RequestStatus? status,
      String? dateTime,
      String? fullAddress,
      String? docId,
      String? number,
      String? token}) {
    return RequestModel(
        title: title ?? this.title,
        description: description ?? this.description,
        coordinates: coordinates ?? this.coordinates,
        image: image ?? this.image,
        area: area ?? this.area,
        user: user ?? this.user,
        profilePic: profilePic ?? this.profilePic,
        status: status ?? this.status,
        dateTime: dateTime ?? this.dateTime,
        fullAddress: fullAddress ?? this.fullAddress,
        docId: docId ?? this.docId,
        number: number ?? this.number,
        token: token ?? this.token);
  }

  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'area': area,
      'profilePic': profilePic,
      'description': description,
      'location': coordinates.toJson(), // Convert Location object to JSON
      'title': title,
      'user': user,
      'status': status.textValue,
      'dateTime': dateTime,
      'fullAddress': fullAddress,
      'docId': docId,
      'token': token,
      'volunteers': volunteers != null
          ? volunteers!.map((x) => x.toJson()).toList()
          : null,
    };
  }

  @override
  List<Object?> get props => [
        image,
        area,
        profilePic,
        description,
        coordinates,
        title,
        user,
        status,
        docId,
        token
      ];
}

class Coordinates extends Equatable {
  final double lat;
  final double lon;

  Coordinates({
    required this.lat,
    required this.lon,
  });

  factory Coordinates.fromJson(Map json) {
    return Coordinates(
      lat: json['lat'] ?? '',
      lon: json['lon'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lat': lat,
      'lon': lon,
    };
  }

  factory Coordinates.empty() {
    return Coordinates(
      lat: 0,
      lon: 0,
    );
  }

  @override
  List<Object?> get props => [lat, lon];
}

class RequestUpdateEntity {
  final String? fullAddress;
  final String? title;
  final String? description;
  final RequestStatus? status;
  final List<VolunteerModel>? volunteers;

  RequestUpdateEntity({
    this.fullAddress,
    this.title,
    this.description,
    this.status,
    this.volunteers,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (fullAddress != null) {
      data['fullAddress'] = fullAddress;
    }
    if (title != null && title!.isNotEmpty) {
      data['title'] = title;
    }
    if (description != null && description!.isNotEmpty) {
      data['description'] = description;
    }
    if (status != null) {
      data['status'] = status?.textValue;
    }
    if (volunteers != null) {
      data['volunteers'] = volunteers!.map((x) => x.toJson()).toList();
    }
    return data;
  }
}

class VolunteerModel {
  final String uid;
  final String fcmToken;

  const VolunteerModel({
    required this.uid,
    required this.fcmToken,
  });

  factory VolunteerModel.fromJson(Map json) {
    return VolunteerModel(
      uid: json['uid'] ?? '',
      fcmToken: json['fcmToken'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'fcmToken': fcmToken,
    };
  }

  VolunteerModel copyWith({String? uid, String? fcmToken}) {
    return VolunteerModel(
      uid: uid ?? this.uid,
      fcmToken: fcmToken ?? this.fcmToken,
    );
  }

  factory VolunteerModel.empty() {
    return const VolunteerModel(
      uid: '',
      fcmToken: '',
    );
  }
}
