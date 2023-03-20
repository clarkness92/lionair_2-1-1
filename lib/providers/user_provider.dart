import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../models/user.dart';

const urlapi = url;

class UserProvider with ChangeNotifier {
  String iDStaff = "";
  String? name;
  String? gender;
  String? title;
  String? organization;
  String? company;
  // String email = "";
  // String telephone = "";
  // String? iDStaff;

  List<User> user2 = [];

  UserProvider() {
    getUserUrl();
  }

  getUserUrl() async {
    final url = Uri.http(urlapi, 'api/jonatan/api/staff?id=53031290');
    final resp = await http.get(url,
        // body: {
        //   'xEmail': objtext
        // },
        headers: {
          "Access-Control-Allow-Origin": "*",
          "Access-Control-Allow-Credentials": "true",
          'Content-type': 'application/json',
          'Accept': 'application/json'
        });
    final response = userFromJson(resp.body);
    user2 = response;
    notifyListeners();
  }
}
