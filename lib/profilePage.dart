import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scan_feast/home.dart';
import 'package:scan_feast/repo.dart';
import 'package:scan_feast/userModel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();

  bool _isEnabled = false;
  bool _camera = false;
  bool isLoading = false;

  String imageUrl = "";
  ImagePicker imagePicker = ImagePicker();
  XFile? file;
  void pickImage() async {
    file = await imagePicker.pickImage(
        source: _camera ? ImageSource.camera : ImageSource.gallery);
    if (file == null) {
      return;
    } else {
      setState(() {
        isLoading = true; // set isLoading flag to true
      });
    }
    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child("userImages");
    Reference referenceImagesToUpload =
        referenceDirImages.child(uniqueFileName);
    try {
      await referenceImagesToUpload.putFile(File(file!.path));
      imageUrl = await referenceImagesToUpload.getDownloadURL();
      print("imageUrl" + imageUrl);
    } catch (err) {
      print(err);
    }
    setState(() {
      isLoading = false; // set isLoading flag to false
    });
  }

  Future<void> updateUserRecord(UserModel user) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .update(user.toJson());
  }

  final controller = Get.put(Repo());

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .where("email", isEqualTo: Repo.instance.firebaseUser.value!.email)
          .snapshots()
          .map((event) =>
              event.docs.map((e) => UserModel.fromSnapshot(e)).single),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          UserModel user = snapshot.data as UserModel;
          final name = TextEditingController(text: user.name);
          final email = TextEditingController(text: user.email);
          final password = TextEditingController(text: user.password);
          final image = user.image;
          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () {
                        Get.to(() => home());
                      },
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "Profile",
                      style: TextStyle(color: Colors.black, fontSize: 24),
                    ),
                  ],
                ),
              ),
              body: isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : SingleChildScrollView(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 1,
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 80,
                                backgroundColor: Colors.orange,
                                child: CircleAvatar(
                                  backgroundImage: file != null
                                      ? FileImage(File(file!.path))
                                      : image != ""
                                          ? CachedNetworkImageProvider(image)
                                          : AssetImage("assets/avatar.png")
                                              as ImageProvider,
                                  radius: 75,
                                ),
                              ),
                              _isEnabled
                                  ? Column(
                                      children: [
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    _camera = true;
                                                  });
                                                  pickImage();
                                                },
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.camera_alt),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text("Camera"),
                                                  ],
                                                )),
                                            GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    _camera = false;
                                                  });
                                                  pickImage();
                                                },
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.filter_sharp),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text("Gallery"),
                                                  ],
                                                )),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                      ],
                                    )
                                  : SizedBox(
                                      height: 20,
                                    ),
                              Padding(
                                padding: EdgeInsets.all(10.0),
                                child: TextFormField(
                                  controller: name,
                                  enabled: _isEnabled,
                                  decoration: InputDecoration(
                                      labelText: "Name",
                                      hintText: "Enter your name",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0))),
                                ),
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.75,
                                    padding: EdgeInsets.all(10.0),
                                    child: TextFormField(
                                      controller: email,
                                      enabled: false,
                                      decoration: InputDecoration(
                                          labelText: "Email",
                                          hintText: "Enter your email",
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0))),
                                    ),
                                  ),
                                  Repo.instance.firebaseUser.value!
                                          .emailVerified
                                      ? Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2,
                                          child: Center(
                                              child: Icon(
                                            Icons.check_circle,
                                            color: Colors.green,
                                            size: 40,
                                          )),
                                        )
                                      : ElevatedButton(
                                          onPressed: () {
                                            if (!_isEnabled) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(
                                                          "Enable the Editing")));
                                            } else {
                                              Repo.instance
                                                  .sendEmailVerification();
                                            }
                                          },
                                          child: Text(
                                            "Verify",
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.white),
                                          ),
                                        )
                                ],
                              ),
                              
                            ],
                          ),
                        ),
                      ),
                    ),
              floatingActionButton: FloatingActionButton(
                onPressed: () async {
                  setState(() {
                    _isEnabled = !_isEnabled;
                  });
                  if (_formKey.currentState!.validate() && !_isEnabled) {
                    if (name.text.trim() == "") {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Enter your name")));
                    } else {
                      final userNewData = UserModel(
                          uid: user.uid,
                          name: name.text.trim(),
                          email: email.text.trim(),
                          password: password.text.trim(),
                          image: imageUrl == "" ? image : imageUrl,
                          );
                      await updateUserRecord(userNewData);
                    }
                  }
                },
                child: Icon(
                  _isEnabled ? Icons.check : Icons.edit,
                  size: 30,
                ),
              ),
            ),
          );
        } else {
          return SafeArea(
            child: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }
      },
    );
  }
}
