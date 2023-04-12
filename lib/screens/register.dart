import 'dart:convert';
// import 'dart:ffi';

import 'dart:convert';
// import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xml2json/xml2json.dart';
import '../constants.dart';
import '../widgets/input_decoration.dart';
import 'package:xml/xml.dart' as xml;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'login_screen.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:http/http.dart' as http;
import 'package:xml2json/xml2json.dart';
import '../constants.dart';
import '../widgets/input_decoration.dart';
import 'package:xml/xml.dart' as xml;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'login_screen.dart';
import 'package:flutter/foundation.dart' show debugPrint;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  // String? _valGender;
  // List _listGender = ["Male", "Female"];

  final _formKey = GlobalKey<FormState>();
  Xml2Json xml2json = Xml2Json();

  TextEditingController iDStaff = TextEditingController();
  TextEditingController nama = TextEditingController();

  String? _gender;

  DropdownMenuItem<String> buildmenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      );

  final items = ['Male', 'Female'];

  void _sendRequest(String iDStaff, String nama) async {
    final String soapEnvelope = '<?xml version="1.0" encoding="utf-8"?>' +
        '<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">' +
        '<soap:Body>' +
        '<InputWebReservation xmlns="http://tempuri.org/">' +
        '<UsernameApi>admin</UsernameApi>' +
        '<PasswordApi>admin</PasswordApi>' +
        '<DESTINATION>String</DESTINATION>' +
        '<IDREFF>string</IDREFF>' +
        '<IDSTAFF>$iDStaff</IDSTAFF>' +
        '<NAME>$nama</NAME>' +
        '<GENDER>MALE</GENDER>' +
        '<TITLE>ADMIN</TITLE>' +
        '<CHECKIN>2022-01-01T00:00:00</CHECKIN>' +
        '<CHECKOUT>2022-01-01T00:00:00</CHECKOUT>' +
        '<NECESSARY>NULL</NECESSARY>' +
        '<NOTES>string</NOTES>' +
        '</InputWebReservation>' +
        '</soap:Body>' +
        '</soap:Envelope>';

    final response = await http.post(Uri.parse(url_InputWebReservation),
        headers: <String, String>{
          "Access-Control-Allow-Origin": "*",
          'SOAPAction': 'http://tempuri.org/InputWebReservation',
          'Access-Control-Allow-Credentials': 'true',
          'Content-type': 'text/xml; charset=utf-8'
        },
        body: soapEnvelope);

    if (response.statusCode == 200) {
      final responseBody = response.body;
      final parsedResponse = xml.XmlDocument.parse(responseBody);
      final result = parsedResponse
          .findAllElements('InputWebReservationResult')
          .single
          .text;
      print('Result: $result');
      sweatAlertAccess(context);
    } else {
      print('Error: ${response.statusCode}');
      sweatAlertDenied(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            registerForm(context),
          ],
        ),
      ),
    );
  }

  SingleChildScrollView registerForm(BuildContext context) {
    return SingleChildScrollView(
      key: _formKey,
      child: Column(
        children: <Widget>[
          const SizedBox(height: 150),
          Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.symmetric(horizontal: 30),
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 15,
                    offset: Offset(10, 5),
                  )
                ]),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Text('Register', style: Theme.of(context).textTheme.headline4),
                const SizedBox(height: 30),
                Form(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: iDStaff,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        autocorrect: false,
                        decoration: InputDecorations.inputDecoration(
                          hintext: '1254***',
                          labeltext: 'ID Staff',
                          icon: const Icon(Icons.credit_card),
                        ),
                        validator: (value) {
                          String pattern = r"[0-9]";
                          RegExp regExp = RegExp(pattern);
                          return regExp.hasMatch(value ?? '')
                              ? null
                              : 'Invalid input';
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        autocorrect: false,
                        obscureText: true,
                        decoration: InputDecorations.inputDecoration(
                          hintext: '******',
                          labeltext: 'Password',
                          icon: const Icon(Icons.lock),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: nama,
                        autocorrect: false,
                        decoration: InputDecorations.inputDecoration(
                            hintext: 'Jon Doe',
                            labeltext: 'Nama',
                            icon: const Icon(Icons.person)),
                      ),
                      const SizedBox(height: 20),
                      Column(
                        children: [
                          DropdownButtonFormField(
                            itemHeight: null,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.transgender),
                            ),
                            hint: const Text('Gender'),
                            items: items.map(buildmenuItem).toList(),
                            onChanged: (value) =>
                                setState(() => _gender = value),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        autocorrect: false,
                        decoration: InputDecorations.inputDecoration(
                            hintext: 'SPV',
                            labeltext: 'Title',
                            icon: const Icon(Icons.business_center)),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        autocorrect: false,
                        decoration: InputDecorations.inputDecoration(
                            hintext: 'Lion Air',
                            labeltext: 'Company',
                            icon: const Icon(Icons.business_rounded)),
                      ),
                      const SizedBox(height: 30),
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        disabledColor: Colors.grey,
                        color: Colors.blueAccent,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 80, vertical: 15),
                          child: const Text('Submit',
                              style: TextStyle(color: Colors.white)),
                        ),
                        onPressed: () async {
                          _sendRequest(iDStaff.text, nama.text);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
  // SingleChildScrollView
}

void sweatAlertAccess(BuildContext context) {
  Alert(
    context: context,
    type: AlertType.success,
    title: "Registrasi berhasil",
    buttons: [
      DialogButton(
          child: Text(
            "Login",
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          onPressed: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => LoginScreen()))),
    ],
  ).show();
  return;
}

void sweatAlertDenied(BuildContext context) {
  Alert(
    context: context,
    type: AlertType.error,
    title: "Registrasi Gagal",
    buttons: [
      DialogButton(
          child: Text(
            "Try Again",
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          onPressed: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => RegisterScreen()))),
    ],
  ).show();
  return;
}
