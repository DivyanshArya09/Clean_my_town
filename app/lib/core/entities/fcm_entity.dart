import 'dart:convert';

class FCMUpdateEntity {
  final String token;

  FCMUpdateEntity({required this.token});

  FCMUpdateEntity copyWith({
    String? token,
  }) {
    return FCMUpdateEntity(
      token: token ?? this.token,
    );
  }

  Map<String, String> toMap() {
    return {'token': token};
  }

  factory FCMUpdateEntity.fromMap(Map<String, dynamic> map) {
    return FCMUpdateEntity(
      token: map['token'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory FCMUpdateEntity.fromJson(String source) =>
      FCMUpdateEntity.fromMap(json.decode(source));

  @override
  String toString() => 'FCMUpdateEntity(token: $token)';
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FCMUpdateEntity && other.token == token;
  }

  @override
  int get hashCode => token.hashCode;
}
