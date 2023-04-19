import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lionair_2/screens/lihat_reservasi.dart';
import 'package:status_alert/status_alert.dart';
import 'package:status_alert/status_alert.dart';
import 'reservasi_mess.dart';
import '../constants.dart';
import 'package:http/http.dart' as http;
import 'package:xml2json/xml2json.dart';
import 'package:xml/xml.dart' as xml;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class HomeScreen extends StatefulWidget {
  var data;
  var data1;
  var data2;

  HomeScreen(
      {super.key,
      required this.data,
      required this.data1,
      required this.data2});

  @override
  State<HomeScreen> createState() => _HomeScreenState(data, data1, data2);
}

class _HomeScreenState extends State<HomeScreen> {
  _HomeScreenState(this.data, this.data1, this.data2);
  late PageController _pageController;
  late PageController _pageController1;
  int activePage = 0;
  int activePage1 = 0;
  int maxLimit = 19;
  int indiLength = 0;
  int indiLength1 = 0;

  final _formKey = GlobalKey<FormState>();
  var loading = false;
  List data = [];
  List data1 = [];
  List data2 = [];
  List data3 = [];
  List dataBaru2 = [];
  Xml2Json xml2json = Xml2Json();
  var hasilJson;

  TextEditingController destination = TextEditingController();
  TextEditingController idpegawai = TextEditingController();

  void updateData2(String destination, String idpegawai) async {
    final temporaryList2 = [];
    idpegawai = data[0]['idemployee'];

    String objBody = '<?xml version="1.0" encoding="utf-8"?>' +
        '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">' +
        '<soap:Body>' +
        '<Checktime_GetCurrentStay xmlns="http://tempuri.org/">' +
        '<UsernameAPI>admin</UsernameAPI>' +
        '<PasswordAPI>admin</PasswordAPI>' +
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

      debugPrint("=================");
      debugPrint(
          "document.toXmlString : ${document.toXmlString(pretty: true, indent: '\t')}");
      debugPrint("=================");

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
      loading = false;
    } else {
      debugPrint('Error: ${response.statusCode}');
      StatusAlert.show(
        context,
        duration: Duration(seconds: 1),
        configuration: IconConfiguration(icon: Icons.done),
        title: "Update Failed, ${response.statusCode}",
        backgroundColor: Colors.grey[300],
      );
      StatusAlert.show(
        context,
        duration: Duration(seconds: 1),
        configuration: IconConfiguration(icon: Icons.error),
        title: "Login Failed",
        backgroundColor: Colors.grey[300],
      );
    }
    setState(() {
      dataBaru2 = temporaryList2;
      loading = true;
      debugPrint('$dataBaru2');
    });

    Map<String, dynamic> map1 = Map.fromIterable(data2, key: (e) => e['idx']);
    Map<String, dynamic> map2 =
        Map.fromIterable(dataBaru2, key: (e) => e['idx']);

    map1.addAll(map2);

    List mergedList = map1.values.toList();

