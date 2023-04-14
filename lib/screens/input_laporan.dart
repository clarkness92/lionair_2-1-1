import "dart:async";
import 'dart:io';
import 'package:flutter/material.dart';
import "package:intl/intl.dart";
import 'package:lionair_2/screens/laporan.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:xml2json/xml2json.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import 'lihat_reservasi.dart';
import 'package:xml/xml.dart' as xml;
import 'package:image_picker/image_picker.dart';

class InputLaporan extends StatefulWidget {
  var data;
  var data1;
  var data2;
  var data3;
  var data4;

  InputLaporan(
      {super.key,
      required this.data,
      required this.data1,
      required this.data2,
      required this.data3,
      required this.data4});

  @override
  State<InputLaporan> createState() =>
      _InputLaporanState(data, data1, data2, data3, data4);
}

class _InputLaporanState extends State<InputLaporan> {
  _InputLaporanState(this.data, this.data1, this.data2, this.data3, this.data4);

  final _formKey = GlobalKey<FormState>();

  Xml2Json xml2json = Xml2Json();

  var loading = false;
  List data = [];
  List data1 = [];
  List data2 = [];
  List data3 = [];
  List data4 = [];

  List result = [];
  String userInput = "";

  final TextEditingController vidx = TextEditingController();
  final TextEditingController description = TextEditingController();

  DateTime selectDate = DateTime.now();
  DateTimeRange dateRange = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now().add(const Duration(days: 7)),
  );

  Future pickDateRange() async {
    DateTimeRange? newDateRange = await showDateRangePicker(
      context: context,
      initialDateRange: dateRange,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (newDateRange == null) return; //for button X

    setState(() => dateRange = newDateRange); //for button SAVE
  }

  String location = 'Balaraja';
  String category = 'KEAMANAN/KETERTIBAN';

  DropdownMenuItem<String> buildmenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      );

  final items = ['Balaraja'];
  List<String> listCategory = [
    'KEAMANAN/KETERTIBAN',
    'KEBERSIHAN',
    'KERUSAKAN BARANG'
  ];

  void _addReport(String vidx, String description) async {
    String namaasli = data[0]['namaasli'];
    vidx = data4[0]['vidx'];

    final String soapEnvelope = '<?xml version="1.0" encoding="utf-8"?>' +
        '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">' +
        '<soap:Body>' +
        '<TenantReport_Entry xmlns="http://tempuri.org/">' +
        '<UsernameAPI>admin</UsernameAPI>' +
        '<PasswordAPI>admin</PasswordAPI>' +
        '<Destination>$location</Destination>' +
        '<VIDX>$vidx</VIDX>' +
        '<CATEGORY>$category</CATEGORY>' +
        '<DESCRIPTION>$description</DESCRIPTION>' +
        '<USERINSERT>$namaasli</USERINSERT>' +
        '</TenantReport_Entry>' +
        '</soap:Body>' +
        '</soap:Envelope>';

    final response = await http.post(Uri.parse(url_TenantReport_Entry),
        headers: <String, String>{
          "Access-Control-Allow-Origin": "*",
          'SOAPAction': 'http://tempuri.org/TenantReport_Entry',
          'Access-Control-Allow-Credentials': 'true',
          'Content-type': 'text/xml; charset=utf-8'
        },
        body: soapEnvelope);

    if (response.statusCode == 200) {
      final responseBody = response.body;
      final parsedResponse = xml.XmlDocument.parse(responseBody);
      final result = parsedResponse.findAllElements('_x002D_').single.text;
      debugPrint('Result: $result');
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
  }

  @override
  Widget build(BuildContext context) {
    final start = dateRange.start;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Report",
                      style:
                          TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                    ),
                    Column(
                      children: [
                        const Text('Today'),
                        Text(
                          DateFormat(DateFormat.YEAR_ABBR_MONTH_WEEKDAY_DAY)
                              .format(start),
                          style: const TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    const Text("Mess Location"),
                    const SizedBox(height: 15),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.black, width: 2),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                              value: location,
                              iconSize: 23,
                              isExpanded: true,
                              items: items.map(buildmenuItem).toList(),
                              onChanged: (value) {
                                setState(() {
                                  location = value!;
                                });
                              }),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30.0),
                    TextField(
                      enabled: false,
                      controller: vidx,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: '${data3[0]['idx']}',
                      ),
                    ),
                    const SizedBox(height: 30.0),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.black, width: 2),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                              value: category,
                              iconSize: 23,
                              isExpanded: true,
                              items: listCategory.map(buildmenuItem).toList(),
                              onChanged: (value) {
                                setState(() {
                                  category = value!;
                                });
                              }),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30.0),
                    TextField(
                      controller: description,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Description',
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () async {
                        _addReport(vidx.text, description.text);
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Lihatlaporan(
                              data: data,
                              data1: data1,
                              data2: data2,
                              data3: data3,
                              data4: data4),
                        ));
                      },
                      child: const Text("Submit"),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => Lihatlaporan(
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
          tooltip: "Back to Report",
          child: const Icon(
            Icons.cancel_outlined,
            size: 45,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
