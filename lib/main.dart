import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:scan_feast/home.dart';
import 'package:scan_feast/payment.dart';
import 'package:scan_feast/repo.dart';
import 'package:scan_feast/routes.dart';
import 'package:scan_feast/splash.dart';
import 'firebase_options.dart';

Future main() async {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then((value) => Get.put(Repo()));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      routes: {
        MyRoutes.splash: (context) => Splash(),
        MyRoutes.home: (context) => home(),
        MyRoutes.payment: (context) => TransactionPage(),
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primarySwatch: Colors.orange,
        appBarTheme: const AppBarTheme(
            backgroundColor: Colors.orange, foregroundColor: Colors.white),
      ),
    );
  }
}
