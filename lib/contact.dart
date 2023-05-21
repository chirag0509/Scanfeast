import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scan_feast/repo.dart';
import 'package:scan_feast/userModel.dart';

class contact extends StatefulWidget {
  const contact({Key? key}) : super(key: key);

  @override
  State<contact> createState() => _contactState();
}

class _contactState extends State<contact> {
  final _formKey = GlobalKey<FormState>();
  User? user = FirebaseAuth.instance.currentUser;
  final TextEditingController msgEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios)),
            Text("Contact Us"),
          ],
        ),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("users")
              .where("email",
                  isEqualTo: Repo.instance.firebaseUser.value!.email)
              .snapshots()
              .map((event) =>
                  event.docs.map((e) => UserModel.fromSnapshot(e)).single),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 25.0, horizontal: 25.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            enabled: false,
                            decoration: InputDecoration(
                              labelText: snapshot.data!.name,
                              labelStyle: const TextStyle(fontSize: 20),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            enabled: false,
                            decoration: InputDecoration(
                              labelText: snapshot.data!.email,
                              labelStyle: const TextStyle(fontSize: 20),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            maxLines: 15,
                            keyboardType: TextInputType.multiline,
                            controller: msgEditingController,
                            decoration: InputDecoration(
                                alignLabelWithHint: true,
                                labelText: "Message",
                                labelStyle: const TextStyle(fontSize: 20),
                                hintText: "Enter Your Message:",
                                hintStyle: const TextStyle(fontSize: 18),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0))),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please Enter Your Message!";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              msgEditingController.text = value!;
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Container(
                            padding: EdgeInsets.only(
                                top: 3, left: 3, right: 3, bottom: 3),
                            child: MaterialButton(
                              minWidth: MediaQuery.of(context).size.width * 1,
                              height: 55,
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc('${user!.email}')
                                      .collection("contact")
                                      .add({
                                    "message": msgEditingController.text.trim(),
                                    "time": Timestamp.now()
                                  });

                                  await Fluttertoast.showToast(
                                      msg:
                                          "Your Information is Successfully Submitted!",
                                      textColor: Colors.white);
                                  Navigator.pop(context);
                                }
                              },
                              color: Colors.orange,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Text(
                                "Submit",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20,
                                    color: Colors.white),
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
