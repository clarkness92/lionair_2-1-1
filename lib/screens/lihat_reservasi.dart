import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lionair_2/screens/laporan.dart';
import '../constants.dart';
import 'package:xml/xml.dart' as xml;
import 'package:http/http.dart' as http;
import 'home_screen.dart' show HomeScreen;
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'reservasi_mess.dart';

class LihatDataEmployee extends StatefulWidget {
  var data;
  var data1;

  LihatDataEmployee({super.key, required this.data, required this.data1});

  @override
  State<LihatDataEmployee> createState() =>
      _LihatDataEmployeeState(data, data1);
}

class _LihatDataEmployeeState extends State<LihatDataEmployee> {
  _LihatDataEmployeeState(this.data, this.data1);

  final _formKey = GlobalKey<FormState>();
  var loading = false;
  List data = [];
  List data1 = [];
  List dataBaru = [];
  var hasilJson;

  TextEditingController destination = TextEditingController();
  TextEditingController idpegawai = TextEditingController();

  void updateData(String destination, String idpegawai) async {
    final temporaryList1 = [];
    String idpegawai = data[0]['idemployee'];

    String objBody = '<?xml version="1.0" encoding="utf-8"?>' +
        '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">' +
        '<soap:Body>' +
        '<GetReservationByIDSTaff xmlns="http://tempuri.org/">' +
        '<UsernameApi>admin</UsernameApi>' +
        '<PasswordApi>admin</PasswordApi>' +
        '<DESTINATION>BLJ</DESTINATION>' +
        '<IDSTAFF>$idpegawai</IDSTAFF>' + //dibuat statis agar mudah bolak balik page => ganti dengan $idpegawai jika ingin dinamis
        '</GetReservationByIDSTaff>' +
        '</soap:Body>' +
        '</soap:Envelope>';

    final response = await http.post(Uri.parse(url_GetReservationByIDSTaff),
        headers: <String, String>{
          "Access-Control-Allow-Origin": "*",
          'SOAPAction': 'http://tempuri.org/GetReservationByIDSTaff',
          "Access-Control-Allow-Credentials": "true",
          'Content-type': 'text/xml; charset=utf-8',
          // 'Accept': 'application/json',
        },
        body: objBody);

    if (response.statusCode == 200) {
      // debugPrint("Response status: ${response.statusCode}");
      // debugPrint("Response body: ${response.body}");

      final document = xml.XmlDocument.parse(response.body);

      debugPrint("=================");
      // debugPrint("document saja : ${document}");
      // debugPrint("=================");
      // debugPrint("document.tostring : ${document.toString()}");
      // debugPrint("=================");
      debugPrint(
          "document.toXmlString : ${document.toXmlString(pretty: true, indent: '\t')}");
      debugPrint("=================");

      final listResultAll1 = document.findAllElements('_x002D_');

      for (final list_result in listResultAll1) {
        final idx = list_result.findElements('IDX').first.text;
        final idstaff = list_result.findElements('IDSTAFF').first.text;
        final name = list_result.findElements('NAME').first.text;
        final checkin = list_result.findElements('CHECKIN').first.text;
        final checkout = list_result.findElements('CHECKOUT').first.text;
        temporaryList1.add({
          'idx': idx,
          'idstaff': idstaff,
          'name': name,
          'checkin': checkin,
          'checkout': checkout
        });
        debugPrint("object 3");
        hasilJson = jsonEncode(temporaryList1);

        debugPrint(hasilJson);
        debugPrint("object_hasilJson 3");
      }
      loading = false;
    } else {
      debugPrint('Error: ${response.statusCode}');
      Alert(
        context: context,
        type: AlertType.error,
        title: "Error, ${response.statusCode}",
      ).show();
      Timer(const Duration(seconds: 2), () {
        Navigator.pop(context);
      });
      return;
    }
    setState(() {
      dataBaru = temporaryList1;
      loading = true;
      debugPrint('$dataBaru');
    });

    Map<String, dynamic> map1 = Map.fromIterable(data1, key: (e) => e['idx']);
    Map<String, dynamic> map2 =
        Map.fromIterable(dataBaru, key: (e) => e['idx']);

    map1.addAll(map2);

    List mergedList = map1.values.toList();

    debugPrint('$mergedList');

    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => LihatDataEmployee(data: data, data1: mergedList),
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
              ),
            ));
          },
          tooltip: "Home Screen",
        ),
        title: const Text("History Reservasi"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () async {
              updateData(destination.text, idpegawai.text);
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
        itemCount: data1.length,
        itemBuilder: (context, index) {
          if (data1.isEmpty) {
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
                        "${data1[index]['idx']}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      const Spacer(
                        flex: 1,
                      ),
                      const Text(
                        "KMR001",
                        style: TextStyle(fontWeight: FontWeight.bold),
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
                              Row(children: const [
                                Text("Area"),
                                Text(
                                  "     MESS 1 TRANSIT",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )
                              ]),
                              Row(children: const [
                                Text("Blok"),
                                Text(
                                  "     K9",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ]),
                              Row(children: const [
                                Text("Nomor"),
                                Text(
                                  " FANTA",
                                  style: TextStyle(fontWeight: FontWeight.bold),
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
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Lihatlaporan(
                                    data: data,
                                    data1: data1,
                                  ),
                                ));
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
                    Row(children: const [
                      Text("Bed"),
                      Text(
                        "      A",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ]),
                    const Divider(
                      thickness: 2,
                    ),
                    Row(children: [
                      // Text("${data[index]['name']}"),
                      const Text("Check-In"),
                      Text(
                        "    : ${data1[index]['checkin']}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ]),
                    Row(
                      children: [
                        const Text("Check-Out"),
                        Text(
                          " : ${data1[index]['checkout']}",
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
