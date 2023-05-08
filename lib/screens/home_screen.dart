// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables, no_logic_in_create_state, prefer_adjacent_string_concatenation, prefer_interpolation_to_compose_strings, non_constant_identifier_names, use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lionair_2/screens/lihat_reservasi.dart';
import 'package:lionair_2/screens/profile.dart';
import 'package:status_alert/status_alert.dart';
import 'laporan.dart';
import 'reservasi_mess.dart';
import '../constants.dart';
import 'package:http/http.dart' as http;
import 'package:xml2json/xml2json.dart';
import 'package:xml/xml.dart' as xml;

class HomeScreen extends StatefulWidget {
  var userapi;
  var passapi;
  var data;
  var data1;
  var data2;

  HomeScreen(
      {super.key,
      required this.userapi,
      required this.passapi,
      required this.data,
      required this.data1,
      required this.data2});

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState(userapi, passapi, data, data1, data2);
}

class _HomeScreenState extends State<HomeScreen> {
  _HomeScreenState(
      this.userapi, this.passapi, this.data, this.data1, this.data2);
  late PageController _pageController;
  int activePage = 0;
  int maxLimit = 19;
  int indiLength = 0;

  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  bool loading1 = false;
  bool loading2 = false;
  bool loading3 = false;
  bool loading4 = false;

  List data = [];
  List data1 = [];
  List data2 = [];
  List data3 = [];
  List data4 = [];
  List dataBaru1 = [];
  List dataBaru2 = [];
  Xml2Json xml2json = Xml2Json();
  var hasilJson;
  var vidxBaru;
  var bookinBaru;
  var bookoutBaru;
  var userapi;
  var passapi;

  TextEditingController destination = TextEditingController();
  TextEditingController idpegawai = TextEditingController();
  TextEditingController vidx = TextEditingController();
  TextEditingController otp = TextEditingController();
  TextEditingController phone = TextEditingController();

