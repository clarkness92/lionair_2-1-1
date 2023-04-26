import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lionair_2/screens/lihat_reservasi.dart';
import 'package:status_alert/status_alert.dart';
import '../constants.dart';
import 'package:xml/xml.dart' as xml;
import 'package:http/http.dart' as http;
import 'input_laporan.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';

class Lihatlaporan extends StatefulWidget {
  var data;
  var data1;
  var data2;
  var data3;
  var data4;
  var vidx4;
  var bookin3;
  var bookout3;

  Lihatlaporan(
      {super.key,
      required this.data,
      required this.data1,
      required this.data2,
      required this.data3,
      required this.data4,
      required this.vidx4,
      required this.bookin3,
      required this.bookout3});

  @override
  State<Lihatlaporan> createState() => _Lihatlaporanstate(
      data, data1, data2, data3, data4, vidx4, bookin3, bookout3);
}

class _Lihatlaporanstate extends State<Lihatlaporan> {
  _Lihatlaporanstate(this.data, this.data1, this.data2, this.data3, this.data4,
      this.vidx4, this.bookin3, this.bookout3);

  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  List data = [];
  List data1 = [];
  List data2 = [];
  List data3 = [];
  List data4 = [];
  List dataBaru4 = [];
  var hasilJson;
  var vidx4;
  var bookin3;
  var bookout3;

  TextEditingController destination = TextEditingController();
  TextEditingController vidx = TextEditingController();

  void updateData4(String destination, String vidx) async {
    final temporaryList6 = [];
    vidx = vidx4;
    data4.clear();

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

      final list_result_all6 = document.findAllElements('_x002D_');

      for (final list_result in list_result_all6) {
        final idx = list_result.findElements('IDX').first.text;
        final vidx = list_result.findElements('VIDX').first.text;
        final date = list_result.findElements('DATE').first.text;
        final category = list_result.findElements('CATEGORY').first.text;
        final description = list_result.findElements('DESCRIPTION').first.text;
        final resolution = list_result.findElements('RESOLUTION').first.text;
        final userinsert = list_result.findElements('USERINSERT').first.text;
        final status = list_result.findElements('STATUS').first.text;
        temporaryList6.add({
          'idx': idx,
          'vidx': vidx,
          'date': date,
          'category': category,
          'description': description,
          'resolution': resolution,
          'userinsert': userinsert,
          'status': status
        });
        debugPrint("object 6");
        hasilJson = jsonEncode(temporaryList6);

        debugPrint(hasilJson);
        debugPrint("object_hasilJson 6");
      }

      Future.delayed(const Duration(seconds: 3), () {
        Map<String, dynamic> map1 =
            Map.fromIterable(data4, key: (e) => e['idx']);
        Map<String, dynamic> map2 =
            Map.fromIterable(dataBaru4, key: (e) => e['idx']);

        map1.addAll(map2);

        List mergedList = map1.values.toList();

        // debugPrint('$mergedList');

        setState(() {
          data4 = mergedList;
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
      dataBaru4 = temporaryList6;
      loading = true;
      // debugPrint('$dataBaru4');
    });
  }

  logout1() {
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
              setState(() {
                loading = true;
              });
              updateData4(destination.text, vidx.text);
            },
            tooltip: "Refresh Data",
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await logout1();
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
            return Center(
                child: loading
                    ? const CircularProgressIndicator()
                    : const Text("No Data"));
          } else {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 10),
                    Text(
                      "${data4[index]['vidx']}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    const SizedBox(height: 40),
                    Container(
                      alignment: Alignment.bottomLeft,
                      margin: const EdgeInsets.only(left: 10),
                      child: Text(
                        "Total Rows: ${data4.length}",
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                    SizedBox(
                      height: 545,
                      // width: 300,
                      child: DataTable2(
                        columnSpacing: 12,
                        horizontalMargin: 12,
                        minWidth: 700,
                        columns: [
                          DataColumn(label: Text("IDX")),
                          DataColumn(label: Text("Category")),
                          DataColumn(label: Text("Date")),
                          DataColumn2(
                              label: Text("Description"), size: ColumnSize.L),
                          DataColumn2(
                              label: Text("Resolution"), size: ColumnSize.L),
                          DataColumn2(
                              label: Text("Status"), size: ColumnSize.S),
                        ],
                        rows: List<DataRow>.generate(
                          data4.length,
                          (index) => DataRow(
                            color: MaterialStateProperty.resolveWith<Color?>(
                                (Set<MaterialState> states) {
                              // Even rows will have a grey color.
                              if (index.isOdd) {
                                return Colors.grey.withOpacity(0.3);
                              }
                              return null; // Use default value for other states and odd rows.
                            }),
                            cells: <DataCell>[
                              DataCell(Text("${data4[index]['idx']}")),
                              DataCell(Text("${data4[index]['category']}")),
                              DataCell(Text(DateFormat('MMM d, yyyy').format(
                                  DateTime.parse(data4[index]['date'])
                                      .toLocal()))),
                              DataCell(Text("${data4[index]['description']}")),
                              DataCell(Text("${data4[index]['resolution']}")),
                              DataCell(Text(
                                "${data4[index]['status']}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red),
                              )),
                            ],
                          ),
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
              vidx4: vidx4,
              bookin3: bookin3,
              bookout3: bookout3,
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
