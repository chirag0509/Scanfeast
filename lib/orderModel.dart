import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  String uid;
  Timestamp date;
  List<dynamic> items;

  OrderModel({
    required this.uid,
    required this.items,
    required this.date,
  });

  toJson() {
    return {"items": items, "date": date};
  }

  factory OrderModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return OrderModel(
        uid: document.id,
        date: data["date"],
        items: data["items"] as List<dynamic>);
  }
}
