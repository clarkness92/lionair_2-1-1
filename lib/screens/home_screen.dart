import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lionair_2/screens/lihat_reservasi.dart';
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
        final idkamar = list_result.findElements('IDKAMAR').first.text;
        final areamess = list_result.findElements('AREAMESS').first.text;
        final blok = list_result.findElements('BLOK').first.text;
        final nokamar = list_result.findElements('NOKAMAR').first.text;
        final namabed = list_result.findElements('NAMABED').first.text;
        final bookin = list_result.findElements('BOOKIN').first.text;
        final bookout = list_result.findElements('BOOKOUT').first.text;
        final checkin = list_result.findElements('CHECKIN').first.text;
        final checkout = list_result.findElements('CHECKOUT').first.text;
        temporaryList3.add({
          'idx': idx,
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

  logout() {
    data.clear();
    data1.clear();
    data2.clear();
    data3.clear();
    data4.clear();
  }

  @override
  void initState() {
    super.initState();
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
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await logout();
              Navigator.pushReplacementNamed(context, 'login');
            },
            tooltip: "Logout",
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
                            const Text(
                              "WELCOME",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            const SizedBox(height: 20),
                            Text("Name : ${data[index]['namaasli']}".trim()),
                            const SizedBox(height: 5),
                            Text("Username : ${data[index]['username']}"),
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
                    const Text(
                      "Pending Reservation",
                      style: TextStyle(
                          fontSize: 30,
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
                    const Text(
                      "Current Reservation",
                      style: TextStyle(
                          fontSize: 30,
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
                            const Text(
                              "WELCOME",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
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
                    const Text(
                      "Pending Reservation",
                      style: TextStyle(
                          fontSize: 30,
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
                    const Text(
                      "Current Reservation",
                      style: TextStyle(
                          fontSize: 30,
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
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18),
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
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 12),
                                                            )
                                                          ]),
                                                          Row(children: [
                                                            Text(
                                                              " ${data2[index]['blok']}",
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 12),
                                                            ),
                                                          ]),
                                                          Row(children: [
                                                            Text(
                                                              " ${data2[index]['nokamar']}",
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 12),
                                                            )
                                                          ]),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                " ${data2[index]['namabed']}",
                                                                style: const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
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
                                                                : const Text(
                                                                    "COMPLAINT",
                                                                    style: TextStyle(
                                                                        fontSize:
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
                            const Text(
                              "WELCOME",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
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
                    const Text(
                      "Pending Reservation",
                      style: TextStyle(
                          fontSize: 30,
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
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18),
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
                    const Text(
                      "Current Reservation",
                      style: TextStyle(
                          fontSize: 30,
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
                            const Text(
                              "WELCOME",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
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
                    const Text(
                      "Pending Reservation",
                      style: TextStyle(
                          fontSize: 30,
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
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18),
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
                    const Text(
                      "Current Reservation",
                      style: TextStyle(
                          fontSize: 30,
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
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18),
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
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 12),
                                                            )
                                                          ]),
                                                          Row(children: [
                                                            Text(
                                                              " ${data2[index]['blok']}",
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 12),
                                                            ),
                                                          ]),
                                                          Row(children: [
                                                            Text(
                                                              " ${data2[index]['nokamar']}",
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 12),
                                                            )
                                                          ]),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                " ${data2[index]['namabed']}",
                                                                style: const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
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
                                                                : const Text(
                                                                    "COMPLAINT",
                                                                    style: TextStyle(
                                                                        fontSize:
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
