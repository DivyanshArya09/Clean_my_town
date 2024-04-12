import 'dart:core';

import 'package:equatable/equatable.dart';

class RequestModel extends Equatable {
  final String image;
  final String area;
  final String profilePic;
  final String description;
  final String location;
  final String title;
  final String dateTime;
  final String user;
  final bool status;
  final String fullAddress;

  RequestModel({
    required this.image,
    required this.area,
    required this.profilePic,
    required this.description,
    required this.location,
    required this.title,
    required this.user,
    required this.status,
    required this.dateTime,
    this.fullAddress = '',
  });

  factory RequestModel.empty() {
    return RequestModel(
      image: '',
      area: '',
      profilePic: '',
      description: '',
      title: '',
      user: '',
      status: false,
      location: '',
      dateTime: '',
      fullAddress: '',
    );
  }

  factory RequestModel.fromJson(Map json) {
    return RequestModel(
      image: json['image'] ?? '',
      area: json['town'] ?? '',
      profilePic: json['profilePic'] ?? '',
      description: json['description'] ?? '',
      location: json['location'] ?? '',
      title: json['title'] ?? '',
      user: json['user'] ?? '',
      status: json['status'] ?? false,
      dateTime: json['dateTime'] ?? '',
      fullAddress: json['fullAddress'] ?? '',
    );
  }
  RequestModel copyWith({
    String? title,
    String? description,
    String? location,
    String? image,
    String? area,
    String? user,
    String? profilePic,
    bool? status,
    String? dateTime,
    String? fullAddress,
  }) {
    return RequestModel(
      title: title ?? this.title,
      description: description ?? this.description,
      location: location ?? this.location,
      image: image ?? this.image,
      area: area ?? this.area,
      user: user ?? this.user,
      profilePic: profilePic ?? this.profilePic,
      status: status ?? this.status,
      dateTime: dateTime ?? this.dateTime,
      fullAddress: fullAddress ?? this.fullAddress,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'area': area,
      'profilePic': profilePic,
      'description': description,
      'location': location, // Convert Location object to JSON
      'title': title,
      'user': user,
      'status': status,
      'dateTime': dateTime,
      'fullAddress': fullAddress
    };
  }

  @override
  List<Object?> get props =>
      [image, area, profilePic, description, location, title, user, status];
}
