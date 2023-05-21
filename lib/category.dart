import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:scan_feast/cartItems.dart';
import 'package:scan_feast/home.dart';
import 'dart:convert';

import 'package:scan_feast/qrDetails.dart';


class Catergory extends StatefulWidget {
  final String apiKey;
  Catergory({Key? key, required this.apiKey}) : super(key: key);

  @override
  State<Catergory> createState() => _CatergoryState();
}

class _CatergoryState extends State<Catergory> {
  Stream<List<Map<String, String>>> getCategory() async* {
    List<Map<String, String>> categoryImages = [];
    final response = await http.get(Uri.parse(widget.apiKey));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      for (var item in data) {
        for (var i in item['data']) {
          if (!categoryImages
              .any((element) => element['category'] == i['category'])) {
            categoryImages.add({
              'category': i['category'],
              'image': i['image'],
              'table': item['table']
            });
            print(categoryImages);
            yield categoryImages;
          }
        }
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  TextEditingController _searchController = TextEditingController();
  String _searchValue = '';
  FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 234, 202),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 255, 234, 202),
        elevation: 0,
        title: IconButton(
          onPressed: () {
            Get.to(() => home());
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                color: Color.fromARGB(255, 255, 234, 202),
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Column(
                  children: [
                    Text(
                      "Category",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        style: TextStyle(color: Colors.black, fontSize: 20),
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: "Search",
                          suffixIcon: Icon(Icons.search, color: Colors.black),
                          hintStyle:
                              TextStyle(fontSize: 20, color: Colors.black),
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(50)),
                          contentPadding:
                              EdgeInsets.only(top: 20, bottom: 20, left: 25),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(50)),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _searchValue = value;
                          });
                        },
                        focusNode: _focusNode,
                        onFieldSubmitted: (value) {
                          _focusNode.unfocus();
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    StreamBuilder<List<Map>>(
                        stream: getCategory(),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<Map>> snapshot) {
                          if (snapshot.hasData) {
                            List<dynamic> filteredData = snapshot.data!
                                .where((element) => element['category']
                                    .toLowerCase()
                                    .contains(_searchValue.toLowerCase()))
                                .toList();
                            return GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        mainAxisSpacing: 6,
                                        crossAxisSpacing: 6,
                                        childAspectRatio: 1),
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: filteredData.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Get.to(() => QrDeatils(
                                          apiKey: widget.apiKey,
                                          category: filteredData[index]
                                              ['category']));
                                      _focusNode.unfocus();
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color.fromARGB(
                                                255, 255, 234, 202),
                                            blurRadius: 2,
                                            spreadRadius: 4,
                                            offset: const Offset(2, 6),
                                          ),
                                        ],
                                      ),
                                      child: Card(
                                        shadowColor: Colors.grey.shade900,
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15))),
                                        elevation: 7,
                                        child: Column(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                15)),
                                                    image: DecorationImage(
                                                        fit: BoxFit.cover,
                                                        image: NetworkImage(
                                                            filteredData[index]
                                                                ['image']))),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Container(
                                              padding: const EdgeInsets.only(
                                                  bottom: 5),
                                              alignment: Alignment.center,
                                              child: Text(
                                                filteredData[index]['category'],
                                                style: const TextStyle(
                                                    fontSize: 21,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                });
                          } else {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        }),
                  ],
                )),
          ],
        ),
      ),
    ));
  }
}
