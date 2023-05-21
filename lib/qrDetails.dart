import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:scan_feast/cartItems.dart';
import 'package:scan_feast/category.dart';
import 'package:scan_feast/itemDetails.dart';
import 'package:scan_feast/summary.dart';
// import 'package:transparent_image/transparent_image.dart';

List<Map<String, String>> cartItems = [];
int totalCost = 0;

int total() {
  int totalCount = 0;

  for (var item in cartItems) {
    totalCount += int.parse(item['count']!);
  }
  return totalCount;
}

class QrDeatils extends StatefulWidget {
  final String apiKey;
  final String category;
  QrDeatils({Key? key, required this.apiKey, required this.category})
      : super(key: key);

  @override
  State<QrDeatils> createState() => _QrDeatilsState();
}

class _QrDeatilsState extends State<QrDeatils> {
  bool grid = false;

  TextEditingController _searchController = TextEditingController();
  String _searchValue = '';
  FocusNode _focusNode = FocusNode();

  Stream<List<Map<String, dynamic>>> getDataStream() async* {
    final response = await http.get(Uri.parse(widget.apiKey));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final matchingData = <Map<String, dynamic>>[];
      for (final item in data) {
        for (final i in item['data']) {
          if (i['category'] == widget.category) {
            matchingData.add({
              'id': i['id'],
              'name': i['name'],
              'category': i['category'],
              'image': i['image'],
              'price': i['price'],
              'description': i['description'],
              'table': item['table'],
            });
          }
        }
      }
      yield matchingData;
    } else {
      throw Exception('Failed to load data');
    }
  }

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
                  Get.to(() => Catergory(apiKey: widget.apiKey));
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                ),
              ),
              Text(
                widget.category + " Menu",
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
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    style: TextStyle(color: Colors.black, fontSize: 20),
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: "Search",
                      suffixIcon: Icon(Icons.search, color: Colors.black),
                      hintStyle: TextStyle(fontSize: 20, color: Colors.black),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                        onPressed: () {
                          setState(() {
                            grid = !grid;
                          });
                        },
                        icon: Icon(grid ? Icons.list : Icons.grid_on))
                  ],
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.66,
                  child: SingleChildScrollView(
                    child: StreamBuilder<List<dynamic>>(
                      stream: getDataStream(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<dynamic> filteredData = snapshot.data!
                              .where((element) => element['name']
                                  .toLowerCase()
                                  .contains(_searchValue.toLowerCase()))
                              .toList();

                          return grid
                              ? GridView.builder(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          mainAxisSpacing: 6,
                                          crossAxisSpacing: 6,
                                          childAspectRatio: 0.78),
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: filteredData.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        Get.to(() => ItemsDetails(
                                              id: filteredData[index]["id"],
                                              price: filteredData[index]
                                                  ["price"],
                                              name: filteredData[index]["name"],
                                              image: filteredData[index]
                                                  ["image"],
                                              table: filteredData[index]
                                                  ["table"],
                                              description: filteredData[index]
                                                  ["description"],
                                            ));
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
                                            children: <Widget>[
                                              Expanded(
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .all(
                                                              Radius.circular(
                                                                  15)),
                                                      image: DecorationImage(
                                                          fit: BoxFit.cover,
                                                          image: NetworkImage(
                                                              filteredData[
                                                                      index]
                                                                  ['image']))),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Container(
                                                padding:
                                                    EdgeInsets.only(bottom: 5),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  filteredData[index]['name'],
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 20),
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    "Rs." +
                                                        filteredData[index]
                                                            ['price'],
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                  Transform.scale(
                                                    scale: 0.8,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        SizedBox(
                                                          width: 35,
                                                          child: ElevatedButton(
                                                            style: ElevatedButton
                                                                .styleFrom(
                                                                    backgroundColor:
                                                                        Color.fromARGB(
                                                                            255,
                                                                            255,
                                                                            208,
                                                                            138),
                                                                    elevation:
                                                                        0,
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.only(
                                                                          topLeft: Radius.circular(
                                                                              15),
                                                                          bottomLeft:
                                                                              Radius.circular(15)),
                                                                    ),
                                                                    side: BorderSide(
                                                                        color: Colors
                                                                            .black,
                                                                        width:
                                                                            1)),
                                                            child: Text(
                                                              "-",
                                                              style: TextStyle(
                                                                  fontSize: 30),
                                                            ),
                                                            onPressed: () {
                                                              setState(() {
                                                                int existingItemIndex = cartItems.indexWhere((item) =>
                                                                    item[
                                                                        'name'] ==
                                                                    filteredData[
                                                                            index]
                                                                        [
                                                                        'name']);
                                                                int currentCount =
                                                                    int.parse(cartItems[
                                                                            existingItemIndex]
                                                                        [
                                                                        'count']!);
                                                                int newCount =
                                                                    currentCount -
                                                                        1;
                                                                if (newCount <
                                                                    1) {
                                                                  cartItems
                                                                      .removeAt(
                                                                          existingItemIndex);
                                                                  totalCost -= int.parse(
                                                                      filteredData[
                                                                              index]
                                                                          [
                                                                          'price']);
                                                                } else {
                                                                  cartItems[existingItemIndex]
                                                                          [
                                                                          'count'] =
                                                                      newCount
                                                                          .toString();
                                                                  totalCost -= int.parse(
                                                                      filteredData[
                                                                              index]
                                                                          [
                                                                          'price']);
                                                                }

                                                                print(
                                                                    cartItems);
                                                              });
                                                            },
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 40,
                                                          child: ElevatedButton(
                                                            style: ElevatedButton
                                                                .styleFrom(
                                                                    backgroundColor:
                                                                        Colors
                                                                            .white,
                                                                    elevation:
                                                                        0,
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.only(
                                                                          topLeft: Radius.circular(
                                                                              0),
                                                                          bottomLeft:
                                                                              Radius.circular(0)),
                                                                    ),
                                                                    side: BorderSide(
                                                                        color: Colors
                                                                            .black,
                                                                        width:
                                                                            1)),
                                                            child: Text(
                                                              cartItems.any((item) =>
                                                                      item['name'] ==
                                                                      filteredData[
                                                                              index]
                                                                          [
                                                                          'name'])
                                                                  ? int.parse(cartItems[cartItems.indexWhere((item) =>
                                                                          item['name'] ==
                                                                          filteredData[index]
                                                                              [
                                                                              'name'])]['count']!)
                                                                      .toString()
                                                                  : "0",
                                                              style: TextStyle(
                                                                  fontSize: 20),
                                                            ),
                                                            onPressed: () {},
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 35,
                                                          child: ElevatedButton(
                                                            style: ElevatedButton
                                                                .styleFrom(
                                                                    backgroundColor:
                                                                        Color.fromARGB(
                                                                            255,
                                                                            255,
                                                                            208,
                                                                            138),
                                                                    elevation:
                                                                        0,
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.only(
                                                                          topRight: Radius.circular(
                                                                              15),
                                                                          bottomRight:
                                                                              Radius.circular(15)),
                                                                    ),
                                                                    side: BorderSide(
                                                                        color: Colors
                                                                            .black,
                                                                        width:
                                                                            1)),
                                                            child: Text(
                                                              "+",
                                                              style: TextStyle(
                                                                  fontSize: 20),
                                                            ),
                                                            onPressed: () {
                                                              setState(() {
                                                                if (!cartItems.any((item) =>
                                                                    item[
                                                                        'name'] ==
                                                                    filteredData[
                                                                            index]
                                                                        [
                                                                        'name'])) {
                                                                  cartItems
                                                                      .add({
                                                                    'name': filteredData[
                                                                            index]
                                                                        [
                                                                        'name'],
                                                                    'image': filteredData[
                                                                            index]
                                                                        [
                                                                        'image'],
                                                                    'price': filteredData[
                                                                            index]
                                                                        [
                                                                        'price'],
                                                                    'table': filteredData[
                                                                            index]
                                                                        [
                                                                        'table'],
                                                                    'description':
                                                                        filteredData[index]
                                                                            [
                                                                            'description'],
                                                                    'count': '1'
                                                                  });
                                                                  totalCost += int.parse(
                                                                      filteredData[
                                                                              index]
                                                                          [
                                                                          'price']);
                                                                } else {
                                                                  int existingItemIndex = cartItems.indexWhere((item) =>
                                                                      item[
                                                                          'name'] ==
                                                                      filteredData[
                                                                              index]
                                                                          [
                                                                          'name']);
                                                                  int currentCount =
                                                                      int.parse(
                                                                          cartItems[existingItemIndex]
                                                                              [
                                                                              'count']!);
                                                                  if (currentCount <
                                                                      5) {
                                                                    cartItems[
                                                                            existingItemIndex]
                                                                        [
                                                                        'count'] = (currentCount +
                                                                            1)
                                                                        .toString();
                                                                    totalCost +=
                                                                        int.parse(filteredData[index]
                                                                            [
                                                                            'price']);
                                                                  }
                                                                }
                                                              });
                                                              print("cartitems : " +
                                                                  cartItems
                                                                      .toString());
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  })
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: filteredData.length,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Get.to(() => ItemsDetails(
                                                  id: filteredData[index]["id"],
                                                  name: filteredData[index]
                                                      ["name"],
                                                  image: filteredData[index]
                                                      ["image"],
                                                  price: filteredData[index]
                                                      ["price"],
                                                  table: filteredData[index]
                                                      ["table"],
                                                  description:
                                                      filteredData[index]
                                                          ["description"],
                                                ));
                                          },
                                          child: Container(
                                            height: 150,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Color(0xFFfae3e2)
                                                      .withOpacity(0.5),
                                                  spreadRadius: 1,
                                                  blurRadius: 1,
                                                  offset: Offset(0, 1),
                                                ),
                                              ],
                                            ),
                                            child: Card(
                                              elevation: 5,
                                              shape:
                                                  const RoundedRectangleBorder(
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
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10),
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                const BorderRadius
                                                                        .all(
                                                                    Radius
                                                                        .circular(
                                                                            15)),
                                                            image: DecorationImage(
                                                                fit: BoxFit
                                                                    .cover,
                                                                image: NetworkImage(
                                                                    filteredData[
                                                                            index]
                                                                        [
                                                                        'image']))),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 15,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            filteredData[index]
                                                                ['name'],
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 20),
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            "Rs." +
                                                                filteredData[
                                                                        index]
                                                                    ['price'],
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(
                                                            width: 40,
                                                            child:
                                                                ElevatedButton(
                                                              style: ElevatedButton
                                                                  .styleFrom(
                                                                      backgroundColor: Color.fromARGB(
                                                                          255,
                                                                          255,
                                                                          208,
                                                                          138),
                                                                      elevation:
                                                                          0,
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        borderRadius: BorderRadius.only(
                                                                            topLeft:
                                                                                Radius.circular(15),
                                                                            bottomLeft: Radius.circular(15)),
                                                                      ),
                                                                      side: BorderSide(
                                                                          color: Colors
                                                                              .black,
                                                                          width:
                                                                              1)),
                                                              child: Text(
                                                                "-",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        30),
                                                              ),
                                                              onPressed: () {
                                                                setState(() {
                                                                  int existingItemIndex = cartItems.indexWhere((item) =>
                                                                      item[
                                                                          'name'] ==
                                                                      filteredData[
                                                                              index]
                                                                          [
                                                                          'name']);
                                                                  int currentCount =
                                                                      int.parse(
                                                                          cartItems[existingItemIndex]
                                                                              [
                                                                              'count']!);
                                                                  int newCount =
                                                                      currentCount -
                                                                          1;
                                                                  if (newCount <
                                                                      1) {
                                                                    cartItems
                                                                        .removeAt(
                                                                            existingItemIndex);
                                                                    totalCost -=
                                                                        int.parse(filteredData[index]
                                                                            [
                                                                            'price']);
                                                                  } else {
                                                                    cartItems[existingItemIndex]
                                                                            [
                                                                            'count'] =
                                                                        newCount
                                                                            .toString();
                                                                    totalCost -=
                                                                        int.parse(filteredData[index]
                                                                            [
                                                                            'price']);
                                                                  }

                                                                  print(
                                                                      cartItems);
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 43,
                                                            child:
                                                                ElevatedButton(
                                                              style: ElevatedButton
                                                                  .styleFrom(
                                                                      backgroundColor:
                                                                          Colors
                                                                              .white,
                                                                      elevation:
                                                                          0,
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        borderRadius: BorderRadius.only(
                                                                            topLeft:
                                                                                Radius.circular(0),
                                                                            bottomLeft: Radius.circular(0)),
                                                                      ),
                                                                      side: BorderSide(
                                                                          color: Colors
                                                                              .black,
                                                                          width:
                                                                              1)),
                                                              child: Text(
                                                                cartItems.any((item) =>
                                                                        item[
                                                                            'name'] ==
                                                                        filteredData[index]
                                                                            [
                                                                            'name'])
                                                                    ? int.parse(cartItems[cartItems.indexWhere((item) =>
                                                                            item['name'] ==
                                                                            filteredData[index]['name'])]['count']!)
                                                                        .toString()
                                                                    : "0",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20),
                                                              ),
                                                              onPressed: () {},
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 40,
                                                            child:
                                                                ElevatedButton(
                                                              style: ElevatedButton
                                                                  .styleFrom(
                                                                      backgroundColor: Color.fromARGB(
                                                                          255,
                                                                          255,
                                                                          208,
                                                                          138),
                                                                      elevation:
                                                                          0,
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        borderRadius: BorderRadius.only(
                                                                            topRight:
                                                                                Radius.circular(15),
                                                                            bottomRight: Radius.circular(15)),
                                                                      ),
                                                                      side: BorderSide(
                                                                          color: Colors
                                                                              .black,
                                                                          width:
                                                                              1)),
                                                              child: Text(
                                                                "+",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20),
                                                              ),
                                                              onPressed: () {
                                                                setState(() {
                                                                  if (!cartItems.any((item) =>
                                                                      item[
                                                                          'name'] ==
                                                                      filteredData[
                                                                              index]
                                                                          [
                                                                          'name'])) {
                                                                    cartItems
                                                                        .add({
                                                                      'name': filteredData[
                                                                              index]
                                                                          [
                                                                          'name'],
                                                                      'image': filteredData[
                                                                              index]
                                                                          [
                                                                          'image'],
                                                                      'price': filteredData[
                                                                              index]
                                                                          [
                                                                          'price'],
                                                                      'table': filteredData[
                                                                              index]
                                                                          [
                                                                          'table'],
                                                                      'description':
                                                                          filteredData[index]
                                                                              [
                                                                              'description'],
                                                                      'count':
                                                                          '1'
                                                                    });
                                                                    totalCost +=
                                                                        int.parse(filteredData[index]
                                                                            [
                                                                            'price']);
                                                                  } else {
                                                                    int existingItemIndex = cartItems.indexWhere((item) =>
                                                                        item[
                                                                            'name'] ==
                                                                        filteredData[index]
                                                                            [
                                                                            'name']);
                                                                    int currentCount =
                                                                        int.parse(cartItems[existingItemIndex]
                                                                            [
                                                                            'count']!);
                                                                    if (currentCount <
                                                                        5) {
                                                                      cartItems[
                                                                              existingItemIndex]
                                                                          [
                                                                          'count'] = (currentCount +
                                                                              1)
                                                                          .toString();
                                                                      totalCost +=
                                                                          int.parse(filteredData[index]
                                                                              [
                                                                              'price']);
                                                                    }
                                                                  }
                                                                });
                                                                print("cartitems : " +
                                                                    cartItems
                                                                        .toString());
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
                                );
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
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
            ),
          ),
        ),
      ),
    );
  }
}
