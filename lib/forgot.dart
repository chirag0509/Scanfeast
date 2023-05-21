import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scan_feast/repo.dart';


class forgot extends StatefulWidget {
  const forgot({super.key});

  @override
  State<forgot> createState() => _forgotState();
}

class _forgotState extends State<forgot> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = new TextEditingController();
  final controller = Get.put(Repo());

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            // alignment: Alignment.center,
            padding:
                EdgeInsets.symmetric(vertical: w * 0.08, horizontal: w * 0.07),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                        size: 26,
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: const Text(
                        "Forgot Password",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 50,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 90),
                  child: Form(
                    key: _formKey,
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          TextFormField(
                              controller: emailController,
                              decoration: InputDecoration(
                                labelText: "Email",
                                prefixIcon: Icon(Icons.email),
                                labelStyle: TextStyle(fontSize: 20),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                    borderRadius: BorderRadius.circular(20)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.orange, width: 1),
                                    borderRadius: BorderRadius.circular(20)),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return ("Please Enter Your Email");
                                }
                                if (!RegExp(
                                        "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                    .hasMatch(value)) {
                                  return ("Please Enter a Valid Email");
                                }
                                return null;
                              },
                              onSaved: (value) {
                                emailController.text = value!;
                              }),
                          const SizedBox(
                            height: 25,
                          ),
                          MaterialButton(
                            minWidth: double.maxFinite,
                            height: 55,
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                String email = emailController.text;
                                try {
                                  String forget = FirebaseAuth.instance
                                      .fetchSignInMethodsForEmail(email)
                                      .toString();
                                  if (forget.contains("password") != null) {
                                    Repo.instance.sendPasswordResetEmail(
                                        emailController.text.trim());

                                    await showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            content: Text(
                                              "Password Reset Sent in your Email Address!",
                                              style: TextStyle(
                                                  fontSize: 21,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(
                                                    "OK",
                                                    style: TextStyle(
                                                        fontSize: 22,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ))
                                            ],
                                          );
                                        });
                                  } else {
                                    await showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text("Error"),
                                            content: const Text(
                                              "User does not exist!",
                                              style: TextStyle(
                                                  fontSize: 21,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text(
                                                    "OK",
                                                    style: TextStyle(
                                                        fontSize: 22,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ))
                                            ],
                                          );
                                        });
                                  }
                                } on FirebaseException catch (e) {
                                  if (kDebugMode) {
                                    print(e);
                                  }
                                }
                              }
                            },
                            color: Colors.orange,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: const Text(
                              "Submit",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
