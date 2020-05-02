class User {
  String id;
  String email;
  String name;
  String profileImgBase64String;
  String profileImageUrl;
  bool isEmailConfirm;

  User({
    this.id,
    this.email,
    this.name,
    this.profileImgBase64String,
    this.isEmailConfirm,
    this.profileImageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'profileImgBase64String': profileImgBase64String,
      'isEmailConfirm': isEmailConfirm,
    };
  }

  Map<String, dynamic> toDocument() {
    return {
      'email': email,
      'name': name,
      'profileImgUrl': profileImageUrl,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      name: json['name'] == null ? "User" : json['name'],
      profileImgBase64String: json['profileImgBase64String'],
      isEmailConfirm: json['isEmailConfirm'],
    );
  }
}
