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
import 'laporan.dart';

class CurrentScreen extends StatefulWidget {
  var userapi;
  var passapi;
  var data;
  var data1;
  var data2;

  CurrentScreen(
      {super.key,
      required this.userapi,
      required this.passapi,
      required this.data,
      required this.data1,
      required this.data2});

  @override
  State<CurrentScreen> createState() =>
      _CurrentScreenState(userapi, passapi, data, data1, data2);
}

class _CurrentScreenState extends State<CurrentScreen> {
  _CurrentScreenState(
      this.userapi, this.passapi, this.data, this.data1, this.data2);
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  bool loading1 = false;
  bool loading2 = false;
  bool _isConnected = true;

  List data = [];
  List data1 = [];
  List data2 = [];
  List data3 = [];
  List data4 = [];
  List dataBaru2 = [];
  Xml2Json xml2json = Xml2Json();
  var hasilJson;
  var vidxBaru;
  var bookinBaru;
  var bookoutBaru;
  var userapi;
  var passapi;

  TextEditingController destination = TextEditingController();
  TextEditingController idpegawai = TextEditingController();
  TextEditingController vidx = TextEditingController();
  TextEditingController otp = TextEditingController();
  TextEditingController phone = TextEditingController();

  void updateData2(String destination, String idpegawai) async {
    final temporaryList2_1 = [];
    idpegawai = data[0]['idemployee'];
    data2.clear();

    String objBody = '<?xml version="1.0" encoding="utf-8"?>' +
        '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">' +
        '<soap:Body>' +
        '<Checktime_GetCurrentStay xmlns="http://tempuri.org/">' +
        '<UsernameAPI>$userapi</UsernameAPI>' +
        '<PasswordAPI>$passapi</PasswordAPI>' +
        '<Destination>BLJ</Destination>' +
        '<IDSTAFF>$idpegawai</IDSTAFF>' +
        '</Checktime_GetCurrentStay>' +
        '</soap:Body>' +
        '</soap:Envelope>';

    final response = await http.post(Uri.parse(url_Checktime_GetCurrentStay),
        headers: <String, String>{
          "Access-Control-Allow-Origin": "*",
          'SOAPAction': 'http://tempuri.org/Checktime_GetCurrentStay',
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

      final listResultAll2 = document.findAllElements('_x002D_');

      for (final list_result in listResultAll2) {
        final idx = list_result.findElements('IDX').first.text;
        final idkamar = list_result.findElements('IDKAMAR').first.text;
        final areamess = list_result.findElements('AREAMESS').first.text;
        final blok = list_result.findElements('BLOK').first.text;
        final nokamar = list_result.findElements('NOKAMAR').first.text;
        final namabed = list_result.findElements('NAMABED').first.text;
        final bookin = list_result.findElements('BOOKIN').first.text;
        final bookout = list_result.findElements('BOOKOUT').first.text;
        final otpid = list_result.findElements('OTPID').first.text;
        temporaryList2_1.add({
          'idx': idx,
          'idkamar': idkamar,
          'areamess': areamess,
          'blok': blok,
          'nokamar': nokamar,
          'namabed': namabed,
          'bookin': bookin,
          'bookout': bookout,
          'otpid': otpid
        });
        debugPrint("object 2.1");
        hasilJson = jsonEncode(temporaryList2_1);

        debugPrint(hasilJson);
        debugPrint("object_hasilJson 2.1");
      }
      Future.delayed(const Duration(seconds: 3), () {
        Map<String, dynamic> map1 =
            Map.fromIterable(data2, key: (e) => e['idx']);
        Map<String, dynamic> map2 =
            Map.fromIterable(dataBaru2, key: (e) => e['idx']);

        map1.addAll(map2);

        List mergedList = map1.values.toList();

        // debugPrint('$mergedList');

        setState(() {
          data2 = mergedList;
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
        title: "Update2 Failed, ${response.statusCode}",
        backgroundColor: Colors.grey[300],
      );
      setState(() {
        loading = false;
      });
    }
    setState(() {
      dataBaru2 = temporaryList2_1;
      loading = true;
      // debugPrint('$dataBaru2');
    });
  }

  void getReport(String destination, String vidx, index) async {
    final temporaryList4 = [];
    vidx = data2[index]['idx'];
    String bookin = data2[index]['bookin'];
    String bookout = data2[index]['bookout'];

    String objBody = '<?xml version="1.0" encoding="utf-8"?>' +
        '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">' +
        '<soap:Body>' +
        '<TenantReport_GetDataVIDX xmlns="http://tempuri.org/">' +
        '<UsernameAPI>$userapi</UsernameAPI>' +
        '<PasswordAPI>$passapi</PasswordAPI>' +
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

      final listResultAll5 = document.findAllElements('_x002D_');

      for (final list_result in listResultAll5) {
        final idx = list_result.findElements('IDX').first.text;
        final vidx = list_result.findElements('VIDX').first.text;
        final date = list_result.findElements('DATE').first.text;
        final category = list_result.findElements('CATEGORY').first.text;
        final description = list_result.findElements('DESCRIPTION').first.text;
        final resolution = list_result.findElements('RESOLUTION').first.text;
        final userinsert = list_result.findElements('USERINSERT').first.text;
        final status = list_result.findElements('STATUS').first.text;
        temporaryList4.add({
          'idx': idx,
          'vidx': vidx,
          'date': date,
          'category': category,
          'description': description,
          'resolution': resolution,
          'userinsert': userinsert,
          'status': status
        });
        debugPrint("object 4");
        hasilJson = jsonEncode(temporaryList4);

        debugPrint(hasilJson);
        debugPrint("object_hasilJson 4");
      }
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Lihatlaporan(
            userapi: userapi,
            passapi: passapi,
            data: data,
            data1: data1,
            data2: data2,
            data3: data3,
            data4: data4,
            vidx4: vidxBaru,
            bookin3: bookinBaru,
            bookout3: bookoutBaru,
          ),
        ));
        setState(() {
          loading1 = false;
        });
      });
    } else {
      debugPrint('Error: ${response.statusCode}');
      StatusAlert.show(
        context,
        duration: const Duration(seconds: 1),
        configuration:
            const IconConfiguration(icon: Icons.error, color: Colors.red),
        title: "Get Data4 Failed, ${response.statusCode}",
        backgroundColor: Colors.grey[300],
      );
    }
    setState(() {
      data4 = temporaryList4;
      vidxBaru = vidx;
      bookinBaru = bookin;
      bookoutBaru = bookout;
      loading1 = true;
    });
  }

  void getOTP(String phone, index) async {
    String idreff = data2[index]['idx'];
    String userinsert = data[0]['namaasli'];

    String objBody = '<?xml version="1.0" encoding="utf-8"?>' +
        '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">' +
        '<soap:Body>' +
        '<GetOTPWA xmlns="http://tempuri.org/">' +
        '<USERNAMEAPI>$userapi</USERNAMEAPI>' +
        '<PASSWORDAPI>$passapi</PASSWORDAPI>' +
        '<CATEGORY>ADR_MESS_CHECKTIME</CATEGORY>' +
        '<IDREFF>$idreff</IDREFF>' +
        '<TONUMBER>$phone</TONUMBER>' +
        '<VALUE>string</VALUE>' +
        '<NOTES>string</NOTES>' +
        '<USERINSERT>$userinsert</USERINSERT>' +
        '</GetOTPWA>' +
        '</soap:Body>' +
        '</soap:Envelope>';

    final response = await http.post(Uri.parse(url_GetOTPWA),
        headers: <String, String>{
          "Access-Control-Allow-Origin": "*",
          'SOAPAction': 'http://tempuri.org/GetOTPWA',
          "Access-Control-Allow-Credentials": "true",
          'Content-type': 'text/xml; charset=utf-8',
        },
        body: objBody);

    if (response.statusCode == 200) {
      final responseBody = response.body;
      final parsedResponse = xml.XmlDocument.parse(responseBody);
      final result = parsedResponse.findAllElements('_x002D_').single.text;
      debugPrint('Result: $result');
      StatusAlert.show(context,
          duration: const Duration(seconds: 1),
          configuration:
              const IconConfiguration(icon: Icons.done, color: Colors.green),
          title: "OTP has been sent to your WhatsApp",
          subtitle: "Please Check!!",
          backgroundColor: Colors.grey[300]);
    } else {
      debugPrint('Error: ${response.statusCode}');
      StatusAlert.show(
        context,
        duration: const Duration(seconds: 1),
        configuration:
            const IconConfiguration(icon: Icons.error, color: Colors.red),
        title: "Get OTP Failed, ${response.statusCode}",
        backgroundColor: Colors.grey[300],
      );
    }
  }

  void cekOTP(String otp, index) async {
    String idreff1 = data2[index]['idx'];

    String objBody = '<?xml version="1.0" encoding="utf-8"?>' +
        '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">' +
        '<soap:Body>' +
        '<OpenOTP xmlns="http://tempuri.org/">' +
        '<USERNAMEAPI>$userapi</USERNAMEAPI>' +
        '<PASSWORDAPI>$passapi</PASSWORDAPI>' +
        '<IDREFF>$idreff1</IDREFF>' +
        '<OTP>$otp</OTP>' +
        '</OpenOTP>' +
        '</soap:Body>' +
        '</soap:Envelope>';

    final response = await http.post(Uri.parse(url_OpenOTP),
        headers: <String, String>{
          "Access-Control-Allow-Origin": "*",
          'SOAPAction': 'http://tempuri.org/OpenOTP',
          "Access-Control-Allow-Credentials": "true",
          'Content-type': 'text/xml; charset=utf-8',
        },
        body: objBody);

    debugPrint(objBody);

    if (response.statusCode == 200) {
      final responseBody = response.body;
      final parsedResponse = xml.XmlDocument.parse(responseBody);
      final result = parsedResponse.findAllElements('_x002D_').single.text;
      debugPrint('Result: $result');
      if (result != "ERROR:INVALID_OTP") {
        StatusAlert.show(context,
            duration: const Duration(seconds: 1),
            configuration:
                const IconConfiguration(icon: Icons.done, color: Colors.green),
            title: "OTP Valid!!",
            backgroundColor: Colors.grey[300]);
      } else {
        StatusAlert.show(
          context,
          duration: const Duration(seconds: 1),
          configuration:
              const IconConfiguration(icon: Icons.error, color: Colors.red),
          title: "Invalid OTP",
          backgroundColor: Colors.grey[300],
        );
      }
    } else {
      debugPrint('Error: ${response.statusCode}');
      StatusAlert.show(
        context,
        duration: const Duration(seconds: 1),
        configuration:
            const IconConfiguration(icon: Icons.error, color: Colors.red),
        title: "Check OTP Failed, ${response.statusCode}",
        backgroundColor: Colors.grey[300],
      );
    }
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
  void dispose() {
    idpegawai.dispose();
    destination.dispose();
    vidx.dispose();
    otp.dispose();
    phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Current Reservation"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () async {
              setState(() {
                loading = true;
              });
              updateData2(destination.text, idpegawai.text);
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
                return data2.isEmpty
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
                              Text("Total Current : ${data2.length}"),
                              SizedBox(
                                width: size.width * 0.98,
                                height: size.height * 0.73,
                                child: loading
                                    ? const CircularProgressIndicator()
                                    : ListView.builder(
                                        itemCount: data2.length,
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
                                                              "${data2[index]['idx']} ",
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
                                                              '${data2[index]['idx']}'); // copy teks ke clipboard
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            const SnackBar(
                                                              content: Text(
                                                                  'Current Reservation ID copied!'),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                      const Spacer(
                                                        flex: 1,
                                                      ),
                                                      Text(
                                                        "${data2[index]['idkamar']}",
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
                                                              Text("Area"),
                                                            ]),
                                                            Row(children: [
                                                              Text("Block"),
                                                            ]),
                                                            Row(children: [
                                                              Text("Number"),
                                                            ]),
                                                            Row(
                                                              children: [
                                                                Text("Bed"),
                                                              ],
                                                            ),
                                                          ]),
                                                      Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(children: [
                                                              Text(
                                                                " ${data2[index]['areamess']}",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        MediaQuery.of(context).textScaleFactor *
                                                                            12),
                                                              )
                                                            ]),
                                                            Row(children: [
                                                              Text(
                                                                " ${data2[index]['blok']}",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        MediaQuery.of(context).textScaleFactor *
                                                                            12),
                                                              ),
                                                            ]),
                                                            Row(children: [
                                                              Text(
                                                                " ${data2[index]['nokamar']}",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        MediaQuery.of(context).textScaleFactor *
                                                                            12),
                                                              )
                                                            ]),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  " ${data2[index]['namabed']}",
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          MediaQuery.of(context).textScaleFactor *
                                                                              12),
                                                                ),
                                                              ],
                                                            )
                                                          ]),
                                                      const Spacer(
                                                        flex: 1,
                                                      ),
                                                      Column(
                                                        children: [
                                                          SizedBox(
                                                            height: 35,
                                                            width: 95,
                                                            child:
                                                                ElevatedButton(
                                                              onPressed: loading1
                                                                  ? null
                                                                  : () async {
                                                                      setState(
                                                                          () {
                                                                        loading1 =
                                                                            true;
                                                                      });
                                                                      getReport(
                                                                          destination
                                                                              .text,
                                                                          vidx.text,
                                                                          index);
                                                                    },
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                backgroundColor:
                                                                    Colors
                                                                        .redAccent,
                                                              ),
                                                              child: loading1
                                                                  ? const SizedBox(
                                                                      height:
                                                                          28,
                                                                      width: 30,
                                                                      child:
                                                                          CircularProgressIndicator())
                                                                  : Text(
                                                                      "COMPLAINT",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              MediaQuery.of(context).textScaleFactor * 11),
                                                                    ),
                                                            ),
                                                          ),
                                                        ],
                                                      )
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
                                                          Row(children: [
                                                            Text("Book-Out"),
                                                          ]),
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
                                                                          data2[index]
                                                                              [
                                                                              'bookin'])
                                                                      .toLocal()),
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ]),
                                                          Row(children: [
                                                            Text(
                                                              DateFormat(
                                                                      ' : MMM dd, yyyy')
                                                                  .format(DateTime.parse(
                                                                          data2[index]
                                                                              [
                                                                              'bookout'])
                                                                      .toLocal()),
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ]),
                                                        ],
                                                      ),
                                                      const Spacer(
                                                        flex: 1,
                                                      ),
                                                      Column(
                                                        children: [
                                                          Padding(
                                                            padding: EdgeInsets.only(
                                                                right: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.033),
                                                            child: SizedBox(
                                                              height: 30,
                                                              width: 65,
                                                              child:
                                                                  ElevatedButton(
                                                                onPressed: loading2
                                                                    ? null
                                                                    : data2[index]['otpid'] != ""
                                                                        ? null
                                                                        : () async {
                                                                            setState(() {
                                                                              loading2 = true;
                                                                            });
                                                                            Future.delayed(const Duration(seconds: 1),
                                                                                () {
                                                                              setState(() {
                                                                                loading2 = false;
                                                                              });
                                                                              showDialog(
                                                                                  context: context,
                                                                                  builder: (BuildContext context) {
                                                                                    return WillPopScope(
                                                                                      onWillPop: () async {
                                                                                        return false;
                                                                                      },
                                                                                      child: AlertDialog(
                                                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
                                                                                        actions: [
                                                                                          TextButton(
                                                                                            child: const Text("Submit"),
                                                                                            onPressed: () {
                                                                                              cekOTP(otp.text, index);
                                                                                              Navigator.of(context).pop();
                                                                                            },
                                                                                          ),
                                                                                          TextButton(
                                                                                            child: const Text("Close"),
                                                                                            onPressed: () {
                                                                                              Navigator.of(context).pop();
                                                                                            },
                                                                                          ),
                                                                                        ],
                                                                                        content: Stack(
                                                                                          children: <Widget>[
                                                                                            Column(
                                                                                              mainAxisSize: MainAxisSize.min,
                                                                                              children: <Widget>[
                                                                                                TextFormField(
                                                                                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                                                                                  enabled: false,
                                                                                                  autocorrect: false,
                                                                                                  controller: phone,
                                                                                                  decoration: const InputDecoration(
                                                                                                    labelText: 'Phone',
                                                                                                    icon: Icon(Icons.phone),
                                                                                                  ),
                                                                                                  validator: (value) {
                                                                                                    return (value != null && value.length == 10) ? null : 'Phone number must be more than or equal to 10 numbers';
                                                                                                  },
                                                                                                ),
                                                                                                const SizedBox(height: 30),
                                                                                                TextFormField(
                                                                                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                                                                                  autocorrect: false,
                                                                                                  controller: otp,
                                                                                                  decoration: InputDecoration(
                                                                                                    hintText: '123***',
                                                                                                    labelText: 'OTP',
                                                                                                    icon: const Icon(Icons.chat),
                                                                                                    suffixIcon: TextButton(
                                                                                                      onPressed: () {
                                                                                                        getOTP(phone.text, index);
                                                                                                      },
                                                                                                      child: const Text("Request OTP"),
                                                                                                    ),
                                                                                                  ),
                                                                                                  validator: (value) {
                                                                                                    return (value != null && value.length == 6) ? null : 'OTP code must be equal to 6';
                                                                                                  },
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    );
                                                                                  });
                                                                            });
                                                                          },
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .redAccent,
                                                                ),
                                                                child: loading2
                                                                    ? const SizedBox(
                                                                        height:
                                                                            20,
                                                                        width:
                                                                            22,
                                                                        child:
                                                                            CircularProgressIndicator())
                                                                    : Text(
                                                                        "OTP",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                MediaQuery.of(context).textScaleFactor * 11),
                                                                      ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    ],
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
