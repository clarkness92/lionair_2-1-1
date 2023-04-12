// import 'package:custom_class/Quote.dart';
// import 'package:flutter/material.dart';

// class HomeText extends StatefulWidget {

//   @override
//   State<HomeText> createState() => _HomeTextState();
// }

// class _HomeTextState extends State<HomeText> {

//   List<Quote> quotelist=<Quote>[];
//   int idx=0;
//   TextEditingController _controller=TextEditingController();
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     quotelist.add(
//         Quote(
//             quoteText: 'ada',
//             author: 'test'
//         )
//     );
//     quotelist.add(
//         Quote(
//             quoteText: 'ada2',
//             author: 'test2'
//         )
//     );
//     quotelist.add(
//         Quote(
//             quoteText: 'ada3',
//             author: 'test3'
//         )
//     );
//     idx=0;
//     _controller = TextEditingController();
//   }
//   @override
//   void dispose() {
//     // TODO: implement dispose
//     _controller.dispose();
//     super.dispose();
//   }
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.grey[850],
//         title: Text('Quotes Generator',
//           style: TextStyle(
//             fontFamily: 'fonts/MyriadPro-Bold.ttf',
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       backgroundColor: Colors.green[900],
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Padding(
//               padding: const EdgeInsets.only(bottom: 10),
//               child: Text(quotelist[idx].getQuote() ,
//                 // child: Text('test' ,
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 30,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ) ,
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 10),
//               child: Text(quotelist[idx].getAuthor1(),
//                 // child: Text('taaata',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 30,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ) ,
//             ),
//             TextButton(
//               onPressed: () {
//                 setState(() {
//                   idx++;
//                   if (idx>2){
//                     idx=0;
//                   }
//                 }
//                 );
//               },
//               child: Text('Show Next Quotes',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 30,horizontal: 20),
//               child: TextField(
//                 controller: _controller,
//                 decoration: InputDecoration(
//                   border: InputBorder.none,
//                   filled: true,
//                   fillColor: Colors.grey[200],
//                 ),
//               ),
//             ),
//             TextButton(
//               onPressed: ()
//               {
//                 // print(_controller.text);
//                 showDialog(
//                     context: context,
//                     barrierDismissible: false,
//                     builder: (BuildContext context)
//                     {
//                       return AlertDialog(
//                         title: Text('Alert Hasil'),
//                         content: Text('Anda mengetik "${_controller.text}""'),
//                         actions: <Widget>[
//                           TextButton(
//                               onPressed: ()
//                             {
//                               Navigator.pop(context);
//                             },
//                               child: Text('Close'),
//                           )
//                         ],
//                         );
//                     }
//                 );
//               },
//               child: Text('input Text for Dialogue',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
