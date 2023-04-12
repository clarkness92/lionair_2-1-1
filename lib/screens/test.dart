// //dokumen xml -->  https://pub.dev/packages/xml
// //program sudah jalan, get xml directly and display
// // good
// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// // import 'package:json_nested/model.dart';
// import 'model.dart';
// import 'package:xml/xml.dart' as xml;

// void main() => runApp(MaterialApp(
//       home: HomeState(),
//     ));

// class HomeState extends StatefulWidget {
//   @override
//   State<HomeState> createState() => _HomeState();
// }

// class _HomeState extends State<HomeState> {
//   List<UsersDetail> _list = [];
//   var loading = false;
//   List hasil_results = [];

//   // ini lebih ke arah procedure/function
//   Future<Null> _fetchData() async {
//     final temporaryList = [];

//     String objBody = '<?xml version="1.0" encoding="utf-8"?>' +
//         '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">' +
//         '<soap:Body>' +
//         '<CekUser xmlns="http://tempuri.org/">' +
//         '<Usernameapi>admin</Usernameapi>' +
//         '<Passwordapi>admin</Passwordapi>' +
//         '<Username>53116266</Username>' +
//         '<Password>123</Password>' +
//         '</CekUser>' +
//         '</soap:Body>' +
//         '</soap:Envelope>';

//     final response = await http.post(
//         Uri.parse("https://lgapvfncacc.com/mess/prc.asmx?op=CekUser"),
//         headers: {
//           "Access-Control-Allow-Origin": "*",
//           "Access-Control-Allow-Credentials": "true",
//           'Content-type': 'text/xml',
//           // 'Accept': 'application/json'
//           // 'SOAPAction': 'http://tempuri.org/CekUser'
//         },
//         body: objBody);
//     if (response.statusCode == 200) {
//       // print("Response status: ${response.statusCode}");
//       // print("Response body: ${response.body}");

//       final document = xml.XmlDocument.parse(response.body);

//       // print("=================");
//       // print("document saja : ${document}");
//       // print("=================");
//       // print("document.tostring : ${document.toString()}");
//       // print("=================");
//       // print("document.toXmlString : ${document.toXmlString(pretty: true, indent: '\t')}");
//       // print("=================");

//       final list_result_all = document.findAllElements('CekUser');

//       for (final list_result in list_result_all) {
//         final username = list_result.findElements('USERNAME').first.text;
//         final idemployee = list_result.findElements('IDEMPLOYEE').first.text;
//         final namaasli = list_result.findElements('NAMAASLI').first.text;
//         temporaryList.add({
//           'username': username,
//           'idemployee': idemployee,
//           'namaasli': namaasli
//         });
//       }
//       loading = false;
//     }

//     setState(() {
//       hasil_results = temporaryList;
//       loading = true;
//     });
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _fetchData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Employee List')),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 20),
//         // list of employees
//         child: ListView.builder(
//           itemBuilder: (context, index) => Card(
//             key: ValueKey(hasil_results[index]['username']),
//             margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
//             color: Colors.amber.shade100,
//             elevation: 4,
//             child: ListTile(
//               title: Text(hasil_results[index]['username']),
//               //subtitle: Text("idemployee: ${hasil_results[index]['idemployee']}"),
//               subtitle: Text("nama : ${hasil_results[index]['namaasli']}"),
//             ),
//           ),
//           itemCount: hasil_results.length,
//         ),
//       ),
//     );
//   }
// }
// //dokumen xml -->  https://pub.dev/packages/xml
// //program sudah jalan, get xml directly and display
// // good
// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// // import 'package:json_nested/model.dart';
// import 'model.dart';
// import 'package:xml/xml.dart' as xml;

// void main() => runApp(MaterialApp(
//       home: HomeState(),
//     ));

// class HomeState extends StatefulWidget {
//   @override
//   State<HomeState> createState() => _HomeState();
// }

// class _HomeState extends State<HomeState> {
//   List<UsersDetail> _list = [];
//   var loading = false;
//   List hasil_results = [];

//   // ini lebih ke arah procedure/function
//   Future<Null> _fetchData() async {
//     final temporaryList = [];

//     String objBody = '<?xml version="1.0" encoding="utf-8"?>' +
//         '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">' +
//         '<soap:Body>' +
//         '<CekUser xmlns="http://tempuri.org/">' +
//         '<Usernameapi>admin</Usernameapi>' +
//         '<Passwordapi>admin</Passwordapi>' +
//         '<Username>53116266</Username>' +
//         '<Password>123</Password>' +
//         '</CekUser>' +
//         '</soap:Body>' +
//         '</soap:Envelope>';

//     final response = await http.post(
//         Uri.parse("https://lgapvfncacc.com/mess/prc.asmx?op=CekUser"),
//         headers: {
//           "Access-Control-Allow-Origin": "*",
//           "Access-Control-Allow-Credentials": "true",
//           'Content-type': 'text/xml',
//           // 'Accept': 'application/json'
//           // 'SOAPAction': 'http://tempuri.org/CekUser'
//         },
//         body: objBody);
//     if (response.statusCode == 200) {
//       // print("Response status: ${response.statusCode}");
//       // print("Response body: ${response.body}");

//       final document = xml.XmlDocument.parse(response.body);

//       // print("=================");
//       // print("document saja : ${document}");
//       // print("=================");
//       // print("document.tostring : ${document.toString()}");
//       // print("=================");
//       // print("document.toXmlString : ${document.toXmlString(pretty: true, indent: '\t')}");
//       // print("=================");

//       final list_result_all = document.findAllElements('CekUser');

//       for (final list_result in list_result_all) {
//         final username = list_result.findElements('USERNAME').first.text;
//         final idemployee = list_result.findElements('IDEMPLOYEE').first.text;
//         final namaasli = list_result.findElements('NAMAASLI').first.text;
//         temporaryList.add({
//           'username': username,
//           'idemployee': idemployee,
//           'namaasli': namaasli
//         });
//       }
//       loading = false;
//     }

//     setState(() {
//       hasil_results = temporaryList;
//       loading = true;
//     });
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _fetchData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Employee List')),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 20),
//         // list of employees
//         child: ListView.builder(
//           itemBuilder: (context, index) => Card(
//             key: ValueKey(hasil_results[index]['username']),
//             margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
//             color: Colors.amber.shade100,
//             elevation: 4,
//             child: ListTile(
//               title: Text(hasil_results[index]['username']),
//               //subtitle: Text("idemployee: ${hasil_results[index]['idemployee']}"),
//               subtitle: Text("nama : ${hasil_results[index]['namaasli']}"),
//             ),
//           ),
//           itemCount: hasil_results.length,
//         ),
//       ),
//     );
//   }
// }
