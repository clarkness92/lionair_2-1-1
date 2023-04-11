import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../models/user.dart';

const urlapi = url_CekUser;

class UserProvider with ChangeNotifier {
  String? USERNAME;
  String? IDEMPLOYEE;
  String? NAMAASLI;
  String? DIVISION;
  String? EMAIL;
  String? PHONE;

  List<User> person = [];

  String toXml() {
    return '<User><IDSTAFF>$IDEMPLOYEE</IDSTAFF><NAME>$NAMAASLI</NAME></User>';
  }

  // UserProvider() {
  //   getUserUrl();
  // }

  // getUserUrl() async {
  //   // print('saya ada disini');
  //   final url = Uri.http(url_CekUser);
  //   final resp = await http.get(url, headers: {
  //     // "Access-Control-Allow-Origin": "*",
  //     // "Access-Control-Allow-Credentials": "true",
  //     'Content-type': 'text/xml',
  //   });
  //   final response = userFromJson(resp.body);
  //   person = response;
  //   notifyListeners();
  // }
}
