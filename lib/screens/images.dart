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
  var data6;
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
      required this.data6,
      required this.vidx4,
      required this.bookin3,
      required this.bookout3});

  @override
  State<Lihatgambar> createState() => _Lihatgambarstate(userapi, passapi, data,
      data1, data2, data3, data4, data5, data6, vidx4, bookin3, bookout3);
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
      this.data6,
      this.vidx4,
      this.bookin3,
      this.bookout3);

  final _formKey = GlobalKey<FormState>();

  bool loading = false;

  List data = [];
  List data1 = [];
  List data2 = [];
  List data3 = [];
  List data4 = [];
  List data5 = [];
  List data6 = [];
  List dataBaru6 = [];
  var hasilJson;
  var vidx4;
  var bookin3;
  var bookout3;
  var userapi;
  var passapi;

  TextEditingController idfile = TextEditingController();

  void updateData6(String idfile) async {
    final temporaryList8 = [];
    idfile = data6[0]['idfile'];
    data6.clear();

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
        temporaryList8.add({
          'idfile': idfile,
          'idref': idref,
          'filebyte': filebyte,
        });
        debugPrint("object 8.1");
        hasilJson = jsonEncode(temporaryList8);

        debugPrint(hasilJson);
        debugPrint("object_hasilJson 8.1");
      }

      Future.delayed(const Duration(seconds: 3), () {
        Map<String, dynamic> map1 =
            Map.fromIterable(data6, key: (e) => e['idfile']);
        Map<String, dynamic> map2 =
            Map.fromIterable(dataBaru6, key: (e) => e['idx']);

        map1.addAll(map2);

        List mergedList = map1.values.toList();

        // debugPrint('$mergedList');

        setState(() {
          data6 = mergedList;
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
        title: "Update Data6 Failed, ${response.statusCode}",
        backgroundColor: Colors.grey[300],
      );
      setState(() {
        loading = false;
      });
    }
    setState(() {
      data6 = temporaryList8;
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
          tooltip: "Home Screen",
        ),
        title: const Text("Image"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () async {
              setState(() {
                loading = true;
              });
              updateData6(idfile.text);
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
          if (data6.isEmpty) {
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
                    Image.memory(base64.decode("${data6[index]['filebyte']}")),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
