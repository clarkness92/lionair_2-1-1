import 'dart:convert';

List<User> userFromJson(String str) {
  var list = List<User>.from(json.decode(str).map((x) => User.fromJson(x)));
  return list;
}

String userToJson(List<User> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class User {
  User(
      {required this.iDStaff,
      this.name,
      this.gender,
      this.title,
      this.organization,
      this.company});

  int? iDStaff;
  String? name;
  String? gender;
  String? title;
  String? organization;
  String? company;

  User.fromJson(Map<String, dynamic> json) {
    iDStaff = json['IDStaff'];
    name = json['Name'];
    gender = json['Gender'];
    title = json['Title'];
    organization = json['Organization'];
    company = json['Company'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = <String, dynamic>{};
    data['IDStaff'] = iDStaff;
    data['Name'] = name;
    data['Gender'] = gender;
    data['Title'] = title;
    data['Organization'] = organization;
    data['Company'] = company;
    return data;
  }
}
