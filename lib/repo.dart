import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scan_feast/home.dart';
import 'package:scan_feast/profilePage.dart';
import 'package:scan_feast/splash.dart';
import 'loginPage.dart';

class Repo extends GetxController {
  static Repo get instance => Get.find();
  final _auth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;
  var verificationId = ''.obs;

  @override
  void onReady() {
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  _setInitialScreen(User? user) {
    user == null ? Get.offAll(() => Splash()) : Get.offAll(() => home());
  }

  Future<void> logout() async =>
      await _auth.signOut().then((_) => Get.offAll(() => loginPage()));

  Future<void> sendPasswordResetEmail(String email) async {
    if (email == '') {
      Get.showSnackbar(const GetSnackBar(
        message: 'Please enter your email to send request.',
        duration: Duration(seconds: 2),
        backgroundColor: Color.fromARGB(255, 37, 37, 37),
      ));
    } else {
      await _auth.sendPasswordResetEmail(email: email);
      Get.offAll(() => const loginPage());  
      Get.showSnackbar(const GetSnackBar(
        message: 'Request has been send. Please check your inbox',
        duration: Duration(seconds: 2),
        backgroundColor: Colors.black,
        icon: Icon(
          Icons.done,
          color: Colors.green,
          size: 20,
        ),
      ));
    }
  }

  Future<void> sendEmailVerification() async {
    await _auth
      ..currentUser!
          .sendEmailVerification()
          .then((_) => Get.showSnackbar(GetSnackBar(
                message: 'Verification link has been sent to your email.',
                duration: Duration(seconds: 2),
                backgroundColor: Color.fromARGB(255, 37, 37, 37),
              )));
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    if (email == '') {
      Get.showSnackbar(GetSnackBar(
        message: 'Please enter your email.',
        duration: Duration(seconds: 2),
        backgroundColor: Color.fromARGB(255, 37, 37, 37),
      ));
    } else if (password == '') {
      Get.showSnackbar(GetSnackBar(
        message: 'Please enter an password.',
        duration: Duration(seconds: 2),
        backgroundColor: Color.fromARGB(255, 37, 37, 37),
      ));
    } else {
      try {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        Get.to(() => ProfilePage());
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          Get.showSnackbar(GetSnackBar(
            message: "No user found for that email.",
            duration: Duration(seconds: 2),
            backgroundColor: Color.fromARGB(255, 37, 37, 37),
          ));
        } else if (e.code == 'wrong-password') {
          Get.showSnackbar(GetSnackBar(
            message: "Please check password you entered.",
            duration: Duration(seconds: 2),
            backgroundColor: Color.fromARGB(255, 37, 37, 37),
          ));
        }
      }
    }
  }
}
