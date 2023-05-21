import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String uid;
  String email;
  String name;
  String password;
  String image;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.password,
    required this.image,
  });

  toJson() {
    return {
      "name": name,
      "email": email,
      "password": password,
      "image": image,
    };
  }

  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return UserModel(
      uid: document.id,
      name: data["name"],
      email: data["email"],
      password: data["password"],
      image: data["image"],
    );
  }
}
