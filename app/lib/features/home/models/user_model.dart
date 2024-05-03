class UserModel {
  final String name;
  final String email;
  final String password;
  final List<String> requests;
  final List<String>? acceptedRequests;
  final String location;
  final String profilePicture;
  final String? token;
  String? number;

  UserModel({
    required this.name,
    required this.email,
    required this.password,
    required this.requests,
    required this.location,
    required this.profilePicture,
    this.number,
    this.token,
    this.acceptedRequests,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '', // Provide default value if 'name' is missing
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      requests: List<String>.from(map['requests'] ?? []),
      location: map['location'] ?? '',
      profilePicture: map['profilePicture'] ?? '',
      number: map['number'] ?? '',
      token: map['fcmToken'] ?? '',
      acceptedRequests: List<String>.from(map['myacceptedrequests'] ?? []),
    );
  }

  factory UserModel.empty() {
    return UserModel(
      name: '',
      email: '',
      password: '',
      requests: [],
      location: '',
      profilePicture: '',
      number: '',
    );
  }

  // Method to convert User object to a map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'requests': requests,
      'location': location,
      'profilePicture': profilePicture,
      'number': number,
    };
  }

  // CopyWith method to create a new UserModel object with some fields updated
  UserModel copyWith({
    String? name,
    String? email,
    String? password,
    List<String>? requests,
    String? location,
    String? profilePicture,
    String? number,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      requests: requests ?? this.requests,
      location: location ?? this.location,
      profilePicture: profilePicture ?? this.profilePicture,
      number: number ?? this.number,
    );
  }
}
