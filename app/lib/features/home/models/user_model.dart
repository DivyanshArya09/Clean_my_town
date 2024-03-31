class UserModel {
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

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '', // Provide default value if 'name' is missing
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      requests: List<String>.from(map['requests'] ?? []),
      location: map['location'] ?? '',
    );
  }

  factory UserModel.empty() {
    return UserModel(
      name: '',
      email: '',
      password: '',
      requests: [],
      location: '',
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
    };
  }

  // CopyWith method to create a new UserModel object with some fields updated
  UserModel copyWith({
    String? name,
    String? email,
    String? password,
    List<String>? requests,
    String? location,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      requests: requests ?? this.requests,
      location: location ?? this.location,
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