  void updateData1(String destination, String idpegawai) async {
    final temporaryList1 = [];
    idpegawai = data[0]['idemployee'];
    data1.clear();

    String objBody = '<?xml version="1.0" encoding="utf-8"?>' +
        '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">' +
        '<soap:Body>' +
        '<GetReservationByIDSTaffPending xmlns="http://tempuri.org/">' +
        '<UsernameApi>$userapi</UsernameApi>' +
        '<PasswordApi>$passapi</PasswordApi>' +
        '<DESTINATION>BLJ</DESTINATION>' +
        '<IDSTAFF>$idpegawai</IDSTAFF>' +
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
        debugPrint("object 1.1");
        hasilJson = jsonEncode(temporaryList1);

        debugPrint(hasilJson);
        debugPrint("object_hasilJson 1.1");
      }
      loading = false;
    } else {
      debugPrint('Error: ${response.statusCode}');
      StatusAlert.show(
        context,
        duration: const Duration(seconds: 1),
        configuration:
            const IconConfiguration(icon: Icons.error, color: Colors.red),
        title: "Update1 Failed, ${response.statusCode}",
        backgroundColor: Colors.grey[300],
      );
    }
    setState(() {
      dataBaru1 = temporaryList1;
      loading = true;
      debugPrint('$dataBaru1');
    });
  }

  void updateData2(String destination, String idpegawai) async {
    final temporaryList2 = [];
    idpegawai = data[0]['idemployee'];
    data2.clear();

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
        debugPrint("object 2.1");
        hasilJson = jsonEncode(temporaryList2);

        debugPrint(hasilJson);
        debugPrint("object_hasilJson 2.1");
      }
      Future.delayed(const Duration(seconds: 3), () {
        Map<String, dynamic> map1 =
            Map.fromIterable(data1, key: (e) => e['idx']);
        Map<String, dynamic> map2 =
            Map.fromIterable(dataBaru1, key: (e) => e['idx']);

        map1.addAll(map2);

        List mergedList = map1.values.toList();

        // debugPrint('$mergedList');

        Map<String, dynamic> map3 =
            Map.fromIterable(data2, key: (e) => e['idx']);
        Map<String, dynamic> map4 =
            Map.fromIterable(dataBaru2, key: (e) => e['idx']);

        map3.addAll(map4);

        List mergedList2 = map3.values.toList();

        // debugPrint('$mergedList2');

        setState(() {
          data1 = mergedList;
          data2 = mergedList2;
          indiLength = data1.length;
          activePage = 0;
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
        title: "Update2 Failed, ${response.statusCode}",
        backgroundColor: Colors.grey[300],
      );
    }
    setState(() {
      dataBaru2 = temporaryList2;
      loading = true;
      // debugPrint('$dataBaru2');
    });
  }

  void getReserveHist(String destination, String idpegawai) async {
    final temporaryList3 = [];
    idpegawai = data[0]['idemployee'];

    String objBody = '<?xml version="1.0" encoding="utf-8"?>' +
        '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">' +
        '<soap:Body>' +
        '<Checktime_GetHistoryStay xmlns="http://tempuri.org/">' +
        '<UsernameAPI>$userapi</UsernameAPI>' +
        '<PasswordAPI>$passapi</PasswordAPI>' +
        '<Destination>BLJ</Destination>' +
        '<IDSTAFF>$idpegawai</IDSTAFF>' +
        '</Checktime_GetHistoryStay>' +
        '</soap:Body>' +
        '</soap:Envelope>';

    final response = await http.post(Uri.parse(url_Checktime_GetHistoryStay),
        headers: <String, String>{
          "Access-Control-Allow-Origin": "*",
          'SOAPAction': 'http://tempuri.org/Checktime_GetHistoryStay',
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

      final listResultAll3 = document.findAllElements('_x002D_');

      for (final list_result in listResultAll3) {
        final idx = list_result.findElements('IDX').first.text;
        final docstate = list_result.findElements('DOCSTATE').first.text;
        final idkamar = list_result.findElements('IDKAMAR').first.text;
        final areamess = list_result.findElements('AREAMESS').first.text;
        final blok = list_result.findElements('BLOK').first.text;
        final nokamar = list_result.findElements('NOKAMAR').first.text;
        final namabed = list_result.findElements('NAMABED').first.text;
        final bookin = list_result.findElements('BOOKIN').first.text;
        final bookout = list_result.findElements('BOOKOUT').first.text;
        if (docstate == "VOID") {
          temporaryList3.add({
            'idx': idx,
            'docstate': docstate,
            'idkamar': idkamar,
            'areamess': areamess,
            'blok': blok,
            'nokamar': nokamar,
            'namabed': namabed,
            'bookin': bookin,
            'bookout': bookout,
          });
        } else {
          final checkin = list_result.findElements('CHECKIN').first.text;
          final checkout = list_result.findElements('CHECKOUT').first.text;
          temporaryList3.add({
            'idx': idx,
            'docstate': docstate,
            'idkamar': idkamar,
            'areamess': areamess,
            'blok': blok,
            'nokamar': nokamar,
            'namabed': namabed,
            'bookin': bookin,
            'bookout': bookout,
            'checkin': checkin,
            'checkout': checkout
          });
        }
        debugPrint("object 3");
        hasilJson = jsonEncode(temporaryList3);

        debugPrint(hasilJson);
        debugPrint("object_hasilJson 3");
      }
      Future.delayed(const Duration(seconds: 5), () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => LihatDataEmployee(
            userapi: userapi,
            passapi: passapi,
            data: data,
            data1: data1,
            data2: data2,
            data3: data3,
          ),
        ));
        setState(() {
          loading2 = false;
        });
      });
    } else {
      debugPrint('Error: ${response.statusCode}');
      StatusAlert.show(
        context,
        duration: const Duration(seconds: 1),
        configuration:
            const IconConfiguration(icon: Icons.error, color: Colors.red),
        title: "Get Data3 Failed, ${response.statusCode}",
        backgroundColor: Colors.grey[300],
      );
    }
    setState(() {
      data3 = temporaryList3;
      loading2 = true;
    });
  }

  void getReport(String destination, String vidx, index) async {
    final temporaryList5 = [];
    vidx = data2[index]['idx'];
    String bookin = data2[index]['bookin'];
    String bookout = data2[index]['bookout'];

    String objBody = '<?xml version="1.0" encoding="utf-8"?>' +
        '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">' +
        '<soap:Body>' +
        '<TenantReport_GetDataVIDX xmlns="http://tempuri.org/">' +
        '<UsernameAPI>$userapi</UsernameAPI>' +
        '<PasswordAPI>$passapi</PasswordAPI>' +
        '<Destination>BLJ</Destination>' +
        '<VIDX>$vidx</VIDX>' +
        '</TenantReport_GetDataVIDX>' +
        '</soap:Body>' +
        '</soap:Envelope>';

    final response = await http.post(Uri.parse(url_TenantReport_GetDataVIDX),
        headers: <String, String>{
          "Access-Control-Allow-Origin": "*",
          'SOAPAction': 'http://tempuri.org/TenantReport_GetDataVIDX',
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

      final listResultAll5 = document.findAllElements('_x002D_');

      for (final list_result in listResultAll5) {
        final idx = list_result.findElements('IDX').first.text;
        final vidx = list_result.findElements('VIDX').first.text;
        final date = list_result.findElements('DATE').first.text;
        final category = list_result.findElements('CATEGORY').first.text;
        final description = list_result.findElements('DESCRIPTION').first.text;
        final resolution = list_result.findElements('RESOLUTION').first.text;
        final userinsert = list_result.findElements('USERINSERT').first.text;
        final status = list_result.findElements('STATUS').first.text;
        temporaryList5.add({
          'idx': idx,
          'vidx': vidx,
          'date': date,
          'category': category,
          'description': description,
          'resolution': resolution,
          'userinsert': userinsert,
          'status': status
        });
        debugPrint("object 4");
        hasilJson = jsonEncode(temporaryList5);

        debugPrint(hasilJson);
        debugPrint("object_hasilJson 4");
      }
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Lihatlaporan(
            userapi: userapi,
            passapi: passapi,
            data: data,
            data1: data1,
            data2: data2,
            data3: data3,
            data4: data4,
            vidx4: vidxBaru,
            bookin3: bookinBaru,
            bookout3: bookoutBaru,
          ),
        ));
        setState(() {
          loading3 = false;
        });
      });
    } else {
      debugPrint('Error: ${response.statusCode}');
      StatusAlert.show(
        context,
        duration: const Duration(seconds: 1),
        configuration:
            const IconConfiguration(icon: Icons.error, color: Colors.red),
        title: "Get Data4 Failed, ${response.statusCode}",
        backgroundColor: Colors.grey[300],
      );
    }
    setState(() {
      data4 = temporaryList5;
      vidxBaru = vidx;
      bookinBaru = bookin;
      bookoutBaru = bookout;
      loading3 = true;
    });
  }

  void getOTP(String phone, index) async {
    String idreff = data2[index]['idx'];
    String userinsert = data[0]['namaasli'];

    String objBody = '<?xml version="1.0" encoding="utf-8"?>' +
        '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">' +
        '<soap:Body>' +
        '<GetOTPWA xmlns="http://tempuri.org/">' +
        '<USERNAMEAPI>$userapi</USERNAMEAPI>' +
        '<PASSWORDAPI>$passapi</PASSWORDAPI>' +
        '<CATEGORY>ADR_MESS_CHECKTIME</CATEGORY>' +
        '<IDREFF>$idreff</IDREFF>' +
        '<TONUMBER>$phone</TONUMBER>' +
        '<VALUE>string</VALUE>' +
        '<NOTES>string</NOTES>' +
        '<USERINSERT>$userinsert</USERINSERT>' +
        '</GetOTPWA>' +
        '</soap:Body>' +
        '</soap:Envelope>';

    final response = await http.post(Uri.parse(url_GetOTPWA),
        headers: <String, String>{
          "Access-Control-Allow-Origin": "*",
          'SOAPAction': 'http://tempuri.org/GetOTPWA',
          "Access-Control-Allow-Credentials": "true",
          'Content-type': 'text/xml; charset=utf-8',
        },
        body: objBody);

    if (response.statusCode == 200) {
      final responseBody = response.body;
      final parsedResponse = xml.XmlDocument.parse(responseBody);
      final result = parsedResponse.findAllElements('_x002D_').single.text;
      debugPrint('Result: $result');
      StatusAlert.show(context,
          duration: const Duration(seconds: 1),
          configuration:
              const IconConfiguration(icon: Icons.done, color: Colors.green),
          title: "OTP has been sent to your WhatsApp",
          subtitle: "Please Check!!",
          backgroundColor: Colors.grey[300]);
    } else {
      debugPrint('Error: ${response.statusCode}');
      StatusAlert.show(
        context,
        duration: const Duration(seconds: 1),
        configuration:
            const IconConfiguration(icon: Icons.error, color: Colors.red),
        title: "Get OTP Failed, ${response.statusCode}",
        backgroundColor: Colors.grey[300],
      );
    }
  }

  void cekOTP(String otp, index) async {
    String idreff1 = data2[index]['idx'];

    String objBody = '<?xml version="1.0" encoding="utf-8"?>' +
        '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">' +
        '<soap:Body>' +
        '<OpenOTP xmlns="http://tempuri.org/">' +
        '<USERNAMEAPI>$userapi</USERNAMEAPI>' +
        '<PASSWORDAPI>$passapi</PASSWORDAPI>' +
        '<IDREFF>$idreff1</IDREFF>' +
        '<OTP>$otp</OTP>' +
        '</OpenOTP>' +
        '</soap:Body>' +
        '</soap:Envelope>';

    final response = await http.post(Uri.parse(url_OpenOTP),
        headers: <String, String>{
          "Access-Control-Allow-Origin": "*",
          'SOAPAction': 'http://tempuri.org/OpenOTP',
          "Access-Control-Allow-Credentials": "true",
          'Content-type': 'text/xml; charset=utf-8',
        },
        body: objBody);

    debugPrint(objBody);

    if (response.statusCode == 200) {
      final responseBody = response.body;
      final parsedResponse = xml.XmlDocument.parse(responseBody);
      final result = parsedResponse.findAllElements('_x002D_').single.text;
      debugPrint('Result: $result');
      StatusAlert.show(context,
          duration: const Duration(seconds: 1),
          configuration:
              const IconConfiguration(icon: Icons.done, color: Colors.green),
          title: "OTP Valid!!",
          backgroundColor: Colors.grey[300]);
      Navigator.of(context).pop();
    } else {
      debugPrint('Error: ${response.statusCode}');
      StatusAlert.show(
        context,
        duration: const Duration(seconds: 1),
        configuration:
            const IconConfiguration(icon: Icons.error, color: Colors.red),
        title: "Check OTP Failed, ${response.statusCode}",
        backgroundColor: Colors.grey[300],
      );
    }
  }

  void logout() {
    setState(() {
      userapi = '';
      passapi = '';
      data.clear();
      data1.clear();
      data2.clear();
      data3.clear();
      data4.clear();
    });

    Navigator.pushReplacementNamed(context, 'login');
  }

  @override
  void initState() {
    super.initState();
    phone.text = data[0]['phone'];
    _pageController = PageController(viewportFraction: 1.0);

    if (data1.length <= maxLimit) {
      indiLength = data1.length;
    } else {
      indiLength = maxLimit;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.home, color: Colors.white),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => HomeScreen(
                userapi: userapi,
                passapi: passapi,
                data: data,
                data1: data1,
                data2: data2,
              ),
            ));
          },
          tooltip: "Home Screen",
        ),
        title: const Text("Home Screen"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () async {
              setState(() {
                loading = true;
              });
              updateData1(destination.text, idpegawai.text);
              updateData2(destination.text, idpegawai.text);
            },
            tooltip: "Refresh Data",
          ),
          PopupMenuButton<String>(
            onSelected: (String value) {
              if (value == 'menu_1') {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => UserProfile(
                    userapi: userapi,
                    passapi: passapi,
                    data: data,
                    data1: data1,
                    data2: data2,
                  ),
                ));
              } else if (value == 'menu_2') {
                logout();
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'menu_1',
                  child: Row(
                    children: const [
                      Icon(
                        Icons.account_circle,
                        color: Colors.black,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text('Profile'),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'menu_2',
                  child: Row(
                    children: const [
                      Icon(
                        Icons.logout,
                        color: Colors.black,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text('Log Out'),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
        centerTitle: true,
        backgroundColor: Colors.redAccent,
      ),
      body: ListView.builder(
        key: _formKey,
        itemCount: 1,
        itemBuilder: (context, index) {
          if (data1.isEmpty && data2.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                  children: <Widget>[
                    Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/logo.png'),
                        ),
                      ),
                      width: double.infinity,
                      height: size.height * 0.1,
                    ),
                    SizedBox(
                      width: 350,
                      height: 230,
                      child: Card(
                        color: Colors.white,
                        elevation: 8.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Column(
                          children: <Widget>[
                            const SizedBox(height: 10),
                            Text(
                              "WELCOME",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize:
                                      MediaQuery.of(context).textScaleFactor *
                                          20),
                            ),
                            const SizedBox(height: 20),
                            Text("Name : ${data[index]['namaasli']}".trim()),
                            const SizedBox(height: 5),
                            Text(
                                "Username : ${data[index]['username']}".trim()),
                            const SizedBox(height: 5),
                            Text("ID Employee : ${data[index]['idemployee']}"
                                .trim()),
                            const SizedBox(height: 10),
                            Container(
                              margin: const EdgeInsets.all(15),
                              child: Row(
                                children: [
                                  SizedBox(
                                    height: 65,
                                    width: 110,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        elevation: 10.0,
                                        side: const BorderSide(
                                            color: Colors.red, width: 2),
                                      ),
                                      onPressed: () async {
                                        setState(() {
                                          loading1 = true;
                                        });
                                        Future.delayed(
                                            const Duration(seconds: 1), () {
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                            builder: (context) => ReservasiMess(
                                              userapi: userapi,
                                              passapi: passapi,
                                              data: data,
                                              data1: data1,
                                              data2: data2,
                                            ),
                                          ));
                                          setState(() {
                                            loading1 = false;
                                          });
                                        });
                                      },
                                      child: loading1
                                          ? const CircularProgressIndicator()
                                          : const Text(
                                              "Mess Reservation",
                                              style: TextStyle(
                                                  color: Colors.black54),
                                              textAlign: TextAlign.center,
                                            ),
                                    ),
                                  ),
                                  const Spacer(
                                    flex: 1,
                                  ),
                                  SizedBox(
                                    height: 65,
                                    width: 110,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        elevation: 10.0,
                                        side: const BorderSide(
                                            color: Colors.red, width: 2),
                                      ),
                                      onPressed: () async {
                                        setState(() {
                                          loading2 = true;
                                        });
                                        getReserveHist(
                                            destination.text, idpegawai.text);
                                      },
                                      child: loading1
                                          ? const CircularProgressIndicator()
                                          : const Text(
                                              "Reservation History",
                                              style: TextStyle(
                                                  color: Colors.black54),
                                              textAlign: TextAlign.center,
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Text(
                      "Pending Reservation",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).textScaleFactor * 30,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              width: 350,
                              height: 250,
                              child: Center(
                                  child: loading
                                      ? const CircularProgressIndicator()
                                      : const Text(
                                          "NO PENDING RESERVATION",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500),
                                        )),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Text(
                      "Current Reservation",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).textScaleFactor * 30,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              width: 350,
                              height: 250,
                              child: Center(
                                  child: loading
                                      ? const CircularProgressIndicator()
                                      : const Text(
                                          "NO CURRENT RESERVATION",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500),
                                        )),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          } else if (data1.isEmpty && data2.isNotEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                  children: <Widget>[
                    Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/logo.png'),
                        ),
                      ),
                      width: double.infinity,
                      height: size.height * 0.1,
                    ),
                    SizedBox(
                      width: 350,
                      height: 230,
                      child: Card(
                        color: Colors.white,
                        elevation: 8.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Column(
                          children: <Widget>[
                            const SizedBox(height: 10),
                            Text(
                              "WELCOME",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize:
                                      MediaQuery.of(context).textScaleFactor *
                                          20),
                            ),
                            const SizedBox(height: 20),
                            Text("Name : ${data[index]['namaasli']}".trim()),
                            const SizedBox(height: 5),
                            Text(
                                "Username : ${data[index]['username']}".trim()),
                            const SizedBox(height: 5),
                            Text("ID Employee : ${data[index]['idemployee']}"
                                .trim()),
                            const SizedBox(height: 10),
                            Container(
                              margin: const EdgeInsets.all(15),
                              child: Row(
                                children: [
                                  SizedBox(
                                    height: 65,
                                    width: 110,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        elevation: 10.0,
                                        side: const BorderSide(
                                            color: Colors.red, width: 2),
                                      ),
                                      onPressed: () async {
                                        setState(() {
                                          loading1 = true;
                                        });
                                        Future.delayed(
                                            const Duration(seconds: 1), () {
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                            builder: (context) => ReservasiMess(
                                              userapi: userapi,
                                              passapi: passapi,
                                              data: data,
                                              data1: data1,
                                              data2: data2,
                                            ),
                                          ));
                                          setState(() {
                                            loading1 = false;
                                          });
                                        });
                                      },
                                      child: loading1
                                          ? const CircularProgressIndicator()
                                          : const Text(
                                              "Mess Reservation",
                                              style: TextStyle(
                                                  color: Colors.black54),
                                              textAlign: TextAlign.center,
                                            ),
                                    ),
                                  ),
                                  const Spacer(
                                    flex: 1,
                                  ),
                                  SizedBox(
                                    height: 65,
                                    width: 110,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        elevation: 10.0,
                                        side: const BorderSide(
                                            color: Colors.red, width: 2),
                                      ),
                                      onPressed: () async {
                                        setState(() {
                                          loading2 = true;
                                        });
                                        getReserveHist(
                                            destination.text, idpegawai.text);
                                      },
                                      child: loading2
                                          ? const CircularProgressIndicator()
                                          : const Text(
                                              "Reservation History",
                                              style: TextStyle(
                                                  color: Colors.black54),
                                              textAlign: TextAlign.center,
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Text(
                      "Pending Reservation",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).textScaleFactor * 30,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              width: 350,
                              height: 250,
                              child: Center(
                                  child: loading
                                      ? const CircularProgressIndicator()
                                      : const Text(
                                          "NO PENDING RESERVATION",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500),
                                        )),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Text(
                      "Current Reservation",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).textScaleFactor * 30,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              width: 350,
                              height: 250,
                              child: loading
                                  ? const CircularProgressIndicator()
                                  : ListView.builder(
                                      itemCount: data2.length,
                                      itemBuilder: (context, index) {
                                        return Card(
                                          color: Colors.white,
                                          elevation: 8.0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                          ),
                                          child: Container(
                                            margin: const EdgeInsets.all(10),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: <Widget>[
                                                Container(
                                                  color: Colors.black12,
                                                  height: 45,
                                                  child: Row(children: [
                                                    Text(
                                                      "${data2[index]['idx']}",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .textScaleFactor *
                                                              18),
                                                    ),
                                                    const Spacer(
                                                      flex: 1,
                                                    ),
                                                    Text(
                                                      "${data2[index]['idkamar']}",
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ]),
                                                ),
                                                const Divider(
                                                  thickness: 2,
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  children: [
                                                    Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(children: const [
                                                            Text("Area"),
                                                          ]),
                                                          Row(children: const [
                                                            Text("Block"),
                                                          ]),
                                                          Row(children: const [
                                                            Text("Number"),
                                                          ]),
                                                          Row(
                                                            children: const [
                                                              Text("Bed"),
                                                            ],
                                                          ),
                                                        ]),
                                                    Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(children: [
                                                            Text(
                                                              " ${data2[index]['areamess']}",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      MediaQuery.of(context)
                                                                              .textScaleFactor *
                                                                          12),
                                                            )
                                                          ]),
                                                          Row(children: [
                                                            Text(
                                                              " ${data2[index]['blok']}",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      MediaQuery.of(context)
                                                                              .textScaleFactor *
                                                                          12),
                                                            ),
                                                          ]),
                                                          Row(children: [
                                                            Text(
                                                              " ${data2[index]['nokamar']}",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      MediaQuery.of(context)
                                                                              .textScaleFactor *
                                                                          12),
                                                            )
                                                          ]),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                " ${data2[index]['namabed']}",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        MediaQuery.of(context).textScaleFactor *
                                                                            12),
                                                              ),
                                                            ],
                                                          )
                                                        ]),
                                                    const Spacer(
                                                      flex: 1,
                                                    ),
                                                    Column(
                                                      children: [
                                                        SizedBox(
                                                          height: 35,
                                                          width: 95,
                                                          child: ElevatedButton(
                                                            onPressed:
                                                                () async {
                                                              setState(() {
                                                                loading3 = true;
                                                              });
                                                              getReport(
                                                                  destination
                                                                      .text,
                                                                  vidx.text,
                                                                  index);
                                                            },
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              backgroundColor:
                                                                  Colors
                                                                      .redAccent,
                                                            ),
                                                            child: loading3
                                                                ? const SizedBox(
                                                                    height: 28,
                                                                    width: 30,
                                                                    child:
                                                                        CircularProgressIndicator())
                                                                : Text(
                                                                    "COMPLAINT",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            MediaQuery.of(context).textScaleFactor *
                                                                                11),
                                                                  ),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                const Divider(
                                                  thickness: 2,
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(children: const [
                                                          Text("Book-In"),
                                                        ]),
                                                        Row(children: const [
                                                          Text("Book-Out"),
                                                        ]),
                                                      ],
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(children: [
                                                          Text(
                                                            DateFormat(
                                                                    ' : MMM dd, yyyy')
                                                                .format(DateTime.parse(
                                                                        data2[index]
                                                                            [
                                                                            'bookin'])
                                                                    .toLocal()),
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ]),
                                                        Row(children: [
                                                          Text(
                                                            DateFormat(
                                                                    ' : MMM dd, yyyy')
                                                                .format(DateTime.parse(
                                                                        data2[index]
                                                                            [
                                                                            'bookout'])
                                                                    .toLocal()),
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ]),
                                                      ],
                                                    ),
                                                    const Spacer(
                                                      flex: 1,
                                                    ),
                                                    Column(
                                                      children: [
                                                        Padding(
                                                          padding: EdgeInsets.only(
                                                              right: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.033),
                                                          child: SizedBox(
                                                            height: 30,
                                                            width: 65,
                                                            child:
                                                                ElevatedButton(
                                                              onPressed:
                                                                  () async {
                                                                setState(() {
                                                                  loading4 =
                                                                      true;
                                                                });
                                                                Future.delayed(
                                                                    const Duration(
                                                                        seconds:
                                                                            1),
                                                                    () {
                                                                  setState(() {
                                                                    loading4 =
                                                                        false;
                                                                  });
                                                                  showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (BuildContext
                                                                              context) {
                                                                        return AlertDialog(
                                                                          content:
                                                                              Stack(
                                                                            clipBehavior:
                                                                                Clip.none,
                                                                            children: <Widget>[
                                                                              Positioned(
                                                                                right: -40.0,
                                                                                top: -40.0,
                                                                                child: InkResponse(
                                                                                  onTap: () {
                                                                                    Navigator.of(context).pop();
                                                                                  },
                                                                                  child: const CircleAvatar(
                                                                                    backgroundColor: Colors.red,
                                                                                    child: Icon(Icons.close),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Column(
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                children: <Widget>[
                                                                                  TextFormField(
                                                                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                                                                    enabled: false,
                                                                                    autocorrect: false,
                                                                                    controller: phone,
                                                                                    decoration: const InputDecoration(
                                                                                      labelText: 'Phone',
                                                                                      icon: Icon(Icons.phone),
                                                                                    ),
                                                                                    validator: (value) {
                                                                                      return (value != null && value.length == 10) ? null : 'Phone number must be more than or equal to 10 numbers';
                                                                                    },
                                                                                  ),
                                                                                  const SizedBox(height: 30),
                                                                                  TextFormField(
                                                                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                                                                    autocorrect: false,
                                                                                    controller: otp,
                                                                                    decoration: InputDecoration(
                                                                                      hintText: '123***',
                                                                                      labelText: 'OTP',
                                                                                      icon: const Icon(Icons.chat),
                                                                                      suffixIcon: TextButton(
                                                                                        onPressed: () {
                                                                                          getOTP(phone.text, index);
                                                                                        },
                                                                                        child: const Text("Request OTP"),
                                                                                      ),
                                                                                    ),
                                                                                    validator: (value) {
                                                                                      return (value != null && value.length == 6) ? null : 'OTP code must be equal to 6 characters';
                                                                                    },
                                                                                  ),
                                                                                  const SizedBox(height: 30),
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.all(10),
                                                                                    child: ElevatedButton(
                                                                                      child: const Text("Submit"),
                                                                                      onPressed: () {
                                                                                        cekOTP(otp.text, index);
                                                                                      },
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        );
                                                                      });
                                                                });
                                                              },
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                backgroundColor:
                                                                    Colors
                                                                        .redAccent,
                                                              ),
                                                              child: loading4
                                                                  ? const SizedBox(
                                                                      height:
                                                                          28,
                                                                      width: 30,
                                                                      child:
                                                                          CircularProgressIndicator())
                                                                  : Text(
                                                                      "OTP",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              MediaQuery.of(context).textScaleFactor * 11),
                                                                    ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          } else if (data1.isNotEmpty && data2.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                  children: <Widget>[
                    Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/logo.png'),
                        ),
                      ),
                      width: double.infinity,
                      height: size.height * 0.1,
                    ),
                    SizedBox(
                      width: 350,
                      height: 230,
                      child: Card(
                        color: Colors.white,
                        elevation: 8.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Column(
                          children: <Widget>[
                            const SizedBox(height: 10),
                            Text(
                              "WELCOME",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize:
                                      MediaQuery.of(context).textScaleFactor *
                                          20),
                            ),
                            const SizedBox(height: 20),
                            Text("Name : ${data[index]['namaasli']}".trim()),
                            const SizedBox(height: 5),
                            Text(
                                "Username : ${data[index]['username']}".trim()),
                            const SizedBox(height: 5),
                            Text("ID Employee : ${data[index]['idemployee']}"
                                .trim()),
                            const SizedBox(height: 10),
                            Container(
                              margin: const EdgeInsets.all(15),
                              child: Row(
                                children: [
                                  SizedBox(
                                    height: 65,
                                    width: 110,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        elevation: 10.0,
                                        side: const BorderSide(
                                            color: Colors.red, width: 2),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          loading1 = true;
                                        });
                                        Future.delayed(
                                            const Duration(seconds: 1), () {
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                            builder: (context) => ReservasiMess(
                                              userapi: userapi,
                                              passapi: passapi,
                                              data: data,
                                              data1: data1,
                                              data2: data2,
                                            ),
                                          ));
                                          setState(() {
                                            loading1 = false;
                                          });
                                        });
                                      },
                                      child: loading1
                                          ? const CircularProgressIndicator()
                                          : const Text(
                                              "Mess Reservation",
                                              style: TextStyle(
                                                  color: Colors.black54),
                                              textAlign: TextAlign.center,
                                            ),
                                    ),
                                  ),
                                  const Spacer(
                                    flex: 1,
                                  ),
                                  SizedBox(
                                    height: 65,
                                    width: 110,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        elevation: 10.0,
                                        side: const BorderSide(
                                            color: Colors.red, width: 2),
                                      ),
                                      onPressed: () async {
                                        setState(() {
                                          loading2 = true;
                                        });
                                        getReserveHist(
                                            destination.text, idpegawai.text);
                                      },
                                      child: loading2
                                          ? const CircularProgressIndicator()
                                          : const Text(
                                              "Reservation History",
                                              style: TextStyle(
                                                  color: Colors.black54),
                                              textAlign: TextAlign.center,
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Text(
                      "Pending Reservation",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).textScaleFactor * 30,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              width: 350,
                              height: 250,
                              child: loading
                                  ? const CircularProgressIndicator()
                                  : PageView.builder(
                                      itemCount: data1.length,
                                      pageSnapping: true,
                                      controller: _pageController,
                                      onPageChanged: (page) {
                                        setState(() {
                                          activePage = page;
                                        });
                                      },
                                      itemBuilder: (context, index) {
                                        return Card(
                                          color: Colors.white,
                                          elevation: 8.0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                          ),
                                          child: Container(
                                            margin: const EdgeInsets.all(10),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: <Widget>[
                                                Container(
                                                  color: Colors.black12,
                                                  height: 45,
                                                  child: Row(children: [
                                                    Text(
                                                      "${data1[index]['idx']}",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .textScaleFactor *
                                                              18),
                                                    ),
                                                    const Spacer(
                                                      flex: 1,
                                                    ),
                                                    Text(
                                                      DateFormat('MMM dd, yyyy')
                                                          .format(DateTime
                                                                  .parse(data1[
                                                                          index]
                                                                      [
                                                                      'insertdate'])
                                                              .toLocal()),
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ]),
                                                ),
                                                Row(
                                                  children: [
                                                    Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(children: const [
                                                            Text("Necessary"),
                                                          ]),
                                                          Row(children: const [
                                                            Text("Notes"),
                                                          ]),
                                                        ]),
                                                    Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(children: [
                                                            Text(
                                                              " ${data1[index]['necessary']}",
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            )
                                                          ]),
                                                          Row(children: [
                                                            Text(
                                                              " ${data1[index]['notes']}",
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ]),
                                                        ]),
                                                  ],
                                                ),
                                                const Divider(
                                                  thickness: 2,
                                                ),
                                                Row(
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(children: const [
                                                          Text("Book-In"),
                                                        ]),
                                                        Row(
                                                          children: const [
                                                            Text("Book-Out"),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(children: [
                                                          Text(
                                                            DateFormat(
                                                                    ' : MMM dd, yyyy')
                                                                .format(DateTime.parse(
                                                                        data1[index]
                                                                            [
                                                                            'checkin'])
                                                                    .toLocal()),
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ]),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              DateFormat(
                                                                      ' : MMM dd, yyyy')
                                                                  .format(DateTime.parse(
                                                                          data1[index]
                                                                              [
                                                                              'checkout'])
                                                                      .toLocal()),
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                            ),
                            const SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: indicators(indiLength, activePage),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Text(
                      "Current Reservation",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).textScaleFactor * 30,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              width: 350,
                              height: 250,
                              child: Center(
                                  child: loading
                                      ? const CircularProgressIndicator()
                                      : const Text(
                                          "NO CURRENT RESERVATION",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500),
                                        )),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                  children: <Widget>[
                    Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/logo.png'),
                        ),
                      ),
                      width: double.infinity,
                      height: size.height * 0.1,
                    ),
                    SizedBox(
                      width: 350,
                      height: 230,
                      child: Card(
                        color: Colors.white,
                        elevation: 8.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Column(
                          children: <Widget>[
                            const SizedBox(height: 10),
                            Text(
                              "WELCOME",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize:
                                      MediaQuery.of(context).textScaleFactor *
                                          20),
                            ),
                            const SizedBox(height: 20),
                            Text("Name : ${data[index]['namaasli']}".trim()),
                            const SizedBox(height: 5),
                            Text(
                                "Username : ${data[index]['username']}".trim()),
                            const SizedBox(height: 5),
                            Text("ID Employee : ${data[index]['idemployee']}"
                                .trim()),
                            const SizedBox(height: 10),
                            Container(
                              margin: const EdgeInsets.all(15),
                              child: Row(
                                children: [
                                  SizedBox(
                                    height: 65,
                                    width: 110,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        elevation: 10.0,
                                        side: const BorderSide(
                                            color: Colors.red, width: 2),
                                      ),
                                      onPressed: () async {
                                        setState(() {
                                          loading1 = true;
                                        });
                                        Future.delayed(
                                            const Duration(seconds: 1), () {
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                            builder: (context) => ReservasiMess(
                                              userapi: userapi,
                                              passapi: passapi,
                                              data: data,
                                              data1: data1,
                                              data2: data2,
                                            ),
                                          ));
                                          setState(() {
                                            loading1 = false;
                                          });
                                        });
                                      },
                                      child: loading1
                                          ? const CircularProgressIndicator()
                                          : const Text(
                                              "Mess Reservation",
                                              style: TextStyle(
                                                  color: Colors.black54),
                                              textAlign: TextAlign.center,
                                            ),
                                    ),
                                  ),
                                  const Spacer(
                                    flex: 1,
                                  ),
                                  SizedBox(
                                    height: 65,
                                    width: 110,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        elevation: 10.0,
                                        side: const BorderSide(
                                            color: Colors.red, width: 2),
                                      ),
                                      onPressed: () async {
                                        setState(() {
                                          loading2 = true;
                                        });
                                        getReserveHist(
                                            destination.text, idpegawai.text);
                                      },
                                      child: loading2
                                          ? const CircularProgressIndicator()
                                          : const Text(
                                              "Reservation History",
                                              style: TextStyle(
                                                  color: Colors.black54),
                                              textAlign: TextAlign.center,
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Text(
                      "Pending Reservation",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).textScaleFactor * 30,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              width: 350,
                              height: 250,
                              child: loading
                                  ? const CircularProgressIndicator()
                                  : PageView.builder(
                                      itemCount: data1.length,
                                      pageSnapping: true,
                                      controller: _pageController,
                                      onPageChanged: (page) {
                                        setState(() {
                                          activePage = page;
                                        });
                                      },
                                      itemBuilder: (context, index) {
                                        return Card(
                                          color: Colors.white,
                                          elevation: 8.0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                          ),
                                          child: Container(
                                            margin: const EdgeInsets.all(10),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: <Widget>[
                                                Container(
                                                  color: Colors.black12,
                                                  height: 45,
                                                  child: Row(children: [
                                                    Text(
                                                      "${data1[index]['idx']}",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .textScaleFactor *
                                                              18),
                                                    ),
                                                    const Spacer(
                                                      flex: 1,
                                                    ),
                                                    Text(
                                                      DateFormat('MMM dd, yyyy')
                                                          .format(DateTime
                                                                  .parse(data1[
                                                                          index]
                                                                      [
                                                                      'insertdate'])
                                                              .toLocal()),
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ]),
                                                ),
                                                Row(
                                                  children: [
                                                    Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(children: const [
                                                            Text("Necessary"),
                                                          ]),
                                                          Row(children: const [
                                                            Text("Notes"),
                                                          ]),
                                                        ]),
                                                    Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(children: [
                                                            Text(
                                                              " ${data1[index]['necessary']}",
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            )
                                                          ]),
                                                          Row(children: [
                                                            Text(
                                                              " ${data1[index]['notes']}",
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ]),
                                                        ]),
                                                  ],
                                                ),
                                                const Divider(
                                                  thickness: 2,
                                                ),
                                                Row(
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(children: const [
                                                          Text("Book-In"),
                                                        ]),
                                                        Row(
                                                          children: const [
                                                            Text("Book-Out"),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(children: [
                                                          Text(
                                                            DateFormat(
                                                                    ' : MMM dd, yyyy')
                                                                .format(DateTime.parse(
                                                                        data1[index]
                                                                            [
                                                                            'checkin'])
                                                                    .toLocal()),
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ]),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              DateFormat(
                                                                      ' : MMM dd, yyyy')
                                                                  .format(DateTime.parse(
                                                                          data1[index]
                                                                              [
                                                                              'checkout'])
                                                                      .toLocal()),
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                            ),
                            const SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: indicators(indiLength, activePage),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Text(
                      "Current Reservation",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).textScaleFactor * 30,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              width: 350,
                              height: 250,
                              child: loading
                                  ? const CircularProgressIndicator()
                                  : ListView.builder(
                                      itemCount: data2.length,
                                      itemBuilder: (context, index) {
                                        return Card(
                                          color: Colors.white,
                                          elevation: 8.0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                          ),
                                          child: Container(
                                            margin: const EdgeInsets.all(10),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: <Widget>[
                                                Container(
                                                  color: Colors.black12,
                                                  height: 45,
                                                  child: Row(children: [
                                                    Text(
                                                      "${data2[index]['idx']}",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .textScaleFactor *
                                                              18),
                                                    ),
                                                    const Spacer(
                                                      flex: 1,
                                                    ),
                                                    Text(
                                                      "${data2[index]['idkamar']}",
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ]),
                                                ),
                                                const Divider(
                                                  thickness: 2,
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  children: [
                                                    Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(children: const [
                                                            Text("Area"),
                                                          ]),
                                                          Row(children: const [
                                                            Text("Block"),
                                                          ]),
                                                          Row(children: const [
                                                            Text("Number"),
                                                          ]),
                                                          Row(
                                                            children: const [
                                                              Text("Bed"),
                                                            ],
                                                          ),
                                                        ]),
                                                    Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(children: [
                                                            Text(
                                                              " ${data2[index]['areamess']}",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      MediaQuery.of(context)
                                                                              .textScaleFactor *
                                                                          12),
                                                            )
                                                          ]),
                                                          Row(children: [
                                                            Text(
                                                              " ${data2[index]['blok']}",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      MediaQuery.of(context)
                                                                              .textScaleFactor *
                                                                          12),
                                                            ),
                                                          ]),
                                                          Row(children: [
                                                            Text(
                                                              " ${data2[index]['nokamar']}",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      MediaQuery.of(context)
                                                                              .textScaleFactor *
                                                                          12),
                                                            )
                                                          ]),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                " ${data2[index]['namabed']}",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        MediaQuery.of(context).textScaleFactor *
                                                                            12),
                                                              ),
                                                            ],
                                                          )
                                                        ]),
                                                    const Spacer(
                                                      flex: 1,
                                                    ),
                                                    Column(
                                                      children: [
                                                        SizedBox(
                                                          height: 35,
                                                          width: 95,
                                                          child: ElevatedButton(
                                                            onPressed:
                                                                () async {
                                                              setState(() {
                                                                loading3 = true;
                                                              });
                                                              getReport(
                                                                  destination
                                                                      .text,
                                                                  vidx.text,
                                                                  index);
                                                            },
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              backgroundColor:
                                                                  Colors
                                                                      .redAccent,
                                                            ),
                                                            child: loading3
                                                                ? const SizedBox(
                                                                    height: 28,
                                                                    width: 30,
                                                                    child:
                                                                        CircularProgressIndicator())
                                                                : Text(
                                                                    "COMPLAINT",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            MediaQuery.of(context).textScaleFactor *
                                                                                11),
                                                                  ),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                const Divider(
                                                  thickness: 2,
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(children: const [
                                                          Text("Book-In"),
                                                        ]),
                                                        Row(children: const [
                                                          Text("Book-Out"),
                                                        ]),
                                                      ],
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(children: [
                                                          Text(
                                                            DateFormat(
                                                                    ' : MMM dd, yyyy')
                                                                .format(DateTime.parse(
                                                                        data2[index]
                                                                            [
                                                                            'bookin'])
                                                                    .toLocal()),
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ]),
                                                        Row(children: [
                                                          Text(
                                                            DateFormat(
                                                                    ' : MMM dd, yyyy')
                                                                .format(DateTime.parse(
                                                                        data2[index]
                                                                            [
                                                                            'bookout'])
                                                                    .toLocal()),
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ]),
                                                      ],
                                                    ),
                                                    const Spacer(
                                                      flex: 1,
                                                    ),
                                                    Column(
                                                      children: [
                                                        Padding(
                                                          padding: EdgeInsets.only(
                                                              right: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.033),
                                                          child: SizedBox(
                                                            height: 30,
                                                            width: 65,
                                                            child:
                                                                ElevatedButton(
                                                              onPressed:
                                                                  () async {
                                                                setState(() {
                                                                  loading4 =
                                                                      true;
                                                                });
                                                                Future.delayed(
                                                                    const Duration(
                                                                        seconds:
                                                                            1),
                                                                    () {
                                                                  setState(() {
                                                                    loading4 =
                                                                        false;
                                                                  });
                                                                  showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (BuildContext
                                                                              context) {
                                                                        return AlertDialog(
                                                                          content:
                                                                              Stack(
                                                                            clipBehavior:
                                                                                Clip.none,
                                                                            children: <Widget>[
                                                                              Positioned(
                                                                                right: -40.0,
                                                                                top: -40.0,
                                                                                child: InkResponse(
                                                                                  onTap: () {
                                                                                    Navigator.of(context).pop();
                                                                                  },
                                                                                  child: const CircleAvatar(
                                                                                    backgroundColor: Colors.red,
                                                                                    child: Icon(Icons.close),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Column(
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                children: <Widget>[
                                                                                  TextFormField(
                                                                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                                                                    enabled: false,
                                                                                    autocorrect: false,
                                                                                    controller: phone,
                                                                                    decoration: const InputDecoration(
                                                                                      labelText: 'Phone',
                                                                                      icon: Icon(Icons.phone),
                                                                                    ),
                                                                                    validator: (value) {
                                                                                      return (value != null && value.length == 10) ? null : 'Phone number must be more than or equal to 10 numbers';
                                                                                    },
                                                                                  ),
                                                                                  const SizedBox(height: 30),
                                                                                  TextFormField(
                                                                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                                                                    autocorrect: false,
                                                                                    controller: otp,
                                                                                    decoration: InputDecoration(
                                                                                      hintText: '123***',
                                                                                      labelText: 'OTP',
                                                                                      icon: const Icon(Icons.chat),
                                                                                      suffixIcon: TextButton(
                                                                                        onPressed: () {
                                                                                          getOTP(phone.text, index);
                                                                                        },
                                                                                        child: const Text("Request OTP"),
                                                                                      ),
                                                                                    ),
                                                                                    validator: (value) {
                                                                                      return (value != null && value.length == 6) ? null : 'OTP code must be equal to 6 characters';
                                                                                    },
                                                                                  ),
                                                                                  const SizedBox(height: 30),
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.all(10),
                                                                                    child: ElevatedButton(
                                                                                      child: const Text("Submit"),
                                                                                      onPressed: () {
                                                                                        cekOTP(otp.text, index);
                                                                                      },
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        );
                                                                      });
                                                                });
                                                              },
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                backgroundColor:
                                                                    Colors
                                                                        .redAccent,
                                                              ),
                                                              child: loading4
                                                                  ? const SizedBox(
                                                                      height:
                                                                          28,
                                                                      width: 30,
                                                                      child:
                                                                          CircularProgressIndicator())
                                                                  : Text(
                                                                      "OTP",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              MediaQuery.of(context).textScaleFactor * 11),
                                                                    ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

List<Widget> indicators(dataLength, currentIndex) {
  return List<Widget>.generate(dataLength, (index) {
    return Container(
      margin: const EdgeInsets.all(3),
      width: 10,
      height: 10,
      decoration: BoxDecoration(
          color: currentIndex == index ? Colors.black : Colors.black26,
          shape: BoxShape.circle),
    );
  });
}
