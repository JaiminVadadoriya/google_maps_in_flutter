import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_in_flutter/pages/login.dart';
import 'package:google_maps_in_flutter/utils/routes.dart';
import 'pages/HomePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // on below line we are specifying title of our app
      title: 'GFG',
      // on below line we are hiding debug banner
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // on below line we are specifying theme
        // primarySwatch: Colors.green,
        colorSchemeSeed: Color.fromARGB(255, 63, 103, 190),
      ),
      // First screen of our app
      // home: const HomePage(),
      initialRoute: "/",
      routes: {
        "/": (context) => ((FirebaseAuth.instance.currentUser != null)
            ? HomePage()
            : Login()),
        // MyRoutes.signRoute: (context) => Signup(),
        MyRoutes.loginRoute: (context) => Login(),
        MyRoutes.homeRoute: (context) => HomePage(),
        // MyRoutes.mobileRoute: (context) => MobileForOtp(),
        // MyRoutes.otpRoute: (context) => ForOtp(),
        // MyRoutes.compRoute: (context) => const ComForm(),
        // MyRoutes.statRoute: (context) => UserHome(),
      },
    );
  }
}
