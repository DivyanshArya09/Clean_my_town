class ProfileModel {
  final String name;
  dynamic image;
  final String email;
  final bool isChanged;
  String? number;

  ProfileModel({
    required this.name,
    required this.image,
    required this.email,
    this.isChanged = false,
    this.number,
  });

  factory ProfileModel.empty() {
    return ProfileModel(
      name: '',
      image: '',
      email: '',
      isChanged: false,
      number: '',
    );
  }

  ProfileModel copyWith({
    String? name,
    dynamic image,
    String? email,
    bool? isChanged,
    String? number,
  }) {
    return ProfileModel(
      name: name ?? this.name,
      image: image ?? this.image,
      email: email ?? this.email,
      isChanged: isChanged ?? this.isChanged,
      number: number ?? this.number,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'profilePicture': image,
      'number': number,
    };
  }
}
