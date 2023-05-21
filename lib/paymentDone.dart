import 'package:fluttertoast/fluttertoast.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:scan_feast/orders.dart';
import 'package:scan_feast/repo.dart';

class PaymentDone extends StatefulWidget {
  const PaymentDone({Key? key});

  @override
  State<PaymentDone> createState() => _PaymentDoneState();
}

class _PaymentDoneState extends State<PaymentDone>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  double _rating = 0.0;
  final TextEditingController msgEditingController = TextEditingController();
  bool isEnabled = false;

  void _submitFeedback() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(Repo.instance.firebaseUser.value!.email)
        .collection("feedbacks")
        .add({
      "rating": _rating,
      "message": msgEditingController.text,
      "time": Timestamp.now(),
    });

    await Fluttertoast.showToast(
        msg: "Your Feedback has been Submitted Successfully!");
    Navigator.pop(context);
  }

  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _controller.forward().whenComplete(() {
      Get.to(() => Orders());
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: true,
            elevation: 3,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Rate your Experience"),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.close),
                  iconSize: 30,
                )
              ],
            ),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('How would you Rate your Experience?'),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      child: Icon(
                        _rating >= 1.0 ? Icons.star : Icons.star_border,
                        color: Colors.orangeAccent,
                        size: 40,
                      ),
                      onTap: () {
                        setState(() {
                          _rating = 1.0;
                        });
                      },
                    ),
                    InkWell(
                      child: Icon(
                        _rating >= 2.0 ? Icons.star : Icons.star_border,
                        color: Colors.orangeAccent,
                        size: 40,
                      ),
                      onTap: () {
                        setState(() {
                          _rating = 2.0;
                        });
                      },
                    ),
                    InkWell(
                      child: Icon(
                        _rating >= 3.0 ? Icons.star : Icons.star_border,
                        color: Colors.orangeAccent,
                        size: 40,
                      ),
                      onTap: () {
                        setState(() {
                          _rating = 3.0;
                        });
                      },
                    ),
                    InkWell(
                      child: Icon(
                        _rating >= 4.0 ? Icons.star : Icons.star_border,
                        color: Colors.orangeAccent,
                        size: 40,
                      ),
                      onTap: () {
                        setState(() {
                          _rating = 4.0;
                        });
                      },
                    ),
                    InkWell(
                      child: Icon(
                        _rating >= 5.0 ? Icons.star : Icons.star_border,
                        color: Colors.orangeAccent,
                        size: 40,
                      ),
                      onTap: () {
                        setState(() {
                          _rating = 5.0;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: msgEditingController,
                  textCapitalization: TextCapitalization.sentences,
                  maxLines: 7,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(),
                    labelText: 'Enter your Feedback:',
                  ),
                  onTap: () {
                    setState(() {
                      isEnabled = true;
                    });
                  },
                  validator: (value) {
                    if (value!.length <= 10) {
                      setState(() {
                        isEnabled = true;
                      });
                    } else {
                      setState(() {
                        isEnabled = false;
                      });
                    }
                    return null;
                  },
                  onSaved: (value) {
                    msgEditingController.text = value!;
                  },
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 1,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(elevation: 3),
                    onPressed: _rating > 0 || isEnabled == true
                        ? _submitFeedback
                        : null,
                    child: Text(
                      'Submit',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Lottie.asset("assets/GpayTick.json", controller: _controller,
              onLoaded: (composition) {
            _controller.duration = composition.duration;
          }),
        ),
      ),
    );
  }
}
