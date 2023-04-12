import 'package:flutter/material.dart';
import 'package:lionair_2/screens/lihat_reservasi.dart';
import 'reservasi_mess.dart';

class HomeScreen extends StatefulWidget {
  var data;
  var data1;

  HomeScreen({super.key, required this.data, required this.data1});

  @override
  State<HomeScreen> createState() => _HomeScreenState(data, data1);
}

class _HomeScreenState extends State<HomeScreen> {
  _HomeScreenState(this.data, this.data1);
  late PageController _pageController;
  int activePage = 0;
  int maxLimit = 19;
  int indiLength = 0;

  final _formKey = GlobalKey<FormState>();
  var loading = false;
  List data = [];
  List data1 = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 1.0);

    if (data1.length <= maxLimit) {
      indiLength = data1.length;
    } else {
      indiLength = maxLimit;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.home, color: Colors.white),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => HomeScreen(
                data: data,
                data1: data1,
              ),
            ));
          },
          tooltip: "Home Screen",
        ),
        title: const Text("Home Screen"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacementNamed(context, 'login');
            },
            tooltip: "Logout",
          ),
        ],
        centerTitle: true,
        backgroundColor: Colors.redAccent,
      ),
      body: ListView.builder(
        key: _formKey,
        itemCount: 1,
        itemBuilder: (context, index) {
          if (data1.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                  children: <Widget>[
                    Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/logo.png'),
                        ),
                      ),
                      width: double.infinity,
                      height: size.height * 0.1,
                    ),
                    SizedBox(
                      width: 350,
                      height: 230,
                      child: Card(
                        color: Colors.white,
                        elevation: 8.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Column(
                          children: <Widget>[
                            const SizedBox(height: 10),
                            const Text(
                              "WELCOME",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            const SizedBox(height: 20),
                            Text("Nama : ${data[index]['namaasli']}"),
                            const SizedBox(height: 5),
                            Text("Username : ${data[index]['idemployee']}"),
                            const SizedBox(height: 5),
                            Text("ID Employee : ${data[index]['idemployee']}"),
                            const SizedBox(height: 10),
                            // Text("Divisi: ${data[index]['namaasli']}"),
                            // const SizedBox(height: 20),
                            // Text("Email: ${data[index]['namaasli']}"),
                            // const SizedBox(height: 20),
                            Container(
                              margin: const EdgeInsets.all(15),
                              child: Row(
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      elevation: 10.0,
                                      side: const BorderSide(
                                          color: Colors.red, width: 2),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) => ReservasiMess(
                                          data: data,
                                          data1: data1,
                                        ),
                                      ));
                                    },
                                    child: const Text(
                                      "\nMess\nReservation\n",
                                      style: TextStyle(color: Colors.black54),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  const Spacer(
                                    flex: 1,
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      elevation: 10.0,
                                      side: const BorderSide(
                                          color: Colors.red, width: 2),
                                    ),
                                    onPressed: () async {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) => LihatDataEmployee(
                                          data: data,
                                          data1: data1,
                                        ),
                                      ));
                                    },
                                    child: const Text(
                                      "\nReservation\nHistory\n",
                                      style: TextStyle(color: Colors.black54),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    const Text(
                      "Current Reservation",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: const [
                            SizedBox(
                              width: 350,
                              height: 250,
                              child: Center(
                                  child: Text(
                                "NO RESERVATION",
                                style: TextStyle(fontWeight: FontWeight.w500),
                              )),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                  children: <Widget>[
                    Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/logo.png'),
                        ),
                      ),
                      width: double.infinity,
                      height: size.height * 0.1,
                    ),
                    SizedBox(
                      width: 350,
                      height: 230,
                      child: Card(
                        color: Colors.white,
                        elevation: 8.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Column(
                          children: <Widget>[
                            const SizedBox(height: 10),
                            const Text(
                              "WELCOME",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            const SizedBox(height: 20),
                            Text("Nama : ${data[index]['namaasli']}"),
                            const SizedBox(height: 5),
                            Text("Username : ${data[index]['idemployee']}"),
                            const SizedBox(height: 5),
                            Text("ID Employee : ${data[index]['idemployee']}"),
                            const SizedBox(height: 10),
                            // Text("Divisi: ${data[index]['namaasli']}"),
                            // const SizedBox(height: 20),
                            // Text("Email: ${data[index]['namaasli']}"),
                            // const SizedBox(height: 20),
                            Container(
                              margin: const EdgeInsets.all(15),
                              child: Row(
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      elevation: 10.0,
                                      side: const BorderSide(
                                          color: Colors.red, width: 2),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) => ReservasiMess(
                                          data: data,
                                          data1: data1,
                                        ),
                                      ));
                                    },
                                    child: const Text(
                                      "\nMess\nReservation\n",
                                      style: TextStyle(color: Colors.black54),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  const Spacer(
                                    flex: 1,
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      elevation: 10.0,
                                      side: const BorderSide(
                                          color: Colors.red, width: 2),
                                    ),
                                    onPressed: () async {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) => LihatDataEmployee(
                                          data: data,
                                          data1: data1,
                                        ),
                                      ));
                                    },
                                    child: const Text(
                                      "\nReservation\nHistory\n",
                                      style: TextStyle(color: Colors.black54),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    const Text(
                      "Current Reservation",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              width: 350,
                              height: 250,
                              child: PageView.builder(
                                  itemCount: data1.length,
                                  pageSnapping: true,
                                  controller: _pageController,
                                  onPageChanged: (page) {
                                    setState(() {
                                      activePage = page;
                                    });
                                  },
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
                                              MainAxisAlignment.spaceAround,
                                          children: <Widget>[
                                            Row(children: [
                                              Text(
                                                "${data1[index]['idx']}",
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18),
                                              ),
                                              const Spacer(
                                                flex: 1,
                                              ),
                                              const Text(
                                                "KMR001",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ]),
                                            const Divider(
                                              thickness: 43,
                                            ),
                                            Row(
                                              children: [
                                                Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(children: const [
                                                        Text("Area"),
                                                        Text(
                                                          "     MESS 1 TRANSIT",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        )
                                                      ]),
                                                      Row(children: const [
                                                        Text("Blok"),
                                                        Text(
                                                          "     K9",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ]),
                                                      Row(children: const [
                                                        Text("Nomor"),
                                                        Text(
                                                          " FANTA",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        )
                                                      ]),
                                                      Row(children: const [
                                                        Text("Bed"),
                                                        Text(
                                                          "      A",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        )
                                                      ]),
                                                    ]),
                                                const Spacer(
                                                  flex: 1,
                                                ),
                                                Column(
                                                  children: const [
                                                    ElevatedButton(
                                                      onPressed: null,
                                                      child: Text("LAPORAN"),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                            const Divider(
                                              thickness: 2,
                                            ),
                                            Row(children: [
                                              // Text("${data[index]['name']}"),
                                              const Text("Check-In"),
                                              Text(
                                                "    : ${data1[index]['checkin']}",
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ]),
                                            Row(
                                              children: [
                                                const Text("Check-Out"),
                                                Text(
                                                  " : ${data1[index]['checkout']}",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                            const SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: indicators(indiLength, activePage),
                            ),
                          ],
                        ),
                      ],
                    ),
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

List<Widget> indicators(dataLength, currentIndex) {
  return List<Widget>.generate(dataLength, (index) {
    return Container(
      margin: const EdgeInsets.all(3),
      width: 10,
      height: 10,
      decoration: BoxDecoration(
          color: currentIndex == index ? Colors.black : Colors.black26,
          shape: BoxShape.circle),
    );
  });
}
