class User {
  String id;
  String name;
  String email;
  String password;
  String? profileImage;
  String role;
  String phoneNumber;
  String gender;
  String playingLevel;
  String refreshToken;
  DateTime createdAt;
  DateTime updatedAt;
  int v;
  String clubAffiliation;
  DateTime birthday;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    this.profileImage,
    required this.role,
    required this.phoneNumber,
    required this.gender,
    required this.playingLevel,
    required this.refreshToken,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.clubAffiliation,
    required this.birthday,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      profileImage: json['profileImage'],
      role: json['role'],
      phoneNumber: json['phoneNumber'],
      gender: json['gender'],
      playingLevel: json['playingLevel'],
      refreshToken: json['refreshToken'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      v: json['__v'],
      clubAffiliation: json['clubAffiliation'],
      birthday: DateTime.parse(json['birthday']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'password': password,
      'profileImage': profileImage,
      'role': role,
      'phoneNumber': phoneNumber,
      'gender': gender,
      'playingLevel': playingLevel,
      'refreshToken': refreshToken,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': v,
      'clubAffiliation': clubAffiliation,
      'birthday': birthday.toIso8601String(),
    };
  }
}
