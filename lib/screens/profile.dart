// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables, no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:lionair_2/screens/uppass.dart';
import 'home_screen.dart' show HomeScreen;

class UserProfile extends StatefulWidget {
  var userapi;
  var passapi;
  var data;
  var data1;
  var data2;

  UserProfile({
    super.key,
    required this.userapi,
    required this.passapi,
    required this.data,
    required this.data1,
    required this.data2,
  });

  @override
  State<UserProfile> createState() =>
      _UserProfileState(userapi, passapi, data, data1, data2);
}

class _UserProfileState extends State<UserProfile> {
  _UserProfileState(
      this.userapi, this.passapi, this.data, this.data1, this.data2);

  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  List data = [];
  List data1 = [];
  List data2 = [];
  var userapi;
  var passapi;

  void logout() {
    setState(() {
      userapi = '';
      passapi = '';
      data.clear();
      data1.clear();
      data2.clear();
    });

    Navigator.pushReplacementNamed(context, 'login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.home, color: Colors.white),
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
        ),
        title: const Text("User Profile"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              logout();
            },
            tooltip: "Log Out",
          ),
        ],
        centerTitle: true,
        backgroundColor: Colors.redAccent,
      ),
      body: ListView.builder(
        key: _formKey,
        itemCount: 1,
        itemBuilder: (context, index) {
          return Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 1,
                height: MediaQuery.of(context).size.height * 0.45,
                child: Card(
                  margin: const EdgeInsets.all(15),
                  elevation: 8,
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.account_circle,
                                size: 100,
                              )
                            ]),
                        const SizedBox(height: 10),
                        const Divider(
                          thickness: 2,
                        ),
                        const SizedBox(height: 10),
                        Row(children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "ID Employee ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        MediaQuery.of(context).textScaleFactor *
                                            16),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "Name ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        MediaQuery.of(context).textScaleFactor *
                                            16),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "Email ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        MediaQuery.of(context).textScaleFactor *
                                            16),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "Phone ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        MediaQuery.of(context).textScaleFactor *
                                            16),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ": ${data[index]['idemployee']}".trim(),
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).textScaleFactor *
                                            15),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                ": ${data[index]['namaasli']}".trim(),
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).textScaleFactor *
                                            15),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                ": ${data[index]['email']}".trim(),
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).textScaleFactor *
                                            15),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                ": ${data[index]['phone']}".trim(),
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).textScaleFactor *
                                            15),
                              ),
                            ],
                          ),
                        ]),
                      ],
                    ),
                  ),
                ),
              ),
              Center(
                child: MaterialButton(
                  color: Colors.red,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  disabledColor: Colors.grey,
                  onPressed: () {
                    setState(() {
                      loading = true;
                    });
                    Future.delayed(const Duration(seconds: 1), () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => UpdatePassword(
                          userapi: userapi,
                          passapi: passapi,
                          data: data,
                          data1: data1,
                          data2: data2,
                        ),
                      ));
                      setState(() {
                        loading = false;
                      });
                    });
                  },
                  child: loading
                      ? const SizedBox(
                          height: 28,
                          width: 30,
                          child: CircularProgressIndicator())
                      : Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 15),
                          child: const Text('Update Password',
                              style: TextStyle(color: Colors.white)),
                        ),
                ),
              )
            ],
          );
        },
      ),
      // floatingActionButton: CircularMenu(
      //   alignment: Alignment.bottomRight,
      //   startingAngleInRadian: 1 * pi,
      //   endingAngleInRadian: 1.5 * pi,
      //   toggleButtonColor: Colors.red,
      //   items: [
      //     CircularMenuItem(
      //       icon: Icons.mail,
      //       color: Colors.redAccent,
      //       onTap: () {
      //         Navigator.of(context).push(MaterialPageRoute(
      //           builder: (context) => UpdateEmail(
      //             userapi: userapi,
      //             passapi: passapi,
      //             data: data,
      //             data1: data1,
      //             data2: data2,
      //           ),
      //         ));
      //       },
      //     ),
      //     CircularMenuItem(
      //       icon: Icons.phone,
      //       color: Colors.green,
      //       onTap: () {},
      //     ),
      //     CircularMenuItem(
      //       icon: Icons.password,
      //       color: Colors.black38,
      //       onTap: () {},
      //     ),
      //   ],
      // ),
    );
  }
}
