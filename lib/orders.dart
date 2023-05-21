import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scan_feast/home.dart';
import 'package:scan_feast/orderItemDetails.dart';
import 'package:scan_feast/orderModel.dart';
import 'package:scan_feast/repo.dart';

class Orders extends StatefulWidget {
  const Orders({Key? key}) : super(key: key);

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  Stream<List<OrderModel>> getOrders() {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(Repo.instance.firebaseUser.value!.email)
        .collection("orders")
        .orderBy("date", descending: true)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => OrderModel.fromSnapshot(e)).toList());
  }

  @override
  Widget build(BuildContext context) {
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
                "Recent Orders",
                style: TextStyle(color: Colors.black, fontSize: 24),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.9,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: StreamBuilder<List<OrderModel>>(
              stream: getOrders(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.length == 0) {
                    return Center(
                      child: Text(
                        "You don't have any recent orders",
                        style: TextStyle(fontSize: 20),
                      ),
                    );
                  } else {
                    // Group orders by date
                    Map<String, List<OrderModel>> ordersByDate = {};
                    snapshot.data!.forEach((order) {
                      String date =
                          DateFormat("dd-MM-yyyy").format(order.date.toDate());
                      if (ordersByDate[date] == null) {
                        ordersByDate[date] = [];
                      }
                      ordersByDate[date]!.add(order);
                    });
                    // Create list of expansion tiles
                    List<Column> expansionTiles = [];
                    ordersByDate.forEach((date, orders) {
                      expansionTiles.add(
                        Column(
                          children: [
                            ExpansionTile(
                              collapsedShape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              collapsedBackgroundColor: Color(0xfff0f2f2),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              backgroundColor: Colors.orange,
                              textColor: Colors.white,
                              iconColor: Colors.white,
                              title: Text(
                                date,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              children: orders.map((order) {
                                return Container(
                                  color: Colors.white,
                                  child: Column(
                                    children: [
                                      Container(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 10),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                1,
                                        decoration: BoxDecoration(
                                            color: Color.fromARGB(
                                                255, 220, 220, 220),
                                            border: Border(
                                                bottom: BorderSide(
                                                    width: 1,
                                                    color: Colors.black),
                                                top: BorderSide(
                                                    width: 1,
                                                    color: Colors.black))),
                                        child: Center(
                                          child: Text(
                                            DateFormat("hh:mm a")
                                                .format(order.date.toDate()),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                      ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount: order.items.length,
                                          itemBuilder: (context, index) {
                                            return GestureDetector(
                                              onTap: () {
                                                Get.to(() => OrderItemDetails(
                                                    price: order.items[index]
                                                        ["price"],
                                                    name: order.items[index]
                                                        ["name"],
                                                    image: order.items[index]
                                                        ["image"],
                                                    description:
                                                        order.items[index]
                                                            ["description"]));
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 10),
                                                decoration: BoxDecoration(
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            width: 1,
                                                            color:
                                                                Colors.grey))),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          width: 120,
                                                          height: 120,
                                                          child: Expanded(
                                                            child: Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(10),
                                                              decoration: BoxDecoration(
                                                                  borderRadius: const BorderRadius
                                                                          .all(
                                                                      Radius.circular(
                                                                          10)),
                                                                  image: DecorationImage(
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      image: CachedNetworkImageProvider(
                                                                          order.items[index]
                                                                              [
                                                                              'image']))),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 20,
                                                        ),
                                                        Text(
                                                          order.items[index]
                                                              ["name"],
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                        ),
                                                      ],
                                                    ),
                                                    Text(
                                                      "₹" +
                                                          order.items[index]
                                                              ["price"],
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      );
                    });
                    return SingleChildScrollView(
                      child: Container(
                          height: MediaQuery.of(context).size.height * 0.9,
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: expansionTiles.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                    onTap: () {
                                      setState(() {});
                                    },
                                    child: expansionTiles[index]);
                              })),
                    );
                  }
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}