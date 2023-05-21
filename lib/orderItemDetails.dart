import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scan_feast/cartItems.dart';
import 'package:scan_feast/qrDetails.dart';

class OrderItemDetails extends StatefulWidget {
  final String name;
  final String image;
  final String price;
  final String description;
  OrderItemDetails({
    Key? key,
    required this.price,
    required this.name,
    required this.image,
    required this.description,
  }) : super(key: key);

  @override
  State<OrderItemDetails> createState() => _OrderItemDetailsState();
}

class _OrderItemDetailsState extends State<OrderItemDetails> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 234, 202),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
            ),
            Text(
              "Food Details",
              style: TextStyle(color: Colors.black, fontSize: 24),
            ),
          ],
        ),
        actions: [
          Row(
            children: [
              Stack(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.shopping_cart,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Get.to(() => CartItems());
                    },
                  ),
                  cartItems.length == 0
                      ? SizedBox.shrink()
                      : Positioned(
                          top: 6,
                          right: 8,
                          child: Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            constraints: BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Text(
                              cartItems.length.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                ],
              ),
              SizedBox(
                width: 20,
              )
            ],
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 1,
                padding: EdgeInsets.symmetric(vertical: 10),
                child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          widget.name,
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 1,
                          height: 220,
                          child: Expanded(
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(widget.image))),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            children: [
                              Text(
                                "Rs." + widget.price,
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                "Food Description",
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                widget.description,
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ]),
                ),
              ),
              SizedBox(
                height: 5,
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