    debugPrint('$mergedList');

    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) =>
          HomeScreen(data: data, data1: data1, data2: mergedList),
    ));
  }

  void getReservationHist(String destination, String idpegawai) async {
    final temporaryList3 = [];
    idpegawai = data[0]['idemployee'];

    String objBody = '<?xml version="1.0" encoding="utf-8"?>' +
        '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">' +
        '<soap:Body>' +
        '<Checktime_GetHistoryStay xmlns="http://tempuri.org/">' +
        '<UsernameAPI>admin</UsernameAPI>' +
        '<PasswordAPI>admin</PasswordAPI>' +
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

      debugPrint("=================");
      debugPrint(
          "document.toXmlString : ${document.toXmlString(pretty: true, indent: '\t')}");
      debugPrint("=================");

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
      loading = false;
    } else {
      debugPrint('Error: ${response.statusCode}');
      StatusAlert.show(
        context,
        duration: Duration(seconds: 1),
        configuration: IconConfiguration(icon: Icons.done),
        title: "Get Data Failed, ${response.statusCode}",
        backgroundColor: Colors.grey[300],
      );
    }
    setState(() {
      data3 = temporaryList3;
      loading = true;
    });

    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => LihatDataEmployee(
        data: data,
        data1: data1,
        data2: data2,
        data3: data3,
      ),
    ));
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 1.0);
    _pageController1 = PageController(viewportFraction: 1.0);

    if (data1.length <= maxLimit) {
      indiLength1 = data1.length;
    } else {
      indiLength1 = maxLimit;
    }

    if (data2.length <= maxLimit) {
      indiLength = data2.length;
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
              updateData2(destination.text, idpegawai.text);
            },
            tooltip: "Refresh Data",
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
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
                            Text("Name : ${data[index]['namaasli']}"),
                            const SizedBox(height: 5),
                            Text("Username : ${data[index]['username']}"),
                            const SizedBox(height: 5),
                            Text("ID Employee : ${data[index]['idemployee']}"),
                            const SizedBox(height: 10),
                            // Text("Divisi: ${data[index]['namaasli']}"),
                            // const SizedBox(height: 20),
                            // Text("Email: ${data[index]['namaasli']}"),
                            // const SizedBox(height: 20),
                            Container(
                              margin: const EdgeInsets.all(15),
                              child: Row(
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      elevation: 10.0,
                                      side: const BorderSide(
                                          color: Colors.red, width: 2),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) => ReservasiMess(
                                          data: data,
                                          data1: data1,
                                          data2: data2,
                                        ),
                                      ));
                                    },
                                    child: const Text(
                                      "\nMess\nReservation\n",
                                      style: TextStyle(color: Colors.black54),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  const Spacer(
                                    flex: 1,
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      elevation: 10.0,
                                      side: const BorderSide(
                                          color: Colors.red, width: 2),
                                    ),
                                    onPressed: () async {
                                      getReservationHist(
                                          destination.text, idpegawai.text);
                                    },
                                    child: const Text(
                                      "\nReservation\nHistory\n",
                                      style: TextStyle(color: Colors.black54),
                                      textAlign: TextAlign.center,
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
                          children: const [
                            SizedBox(
                              width: 350,
                              height: 250,
                              child: Center(
                                  child: Text(
                                "NO PENDING RESERVATION",
                                style: TextStyle(fontWeight: FontWeight.w500),
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
                          children: const [
                            SizedBox(
                              width: 350,
                              height: 250,
                              child: Center(
                                  child: Text(
                                "NO CURRENT RESERVATION",
                                style: TextStyle(fontWeight: FontWeight.w500),
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
                            Text("Name : ${data[index]['namaasli']}"),
                            const SizedBox(height: 5),
                            Text("Username : ${data[index]['idemployee']}"),
                            const SizedBox(height: 5),
                            Text("ID Employee : ${data[index]['idemployee']}"),
                            const SizedBox(height: 10),
                            // Text("Divisi: ${data[index]['namaasli']}"),
                            // const SizedBox(height: 20),
                            // Text("Email: ${data[index]['namaasli']}"),
                            // const SizedBox(height: 20),
                            Container(
                              margin: const EdgeInsets.all(15),
                              child: Row(
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      elevation: 10.0,
                                      side: const BorderSide(
                                          color: Colors.red, width: 2),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) => ReservasiMess(
                                          data: data,
                                          data1: data1,
                                          data2: data2,
                                        ),
                                      ));
                                    },
                                    child: const Text(
                                      "\nMess\nReservation\n",
                                      style: TextStyle(color: Colors.black54),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  const Spacer(
                                    flex: 1,
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      elevation: 10.0,
                                      side: const BorderSide(
                                          color: Colors.red, width: 2),
                                    ),
                                    onPressed: () async {
                                      getReservationHist(
                                          destination.text, idpegawai.text);
                                    },
                                    child: const Text(
                                      "\nReservation\nHistory\n",
                                      style: TextStyle(color: Colors.black54),
                                      textAlign: TextAlign.center,
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
                          children: const [
                            SizedBox(
                              width: 350,
                              height: 250,
                              child: Center(
                                  child: Text(
                                "NO PENDING RESERVATION",
                                style: TextStyle(fontWeight: FontWeight.w500),
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
                              child: PageView.builder(
                                  itemCount: data2.length,
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
                                                                      .bold),
                                                        )
                                                      ]),
                                                      Row(children: [
                                                        Text(
                                                          " ${data2[index]['blok']}",
                                                          style: const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ]),
                                                      Row(children: [
                                                        Text(
                                                          " ${data2[index]['nokamar']}",
                                                          style: const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        )
                                                      ]),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            " ${data2[index]['namabed']}",
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ],
                                                      )
                                                    ]),
                                                const Spacer(
                                                  flex: 1,
                                                ),
                                                Column(
                                                  children: [
                                                    ElevatedButton(
                                                      onPressed: null,
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            Colors.redAccent,
                                                      ),
                                                      child: const Text(
                                                          "CHECK-IN"),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                            const Divider(
                                              thickness: 2,
                                            ),
                                            Row(
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
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
                                                      CrossAxisAlignment.start,
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
                            const SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: indicators(indiLength, activePage),
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
                            Text("Name : ${data[index]['namaasli']}"),
                            const SizedBox(height: 5),
                            Text("Username : ${data[index]['idemployee']}"),
                            const SizedBox(height: 5),
                            Text("ID Employee : ${data[index]['idemployee']}"),
                            const SizedBox(height: 10),
                            // Text("Divisi: ${data[index]['namaasli']}"),
                            // const SizedBox(height: 20),
                            // Text("Email: ${data[index]['namaasli']}"),
                            // const SizedBox(height: 20),
                            Container(
                              margin: const EdgeInsets.all(15),
                              child: Row(
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      elevation: 10.0,
                                      side: const BorderSide(
                                          color: Colors.red, width: 2),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) => ReservasiMess(
                                          data: data,
                                          data1: data1,
                                          data2: data2,
                                        ),
                                      ));
                                    },
                                    child: const Text(
                                      "\nMess\nReservation\n",
                                      style: TextStyle(color: Colors.black54),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  const Spacer(
                                    flex: 1,
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      elevation: 10.0,
                                      side: const BorderSide(
                                          color: Colors.red, width: 2),
                                    ),
                                    onPressed: () async {
                                      getReservationHist(
                                          destination.text, idpegawai.text);
                                    },
                                    child: const Text(
                                      "\nReservation\nHistory\n",
                                      style: TextStyle(color: Colors.black54),
                                      textAlign: TextAlign.center,
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
                              child: PageView.builder(
                                  itemCount: data1.length,
                                  pageSnapping: true,
                                  controller: _pageController,
                                  onPageChanged: (page1) {
                                    setState(() {
                                      activePage1 = page1;
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
                                                      .format(DateTime.parse(
                                                              data1[index][
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
                                                      CrossAxisAlignment.start,
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
                                                      CrossAxisAlignment.start,
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
                              children: indicators(indiLength1, activePage1),
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
                          children: const [
                            SizedBox(
                              width: 350,
                              height: 250,
                              child: Center(
                                  child: Text(
                                "NO CURRENT RESERVATION",
                                style: TextStyle(fontWeight: FontWeight.w500),
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
                            Text("Name : ${data[index]['namaasli']}"),
                            const SizedBox(height: 5),
                            Text("Username : ${data[index]['idemployee']}"),
                            const SizedBox(height: 5),
                            Text("ID Employee : ${data[index]['idemployee']}"),
                            const SizedBox(height: 10),
                            // Text("Divisi: ${data[index]['namaasli']}"),
                            // const SizedBox(height: 20),
                            // Text("Email: ${data[index]['namaasli']}"),
                            // const SizedBox(height: 20),
                            Container(
                              margin: const EdgeInsets.all(15),
                              child: Row(
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      elevation: 10.0,
                                      side: const BorderSide(
                                          color: Colors.red, width: 2),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) => ReservasiMess(
                                          data: data,
                                          data1: data1,
                                          data2: data2,
                                        ),
                                      ));
                                    },
                                    child: const Text(
                                      "\nMess\nReservation\n",
                                      style: TextStyle(color: Colors.black54),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  const Spacer(
                                    flex: 1,
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      elevation: 10.0,
                                      side: const BorderSide(
                                          color: Colors.red, width: 2),
                                    ),
                                    onPressed: () async {
                                      getReservationHist(
                                          destination.text, idpegawai.text);
                                    },
                                    child: const Text(
                                      "\nReservation\nHistory\n",
                                      style: TextStyle(color: Colors.black54),
                                      textAlign: TextAlign.center,
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
                              child: PageView.builder(
                                  itemCount: data1.length,
                                  pageSnapping: true,
                                  controller: _pageController,
                                  onPageChanged: (page1) {
                                    setState(() {
                                      activePage1 = page1;
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
                                                      .format(DateTime.parse(
                                                              data1[index][
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
                                                      CrossAxisAlignment.start,
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
                                                      CrossAxisAlignment.start,
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
                              children: indicators(indiLength1, activePage1),
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
                              child: PageView.builder(
                                  itemCount: data2.length,
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
                                                                      .bold),
                                                        )
                                                      ]),
                                                      Row(children: [
                                                        Text(
                                                          " ${data2[index]['blok']}",
                                                          style: const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ]),
                                                      Row(children: [
                                                        Text(
                                                          " ${data2[index]['nokamar']}",
                                                          style: const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        )
                                                      ]),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            " ${data2[index]['namabed']}",
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ],
                                                      )
                                                    ]),
                                                const Spacer(
                                                  flex: 1,
                                                ),
                                                Column(
                                                  children: [
                                                    ElevatedButton(
                                                      onPressed: null,
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            Colors.redAccent,
                                                      ),
                                                      child: const Text(
                                                          "CHECK-IN"),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                            const Divider(
                                              thickness: 2,
                                            ),
                                            Row(
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
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
                                                      CrossAxisAlignment.start,
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
                            const SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: indicators(indiLength, activePage),
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
