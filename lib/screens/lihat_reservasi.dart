import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'laporan.dart';
import '../constants.dart';
import 'package:xml/xml.dart' as xml;
import 'package:http/http.dart' as http;
import 'home_screen.dart' show HomeScreen;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'reservasi_mess.dart';

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
  var loading = false;
  List data = [];
  List data1 = [];
  List data2 = [];
  List data3 = [];
  List data4 = [];
  List dataBaru3 = [];
  var hasilJson;

  TextEditingController destination = TextEditingController();
  TextEditingController idpegawai = TextEditingController();
  TextEditingController vidx = TextEditingController();

  void updateData3(String destination, String idpegawai) async {
    final temporaryList4 = [];
    String idpegawai = data[0]['idemployee'];

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
        final vidx = list_result.findElements('VIDX').first.text;
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
          'vidx': vidx,
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
      loading = false;
    } else {
      debugPrint('Error: ${response.statusCode}');
      Alert(
        context: context,
        type: AlertType.error,
        title: "Update Failed, ${response.statusCode}",
      ).show();
      Timer(const Duration(seconds: 1), () {
        Navigator.pop(context);
      });
      return;
    }
    setState(() {
      dataBaru3 = temporaryList4;
      loading = true;
      debugPrint('$dataBaru3');
    });

    Map<String, dynamic> map1 = Map.fromIterable(data3, key: (e) => e['idx']);
    Map<String, dynamic> map2 =
        Map.fromIterable(dataBaru3, key: (e) => e['idx']);

    map1.addAll(map2);

    List mergedList = map1.values.toList();

    debugPrint('$mergedList');

    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => LihatDataEmployee(
          data: data, data1: data1, data2: data2, data3: mergedList),
    ));
  }

  void getReport(String destination, String vidx) async {
    final temporaryList5 = [];
    vidx = data3[0]['idx'];

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

      debugPrint("=================");
      debugPrint(
          "document.toXmlString : ${document.toXmlString(pretty: true, indent: '\t')}");
      debugPrint("=================");

      final listResultAll5 = document.findAllElements('_x002D_');

      for (final list_result in listResultAll5) {
        final idx = list_result.findElements('IDX').first.text;
        final category = list_result.findElements('CATEGORY').first.text;
        final description = list_result.findElements('DESCRIPTION').first.text;
        final date = list_result.findElements('DATE').first.text;
        final userinsert = list_result.findElements('USERINSERT').first.text;
        temporaryList5.add({
          'idx': idx,
          'category': category,
          'description': description,
          'date': date,
          'userinsert': userinsert
        });
        debugPrint("object 4");
        hasilJson = jsonEncode(temporaryList5);

        debugPrint(hasilJson);
        debugPrint("object_hasilJson 4");
      }
      loading = false;
    } else {
      debugPrint('Error: ${response.statusCode}');
      Alert(
        context: context,
        type: AlertType.error,
        title: "Error, ${response.statusCode}",
      ).show();
      Timer(const Duration(seconds: 1), () {
        Navigator.pop(context);
      });
      return;
    }
    setState(() {
      data4 = temporaryList5;
      loading = true;
    });

    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => Lihatlaporan(
        data: data,
        data1: data1,
        data2: data2,
        data3: data3,
        data4: data4,
      ),
    ));
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
              updateData3(destination.text, idpegawai.text);
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
        itemCount: data3.length,
        itemBuilder: (context, index) {
          if (data3.length.isNaN) {
            return const Center(
                child: SizedBox(height: 15, child: Text("No Data")));
          } else {
            return Card(
              margin: const EdgeInsets.all(8),
              elevation: 8,
              child: Container(
                margin: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Row(children: [
                      Text(
                        "${data3[index]['idx']}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      const Spacer(
                        flex: 1,
                      ),
                      Text(
                        "${data3[index]['idkamar']}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ]),
                    const Divider(
                      thickness: 43,
                    ),
                    Row(
                      children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(children: [
                                const Text("Area"),
                                Text(
                                  "      ${data3[index]['areamess']}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                )
                              ]),
                              Row(children: [
                                const Text("Blok"),
                                Text(
                                  "      ${data3[index]['blok']}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ]),
                              Row(children: [
                                const Text("Nomor"),
                                Text(
                                  "  ${data3[index]['nokamar']}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                )
                              ]),
                            ]),
                        const Spacer(
                          flex: 1,
                        ),
                        Column(
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                getReport(destination.text, vidx.text);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                              ),
                              child: const Text("LAPORAN"),
                            ),
                          ],
                        )
                      ],
                    ),
                    Row(children: [
                      const Text("Bed"),
                      Text(
                        "      ${data3[index]['namabed']}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )
                    ]),
                    const Divider(
                      thickness: 2,
                    ),
                    Row(children: [
                      const Text("Book-In"),
                      Text(
                        "      : ${data3[index]['bookin']}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ]),
                    Row(children: [
                      const Text("Book-Out"),
                      Text(
                        "   : ${data3[index]['bookout']}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ]),
                    Row(children: [
                      const Text("Check-In"),
                      Text(
                        "    : ${data3[index]['checkin']}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ]),
                    Row(
                      children: [
                        const Text("Check-Out"),
                        Text(
                          " : ${data3[index]['checkout']}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
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
