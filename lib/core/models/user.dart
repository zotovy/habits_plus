class User {
  String email;
  String name;
  String profileImgBase64String;
  bool isEmailConfirm;

  User({
    this.email,
    this.name,
    this.profileImgBase64String,
    this.isEmailConfirm,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
      'profileImgBase64String': profileImgBase64String,
      'isEmailConfirm': isEmailConfirm,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      name: json['name'],
      profileImgBase64String: json['profileImgBase64String'],
      isEmailConfirm: json['isEmailConfirm'],
    );
  }
}
