// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables, no_logic_in_create_state, no_leading_underscores_for_local_identifiers, prefer_interpolation_to_compose_strings, prefer_adjacent_string_concatenation, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:status_alert/status_alert.dart';
import '../constants.dart';
import 'package:xml/xml.dart' as xml;
import 'package:http/http.dart' as http;
import 'lihat_reservasi.dart';

class LihatRating extends StatefulWidget {
  var userapi;
  var passapi;
  var data;
  var data1;
  var data2;
  var data3;
  var data7;

  LihatRating({
    super.key,
    required this.userapi,
    required this.passapi,
    required this.data,
    required this.data1,
    required this.data2,
    required this.data3,
    required this.data7,
  });

  @override
  State<LihatRating> createState() =>
      _LihatRatingState(userapi, passapi, data, data1, data2, data3, data7);
}

class _LihatRatingState extends State<LihatRating> {
  _LihatRatingState(this.userapi, this.passapi, this.data, this.data1,
      this.data2, this.data3, this.data7);

  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  bool loading1 = false;

  List data = [];
  List data1 = [];
  List data2 = [];
  List data3 = [];
  List data7 = [];
  var hasilJson;
  var userapi;
  var passapi;
  late double ratingBaru;
  final double _initialRating = 0;

  TextEditingController destination = TextEditingController();
  TextEditingController idpegawai = TextEditingController();
  TextEditingController vidx = TextEditingController();
  final TextEditingController _rating = TextEditingController();
  TextEditingController idx = TextEditingController();

  void updateRating(String _rating, String idx, index) async {
    final temporaryList9 = [];
    idx = data3[index]['idx'];
    _rating = String.fromCharCode(ratingBaru.round() + 48);
    String objBody = '<?xml version="1.0" encoding="utf-8"?>' +
        '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">' +
        '<soap:Body>' +
        '<RATING_UpdateData xmlns="http://tempuri.org/">' +
        '<UsernameAPI>$userapi</UsernameAPI>' +
        '<PasswordAPI>$passapi</PasswordAPI>' +
        '<Destination>BLJ</Destination>' +
        '<IDX>$idx</IDX>' +
        '<Rating>$_rating</Rating>' +
        '</RATING_UpdateData>' +
        '</soap:Body>' +
        '</soap:Envelope>';

    final response = await http.post(Uri.parse(url_RATING_UpdateData),
        headers: <String, String>{
          "Access-Control-Allow-Origin": "*",
          'SOAPAction': 'http://tempuri.org/RATING_UpdateData',
          'Access-Control-Allow-Credentials': 'true',
          'Content-type': 'text/xml; charset=utf-8'
        },
        body: objBody);

    if (response.statusCode == 200) {
      final responseBody = response.body;
      final parsedResponse = xml.XmlDocument.parse(responseBody);
      final result = parsedResponse.findAllElements('_x002D_').single.text;
      debugPrint('Result: $result');
    } else {
      debugPrint('Error: ${response.statusCode}');
      StatusAlert.show(
        context,
        duration: const Duration(seconds: 1),
        configuration:
            const IconConfiguration(icon: Icons.error, color: Colors.red),
        title: "Input Data7 Failed, ${response.statusCode}",
        backgroundColor: Colors.grey[300],
      );
    }
  }

  @override
  void initState() {
    super.initState();
    ratingBaru = _initialRating;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () async {
            data7.clear();
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => LihatDataEmployee(
                userapi: userapi,
                passapi: passapi,
                data: data,
                data1: data1,
                data2: data2,
                data3: data3,
              ),
            ));
          },
        ),
        title: const Text("Rating"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () async {
              setState(() {
                loading = true;
              });
            },
            tooltip: "Refresh Data",
          ),
        ],
        centerTitle: true,
        backgroundColor: Colors.redAccent,
      ),
      body: Center(
        child: loading
            ? const CircularProgressIndicator()
            : ListView.builder(
                key: _formKey,
                itemCount: data7.length,
                itemBuilder: (context, index) {
                  if (data3.isEmpty) {
                    return const Center(child: Text("No Data"));
                  } else {
                    return Card(
                      margin: const EdgeInsets.all(8),
                      elevation: 8,
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Text(
                              '${data7[index]['idx']}',
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),
      ),
    );
  }
}
