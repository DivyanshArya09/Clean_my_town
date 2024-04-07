class UserModel {
  final String name;
  final String email;
  final String password;
  final List<String> requests;
  final String location;
  final String profilePicture;

  UserModel({
    required this.name,
    required this.email,
    required this.password,
    required this.requests,
    required this.location,
    required this.profilePicture,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '', // Provide default value if 'name' is missing
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      requests: List<String>.from(map['requests'] ?? []),
      location: map['location'] ?? '',
      profilePicture: map['profilePicture'] ?? '',
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
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      requests: requests ?? this.requests,
      location: location ?? this.location,
      profilePicture: profilePicture ?? this.profilePicture,
    );
  }
}


/**class UserModel {
  final String name;
  final String email;
  final String password;
  final List<String> requests;
  final String location;

  UserModel({
    required this.name,
    required this.email,
    required this.password,
    required this.requests,
    required this.location,
  });

  factory UserModel.empty() {
    return UserModel(
      name: '',
      email: '',
      password: '',
      requests: [],
      location: '',
    );
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '', // Provide default value if 'name' is missing
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      requests: List<String>.from(map['requests'] ?? []),
      location: map['location'] ?? '',
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
 */