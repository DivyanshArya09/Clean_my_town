class ProfileModel {
  final String name;
  dynamic image;
  final String email;
  final bool isChanged;

  ProfileModel({
    required this.name,
    required this.image,
    required this.email,
    this.isChanged = false,
  });

  factory ProfileModel.empty() {
    return ProfileModel(
      name: '',
      image: '',
      email: '',
      isChanged: false,
    );
  }

  ProfileModel copyWith({
    String? name,
    dynamic image,
    String? email,
    bool? isChanged,
  }) {
    return ProfileModel(
      name: name ?? this.name,
      image: image ?? this.image,
      email: email ?? this.email,
      isChanged: isChanged ?? this.isChanged,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'profilePicture': image,
    };
  }
}
