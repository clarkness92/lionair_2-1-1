import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:status_alert/status_alert.dart';
import '../constants.dart';
import 'package:xml/xml.dart' as xml;
import 'package:http/http.dart' as http;
import 'laporan.dart';

class Lihatgambar extends StatefulWidget {
  var userapi;
  var passapi;
  var data;
  var data1;
  var data2;
  var data3;
  var data4;
  var data5;
  var idreff5;
  var vidx4;
  var bookin3;
  var bookout3;

  Lihatgambar(
      {super.key,
      required this.userapi,
      required this.passapi,
      required this.data,
      required this.data1,
      required this.data2,
      required this.data3,
      required this.data4,
      required this.data5,
      required this.idreff5,
      required this.vidx4,
      required this.bookin3,
      required this.bookout3});

  @override
  State<Lihatgambar> createState() => _Lihatgambarstate(userapi, passapi, data,
      data1, data2, data3, data4, data5, idreff5, vidx4, bookin3, bookout3);
}

class _Lihatgambarstate extends State<Lihatgambar> {
  _Lihatgambarstate(
      this.userapi,
      this.passapi,
      this.data,
      this.data1,
      this.data2,
      this.data3,
      this.data4,
      this.data5,
      this.idreff5,
      this.vidx4,
      this.bookin3,
      this.bookout3);

  final _formKey = GlobalKey<FormState>();

  bool loading = false;
  bool loading1 = false;

  List data = [];
  List data1 = [];
  List data2 = [];
  List data3 = [];
  List data4 = [];
  List data5 = [];
  List data6 = [];
  List dataBaru5 = [];
  var hasilJson;
  var vidx4;
  var bookin3;
  var bookout3;
  var userapi;
  var passapi;
  var idreff5;

  TextEditingController idreff = TextEditingController();
  TextEditingController idfile = TextEditingController();

  void updateData5(String idreff) async {
    final temporaryList8 = [];
    idreff = idreff5;
    data5.clear();

    String objBody = '<?xml version="1.0" encoding="utf-8"?>' +
        '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">' +
        '<soap:Body>' +
        '<File_GetDataFromIDReff xmlns="http://tempuri.org/">' +
        '<UsernameApi>$userapi</UsernameApi>' +
        '<PasswordApi>$passapi</PasswordApi>' +
        '<DESTINATION>BLJ</DESTINATION>' +
        '<IDRESERVATION>$idreff</IDRESERVATION>' +
        '</File_GetDataFromIDReff>' +
        '</soap:Body>' +
        '</soap:Envelope>';

    final response = await http.post(Uri.parse(url_File_GetDataFromIDReff),
        headers: <String, String>{
          "Access-Control-Allow-Origin": "*",
          'SOAPAction': 'http://tempuri.org/File_GetDataFromIDReff',
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

      final list_result_all8 = document.findAllElements('_x002D_');

      for (final list_result in list_result_all8) {
        final idfile = list_result.findElements('IDFILE').first.text;
        final filename = list_result.findElements('FILENAME').first.text;
        temporaryList8.add({
          'idfile': idfile,
          'filename': filename,
        });
        debugPrint("object 7.1");
        hasilJson = jsonEncode(temporaryList8);

        debugPrint(hasilJson);
        debugPrint("object_hasilJson 7.1");
      }

      Future.delayed(const Duration(seconds: 3), () {
        Map<String, dynamic> map1 =
            Map.fromIterable(data5, key: (e) => e['idfile']);
        Map<String, dynamic> map2 =
            Map.fromIterable(dataBaru5, key: (e) => e['idfile']);

        map1.addAll(map2);

        List mergedList = map1.values.toList();

        // debugPrint('$mergedList');

        setState(() {
          data5 = mergedList;
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
        title: "Update5 Failed, ${response.statusCode}",
        backgroundColor: Colors.grey[300],
      );
      setState(() {
        loading = false;
      });
    }
    setState(() {
      dataBaru5 = temporaryList8;
      loading = true;
      // debugPrint('$dataBaru4');
    });
  }

  void getImage(String idfile, index) async {
    final temporaryList9 = [];
    idfile = data5[index]['idfile'];

    String objBody = '<?xml version="1.0" encoding="utf-8"?>' +
        '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">' +
        '<soap:Body>' +
        '<File_GetDataFromIDFile xmlns="http://tempuri.org/">' +
        '<UsernameApi>$userapi</UsernameApi>' +
        '<PasswordApi>$passapi</PasswordApi>' +
        '<DESTINATION>BLJ</DESTINATION>' +
        '<IDFILE>$idfile</IDFILE>' +
        '</File_GetDataFromIDFile>' +
        '</soap:Body>' +
        '</soap:Envelope>';

    final response = await http.post(Uri.parse(url_File_GetDataFromIDFile),
        headers: <String, String>{
          "Access-Control-Allow-Origin": "*",
          'SOAPAction': 'http://tempuri.org/File_GetDataFromIDFile',
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

      final list_result_all8 = document.findAllElements('_x002D_');

      for (final list_result in list_result_all8) {
        final idfile = list_result.findElements('IDFile').first.text;
        final idref = list_result.findElements('IDRef').first.text;
        final filebyte = list_result.findElements('Filebyte').first.text;
        temporaryList9.add({
          'idfile': idfile,
          'idref': idref,
          'filebyte': filebyte,
        });
        debugPrint("object 8");
        hasilJson = jsonEncode(temporaryList9);

        debugPrint(hasilJson);
        debugPrint("object_hasilJson 8");
      }

      Future.delayed(const Duration(seconds: 3), () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Stack(
                  clipBehavior: Clip.none,
                  children: <Widget>[
                    Positioned(
                      right: -40.0,
                      top: -40.0,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: const CircleAvatar(
                          backgroundColor: Colors.red,
                          child: Icon(Icons.close),
                        ),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(1),
                          child: SizedBox(
                            width: 280,
                            height: 360,
                            child: Image.memory(
                                base64Decode("${data6[0]['filebyte']}")),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            });
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
        title: "Get Data6 Failed, ${response.statusCode}",
        backgroundColor: Colors.grey[300],
      );
      setState(() {
        loading1 = false;
      });
    }
    setState(() {
      data6 = temporaryList9;
      loading1 = true;
      // debugPrint('$dataBaru4');
    });
  }

  logout1() {
    data.clear();
    data1.clear();
    data2.clear();
    data3.clear();
    data4.clear();
    data5.clear();
    data6.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
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
        ),
        title: const Text("List Images"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () async {
              setState(() {
                loading = true;
              });
              updateData5(idreff.text);
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
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              shrinkWrap: true,
              key: _formKey,
              itemCount: data5.length,
              itemBuilder: (context, index) {
                if (data5.isEmpty) {
                  return const Center(child: Text("No Data"));
                } else {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        margin: const EdgeInsets.all(8),
                        elevation: 8,
                        child: Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Center(
                                child: loading1
                                    ? const CircularProgressIndicator()
                                    : IconButton(
                                        onPressed: () async {
                                          setState(() {
                                            loading1 = true;
                                          });
                                          getImage(idfile.text, index);
                                        },
                                        icon: const Icon(Icons.zoom_in)),
                              ),
                              Center(child: Text("${data5[index]['idfile']}"))
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
    );
  }
}
