import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lionair_2/screens/lihat_reservasi.dart';
import '../constants.dart';
import 'package:xml/xml.dart' as xml;
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';

import 'input_laporan.dart';

class Lihatlaporan extends StatefulWidget {
  var data;
  var data1;
  var data2;
  var data3;
  var data4;

  Lihatlaporan(
      {super.key,
      required this.data,
      required this.data1,
      required this.data2,
      required this.data3,
      required this.data4});

  @override
  State<Lihatlaporan> createState() =>
      _Lihatlaporanstate(data, data1, data2, data3, data4);
}

class _Lihatlaporanstate extends State<Lihatlaporan> {
  _Lihatlaporanstate(this.data, this.data1, this.data2, this.data3, this.data4);

  final _formKey = GlobalKey<FormState>();
  var loading = false;
  List data = [];
  List data1 = [];
  List data2 = [];
  List data3 = [];
  List data4 = [];
  List dataBaru4 = [];
  var hasilJson;

  TextEditingController destination = TextEditingController();
  TextEditingController vidx = TextEditingController();

  void updateData4(String destination, String vidx) async {
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

      final list_result_all5 = document.findAllElements('_x002D_');

      for (final list_result in list_result_all5) {
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
        debugPrint("object 5");
        hasilJson = jsonEncode(temporaryList5);

        debugPrint(hasilJson);
        debugPrint("object_hasilJson 5");
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
      dataBaru4 = temporaryList5;
      loading = true;
      debugPrint('$dataBaru4');
    });

    Map<String, dynamic> map1 = Map.fromIterable(data4, key: (e) => e['idx']);
    Map<String, dynamic> map2 =
        Map.fromIterable(dataBaru4, key: (e) => e['idx']);

    map1.addAll(map2);

    List mergedList = map1.values.toList();

    debugPrint('$mergedList');

    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => Lihatlaporan(
        data: data,
        data1: data1,
        data2: data2,
        data3: data3,
        data4: mergedList,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
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
        title: const Text("Report"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () async {
              updateData4(destination.text, vidx.text);
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
        shrinkWrap: true,
        key: _formKey,
        itemCount: 1,
        itemBuilder: (context, index) {
          if (data4.isEmpty) {
            return const Center(child: Text("No Data"));
          } else {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 350,
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: Card(
                        color: Colors.white,
                        elevation: 8.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Column(
                          children: <Widget>[
                            const SizedBox(height: 25),
                            Text(
                              "${data3[0]['idx']}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            const SizedBox(height: 50),
                            Container(
                              alignment: Alignment.bottomLeft,
                              margin: const EdgeInsets.only(left: 24),
                              child: const Text(
                                "Status: OPEN",
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  columns: const <DataColumn>[
                                    DataColumn(label: Text("IDX")),
                                    DataColumn(label: Text("Category")),
                                    DataColumn(label: Text("Description")),
                                    DataColumn(label: Text("Date")),
                                    DataColumn(label: Text("User Insert")),
                                  ],
                                  rows: List<DataRow>.generate(
                                    data4.length,
                                    (index) => DataRow(
                                      cells: <DataCell>[
                                        DataCell(
                                            Text("${data4[index]['idx']}")),
                                        DataCell(Text(
                                            "${data4[index]['category']}")),
                                        DataCell(Text(
                                            "${data4[index]['description']}")),
                                        DataCell(
                                            Text("${data4[index]['date']}")),
                                        DataCell(Text(
                                            "${data4[index]['userinsert']}")),
                                      ],
                                    ),
                                  ),
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
              data4: data4,
            ),
          ));
        },
        backgroundColor: Colors.red,
        elevation: 12,
        tooltip: "Add Report",
        child: const Icon(Icons.add),
      ),
    );
  }
}
