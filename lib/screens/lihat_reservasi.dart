import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:status_alert/status_alert.dart';
import 'laporan.dart';
import '../constants.dart';
import 'package:xml/xml.dart' as xml;
import 'package:http/http.dart' as http;
import 'home_screen.dart' show HomeScreen;
import 'reservasi_mess.dart';
import 'package:clipboard/clipboard.dart';

class LihatDataEmployee extends StatefulWidget {
  var data;
  var data1;
  var data2;
  var data3;

  LihatDataEmployee(
      {super.key,
      required this.data,
      required this.data1,
      required this.data2,
      required this.data3});

  @override
  State<LihatDataEmployee> createState() =>
      _LihatDataEmployeeState(data, data1, data2, data3);
}

class _LihatDataEmployeeState extends State<LihatDataEmployee> {
  _LihatDataEmployeeState(this.data, this.data1, this.data2, this.data3);

  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  List data = [];
  List data1 = [];
  List data2 = [];
  List data3 = [];
  List data4 = [];
  List dataBaru3 = [];
  var hasilJson;
  var vidxBaru;
  var bookinBaru;
  var bookoutBaru;

  TextEditingController destination = TextEditingController();
  TextEditingController idpegawai = TextEditingController();
  TextEditingController vidx = TextEditingController();

  void updateData3(String destination, String idpegawai) async {
    final temporaryList4 = [];
    String idpegawai = data[0]['idemployee'];
    data3.clear();

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
          // 'Accept': 'application/json',
        },
        body: objBody);

    if (response.statusCode == 200) {
      final document = xml.XmlDocument.parse(response.body);

      debugPrint("=================");
      debugPrint(
          "document.toXmlString : ${document.toXmlString(pretty: true, indent: '\t')}");
      debugPrint("=================");

      final listResultAll4 = document.findAllElements('_x002D_');

      for (final list_result in listResultAll4) {
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
        temporaryList4.add({
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
        debugPrint("object 3.1");
        hasilJson = jsonEncode(temporaryList4);

        debugPrint(hasilJson);
        debugPrint("object_hasilJson 3.1");
      }
      Future.delayed(Duration(seconds: 3), () {
        Map<String, dynamic> map1 =
            Map.fromIterable(data3, key: (e) => e['idx']);
        Map<String, dynamic> map2 =
            Map.fromIterable(dataBaru3, key: (e) => e['idx']);

        map1.addAll(map2);

        List mergedList = map1.values.toList();

        debugPrint('$mergedList');

        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => LihatDataEmployee(
              data: data, data1: data1, data2: data2, data3: mergedList),
        ));
        setState(() {
          loading = false;
        });
      });
    } else {
      debugPrint('Error: ${response.statusCode}');
      StatusAlert.show(
        context,
        duration: const Duration(seconds: 1),
        configuration: const IconConfiguration(icon: Icons.done),
        title: "Update Failed, ${response.statusCode}",
        backgroundColor: Colors.grey[300],
      );
    }
    setState(() {
      dataBaru3 = temporaryList4;
      loading = true;
      debugPrint('$dataBaru3');
    });
  }

  void getReport(String destination, String vidx, index) async {
    final temporaryList5 = [];
    vidx = data3[index]['idx'];
    String bookin = data3[index]['bookin'];
    String bookout = data3[index]['bookout'];

    String objBody = '<?xml version="1.0" encoding="utf-8"?>' +
        '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">' +
        '<soap:Body>' +
        '<TenantReport_GetDataVIDX xmlns="http://tempuri.org/">' +
        '<UsernameAPI>admin</UsernameAPI>' +
        '<PasswordAPI>admin</PasswordAPI>' +
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
      loading = false;
    } else {
      debugPrint('Error: ${response.statusCode}');
      StatusAlert.show(
        context,
        duration: const Duration(seconds: 1),
        configuration: const IconConfiguration(icon: Icons.done),
        title: "Get Data Failed, ${response.statusCode}",
        backgroundColor: Colors.grey[300],
      );
    }
    setState(() {
      data4 = temporaryList5;
      vidxBaru = vidx;
      bookinBaru = bookin;
      bookoutBaru = bookout;
      loading = true;
    });

    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => Lihatlaporan(
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
  }

  logout() {
    data.clear();
    data1.clear();
    data2.clear();
    data3.clear();
    data4.clear();
  }

  @override
  Widget build(BuildContext context) {
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
        title: const Text("Reservation History"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () async {
              setState(() {
                loading = true;
              });
              updateData3(destination.text, idpegawai.text);
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
      body: Center(
        child: loading
            ? CircularProgressIndicator()
            : ListView.builder(
                key: _formKey,
                itemCount: data3.length,
                itemBuilder: (context, index) {
                  if (data3.isEmpty) {
                    return const Center(child: Text("No Data"));
                  } else {
                    return Card(
                      margin: const EdgeInsets.all(8),
                      elevation: 8,
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Container(
                              color: Colors.black12,
                              height: 45,
                              child: Row(children: [
                                GestureDetector(
                                  child: Row(
                                    children: [
                                      Text(
                                        "${data3[index]['idx']} ",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                      const Icon(
                                        Icons.copy_rounded,
                                        color: Colors.black38,
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    FlutterClipboard.copy(
                                        '${data3[index]['idx']}'); // copy teks ke clipboard
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Reservation ID copied!'),
                                      ),
                                    );
                                  },
                                ),
                                const Spacer(
                                  flex: 1,
                                ),
                                Text(
                                  "${data3[index]['idkamar']}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ]),
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
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(children: [
                                        Text(
                                          " ${data3[index]['areamess']}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )
                                      ]),
                                      Row(children: [
                                        Text(
                                          " ${data3[index]['blok']}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ]),
                                      Row(children: [
                                        Text(
                                          " ${data3[index]['nokamar']}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )
                                      ]),
                                      Row(
                                        children: [
                                          Text(
                                            " ${data3[index]['namabed']}",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
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
                                      onPressed: () async {
                                        getReport(
                                            destination.text, vidx.text, index);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.redAccent,
                                      ),
                                      child: const Text("REPORT"),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(children: const [
                                      Text("Book-In"),
                                    ]),
                                    Row(children: const [
                                      Text("Book-Out"),
                                    ]),
                                    Row(children: const [
                                      Text("Check-In"),
                                    ]),
                                    Row(
                                      children: const [
                                        Text("Check-Out"),
                                      ],
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(children: [
                                      Text(
                                        DateFormat(' : MMM dd, yyyy').format(
                                            DateTime.parse(
                                                    data3[index]['bookin'])
                                                .toLocal()),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ]),
                                    Row(children: [
                                      Text(
                                        DateFormat(' : MMM dd, yyyy').format(
                                            DateTime.parse(
                                                    data3[index]['bookout'])
                                                .toLocal()),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ]),
                                    Row(children: [
                                      Text(
                                        DateFormat(' : MMM dd, yyyy').format(
                                            DateTime.parse(
                                                    data3[index]['checkin'])
                                                .toLocal()),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ]),
                                    Row(
                                      children: [
                                        Text(
                                          DateFormat(' : MMM dd, yyyy').format(
                                              DateTime.parse(
                                                      data3[index]['checkout'])
                                                  .toLocal()),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
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
                  }
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ReservasiMess(
              data: data,
              data1: data1,
              data2: data2,
            ),
          ));
        },
        backgroundColor: Colors.red,
        elevation: 12,
        tooltip: "Add Reservation",
        child: const Icon(Icons.add),
      ),
    );
  }
}
