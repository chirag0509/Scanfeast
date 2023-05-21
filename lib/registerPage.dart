import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scan_feast/home.dart';
import 'package:scan_feast/loginPage.dart';
import 'package:scan_feast/userModel.dart';
import 'package:scan_feast/welcomePage.dart';

class registerPage extends StatefulWidget {
  const registerPage({Key? key}) : super(key: key);

  @override
  State<registerPage> createState() => _registerPageState();
}

class _registerPageState extends State<registerPage> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameEditingController = TextEditingController();
  final TextEditingController emailEditingController = TextEditingController();
  final TextEditingController passwordEditingController =
      TextEditingController();
  final TextEditingController confirmpasswordEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => welcomePage()));
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 40),
            height: MediaQuery.of(context).size.height - 100,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: [
                    Text("Register",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Create an account",
                      style: TextStyle(fontSize: 18, color: Colors.black54),
                    ),
                  ],
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      inputFile(
                        label: "User Name",
                        picon: Icon(Icons.account_circle),
                        controller: nameEditingController,
                        validator: (value) {
                          RegExp regex = new RegExp(r'^.{3,}$');
                          if (value!.isEmpty) {
                            return ("Name cannot be empty");
                          }
                          if (!regex.hasMatch(value)) {
                            return ("Enter Valid name(Min. 3 Character)");
                          }
                          return null;
                        },
                        onSaved: (value) {
                          nameEditingController.text = value!;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      inputFile(
                          label: "Email",
                          picon: Icon(Icons.email_rounded),
                          controller: emailEditingController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return ("Please enter your email");
                            }
                            if (!RegExp(
                                    "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                .hasMatch(value)) {
                              return ("Please enter a valid email");
                            }
                            return null;
                          },
                          onSaved: (value) {
                            emailEditingController.text = value!;
                          }),
                      SizedBox(
                        height: 20,
                      ),
                      inputFile(
                          label: "Password",
                          picon: Icon(Icons.lock),
                          controller: passwordEditingController,
                          validator: (value) {
                            RegExp regex = new RegExp(r'^.{6,}$');
                            if (value!.isEmpty) {
                              return ("Password is requried");
                            }
                            if (!regex.hasMatch(value)) {
                              return ("Enter a valid password(Min. 6 character)");
                            }
                            return null;
                          },
                          onSaved: (value) {
                            passwordEditingController.text = value!;
                          },
                          obscureText: true),
                      SizedBox(
                        height: 20,
                      ),
                      inputFile(
                          label: "Confirm Password",
                          picon: Icon(Icons.lock),
                          controller: confirmpasswordEditingController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return ("Re-Enter the Password");
                            }
                            if (confirmpasswordEditingController.text !=
                                passwordEditingController.text) {
                              return ("Password don't Match");
                            }
                            return null;
                          },
                          onSaved: (value) {
                            confirmpasswordEditingController.text = value!;
                          },
                          obscureText: true),
                    ],
                  ),
                ),
                Container(
                    padding:
                        EdgeInsets.only(top: 3, left: 3, right: 3, bottom: 3),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border(
                          bottom: BorderSide(color: Colors.black),
                          top: BorderSide(color: Colors.black),
                          left: BorderSide(color: Colors.black),
                          right: BorderSide(color: Colors.black),
                        )),
                    child: MaterialButton(
                      minWidth: double.infinity,
                      height: 55,
                      onPressed: () {
                        signUp(emailEditingController.text,
                            passwordEditingController.text);
                      },
                      color: Colors.orange,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text(
                        "Register",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: Colors.white),
                      ),
                    )),
                // Text(
                //   "OR",
                //   style: TextStyle(
                //     color: Colors.grey,
                //     fontWeight: FontWeight.bold,
                //     fontSize: 20,
                //   ),
                // ),
                // Wrap(
                //   children: List<Widget>.generate(2, (index) {
                //     return Padding(
                //       padding: const EdgeInsets.all(10.0),
                //       child: CircleAvatar(
                //         radius: 25,
                //         backgroundColor: Colors.white,
                //         backgroundImage: AssetImage("img/" + images[index]),
                //       ),
                //     );
                //   }),
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Already have an account?",
                      style: TextStyle(color: Colors.black54, fontSize: 18),
                    ),
                    InkWell(
                      child: Text(
                        " Login",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 19,
                          color: Colors.orange,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => loginPage()));
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  void signUp(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {postDetailsToFirestore()})
          .catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
      });
      final user = UserModel(
          uid: Random().toString(),
          name: nameEditingController.text.trim(),
          email: emailEditingController.text.trim(),
          password: passwordEditingController.text.trim(),
          image: "",);
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.email)
          .set(user.toJson())
          .whenComplete(() {
        print("success");
      });
    }
  }

  postDetailsToFirestore() async {
    // FirebaseFirestore firebaseFirestore=FirebaseFirestore.instance;
    // User? user=_auth.currentUser;
    // UserModel userModel= UserModel();
    // userModel.email=user!.email;
    // userModel.uid=user.uid;
    // userModel.name=nameEditingController.text;
    //
    // await firebaseFirestore
    //   .collection("users")
    //   .doc(user.uid)
    //   .set(userModel.toMap());

    await Fluttertoast.showToast(msg: "Account created successfully :)");

    Navigator.pushAndRemoveUntil((context),
        MaterialPageRoute(builder: (context) => home()), (route) => false);
  }
}

Widget inputFile(
    {label, picon, controller, validator, onSaved, obscureText = false}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Container(
          child: TextFormField(
              autofocus: false,
              textInputAction: TextInputAction.next,
              controller: controller,
              obscureText: obscureText,
              validator: validator,
              onSaved: onSaved,
              style: TextStyle(
                fontSize: 20,
              ),
              decoration: InputDecoration(
                labelText: label,
                prefixIcon: picon,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(20),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(20),
                ),
              ))),
    ],
  );
}
