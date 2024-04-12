import 'dart:core';

import 'package:equatable/equatable.dart';

class RequestModel extends Equatable {
  final String image;
  final String area;
  final String profilePic;
  final String description;
  final Coordinates coordinates;
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
    required this.coordinates,
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
      coordinates: Coordinates.empty(),
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
      coordinates: Coordinates.fromJson(json['location']),
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
    Coordinates? coordinates,
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
      coordinates: coordinates ?? this.coordinates,
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
      'location': coordinates.toJson(), // Convert Location object to JSON
      'title': title,
      'user': user,
      'status': status,
      'dateTime': dateTime,
      'fullAddress': fullAddress
    };
  }

  @override
  List<Object?> get props =>
      [image, area, profilePic, description, coordinates, title, user, status];
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
