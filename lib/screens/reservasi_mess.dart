// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables, no_logic_in_create_state, unused_field, prefer_interpolation_to_compose_strings, prefer_adjacent_string_concatenation, use_build_context_synchronously

import 'package:flutter/material.dart';
import "dart:async";
import "package:intl/intl.dart";
import 'package:lionair_2/screens/home_screen.dart';
import 'package:status_alert/status_alert.dart';
import 'package:xml2json/xml2json.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import 'package:xml/xml.dart' as xml;

class ReservasiMess extends StatefulWidget {
  var userapi;
  var passapi;
  var data;
  var data1;
  var data2;

  ReservasiMess(
      {super.key,
      required this.userapi,
      required this.passapi,
      required this.data,
      required this.data1,
      required this.data2});

  @override
  State<ReservasiMess> createState() =>
      _ReservasiMessState(userapi, passapi, data, data1, data2);
}

class _ReservasiMessState extends State<ReservasiMess> {
  _ReservasiMessState(
      this.userapi, this.passapi, this.data, this.data1, this.data2);

  final _formKey = GlobalKey<FormState>();

  Xml2Json xml2json = Xml2Json();

  var loading = false;
  List data = [];
  List data1 = [];
  List data2 = [];
  List result = [];
  var gender1;
  var userapi;
  var passapi;

  DateTime selectDate = DateTime.now();

  String location = 'Balaraja';
  List<String> items = ['Balaraja', 'Makassar', 'Manado'];

  final TextEditingController destination = TextEditingController();
  final TextEditingController gender = TextEditingController();
  final TextEditingController necessary = TextEditingController();
  final TextEditingController notes = TextEditingController();

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

    setState(() {
      dateRange = newDateRange;
    }); //for button SAVE
  }

  DropdownMenuItem<String> buildmenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      );

  void _sendReservation(String gender, String necessary, String notes) async {
    String idpegawai = data[0]['idemployee'];
    String nama = data[0]['namaasli'];
    String title = data[0]['division'];

    final String soapEnvelope = '<?xml version="1.0" encoding="utf-8"?>' +
        '<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">' +
        '<soap:Body>' +
        '<InputWebReservation xmlns="http://tempuri.org/">' +
        '<UsernameApi>$userapi</UsernameApi>' +
        '<PasswordApi>$passapi</PasswordApi>' +
        '<DESTINATION>$location</DESTINATION>' +
        '<IDREFF>Android</IDREFF>' +
        '<IDSTAFF>$idpegawai</IDSTAFF>' +
        '<NAME>$nama</NAME>' +
        '<GENDER>$gender</GENDER>' +
        '<TITLE>$title</TITLE>' +
        '<CHECKIN>${dateRange.start.toIso8601String()}</CHECKIN>' +
        '<CHECKOUT>${dateRange.end.toIso8601String()}</CHECKOUT>' +
        '<NECESSARY>$necessary</NECESSARY>' +
        '<NOTES>$notes</NOTES>' +
        '</InputWebReservation>' +
        '</soap:Body>' +
        '</soap:Envelope>';

    final response = await http.post(Uri.parse(url_InputWebReservation),
        headers: <String, String>{
          "Access-Control-Allow-Origin": "*",
          'SOAPAction': 'http://tempuri.org/InputWebReservation',
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
      StatusAlert.show(context,
          duration: const Duration(seconds: 1),
          configuration:
              const IconConfiguration(icon: Icons.done, color: Colors.green),
          title: "Input Data Success",
          subtitle: "Please Refresh!!",
          backgroundColor: Colors.grey[300]);
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => HomeScreen(
            userapi: userapi,
            passapi: passapi,
            data: data,
            data1: data1,
            data2: data2),
      ));
    } else {
      debugPrint('Error: ${response.statusCode}');
      StatusAlert.show(
        context,
        duration: const Duration(seconds: 1),
        configuration:
            const IconConfiguration(icon: Icons.error, color: Colors.red),
        title: "Input Data1 Failed, ${response.statusCode}",
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
    destination.text = location;
    gender.text = data[0]['gender'];
  }

  @override
  Widget build(BuildContext context) {
    final start = dateRange.start;
    final end = dateRange.end;

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
                      "Reservation",
                      style:
                          TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Column(
                      children: [
                        const Text('Start Date:'),
                        Text(
                          DateFormat(DateFormat.YEAR_ABBR_MONTH_WEEKDAY_DAY)
                              .format(start),
                          style: const TextStyle(fontSize: 20),
                        ),
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
                      onPressed: () async {
                        pickDateRange();
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
                      controller: gender,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Gender",
                      ),
                    ),
                    const SizedBox(height: 30.0),
                    TextField(
                      maxLength: 20,
                      controller: necessary,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Necessary',
                      ),
                    ),
                    const SizedBox(height: 30.0),
                    TextField(
                      maxLength: 20,
                      controller: notes,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Notes',
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
                          _sendReservation(
                              gender.text, necessary.text, notes.text);
                        }
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
              builder: (context) => HomeScreen(
                userapi: userapi,
                passapi: passapi,
                data: data,
                data1: data1,
                data2: data2,
              ),
            ));
          },
          backgroundColor: Colors.red,
          elevation: 12,
          tooltip: "Back to HomeScreen",
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
