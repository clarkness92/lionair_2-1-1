import 'package:flutter/material.dart';

class User {
  // String? username;
  String? idemployee;
  String? namaasli;

  // User({required this.username, this.idemployee, this.namaasli});

  User({required this.idemployee, this.namaasli});

  Map<String, dynamic> data() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // data['username'] = this.username;
    data['idemployee'] = this.idemployee;
    data['namaasli'] = this.namaasli;
    return data;
  }

  User.fromJson(Map<String, dynamic> User) {
    // username = User['username'];
    idemployee = User['idemployee'];
    namaasli = User['namaasli'];
  }
}

class MultipartUpload extends StatelessWidget {
  // const MultipartUpload({super.key});

  final Widget child;

  const MultipartUpload({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
