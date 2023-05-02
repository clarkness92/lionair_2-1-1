import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import '../widgets/input_decoration.dart';
import '../constants.dart';
import '../screens/home_screen.dart';
import 'package:http/http.dart' as http;
import 'package:xml2json/xml2json.dart';
import 'package:xml/xml.dart' as xml;
import 'package:status_alert/status_alert.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  bool loading = false;
  List hasil_result = [];
  List hasil_result1 = [];
  List hasil_result2 = [];
  List hasil_result3 = [];
  Xml2Json xml2json = Xml2Json();
  var hasilJson;
  String userapi = 'admin';
  String passapi = 'admin';

  TextEditingController destination = TextEditingController();
  TextEditingController idpegawai = TextEditingController();
  TextEditingController password = TextEditingController();

  void _cekUser(String idpegawai, String password) async {
    final temporaryList = [];

    String objBody = '<?xml version="1.0" encoding="utf-8"?>' +
        '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">' +
        '<soap:Body>' +
        '<CekUser xmlns="http://tempuri.org/">' +
        '<Usernameapi>$userapi</Usernameapi>' +
        '<Passwordapi>$passapi</Passwordapi>' +
        '<Username>$idpegawai</Username>' +
        '<Password>$password</Password>' +
        '</CekUser>' +
        '</soap:Body>' +
        '</soap:Envelope>';

    final response = await http.post(Uri.parse(url_CekUser),
        headers: {
          "Access-Control-Allow-Origin": "*",
          'SOAPAction': 'http://tempuri.org/CekUser',
          "Access-Control-Allow-Credentials": "true",
          'Content-type': 'text/xml; charset=utf-8',
        },
        body: objBody);

    if (response.statusCode == 200) {
      final document = xml.XmlDocument.parse(response.body);

      // debugPrint("=================");
      // debugPrint(
      //     "document.toXmlString : ${document.toXmlString(pretty: true, indent: '\t')}");
      // debugPrint("=================");

      final listResultAll = document.findAllElements('CekUser');

      for (final list_result in listResultAll) {
        final username = list_result.findElements('USERNAME').first.text;
        final idemployee = list_result.findElements('IDEMPLOYEE').first.text;
        final namaasli = list_result.findElements('NAMAASLI').first.text;
        final division = list_result.findElements('DIVISION').first.text;
        final gender = list_result.findElements('GENDER').first.text;
        temporaryList.add({
          'username': username,
          'idemployee': idemployee,
          'namaasli': namaasli,
          'division': division,
          'gender': gender,
        });
        debugPrint("object");
        hasilJson = jsonEncode(temporaryList);

        debugPrint(hasilJson);
        debugPrint("object_hasilJson");
      }
      loading = false;
    } else {
      debugPrint('Error: ${response.statusCode}');
      StatusAlert.show(
        context,
        duration: const Duration(seconds: 1),
        configuration:
            const IconConfiguration(icon: Icons.error, color: Colors.red),
        title: "Cek User Failed, ${response.statusCode}",
        backgroundColor: Colors.grey[300],
      );
      setState(() {
        loading = false;
      });
    }
    setState(() {
      hasil_result = temporaryList;
      loading = true;
    });
  }

  void getData(String destination, String idpegawai) async {
    final temporaryList1 = [];

    String objBody = '<?xml version="1.0" encoding="utf-8"?>' +
        '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">' +
        '<soap:Body>' +
        '<GetReservationByIDSTaffPending xmlns="http://tempuri.org/">' +
        '<UsernameApi>$userapi</UsernameApi>' +
        '<PasswordApi>$passapi</PasswordApi>' +
        '<DESTINATION>BLJ</DESTINATION>' +
        '<IDSTAFF>$idpegawai</IDSTAFF>' + //dibuat statis agar mudah bolak balik page => ganti dengan $idpegawai jika ingin dinamis
        '</GetReservationByIDSTaffPending>' +
        '</soap:Body>' +
        '</soap:Envelope>';

    final response =
        await http.post(Uri.parse(url_GetReservationByIDSTaffPending),
            headers: <String, String>{
              "Access-Control-Allow-Origin": "*",
              'SOAPAction': 'http://tempuri.org/GetReservationByIDSTaffPending',
              "Access-Control-Allow-Credentials": "true",
              'Content-type': 'text/xml; charset=utf-8',
            },
            body: objBody);

    if (response.statusCode == 200) {
      final document = xml.XmlDocument.parse(response.body);

      // debugPrint("=================");
      // debugPrint(
      //     "document.toXmlString : ${document.toXmlString(pretty: true, indent: '\t')}");
      // debugPrint("=================");

      final listResultAll1 = document.findAllElements('_x002D_');

      for (final list_result in listResultAll1) {
        final idx = list_result.findElements('IDX').first.text;
        final checkin = list_result.findElements('CHECKIN').first.text;
        final checkout = list_result.findElements('CHECKOUT').first.text;
        final necessary = list_result.findElements('NECESSARY').first.text;
        final notes = list_result.findElements('NOTES').first.text;
        final insertdate = list_result.findElements('INSERTDATE').first.text;
        temporaryList1.add({
          'idx': idx,
          'checkin': checkin,
          'checkout': checkout,
          'necessary': necessary,
          'notes': notes,
          'insertdate': insertdate,
        });
        debugPrint("object 2");
        hasilJson = jsonEncode(temporaryList1);

        debugPrint(hasilJson);
        debugPrint("object_hasilJson 2");
      }
      loading = false;
    } else {
      debugPrint('Error: ${response.statusCode}');
      StatusAlert.show(
        context,
        duration: const Duration(seconds: 1),
        configuration:
            const IconConfiguration(icon: Icons.error, color: Colors.red),
        title: "Get Data1 Failed, ${response.statusCode}",
        backgroundColor: Colors.grey[300],
      );
      setState(() {
        loading = false;
      });
    }
    setState(() {
      hasil_result1 = temporaryList1;
      loading = true;
    });
  }

  void getReservation(String destination, String idpegawai) async {
    final temporaryList2 = [];

    String objBody = '<?xml version="1.0" encoding="utf-8"?>' +
        '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">' +
        '<soap:Body>' +
        '<Checktime_GetCurrentStay xmlns="http://tempuri.org/">' +
        '<UsernameAPI>$userapi</UsernameAPI>' +
        '<PasswordAPI>$passapi</PasswordAPI>' +
        '<Destination>BLJ</Destination>' +
        '<IDSTAFF>$idpegawai</IDSTAFF>' +
        '</Checktime_GetCurrentStay>' +
        '</soap:Body>' +
        '</soap:Envelope>';

    final response = await http.post(Uri.parse(url_Checktime_GetCurrentStay),
        headers: <String, String>{
          "Access-Control-Allow-Origin": "*",
          'SOAPAction': 'http://tempuri.org/Checktime_GetCurrentStay',
          "Access-Control-Allow-Credentials": "true",
          'Content-type': 'text/xml; charset=utf-8',
        },
        body: objBody);

    if (response.statusCode == 200) {
      final document = xml.XmlDocument.parse(response.body);

      // debugPrint("=================");
      // debugPrint(
      //     "document.toXmlString : ${document.toXmlString(pretty: true, indent: '\t')}");
      // debugPrint("=================");

      final listResultAll2 = document.findAllElements('_x002D_');

      for (final list_result in listResultAll2) {
        final idx = list_result.findElements('IDX').first.text;
        final idkamar = list_result.findElements('IDKAMAR').first.text;
        final areamess = list_result.findElements('AREAMESS').first.text;
        final blok = list_result.findElements('BLOK').first.text;
        final nokamar = list_result.findElements('NOKAMAR').first.text;
        final namabed = list_result.findElements('NAMABED').first.text;
        final bookin = list_result.findElements('BOOKIN').first.text;
        final bookout = list_result.findElements('BOOKOUT').first.text;
        temporaryList2.add({
          'idx': idx,
          'idkamar': idkamar,
          'areamess': areamess,
          'blok': blok,
          'nokamar': nokamar,
          'namabed': namabed,
          'bookin': bookin,
          'bookout': bookout
        });
        debugPrint("object 3");
        hasilJson = jsonEncode(temporaryList2);

        debugPrint(hasilJson);
        debugPrint("object_hasilJson 3");
      }
      Future.delayed(const Duration(seconds: 5), () {
        if (hasil_result.isEmpty) {
          sweatAlertDenied(context);
        } else {
          StatusAlert.show(context,
              duration: const Duration(seconds: 1),
              configuration: const IconConfiguration(
                  icon: Icons.done, color: Colors.green),
              title: "Login Success",
              backgroundColor: Colors.grey[300]);
          Timer(const Duration(seconds: 1), () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => HomeScreen(
                  userapi: userapi,
                  passapi: passapi,
                  data: hasil_result,
                  data1: hasil_result1,
                  data2: hasil_result2),
            ));
          });
        }
        setState(() {
          loading = false;
        });
      });
    } else {
      debugPrint('Error: ${response.statusCode}');
      StatusAlert.show(
        context,
        duration: const Duration(seconds: 1),
        configuration:
            const IconConfiguration(icon: Icons.error, color: Colors.red),
        title: "Get Data2 Failed, ${response.statusCode}",
        backgroundColor: Colors.grey[300],
      );
      setState(() {
        loading = false;
      });
    }
    setState(() {
      hasil_result2 = temporaryList2;
      loading = true;
    });
  }

  // Future<void> _showNotification() async {
  //   const AndroidNotificationDetails androidPlatformChannelSpecifics =
  //       AndroidNotificationDetails(
  //     'your channel id',
  //     'your channel name',
  //     importance: Importance.max,
  //     priority: Priority.high,
  //     ticker: 'ticker',
  //   );
  //   const NotificationDetails platformChannelSpecifics =
  //       NotificationDetails(android: androidPlatformChannelSpecifics);
  //   await flutterLocalNotificationsPlugin.show(
  //     0,
  //     'New Notification',
  //     'Hi, ${idpegawai.text}',
  //     platformChannelSpecifics,
  //     payload: 'item x',
  //   );
  // }

  // void initstate() {
  //   super.initState();
  //   _showNotification();
  // }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/logo.png'),
                  ),
                ),
                width: double.infinity,
                height: size.height * 0.4,
              ),
              loginForm(context),
            ],
          ),
        ),
      ),
    );
  }

  SingleChildScrollView loginForm(BuildContext context) {
    // final userProvider = Provider.of<UserProvider>(context);
    // userProvider.getUserUrl();
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 250),
          Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.symmetric(horizontal: 30),
            width: double.infinity,
            // height: 350,
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
                Text('Login',
                    style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 30),
                Form(
                  key: _formKey,
                  // autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      TextFormField(
                        autofocus: true,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        autocorrect: false,
                        controller: idpegawai,
                        decoration: InputDecorations.inputDecoration(
                          hintext: '1234***',
                          labeltext: 'ID Pegawai',
                          icon: const Icon(Icons.credit_card_outlined),
                        ),
                        validator: (value) {
                          String pattern = r"[0-9]";
                          RegExp regExp = RegExp(pattern);
                          return regExp.hasMatch(value ?? '')
                              ? null
                              : 'Invalid input';
                        },
                      ),
                      const SizedBox(height: 30),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        autocorrect: false,
                        controller: password,
                        obscureText: true,
                        decoration: InputDecorations.inputDecoration(
                          hintext: '*****',
                          labeltext: 'Password',
                          icon: const Icon(Icons.lock_outlined),
                        ),
                        //VALIDATOR Password
                        validator: (value) {
                          return (value != null && value.length >= 3)
                              ? null
                              : 'Password must be greater than or equal to 3 characters';
                        },
                      ),
                      const SizedBox(height: 30),
                      loading
                          ? const CircularProgressIndicator()
                          : MaterialButton(
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
                                setState(() {
                                  loading = true;
                                });
                                _cekUser(idpegawai.text, password.text);
                                getData(destination.text, idpegawai.text);
                                getReservation(
                                    destination.text, idpegawai.text);
                                // _showNotification();
                              }),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // const SizedBox(height: 20),
          // const Text('OR'),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: <Widget>[
          //     TextButton(
          //       style: TextButton.styleFrom(
          //         textStyle: const TextStyle(
          //             fontSize: 17, fontWeight: FontWeight.bold),
          //       ),
          //       onPressed: () async {
          //         Navigator.pushReplacementNamed(context, 'register');
          //       },
          //       child: const Text('Create a new account'),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}

void sweatAlertDenied(BuildContext context) {
  StatusAlert.show(
    context,
    duration: const Duration(seconds: 1),
    configuration:
        const IconConfiguration(icon: Icons.error, color: Colors.red),
    title: "Login gagal, sudah registrasi?",
    backgroundColor: Colors.grey[300],
  );
}
