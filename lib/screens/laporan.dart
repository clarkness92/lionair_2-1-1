import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:lionair_2/screens/lihat_reservasi.dart';
import '../constants.dart';
import '../models/user.dart';
import '../screens/login_screen.dart';
import 'package:xml/xml.dart' as xml;
import 'package:http/http.dart' as http;
import 'package:xml2json/xml2json.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../models/user.dart';
import 'home_screen.dart' show HomeScreen;
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:rflutter_alert/rflutter_alert.dart';

import 'input_laporan.dart';
import 'reservasi_mess.dart';

class Lihatlaporan extends StatefulWidget {
  var data;
  var data1;
  var data2;
  var data3;

  Lihatlaporan(
      {super.key,
      required this.data,
      required this.data1,
      required this.data2,
      required this.data3});

  @override
  State<Lihatlaporan> createState() =>
      _Lihatlaporanstate(data, data1, data2, data3);
}

class _Lihatlaporanstate extends State<Lihatlaporan> {
  _Lihatlaporanstate(this.data, this.data1, this.data2, this.data3);

  final _formKey = GlobalKey<FormState>();
  var loading = false;
  List data = [];
  List data1 = [];
  List data2 = [];
  List data3 = [];
  List dataBaru = [];
  var hasilJson;

  TextEditingController idx = TextEditingController();

  void updateData(String idx) async {
    final temporaryList1 = [];
    String idx = data1[0]['idx'];

    String objBody = '<?xml version="1.0" encoding="utf-8"?>' +
        '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">' +
        '<soap:Body>' +
        '<TenantReport_GetDataIDX xmlns="http://tempuri.org/">' +
        '<UsernameAPI>admin</UsernameAPI>' +
        '<PasswordAPI>admin</PasswordAPI>' +
        '<Destination>BLJ</Destination>' +
        '<IDX>$idx</IDX>' +
        '</TenantReport_GetDataIDX>' +
        '</soap:Body>' +
        '</soap:Envelope>';

    final response = await http.post(Uri.parse(url_TenantReport_GetDataIDX),
        headers: <String, String>{
          "Access-Control-Allow-Origin": "*",
          'SOAPAction': 'http://tempuri.org/TenantReport_GetDataIDX',
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

      final list_result_all1 = document.findAllElements('_x002D_');

      for (final list_result in list_result_all1) {
        final idx = list_result.findElements('IDX').first.text;
        final vidx = list_result.findElements('VIDX').first.text;
        final date = list_result.findElements('DATE').first.text;
        final status = list_result.findElements('STATUS').first.text;
        final category = list_result.findElements('CATEGORY').first.text;
        final description = list_result.findElements('DESCRIPTION').first.text;
        temporaryList1.add({
          'idx': idx,
          'vidx': vidx,
          'date': date,
          'status': status,
          'category': category,
          'description': description
        });
        debugPrint("object 4");
        hasilJson = jsonEncode(temporaryList1);

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
      Timer(Duration(seconds: 2), () {
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
      builder: (context) => Lihatlaporan(
          data: data, data1: data1, data2: data2, data3: mergedList),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => LihatDataEmployee(
                data: data,
                data1: data1,
                data2: data2,
                data3: data3,
              ),
            ));
          },
          tooltip: "Home Screen",
        ),
        title: const Text("Laporan"),
        actions: <Widget>[
          IconButton(
            icon: new Icon(Icons.refresh, color: Colors.white),
            onPressed: () async {
              // updateData(idx.text);
            },
            tooltip: "Refresh Data",
          ),
          IconButton(
            icon: new Icon(Icons.logout, color: Colors.white),
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
            return Center(child: Text("No Data"));
          } else {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 350,
                      height: 350,
                      child: Card(
                        color: Colors.white,
                        elevation: 8.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Column(
                          children: <Widget>[
                            const SizedBox(height: 25),
                            const Text(
                              "IDX",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            const SizedBox(height: 50),
                            Container(
                              alignment: Alignment.bottomLeft,
                              margin: EdgeInsets.only(left: 24),
                              child: const Text(
                                "Status: OPEN",
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                            Container(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  columns: <DataColumn>[
                                    DataColumn(label: Text("VIDX")),
                                    DataColumn(label: Text("Category")),
                                    DataColumn(label: Text("Description")),
                                    DataColumn(label: Text("Date")),
                                    DataColumn(label: Text("Status")),
                                  ],
                                  rows: <DataRow>[
                                    DataRow(
                                      cells: <DataCell>[
                                        DataCell(Text("MBR01230027")),
                                        DataCell(Text("KEAMANAN/KETERTIBAN")),
                                        DataCell(Text("TESTING")),
                                        DataCell(
                                            Text("2023-04-03 00:00:00.000")),
                                        DataCell(Text("OPEN")),
                                      ],
                                    ),
                                    DataRow(
                                      cells: <DataCell>[
                                        DataCell(Text("MBR01230027")),
                                        DataCell(Text("KEAMANAN/KETERTIBAN")),
                                        DataCell(Text("TESTING")),
                                        DataCell(
                                            Text("2023-04-03 00:00:00.000")),
                                        DataCell(Text("OPEN")),
                                      ],
                                    ),
                                    DataRow(
                                      cells: <DataCell>[
                                        DataCell(Text("MBR01230027")),
                                        DataCell(Text("KEAMANAN/KETERTIBAN")),
                                        DataCell(Text("TESTING")),
                                        DataCell(
                                            Text("2023-04-03 00:00:00.000")),
                                        DataCell(Text("OPEN")),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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
            builder: (context) => InputLaporan(
              data: data,
              data1: data1,
              data2: data2,
              data3: data3,
            ),
          ));
        },
        backgroundColor: Colors.red,
        child: const Icon(Icons.add),
        elevation: 12,
        tooltip: "Add Report",
      ),
    );
  }
}
