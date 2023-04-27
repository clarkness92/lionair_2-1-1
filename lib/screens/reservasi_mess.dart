import 'package:flutter/material.dart';
import "dart:async";
import "package:intl/intl.dart";
import 'package:lionair_2/screens/home_screen.dart';
import 'package:status_alert/status_alert.dart';
import 'package:status_alert/status_alert.dart';
import 'package:xml2json/xml2json.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import 'package:xml/xml.dart' as xml;

class ReservasiMess extends StatefulWidget {
  var data;
  var data1;
  var data2;

  ReservasiMess(
      {super.key,
      required this.data,
      required this.data1,
      required this.data2});

  @override
  State<ReservasiMess> createState() => _ReservasiMessState(data, data1, data2);
}

class _ReservasiMessState extends State<ReservasiMess> {
  _ReservasiMessState(this.data, this.data1, this.data2);

  final _formKey = GlobalKey<FormState>();

  Xml2Json xml2json = Xml2Json();

  var loading = false;
  List data = [];
  List data1 = [];
  List data2 = [];
  List result = [];
  var gender1;

  final TextEditingController destination = TextEditingController();
  final TextEditingController gender = TextEditingController();
  final TextEditingController notes = TextEditingController();
  final TextEditingController necessary = TextEditingController();

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

    setState(() {
      dateRange = newDateRange;
    }); //for button SAVE
  }

  String location = 'Balaraja';

  DropdownMenuItem<String> buildmenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      );

  List<String> items = ['Balaraja'];

  void _sendReservation(String gender, String necessary, String notes) async {
    String idpegawai = data[0]['idemployee'];
    String nama = data[0]['namaasli'];
    String title = data[0]['division'];

    final String soapEnvelope = '<?xml version="1.0" encoding="utf-8"?>' +
        '<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">' +
        '<soap:Body>' +
        '<InputWebReservation xmlns="http://tempuri.org/">' +
        '<UsernameApi>admin</UsernameApi>' +
        '<PasswordApi>admin</PasswordApi>' +
        '<DESTINATION>BLJ</DESTINATION>' +
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
    } else {
      debugPrint('Error: ${response.statusCode}');
      StatusAlert.show(
        context,
        duration: Duration(seconds: 1),
        configuration: IconConfiguration(icon: Icons.error),
        title: "Input Data Failed, ${response.statusCode}",
        backgroundColor: Colors.grey[300],
      );
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
                    TextField(
                      enabled: false,
                      controller: destination,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Mess Location",
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
                        _sendReservation(
                            gender.text, necessary.text, notes.text);
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => HomeScreen(
                              data: data, data1: data1, data2: data2),
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
              builder: (context) => HomeScreen(
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
