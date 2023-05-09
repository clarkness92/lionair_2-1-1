// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables, no_logic_in_create_state, prefer_interpolation_to_compose_strings, prefer_adjacent_string_concatenation, use_build_context_synchronously

import "dart:async";
import 'package:flutter/material.dart';
import "package:intl/intl.dart";
import 'package:lionair_2/screens/laporan.dart';
import 'package:status_alert/status_alert.dart';
import 'package:xml2json/xml2json.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import 'package:xml/xml.dart' as xml;

class InputLaporan extends StatefulWidget {
  var userapi;
  var passapi;
  var data;
  var data1;
  var data2;
  var data3;
  var data4;
  var vidx4;
  var bookin3;
  var bookout3;

  InputLaporan(
      {super.key,
      required this.userapi,
      required this.passapi,
      required this.data,
      required this.data1,
      required this.data2,
      required this.data3,
      required this.data4,
      required this.vidx4,
      required this.bookin3,
      required this.bookout3});

  @override
  State<InputLaporan> createState() => _InputLaporanState(userapi, passapi,
      data, data1, data2, data3, data4, vidx4, bookin3, bookout3);
}

class _InputLaporanState extends State<InputLaporan> {
  _InputLaporanState(
      this.userapi,
      this.passapi,
      this.data,
      this.data1,
      this.data2,
      this.data3,
      this.data4,
      this.vidx4,
      this.bookin3,
      this.bookout3);

  final _formKey = GlobalKey<FormState>();

  Xml2Json xml2json = Xml2Json();

  var loading = false;
  List data = [];
  List data1 = [];
  List data2 = [];
  List data3 = [];
  List data4 = [];
  List result = [];
  var vidx4;
  var bookin3;
  var bookout3;
  var userapi;
  var passapi;

  DateTime selectDate = DateTime.now();

  String location = 'Balaraja';
  String category = 'KEAMANAN/KETERTIBAN';
  final items = ['Balaraja', 'Makassar', 'Manado'];
  List<String> listCategory = [
    'KEAMANAN/KETERTIBAN',
    'KEBERSIHAN',
    'KERUSAKAN BARANG'
  ];

  final TextEditingController vidx = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController destination = TextEditingController();

  Future pickDate() async {
    final DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: selectDate,
      firstDate: DateTime.parse(bookin3).toLocal(),
      lastDate: DateTime.parse(bookout3).toLocal().add(const Duration(days: 7)),
    );
    if (newDate == null) return; //for button X

    setState(() => selectDate = newDate); //for button SAVE
  }

  DropdownMenuItem<String> buildmenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      );

  void _addReport(String idx, String description) async {
    String namaasli = data[0]['namaasli'];
    idx = idx;

    final String soapEnvelope = '<?xml version="1.0" encoding="utf-8"?>' +
        '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">' +
        '<soap:Body>' +
        '<TenantReport_Entry xmlns="http://tempuri.org/">' +
        '<UsernameAPI>$userapi</UsernameAPI>' +
        '<PasswordAPI>$passapi</PasswordAPI>' +
        '<Destination>$location</Destination>' +
        '<VIDX>$idx</VIDX>' +
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
      StatusAlert.show(context,
          duration: const Duration(seconds: 1),
          configuration:
              const IconConfiguration(icon: Icons.done, color: Colors.green),
          title: "Input Data Success",
          subtitle: "Please Refresh!!",
          backgroundColor: Colors.grey[300]);
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Lihatlaporan(
            userapi: userapi,
            passapi: passapi,
            data: data,
            data1: data1,
            data2: data2,
            data3: data3,
            data4: data4,
            vidx4: vidx4,
            bookin3: bookin3,
            bookout3: bookout3),
      ));
    } else {
      debugPrint('Error: ${response.statusCode}');
      StatusAlert.show(
        context,
        duration: const Duration(seconds: 1),
        configuration:
            const IconConfiguration(icon: Icons.error, color: Colors.red),
        title: "Input Data4 Failed, ${response.statusCode}",
        backgroundColor: Colors.grey[300],
      );
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    vidx.text = vidx4;
    destination.text = location;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Complaint",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).textScaleFactor * 33,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Column(
                      children: [
                        const Text('Date'),
                        Text(
                          DateFormat('MMM dd, yyyy').format(selectDate),
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).textScaleFactor * 20),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: () async {
                        pickDate();
                      },
                      icon: const Icon(Icons.calendar_month_outlined),
                      label: const Text(
                        "Choose",
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      "Mess Location",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
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
                    const SizedBox(height: 30),
                    TextField(
                      enabled: false,
                      controller: vidx,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Reservation ID",
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      "Category",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
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
                    const SizedBox(height: 30),
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
                        if (location == 'Makassar' || location == 'Manado') {
                          StatusAlert.show(
                            context,
                            duration: const Duration(seconds: 1),
                            configuration: const IconConfiguration(
                                icon: Icons.error, color: Colors.red),
                            title: "Still On Progress",
                            backgroundColor: Colors.grey[300],
                          );
                        } else {
                          _addReport(vidx.text, description.text);
                        }
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
                userapi: userapi,
                passapi: passapi,
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
