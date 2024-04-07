class ProfileModel {
  final String name;
  final dynamic image;

  ProfileModel({
    required this.name,
    required this.image,
  });

  factory ProfileModel.empty() {
    return ProfileModel(
      name: '',
      image: '',
    );
  }

  ProfileModel copyWith({
    String? name,
    dynamic image,
  }) {
    return ProfileModel(
      name: name ?? this.name,
      image: image ?? this.image,
    );
  }
}
