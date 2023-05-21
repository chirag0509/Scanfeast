import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:scan_feast/aboutUs.dart';
import 'package:scan_feast/cartItems.dart';

import 'package:scan_feast/contact.dart';
import 'package:scan_feast/orders.dart';
import 'package:scan_feast/profilePage.dart';
import 'package:scan_feast/qrDetails.dart';
import 'package:scan_feast/qrView.dart';
import 'package:scan_feast/repo.dart';
import 'package:scan_feast/userModel.dart';
import 'package:carousel_slider/carousel_slider.dart';
class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  String? _qrInfo = 'Scan a QR/Bar code';
  String? _scanBarcode;
  bool _camState = false;

  Future<void> startBarcodeScanStream() async {
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
            '#ff6666', 'Cancel', true, ScanMode.QR)!
        .listen((barcode) => print(barcode));
  }

  _qrCallback(String? code) {
    setState(() {
      _camState = false;
      _qrInfo = code;
    });
  }

  _scanCode() {
    setState(() {
      _camState = true;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _scanCode();
  }
  int _current = 0;
  final List<String> _imageUrls = [
    'https://firebasestorage.googleapis.com/v0/b/scanfeast.appspot.com/o/images%2Fresto1.png?alt=media&token=52fcd329-3c15-4887-9b8a-5c381ef4cbf5',
    'https://firebasestorage.googleapis.com/v0/b/scanfeast.appspot.com/o/images%2FscanImg.png?alt=media&token=16f79bfe-7cdf-4f53-bbd2-7b9062355027',
    'https://firebasestorage.googleapis.com/v0/b/scanfeast.appspot.com/o/images%2Fenjoy1.png?alt=media&token=29e6e455-1033-48ba-a4b0-f8486e2ef57a',
  ];
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
            return SafeArea(
              child: Scaffold(
                appBar: AppBar(
                  title: const Text(
                    'Scan Feast',
                  ),
                  actions: [
                    Row(
                      children: [
                        Stack(
                          children: [
                            IconButton(
                              icon: Icon(Icons.shopping_cart),
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
                drawer: Drawer(
                  // backgroundColor: Color.fromARGB(255, 255, 230, 193),
                  backgroundColor: Colors.white,
                  child: ListView(
                    // Important: Remove any padding from the ListView.
                    padding: EdgeInsets.zero,
                    children: [
                      Column(
                        children: [
                          Container(
                            height: 205,
                            margin: EdgeInsetsDirectional.only(bottom: 0),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Get.to(() => ProfilePage());
                                  },
                                  child: CircleAvatar(
                                    radius: 55,
                                    backgroundColor: Colors.orange,
                                    child: CircleAvatar(
                                      backgroundImage:
                                          snapshot.data!.image != ""
                                              ? CachedNetworkImageProvider(
                                                      snapshot.data!.image)
                                                  as ImageProvider<Object>
                                              : AssetImage("assets/avatar.png"),
                                      radius: 50,
                                    ),
                                  ),
                                ),
                                ListTile(
                                  title: Center(
                                    child: Text(
                                      "${snapshot.data!.name}"
                                          .capitalize
                                          .toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 21),
                                    ),
                                  ),
                                  subtitle: Center(
                                    child: Text(
                                      "${snapshot.data!.email}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      Divider(
                        thickness: 2,
                        color: Colors.grey,
                        indent: 12,
                        endIndent: 12,
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.person,
                        ),
                        title: const Text(
                          'About Us',
                          style: TextStyle(fontSize: 21),
                        ),
                        onTap: () {
                          Get.to(() => aboutUs());
                        },
                      ),
                      ListTile(
                          leading: const Icon(
                            Icons.contact_support_sharp,
                          ),
                          title: const Text(
                            'Contact Us',
                            style: TextStyle(fontSize: 21),
                          ),
                          onTap: () {
                            if (!Repo
                                .instance.firebaseUser.value!.emailVerified) {
                              Get.showSnackbar(GetSnackBar(
                                message: 'Please verify your account first.',
                                duration: Duration(seconds: 2),
                                backgroundColor:
                                    Color.fromARGB(255, 37, 37, 37),
                              ));
                            } else {
                              Get.to(() => contact());
                            }
                          }),
                      ListTile(
                        leading: const Icon(
                          Icons.summarize_rounded,
                        ),
                        title: const Text(
                          'Orders',
                          style: TextStyle(fontSize: 21),
                        ),
                        onTap: () {
                          Get.to(() => Orders());
                        },
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.logout_rounded,
                        ),
                        title: const Text(
                          'Logout',
                          style: TextStyle(fontSize: 21),
                        ),
                        onTap: () {
                          controller.logout();
                        },
                      ),
                    ],
                  ),
                ),
                body: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 70,
                                ),
                                Container(
                                  child: Text(
                                    "WELCOME TO SCAN FEAST",
                                    style: TextStyle(
                                        color: Colors.orange,
                                        shadows: [
                                          Shadow(
                                            blurRadius: 3.0,
                                            color:
                                                Colors.grey.withOpacity(0.6),
                                            offset: Offset(2.0, 2.0),
                                          ),
                                        ],
                                        fontSize: 28,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              child: CarouselSlider(
                                options: CarouselOptions(
                                  autoPlay: true,
                                  aspectRatio: 16 / 9,
                                  height: MediaQuery.of(context).size.height /
                                      2.6,
                                  autoPlayCurve: Curves.fastOutSlowIn,
                                  autoPlayInterval: Duration(seconds: 3),
                                  viewportFraction: 0.8,
                                  enlargeCenterPage: true,
                                  onPageChanged: (index, reason) {
                                    setState(() {
                                      _current = index;
                                    });
                                  },
                                ),
                                items: _imageUrls.map((imageUrl) {
                                  return Container(
                                    margin: EdgeInsets.all(5),
                                    child: Image.network(
                                      imageUrl,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: 600,
                                      errorBuilder: (BuildContext context,
                                          Object exception,
                                          StackTrace? stackTrace) {
                                        return Center(
                                          child: Text(
                                            'Something went wrong!. 😢',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 24,
                                              color: Colors.orange,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: _imageUrls.map((imageUrl) {
                                int index = _imageUrls.indexOf(imageUrl);
                                return Container(
                                  width: 10,
                                  height: 10,
                                  margin: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 2),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _current == index
                                        ? Colors.orange
                                        : Colors.grey.withOpacity(0.5),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Divider(
                                thickness: 2,
                                color: Colors.grey[300],
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                              child: Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 2,
                                    ),
                                    Icon(
                                      Icons.search,
                                      color: Colors.orange,
                                      size: 26,
                                      shadows: [
                                        Shadow(
                                          blurRadius: 4.0,
                                          color: Colors.grey.withOpacity(0.6),
                                          offset: Offset(2.0, 2.0),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "Find out the Delicious Food!",
                                      style: TextStyle(
                                          color: Colors.orange,
                                          shadows: [
                                            Shadow(
                                              blurRadius: 4.0,
                                              color: Colors.grey
                                                  .withOpacity(0.6),
                                              offset: Offset(2.0, 2.0),
                                            ),
                                          ],
                                          fontSize: 23,
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                thickness: 2,
                                color: Colors.grey[300],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width:
                                    MediaQuery.of(context).size.width * 0.55,
                                height: 300,
                                padding: EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 5),
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30)),
                                    color: Colors.brown[400],
                                    boxShadow: [
                                      BoxShadow(
                                          spreadRadius: 0,
                                          offset: Offset(0, 10),
                                          blurRadius: 0,
                                          color: Colors.grey.withOpacity(0.7))
                                    ]),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(22)),
                                            border: Border.all(
                                                color: Colors.white),
                                            image: DecorationImage(
                                                image: AssetImage(
                                                  "assets/dhokla.png",
                                                ),
                                                fit: BoxFit.fitHeight)),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      "Dhokla",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 19,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Famous Gujarati Dhokla",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 13),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.35,
                                    height: 185,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 3, horizontal: 3),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(23)),
                                        color: Colors.lightGreen,
                                        boxShadow: [
                                          BoxShadow(
                                              spreadRadius: 0,
                                              offset: Offset(0, 10),
                                              blurRadius: 0,
                                              color: Colors.grey
                                                  .withOpacity(0.7))
                                        ]),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.all(
                                                        Radius.circular(21)),
                                                border: Border.all(
                                                    color: Colors.white),
                                                image: DecorationImage(
                                                  image: AssetImage(
                                                      "assets/daal.png"),
                                                  fit: BoxFit.fitHeight,
                                                )),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Text(
                                          "Daal Baati Churma",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          "Rajashthan Famous",
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                        width: MediaQuery.of(context)
                                                .size
                                                .width *
                                            0.35,
                                        height: 210,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 2, horizontal: 3),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(23)),
                                            color: Colors.black,
                                            boxShadow: [
                                              BoxShadow(
                                                  spreadRadius: 0,
                                                  offset: Offset(0, 10),
                                                  blurRadius: 0,
                                                  color: Colors.grey
                                                      .withOpacity(0.7))
                                            ]),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20)),
                                                    border: Border.all(
                                                        color: Colors.white),
                                                    image: DecorationImage(
                                                      image: AssetImage(
                                                          "assets/vada.png"),
                                                      fit: BoxFit.fitHeight,
                                                    )),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Text(
                                              "Vada Pav",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                              "Maharashtra's Famous Street Food",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.white),
                                              textAlign: TextAlign.center,
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                ),
                floatingActionButton: FloatingActionButton.extended(
                  onPressed: () {
                    if (!Repo.instance.firebaseUser.value!.emailVerified) {
                      Get.showSnackbar(GetSnackBar(
                        message: 'Please verify your account first.',
                        duration: Duration(seconds: 2),
                        backgroundColor: Color.fromARGB(255, 37, 37, 37),
                      ));
                    } else {
                      Get.to(() => QrView());
                    }
                  },
                  label: Row(children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Colors.orange,
                      ),
                      child: Container(
                        // padding: EdgeInsets.all(1),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.qr_code_scanner_rounded,
                              color: Colors.white,
                              size: 31,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Scan Menu",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 23,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w700,
                                shadows: [
                                  Shadow(
                                    blurRadius: 3.0,
                                    color: Colors.grey.withOpacity(0.8),
                                    offset: Offset(2.0, 2.0),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]),
                ),
                floatingActionButtonAnimator:
                    FloatingActionButtonAnimator.scaling,
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerFloat,
              ),
            );
          } else {
            return SafeArea(
                child: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ));
          }
        });
  }
}

class logout extends StatefulWidget {
  @override
  State<logout> createState() => _logoutState();
}

class _logoutState extends State<logout> {
  final controller = Get.put(Repo());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(primary: Colors.orangeAccent),
          onPressed: () {
            controller.logout();
          },
          child: Text(
            "Logout",
            style: TextStyle(
                fontSize: 21, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
