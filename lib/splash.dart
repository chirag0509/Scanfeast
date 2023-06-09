import 'package:flutter/material.dart';
import 'package:scan_feast/welcomePage.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    _navigatetohome();
  }

  _navigatetohome()async{
    await Future.delayed(Duration(milliseconds: 2300),(){});
    Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=>welcomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image(image: AssetImage('img/Scan Feast GIF.gif'),),
      ),
    );
  }
}

