// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables, no_logic_in_create_state, prefer_adjacent_string_concatenation, prefer_interpolation_to_compose_strings, non_constant_identifier_names, use_build_context_synchronously

import 'dart:convert';
import 'package:clipboard/clipboard.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:status_alert/status_alert.dart';
import '../constants.dart';
import 'package:http/http.dart' as http;
import 'package:xml2json/xml2json.dart';
import 'package:xml/xml.dart' as xml;

class PendingScreen extends StatefulWidget {
  var userapi;
  var passapi;
  var data;
  var data1;

  PendingScreen(
      {super.key,
      required this.userapi,
      required this.passapi,
      required this.data,
      required this.data1});

  @override
  State<PendingScreen> createState() =>
      _PendingScreenState(userapi, passapi, data, data1);
}

class _PendingScreenState extends State<PendingScreen> {
  _PendingScreenState(this.userapi, this.passapi, this.data, this.data1);
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  bool _isConnected = true;

  List data = [];
  List data1 = [];
  List dataBaru1 = [];
  Xml2Json xml2json = Xml2Json();
  var hasilJson;
  var userapi;
  var passapi;

  TextEditingController destination = TextEditingController();
  TextEditingController idpegawai = TextEditingController();

  void updateData1(String destination, String idpegawai) async {
    final temporaryList1_1 = [];
    idpegawai = data[0]['idemployee'];
    data1.clear();

    String objBody = '<?xml version="1.0" encoding="utf-8"?>' +
        '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">' +
        '<soap:Body>' +
        '<GetReservationByIDSTaffPending xmlns="http://tempuri.org/">' +
        '<UsernameApi>$userapi</UsernameApi>' +
        '<PasswordApi>$passapi</PasswordApi>' +
        '<DESTINATION>BLJ</DESTINATION>' +
        '<IDSTAFF>$idpegawai</IDSTAFF>' +
        '</GetReservationByIDSTaffPending>' +
        '</soap:Body>' +
        '</soap:Envelope>';

    final response =
        await http.post(Uri.parse(url_GetReservationByIDSTaffPending),
            headers: <String, String>{
              "Access-Control-Allow-Origin": "*",
              'SOAPAction': 'http://tempuri.org/GetReservationByIDSTaffPending',
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

      final listResultAll1 = document.findAllElements('_x002D_');

      for (final list_result in listResultAll1) {
        final idx = list_result.findElements('IDX').first.text;
        final checkin = list_result.findElements('CHECKIN').first.text;
        final checkout = list_result.findElements('CHECKOUT').first.text;
        final necessary = list_result.findElements('NECESSARY').first.text;
        final notes = list_result.findElements('NOTES').first.text;
        final insertdate = list_result.findElements('INSERTDATE').first.text;
        temporaryList1_1.add({
          'idx': idx,
          'checkin': checkin,
          'checkout': checkout,
          'necessary': necessary,
          'notes': notes,
          'insertdate': insertdate,
        });
        debugPrint("object 1.1");
        hasilJson = jsonEncode(temporaryList1_1);

        debugPrint(hasilJson);
        debugPrint("object_hasilJson 1.1");
      }
      Future.delayed(const Duration(seconds: 3), () {
        Map<String, dynamic> map1 =
            Map.fromIterable(data1, key: (e) => e['idx']);
        Map<String, dynamic> map2 =
            Map.fromIterable(dataBaru1, key: (e) => e['idx']);

        map1.addAll(map2);

        List mergedList = map1.values.toList();

        // debugPrint('$mergedList');

        setState(() {
          data1 = mergedList;
          loading = false;
        });
      });
    } else {
      debugPrint('Error: ${response.statusCode}');
      StatusAlert.show(
        context,
        duration: const Duration(seconds: 1),
        configuration:
            const IconConfiguration(icon: Icons.error, color: Colors.red),
        title: "Update1 Failed, ${response.statusCode}",
        backgroundColor: Colors.grey[300],
      );
      setState(() {
        loading = false;
      });
    }
    setState(() {
      dataBaru1 = temporaryList1_1;
      loading = true;
      debugPrint('$dataBaru1');
    });
  }

  @override
  void initState() {
    super.initState();
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        _isConnected = (result != ConnectivityResult.none);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pending Reservation"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () async {
              setState(() {
                loading = true;
              });
              updateData1(destination.text, idpegawai.text);
            },
            tooltip: "Refresh Data",
          ),
        ],
        centerTitle: true,
        backgroundColor: Colors.redAccent,
      ),
      body: !_isConnected
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('No Internet Connection,'),
                  Text('Please Check Your Connection!!'),
                ],
              ),
            )
          : ListView.builder(
              key: _formKey,
              itemCount: 1,
              itemBuilder: (context, index) {
                return data1.isEmpty
                    ? Container(
                        height: size.height * 0.785,
                        alignment: Alignment.center,
                        child: loading
                            ? const CircularProgressIndicator()
                            : const Text(
                                "No Data",
                              ),
                      )
                    : Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Column(
                            children: <Widget>[
                              Text("Total Pending : ${data1.length}"),
                              SizedBox(
                                width: size.width * 0.98,
                                height: size.height * 0.73,
                                child: loading
                                    ? const CircularProgressIndicator()
                                    : ListView.builder(
                                        itemCount: data1.length,
                                        itemBuilder: (context, index) {
                                          return Card(
                                            color: Colors.white,
                                            elevation: 8.0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                            ),
                                            child: Container(
                                              margin: const EdgeInsets.all(10),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: <Widget>[
                                                  Container(
                                                    color: Colors.black12,
                                                    height: 45,
                                                    child: Row(children: [
                                                      GestureDetector(
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              "${data1[index]['idx']} ",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      MediaQuery.of(context)
                                                                              .textScaleFactor *
                                                                          18),
                                                            ),
                                                            const Icon(
                                                              Icons
                                                                  .copy_rounded,
                                                              color: Colors
                                                                  .black38,
                                                            ),
                                                          ],
                                                        ),
                                                        onTap: () {
                                                          FlutterClipboard.copy(
                                                              '${data1[index]['idx']}'); // copy teks ke clipboard
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            const SnackBar(
                                                              content: Text(
                                                                  'Pending Reservation ID copied!'),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                      const Spacer(
                                                        flex: 1,
                                                      ),
                                                      Text(
                                                        DateFormat(
                                                                'MMM dd, yyyy')
                                                            .format(DateTime.parse(
                                                                    data1[index]
                                                                        [
                                                                        'insertdate'])
                                                                .toLocal()),
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ]),
                                                  ),
                                                  const Divider(
                                                    thickness: 2,
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(children: [
                                                              Text("Necessary"),
                                                            ]),
                                                            Row(children: [
                                                              Text("Notes"),
                                                            ]),
                                                          ]),
                                                      Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(children: [
                                                              Text(
                                                                " ${data1[index]['necessary']}",
                                                                style: const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              )
                                                            ]),
                                                            Row(children: [
                                                              Text(
                                                                " ${data1[index]['notes']}",
                                                                style: const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ]),
                                                          ]),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  const Divider(
                                                    thickness: 2,
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(children: [
                                                            Text("Book-In"),
                                                          ]),
                                                          Row(
                                                            children: [
                                                              Text("Book-Out"),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(children: [
                                                            Text(
                                                              DateFormat(
                                                                      ' : MMM dd, yyyy')
                                                                  .format(DateTime.parse(
                                                                          data1[index]
                                                                              [
                                                                              'checkin'])
                                                                      .toLocal()),
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ]),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                DateFormat(
                                                                        ' : MMM dd, yyyy')
                                                                    .format(DateTime.parse(data1[index]
                                                                            [
                                                                            'checkout'])
                                                                        .toLocal()),
                                                                style: const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }),
                              ),
                            ],
                          ),
                        ),
                      );
              },
            ),
    );
  }
}
