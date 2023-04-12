import 'dart:convert';

List<User> userFromJson(String str) {
  var list = List<User>.from(json.decode(str).map((x) => User.fromJson(x)));
  return list;
}

String userToJson(List<User> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class User {
  User({
    required this.id,
    this.email,
    required this.password,
  });

  int id;
  String? email;
  String password;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        email: json["email"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "password": password,
      };
}
