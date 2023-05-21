import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:scan_feast/orderModel.dart';
import 'package:scan_feast/paymentDone.dart';
import 'package:scan_feast/qrDetails.dart';
import 'package:scan_feast/repo.dart';
import 'package:scan_feast/userModel.dart';

class TransactionPage extends StatefulWidget {
  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  createOrder(OrderModel order) {
    FirebaseFirestore.instance
        .collection("users")
        .doc(Repo.instance.firebaseUser.value!.email)
        .collection("orders")
        .add(order.toJson())
        .whenComplete(() {
      print("success");
    });
  }

  bool setCredit = true;
  bool setDebit = false;
  bool setUPI=false;
  TextEditingController _creditCardController = TextEditingController();
  TextEditingController _debitCardController = TextEditingController();
  TextEditingController _UPIController = TextEditingController();
  TextEditingController _creditcvvController = TextEditingController();
  TextEditingController _debitcvvController = TextEditingController();
  TextEditingController _creditmonthContrller = TextEditingController();
  TextEditingController _debitmonthContrller = TextEditingController();
  TextEditingController _credityearContrller = TextEditingController();
  TextEditingController _debityearContrller = TextEditingController();


  Timer? _timer;
  int _secondsRemaining = 300;

  @override
  void initState() {
    super.initState();

    // Start the timer
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _secondsRemaining--;
      });
    });
  }

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
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
                  if (_secondsRemaining == 0) {
                    SystemNavigator.pop();
                    _timer!.cancel();
                  } else {
                    _timer!.cancel();
                    Navigator.pop(context);
                  }
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                ),
              ),
              Text(
                "Payment",
                style: TextStyle(color: Colors.black, fontSize: 24),
              ),
            ],
          ),
        ),
        body: WillPopScope(
          onWillPop: () async {
            if (_secondsRemaining == 0) {
              SystemNavigator.pop();
              _timer!.cancel();
              return true;
            } else {
              _timer!.cancel();
              Navigator.pop(context);
              return true;
            }
          },
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.9,
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: SingleChildScrollView(
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("users")
                        .where("email",
                            isEqualTo: Repo.instance.firebaseUser.value!.email)
                        .snapshots()
                        .map((event) => event.docs
                            .map((e) => UserModel.fromSnapshot(e))
                            .single),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Column(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height * 0.79,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Select an option",
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      Text(
                                        "Total : " + totalCost.toString(),
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.96,
                                    child: Row(
                                      children: [
                                        GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                setCredit = true;
                                                setDebit = false;
                                                setUPI=false;
                                              });
                                            },
                                            child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 10),
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        width: 1,
                                                        color: Colors.black),
                                                    color: setCredit
                                                        ? Colors.orange
                                                        : Colors.white,
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topLeft: Radius
                                                                .circular(10),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    10))),
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.315,
                                                child: Center(
                                                    child: Text(
                                                  "Credit",
                                                  style: TextStyle(
                                                      color: setCredit
                                                            ? Colors.white
                                                            : Colors.black,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                )))),
                                        GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                setCredit = false;
                                                setDebit = true;
                                                setUPI=false;
                                              });
                                            },
                                            child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 10),
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                      bottom: BorderSide(
                                                          width: 1,
                                                          color: Colors.black),
                                                      top: BorderSide(
                                                          width: 1,
                                                          color: Colors.black)),
                                                  color: setDebit
                                                      ? Colors.orange
                                                      : Colors.white,
                                                ),
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.315,
                                                child: Center(
                                                    child: Text(
                                                  "Debit",
                                                  style: TextStyle(
                                                      color: setDebit
                                                            ? Colors.white
                                                            : Colors.black,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                )))),
                                        GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                setCredit = false;
                                                setDebit = false;
                                                setUPI=true;
                                              });
                                            },
                                            child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 10),
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        width: 1,
                                                        color: Colors.black),
                                                    color:
                                                        setUPI
                                                            ? Colors.orange
                                                            : Colors.white,
                                                    
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topRight:
                                                                Radius.circular(
                                                                    10),
                                                            bottomRight: Radius
                                                                .circular(10))),
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.315,
                                                child: Center(
                                                    child: Text(
                                                  "UPI",
                                                  style: TextStyle(
                                                      color: setUPI
                                                            ? Colors.white
                                                            : Colors.black,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w600,fontStyle: FontStyle.italic),
                                                        
                                                )))),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Visibility(
                                      visible: setCredit,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Card Number",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                                "Enter the 16-digit card number on the card"),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            TextFormField(
                                              controller: _creditCardController,
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: [
                                                CreditCardFormatter()
                                              ],
                                              decoration: InputDecoration(
                                                  labelText:
                                                      "Credit card number",
                                                  hintText:
                                                      "0000 0000 0000 0000",
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0))),
                                            ),
                                            SizedBox(
                                              height: 30,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.65,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "CVV Number",
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                          "Enter the 3-digit cvv number on the card"),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.25,
                                                  child: TextFormField(
                                                    controller: _creditcvvController,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    inputFormatters: [
                                                      LengthLimitingTextInputFormatter(
                                                          3)
                                                    ],
                                                    decoration: InputDecoration(
                                                        labelText: "CVV",
                                                        hintText: "000",
                                                        border: OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0))),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 30,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.4,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "Expiry Number",
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                          "Enter the expiration date on the card"),
                                                    ],
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.18,
                                                      child: TextFormField(
                                                        controller:
                                                            _creditmonthContrller,
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        inputFormatters: [
                                                          LengthLimitingTextInputFormatter(
                                                              2)
                                                        ],
                                                        decoration: InputDecoration(
                                                            labelText: "MM",
                                                            hintText: "00",
                                                            border: OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10.0))),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      "/",
                                                      style: TextStyle(
                                                          fontSize: 50,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.18,
                                                      child: TextFormField(
                                                        controller:
                                                            _credityearContrller,
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        inputFormatters: [
                                                          LengthLimitingTextInputFormatter(
                                                              2)
                                                        ],
                                                        decoration: InputDecoration(
                                                            labelText: "YY",
                                                            hintText: "00",
                                                            border: OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10.0))),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      )),
                                  Visibility(
                                      visible: setDebit,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Card Number",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                                "Enter the 16-digit card number on the card"),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            TextFormField(
                                              controller: _debitCardController,
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: [
                                                CreditCardFormatter()
                                              ],
                                              decoration: InputDecoration(
                                                  labelText:
                                                      "Debit card number",
                                                  hintText:
                                                      "0000 0000 0000 0000",
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0))),
                                            ),
                                            SizedBox(
                                              height: 30,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.65,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "CVV Number",
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                          "Enter the 3-digit cvv number on the card"),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.25,
                                                  child: TextFormField(
                                                    controller: _debitcvvController,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    inputFormatters: [
                                                      LengthLimitingTextInputFormatter(
                                                          3)
                                                    ],
                                                    decoration: InputDecoration(
                                                        labelText: "CVV",
                                                        hintText: "000",
                                                        border: OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0))),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 30,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.4,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "Expiry Number",
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                          "Enter the expiration date on the card"),
                                                    ],
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.18,
                                                      child: TextFormField(
                                                        controller:
                                                            _debitmonthContrller,
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        inputFormatters: [
                                                          LengthLimitingTextInputFormatter(
                                                              2)
                                                        ],
                                                        decoration: InputDecoration(
                                                            labelText: "MM",
                                                            hintText: "00",
                                                            border: OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10.0))),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      "/",
                                                      style: TextStyle(
                                                          fontSize: 50,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.18,
                                                      child: TextFormField(
                                                        controller:
                                                            _debityearContrller,
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        inputFormatters: [
                                                          LengthLimitingTextInputFormatter(
                                                              2)
                                                        ],
                                                        decoration: InputDecoration(
                                                            labelText: "YY",
                                                            hintText: "00",
                                                            border: OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10.0))),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      )),
                                  Visibility(
                                      visible: setUPI,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "UPI ID",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text("Enter your UPI ID"),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            TextFormField(
                                              controller: _UPIController,
                                              decoration: InputDecoration(
                                                  labelText: "UPI ID",
                                                  hintText: "scanfeast@okaxis",
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0))),
                                            ),
                                          ],
                                        ),
                                      )),
                                ],
                              ),
                            ),
                            Container(
                                padding: EdgeInsets.only(
                                    top: 0, left: 3, right: 3, bottom: 0),
                                child: MaterialButton(
                                  minWidth:
                                      MediaQuery.of(context).size.width * 0.445,
                                  height: 55,
                                  onPressed: () async {
                                    if(setCredit)
                                    {
                                      if (_creditCardController.text.trim() =="") {
                                        Get.showSnackbar(
                                          GetSnackBar(
                                            message:"Please enter credit card number",
                                            duration:
                                              Duration(milliseconds: 1500),
                                            backgroundColor:
                                              Color.fromARGB(255, 37, 37, 37),
                                          ),
                                        );
                                      }
                                      else if(_creditCardController.text.trim().length !=19){
                                        Get.showSnackbar(
                                          GetSnackBar(
                                            message: "Please check the credit card number you entered",
                                            duration:
                                                Duration(milliseconds: 1500),
                                            backgroundColor:
                                                Color.fromARGB(255, 37, 37, 37),
                                          ),
                                        );
                                      }
                                      else if (_creditcvvController.text.trim() == "") {
                                        Get.showSnackbar(
                                          GetSnackBar(
                                            message: "Please enter cvv number",
                                            duration:
                                                Duration(milliseconds: 1500),
                                            backgroundColor:
                                                Color.fromARGB(255, 37, 37, 37),
                                          ),
                                        );
                                      } 
                                      else if (_creditcvvController.text.trim().length !=3) {
                                        Get.showSnackbar(
                                          GetSnackBar(
                                            message:
                                                "Please check the cvv number you entered",
                                            duration:
                                                Duration(milliseconds: 1500),
                                            backgroundColor:
                                                Color.fromARGB(255, 37, 37, 37),
                                          ),
                                        );
                                      } 
                                      else if (_creditmonthContrller.text.trim() =="" || _credityearContrller.text.trim() == "") {
                                        Get.showSnackbar(
                                          GetSnackBar(
                                            message:"Please enter expiry date of card",
                                            duration:
                                                Duration(milliseconds: 1500),
                                            backgroundColor:
                                                Color.fromARGB(255, 37, 37, 37),
                                          ),
                                        );
                                      }
                                      else if (_creditmonthContrller.text.trim().length !=2 || _credityearContrller.text.trim().length !=2 ||
                                          int.parse(_creditmonthContrller.text.trim()) >12 || int.parse(_creditmonthContrller.text.trim()) ==00) {
                                        Get.showSnackbar(
                                          GetSnackBar(
                                            message:
                                                "Please check the expiry date you entered",
                                            duration:
                                                Duration(milliseconds: 1500),
                                            backgroundColor:
                                                Color.fromARGB(255, 37, 37, 37),
                                          ),
                                        );
                                      }
                                      else{
                                        final order = OrderModel(
                                          uid: Random().toString(),
                                          date: Timestamp.now(),
                                          items: cartItems);
                                      await createOrder(order);
                                      setState(() {
                                        cartItems.clear();
                                        totalCost = 0;
                                      });
                                      Get.to(() => PaymentDone());
                                      }
                                    }
                                    else if(setDebit)
                                    {
                                      if (_debitCardController.text.trim() =="") {
                                        Get.showSnackbar(
                                          GetSnackBar(
                                            message:"Please enter Debit card number",
                                            duration:
                                              Duration(milliseconds: 1500),
                                            backgroundColor:
                                              Color.fromARGB(255, 37, 37, 37),
                                          ),
                                        );
                                      }
                                      else if(_debitCardController.text.trim().length !=19){
                                        Get.showSnackbar(
                                          GetSnackBar(
                                            message: "Please check the Debit Card number you entered",
                                            duration:
                                                Duration(milliseconds: 1500),
                                            backgroundColor:
                                                Color.fromARGB(255, 37, 37, 37),
                                          ),
                                        );
                                      }
                                      else if (_debitcvvController.text.trim() == "") {
                                        Get.showSnackbar(
                                          GetSnackBar(
                                            message: "Please enter cvv number",
                                            duration:
                                                Duration(milliseconds: 1500),
                                            backgroundColor:
                                                Color.fromARGB(255, 37, 37, 37),
                                          ),
                                        );
                                      }
                                       else if (_debitcvvController.text.trim().length !=3) {
                                        Get.showSnackbar(
                                          GetSnackBar(
                                            message:
                                                "Please check the cvv number you entered",
                                            duration:
                                                Duration(milliseconds: 1500),
                                            backgroundColor:
                                                Color.fromARGB(255, 37, 37, 37),
                                          ),
                                        );
                                      } 
                                      else if (_debitmonthContrller.text.trim() =="" || _debityearContrller.text.trim() == "") {
                                        Get.showSnackbar(
                                          GetSnackBar(
                                            message:"Please enter expiry date of card",
                                            duration:
                                                Duration(milliseconds: 1500),
                                            backgroundColor:
                                                Color.fromARGB(255, 37, 37, 37),
                                          ),
                                        );
                                      }
                                      else if (_debitmonthContrller.text.trim().length !=2 || _debityearContrller.text.trim().length !=2 ||
                                          int.parse(_debitmonthContrller.text.trim()) >12 || int.parse(_debitmonthContrller.text.trim()) ==00) {
                                        Get.showSnackbar(
                                          GetSnackBar(
                                            message:
                                                "Please check the expiry date you entered",
                                            duration:
                                                Duration(milliseconds: 1500),
                                            backgroundColor:
                                                Color.fromARGB(255, 37, 37, 37),
                                          ),
                                        );
                                      }
                                      else{
                                        final order = OrderModel(
                                          uid: Random().toString(),
                                          date: Timestamp.now(),
                                          items: cartItems);
                                      await createOrder(order);
                                      setState(() {
                                        cartItems.clear();
                                        totalCost = 0;
                                      });
                                      Get.to(() => PaymentDone());
                                      }
                                    }
                                    else if(setUPI)
                                    {
                                      if (_UPIController.text.trim() =="") {
                                        Get.showSnackbar(
                                          GetSnackBar(
                                            message:"Please enter your UPI ID",
                                            duration:
                                              Duration(milliseconds: 1500),
                                            backgroundColor:
                                              Color.fromARGB(255, 37, 37, 37),
                                          ),
                                        );
                                      }
                                      else if(_UPIController.text.trim().length <10){
                                        Get.showSnackbar(
                                          GetSnackBar(
                                            message: "Please check the UPI ID you entered",
                                            duration:
                                                Duration(milliseconds: 1500),
                                            backgroundColor:
                                                Color.fromARGB(255, 37, 37, 37),
                                          ),
                                        );
                                      }
                                      else{
                                        final order = OrderModel(
                                          uid: Random().toString(),
                                          date: Timestamp.now(),
                                          items: cartItems);
                                      await createOrder(order);
                                      setState(() {
                                        cartItems.clear();
                                        totalCost = 0;
                                      });
                                      Get.to(() => PaymentDone());
                                      }
                                    }
                                  },
                                  color: Colors.orange,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(),
                                      Text(
                                        "Pay",
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
                        );
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CreditCardFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String formatted = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (formatted.length > 16) {
      formatted = formatted.substring(0, 16);
    }
    List<String> segments = <String>[];
    for (var i = 0; i < formatted.length; i += 4) {
      segments.add(formatted.substring(i, i + 4));
    }
    String result = segments.join(' ');
    return TextEditingValue(
      text: result,
      selection: TextSelection.collapsed(offset: result.length),
    );
  }
}
