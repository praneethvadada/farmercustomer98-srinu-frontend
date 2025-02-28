import 'package:flutter/material.dart';
import 'dart:async';
import 'language_selection_screen.dart';
import 'role_selection_screen.dart';
import '../utils/shared_prefs.dart';

// Updated SplashScreen to accept `nextScreen` parameter
class SplashScreen extends StatefulWidget {
  final Widget nextScreen;

  SplashScreen({required this.nextScreen});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => widget.nextScreen),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Welcome to the App", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'dart:async';
// import 'language_selection_screen.dart';
// import 'role_selection_screen.dart';
// import '../utils/shared_prefs.dart';


//
// class SplashScreen extends StatefulWidget {
//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     Timer(Duration(seconds: 1), () async {
//       bool firstTime = await SharedPrefs.isFirstTime();
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => firstTime ? LanguageSelectionScreen() : RoleSelectionScreen()),
//       );
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(child: Image.asset('assets/splash.png')),
//     );
//   }
// }
