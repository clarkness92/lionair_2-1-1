// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables, no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:lionair_2/screens/profile.dart';

class UpdateEmail extends StatefulWidget {
  var userapi;
  var passapi;
  var data;
  var data1;
  var data2;

  UpdateEmail({
    super.key,
    required this.userapi,
    required this.passapi,
    required this.data,
    required this.data1,
    required this.data2,
  });

  @override
  State<UpdateEmail> createState() =>
      _UpdateEmailState(userapi, passapi, data, data1, data2);
}

class _UpdateEmailState extends State<UpdateEmail> {
  _UpdateEmailState(
      this.userapi, this.passapi, this.data, this.data1, this.data2);

  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  bool loading1 = false;

  List data = [];
  List data1 = [];
  List data2 = [];
  var userapi;
  var passapi;

  TextEditingController newemail = TextEditingController();
  TextEditingController otp = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => UserProfile(
                userapi: userapi,
                passapi: passapi,
                data: data,
                data1: data1,
                data2: data2,
              ),
            ));
          },
        ),
        title: const Text("Update Email"),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.all(8),
                  elevation: 8,
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        const SizedBox(height: 10),
                        Form(
                          key: _formKey,
                          // autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: Column(
                            children: [
                              TextFormField(
                                autofocus: true,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                autocorrect: false,
                                controller: newemail,
                                decoration: const InputDecoration(
                                  hintText: 'example@gmail.com',
                                  labelText: 'New Email',
                                  icon: Icon(Icons.mail),
                                ),
                                validator: (value) {
                                  String pattern = r"[0-9]";
                                  RegExp regExp = RegExp(pattern);
                                  return regExp.hasMatch(value ?? '')
                                      ? null
                                      : 'Invalid input';
                                },
                              ),
                              const SizedBox(height: 30),
                              TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                autocorrect: false,
                                controller: otp,
                                decoration: InputDecoration(
                                  hintText: '123***',
                                  labelText: 'OTP',
                                  icon: const Icon(Icons.chat),
                                  suffixIcon: TextButton(
                                    onPressed: () {},
                                    child: const Text("Request OTP"),
                                  ),
                                ),
                                validator: (value) {
                                  return (value != null && value.length == 6)
                                      ? null
                                      : 'OTP code must be equal to 6 characters';
                                },
                              ),
                              const SizedBox(height: 30),
                              TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                autocorrect: false,
                                controller: password,
                                obscureText: true,
                                decoration: const InputDecoration(
                                  hintText: '*****',
                                  labelText: 'Password',
                                  icon: Icon(Icons.lock_outlined),
                                ),
                                //VALIDATOR Password
                                validator: (value) {
                                  return (value != null && value.length >= 3)
                                      ? null
                                      : 'Password must be greater than or equal to 3 characters';
                                },
                              ),
                              const SizedBox(height: 30),
                              loading
                                  ? const CircularProgressIndicator()
                                  : MaterialButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      disabledColor: Colors.grey,
                                      color: Colors.blueAccent,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 80, vertical: 15),
                                        child: const Text('Update',
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ),
                                      onPressed: () async {
                                        setState(() {
                                          loading = true;
                                        });
                                      }),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
