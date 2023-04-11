import 'package:flutter/material.dart';
import "dart:async";
import "package:intl/intl.dart";
import 'package:lionair_2/screens/home_screen.dart';
import 'package:lionair_2/screens/laporan.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:xml2json/xml2json.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import 'lihat_reservasi.dart';
import 'package:xml/xml.dart' as xml;
import 'login_screen.dart' as login;
import 'package:flutter/foundation.dart' show debugPrint;

class InputLaporan extends StatefulWidget {
  var data;
  var data1;

  InputLaporan({super.key, required this.data, required this.data1});

  @override
  State<InputLaporan> createState() => _InputLaporanState(data, data1);
}

class _InputLaporanState extends State<InputLaporan> {
  _InputLaporanState(this.data, this.data1);

  final _formKey = GlobalKey<FormState>();

  String? name, idstaff, gender, title;
  Xml2Json xml2json = new Xml2Json();

  var loading = false;
  List data = [];
  List data1 = [];

  List result = [];
  String userInput = "";

  final TextEditingController vidx = TextEditingController();
  final TextEditingController category = TextEditingController();
  final TextEditingController description = TextEditingController();

  DateTime selectDate = DateTime.now();
  DateTimeRange dateRange = DateTimeRange(
    start: DateTime(2023, 1, 1),
    end: DateTime(2023, 1, 1),
  );

  Future pickDateRange() async {
    DateTimeRange? newDateRange = await showDateRangePicker(
      context: context,
      initialDateRange: dateRange,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (newDateRange == null) return; //for button X

    setState(() => dateRange = newDateRange); //for button SAVE
  }

  String? value;

  DropdownMenuItem<String> buildmenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      );

  final items = ['Balaraja', 'Makassar', 'Manado'];

  void _addReport(String vidx, String category, String description) async {
    String namaasli = data[0]['namaasli'];

    final String soapEnvelope = '<?xml version="1.0" encoding="utf-8"?>' +
        '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">' +
        '<soap:Body>' +
        '<TenantReport_Entry xmlns="http://tempuri.org/">' +
        '<UsernameAPI>admin</UsernameAPI>' +
        '<PasswordAPI>admin</PasswordAPI>' +
        '<Destination>BLJ</Destination>' +
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
      final result = parsedResponse
          .findAllElements('InputWebReservationResult')
          .single
          .text;
      debugPrint('Result: $result');
    } else {
      debugPrint('Error: ${response.statusCode}');
      Alert(
        context: context,
        type: AlertType.error,
        title: "Login Gagal, ${response.statusCode}",
      ).show();
      Timer(Duration(seconds: 2), () {
        Navigator.pop(context);
      });
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final start = dateRange.start;
    final end = dateRange.end;
    final difference = dateRange.duration;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Select Date",
                      style: TextStyle(fontSize: 25),
                    ),
                    const SizedBox(height: 20),
                    Column(
                      children: [
                        // const SizedBox(height: 20),
                        const Text('Start Date:'),
                        Text(
                          DateFormat(DateFormat.YEAR_ABBR_MONTH_WEEKDAY_DAY)
                              .format(start),
                          style: const TextStyle(fontSize: 20),
                        ),
                        // const Text(" --- "),
                        const SizedBox(height: 20),
                        const Text('End Date:'),
                        Text(
                          DateFormat(DateFormat.YEAR_ABBR_MONTH_WEEKDAY_DAY)
                              .format(end),
                          style: const TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: pickDateRange,
                      icon: const Icon(Icons.calendar_month_outlined),
                      label: const Text(
                        "Choose",
                      ),
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
                            value: value,
                            iconSize: 23,
                            isExpanded: true,
                            items: items.map(buildmenuItem).toList(),
                            onChanged: (value) =>
                                setState(() => this.value = value),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30.0),
                    TextField(
                      controller: vidx,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'VIDX',
                      ),
                    ),
                    const SizedBox(height: 30.0),
                    TextField(
                      controller: category,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Category',
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
                        _addReport(vidx.text, category.text, description.text);
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              LihatDataEmployee(data: data, data1: data1),
                        ));
                      },
                      child: const Text("Submit"),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    // Text("$dateRange"),
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
              ),
            ));
          },
          backgroundColor: Colors.red,
          child: const Icon(
            Icons.cancel_outlined,
            size: 45,
          ),
          elevation: 12,
          tooltip: "Back to HomeScreen",
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
