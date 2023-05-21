import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scan_feast/itemDetails.dart';
import 'package:scan_feast/qrDetails.dart';
import 'package:scan_feast/summary.dart';

class CartItems extends StatefulWidget {
  const CartItems({super.key});

  @override
  State<CartItems> createState() => _CartItemsState();
}

class _CartItemsState extends State<CartItems> {
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
              "Order Cart",
              style: TextStyle(color: Colors.black, fontSize: 24),
            ),
          ],
        ),
      ),
      body: Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: cartItems.length==0?Center(child: Text("You don't have any item the cart",style: TextStyle(color: Colors.black),)):
          Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.8,
                child: SingleChildScrollView(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      return
                       Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.to(() => ItemsDetails(
                                  id: cartItems[index]["id"].toString(),
                                  price: cartItems[index]["price"].toString(),
                                  name: cartItems[index]["name"].toString(),
                                  image: cartItems[index]["image"].toString(),
                                  description: cartItems[index]["description"]
                                      .toString(),
                                  table: cartItems[index]["table"].toString()));
                            },
                            child: Container(
                              height: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFFfae3e2).withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 1,
                                    offset: Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: Card(
                                elevation: 5,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 170,
                                      child: Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(15)),
                                              image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: NetworkImage(
                                                      cartItems[index]
                                                          ['image']!))),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              cartItems[index]['name']!,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              "Rs." +
                                                  cartItems[index]['price']!,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: 35,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Color.fromARGB(
                                                            255, 255, 208, 138),
                                                    elevation: 0,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topLeft: Radius
                                                                  .circular(15),
                                   
                                                              bottomLeft: Radius
                                                                  .circular(
                                                                      15)),
                                                    ),
                                                    side: BorderSide(
                                                        color: Colors.black,
                                                        width: 1)),
                                                child: Text(
                                                  "-",
                                                  style:
                                                      TextStyle(fontSize: 30),
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    int existingItemIndex =
                                                        cartItems.indexWhere(
                                                            (item) =>
                                                                item['name'] ==
                                                                cartItems[index]
                                                                    ['name']);
                                                    int currentCount =
                                                        int.parse(cartItems[
                                                                existingItemIndex]
                                                            ['count']!);
                                                    int newCount =
                                                        currentCount - 1;
                                                    if (newCount < 1) {
                                                      totalCost -= int.parse(
                                                          cartItems[index]
                                                              ['price']!);
                                                      cartItems.removeAt(
                                                          existingItemIndex);
                                                    } else {
                                                      cartItems[existingItemIndex]
                                                              ['count'] =
                                                          newCount.toString();
                                                      totalCost -= int.parse(
                                                          cartItems[index]
                                                              ['price']!);
                                                    }

                                                    print(cartItems);
                                                  });
                                                },
                                              ),
                                            ),
                                            SizedBox(
                                              width: 45,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.white,
                                                    elevation: 0,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topLeft: Radius
                                                                  .circular(0),
                                                              bottomLeft: Radius
                                                                  .circular(0)),
                                                    ),
                                                    side: BorderSide(
                                                        color: Colors.black,
                                                        width: 1)),
                                                child: Text(
                                                  cartItems.any((item) =>
                                                          item['name'] ==
                                                          cartItems[index]
                                                              ['name'])
                                                      ? int.parse(cartItems[cartItems
                                                              .indexWhere((item) =>
                                                                  item[
                                                                      'name'] ==
                                                                  cartItems[
                                                                          index]
                                                                      [
                                                                      'name'])]['count']!)
                                                          .toString()
                                                      : "0",
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                ),
                                                onPressed: () {},
                                              ),
                                            ),
                                            SizedBox(
                                              width: 45,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Color.fromARGB(
                                                            255, 255, 208, 138),
                                                    elevation: 0,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topRight: Radius
                                                                  .circular(15),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          15)),
                                                    ),
                                                    side: BorderSide(
                                                        color: Colors.black,
                                                        width: 1)),
                                                child: Text(
                                                  "+",
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    if (!cartItems.any((item) =>
                                                        item['name'] ==
                                                        cartItems[index]
                                                            ['name'])) {
                                                      cartItems.add({
                                                        'name': cartItems[index]
                                                            ['name']!,
                                                        'image':
                                                            cartItems[index]
                                                                ['image']!,
                                                        'price':
                                                            cartItems[index]
                                                                ['price']!,
                                                        'table':
                                                            cartItems[index]
                                                                ['table']!,
                                                        'count': '1'
                                                      });
                                                      totalCost += int.parse(
                                                          cartItems[index]
                                                              ['price']!);
                                                    } else {
                                                      int existingItemIndex =
                                                          cartItems.indexWhere(
                                                              (item) =>
                                                                  item[
                                                                      'name'] ==
                                                                  cartItems[
                                                                          index]
                                                                      ['name']);
                                                      int currentCount =
                                                          int.parse(cartItems[
                                                                  existingItemIndex]
                                                              ['count']!);
                                                      if (currentCount < 5) {
                                                        cartItems[existingItemIndex]
                                                                ['count'] =
                                                            (currentCount + 1)
                                                                .toString();
                                                        totalCost += int.parse(
                                                            cartItems[index]
                                                                ['price']!);
                                                      }
                                                    }
                                                  });
                                                  print("cartitems : " +
                                                      cartItems.toString());
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          )
                        ],
                      );
                    },
                  ),
                ),
              ),
              Container(
                  padding:
                      EdgeInsets.only(top: 3, left: 3, right: 3, bottom: 3),
                  child: MaterialButton(
                    minWidth: MediaQuery.of(context).size.width * 0.445,
                    height: 55,
                    onPressed: () {
                      if (totalCost != 0) {
                        Get.to(() => OrderSummary());
                      }
                    },
                    color: Colors.orange,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          total().toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                              color: Colors.white),
                        ),
                        Text(
                          "Checkout",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                              color: Colors.white),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 20,
                        ),
                      ],
                    ),
                  )),
            ],
          )),
    ));
  }
}
