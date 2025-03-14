import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../services/auth_service.dart';
import 'farmer_signup_screen.dart';
import 'farmer_home_screen.dart';

class FarmerLoginScreen extends StatefulWidget {
  @override
  _FarmerLoginScreenState createState() => _FarmerLoginScreenState();
}

class _FarmerLoginScreenState extends State<FarmerLoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    String? role = prefs.getString("role");

    if (token != null && role == "farmer") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => FarmerHomeScreen()),
      );
    }
  }

  Future<void> _login() async {
    bool success = await AuthService.login(emailController.text, passwordController.text);
    if (success) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => FarmerHomeScreen()),
            (route) => false, // Clears navigation stack
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("invalid_credentials".tr()),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // Prevent back navigation
      child: Scaffold(
        resizeToAvoidBottomInset : false,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("farmer_login".tr(), style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          backgroundColor: Colors.green,
          centerTitle: true,
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green.shade100, Colors.blue.shade100],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon at the top
                  Icon(Icons.agriculture, size: 100, color: Colors.green.shade700),

                  SizedBox(height: 20),

                  // Login Title
                  Text(
                    "farmer_login".tr(),
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),

                  SizedBox(height: 10),

                  // Text(
                  //   "farmer_login".tr(),
                  //   style: TextStyle(fontSize: 16, color: Colors.black54),
                  // ),

                  SizedBox(height: 40),

                  // Email TextField
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "email".tr(),
                      prefixIcon: Icon(Icons.email, color: Colors.green),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),

                  SizedBox(height: 20),

                  // Password TextField
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "password".tr(),
                      prefixIcon: Icon(Icons.lock, color: Colors.green),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),

                  SizedBox(height: 30),

                  // Login Button
                  ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.green,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                      elevation: 5,
                    ),
                    child: Text("login".tr(), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),

                  SizedBox(height: 15),

                  // Signup Navigation
                  TextButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => FarmerSignupScreen())),
                    child: Text(
                      "signup".tr(),
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:easy_localization/easy_localization.dart';
// import '../../services/auth_service.dart';
// import 'farmer_signup_screen.dart';
// import 'farmer_home_screen.dart';
//
// class FarmerLoginScreen extends StatefulWidget {
//   @override
//   _FarmerLoginScreenState createState() => _FarmerLoginScreenState();
// }
//
// class _FarmerLoginScreenState extends State<FarmerLoginScreen> {
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     _checkLoginStatus();
//   }
//
//   Future<void> _checkLoginStatus() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? token = prefs.getString("token");
//     String? role = prefs.getString("role");
//
//     if (token != null && role == "farmer") {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => FarmerHomeScreen()),
//       );
//     }
//   }
//
//   Future<void> _login() async {
//     bool success = await AuthService.login(emailController.text, passwordController.text);
//     if (success) {
//       Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(builder: (_) => FarmerHomeScreen()),
//             (route) => false, // Clears navigation stack
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("invalid_credentials".tr())));
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async => false, // Prevent back navigation
//       child: Scaffold(
//         appBar: AppBar(
//             automaticallyImplyLeading: false,
//             title: Text("farmer_login".tr())),
//         body: Padding(
//           padding: EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               TextField(controller: emailController, decoration: InputDecoration(labelText: "email".tr())),
//               TextField(controller: passwordController, decoration: InputDecoration(labelText: "password".tr()), obscureText: true),
//               SizedBox(height: 10),
//               ElevatedButton(onPressed: _login, child: Text("login".tr())),
//               TextButton(
//                 onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => FarmerSignupScreen())),
//                 child: Text("signup".tr()),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
//
// // import 'package:flutter/material.dart';
// // import 'package:http/http.dart' as http;
// // import 'dart:convert';
// // import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:easy_localization/easy_localization.dart';
// // import '../../services/auth_service.dart';
// // import 'farmer_signup_screen.dart';
// // import 'farmer_home_screen.dart';
// // import '../role_selection_screen.dart';
// //
// // class FarmerLoginScreen extends StatefulWidget {
// //   @override
// //   _FarmerLoginScreenState createState() => _FarmerLoginScreenState();
// // }
// //
// // class _FarmerLoginScreenState extends State<FarmerLoginScreen> {
// //   final emailController = TextEditingController();
// //   final passwordController = TextEditingController();
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _checkLoginStatus();
// //   }
// //
// //   /// ✅ Check if User is Already Logged In
// //   Future<void> _checkLoginStatus() async {
// //     SharedPreferences prefs = await SharedPreferences.getInstance();
// //     String? token = prefs.getString("token");
// //     String? role = prefs.getString("role");
// //
// //     if (token != null && role == "farmer") {
// //       Navigator.pushReplacement(
// //         context,
// //         MaterialPageRoute(builder: (_) => FarmerHomeScreen()),
// //       );
// //     }
// //   }
// //
// //
// //   Future<void> _login() async {
// //     bool success = await AuthService.login(emailController.text, passwordController.text, "farmer");
// //     if (success) {
// //       SharedPreferences prefs = await SharedPreferences.getInstance();
// //       await prefs.setString("role", "farmer");
// //
// //       Navigator.pushAndRemoveUntil(
// //         context,
// //         MaterialPageRoute(builder: (_) => FarmerHomeScreen()),
// //             (route) => false, // Removes all previous routes from the stack
// //       );
// //     } else {
// //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("invalid_credentials".tr())));
// //     }
// //   }
// //
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return WillPopScope(
// //       onWillPop: () async => false,  // Disable back button
// //       child: Scaffold(
// //         appBar: AppBar(title: Text("farmer_login".tr())),
// //         body: Padding(
// //           padding: EdgeInsets.all(16.0),
// //           child: Column(
// //             children: [
// //               TextField(controller: emailController, decoration: InputDecoration(labelText: "email".tr())),
// //               TextField(controller: passwordController, decoration: InputDecoration(labelText: "password".tr()), obscureText: true),
// //               SizedBox(height: 10),
// //               ElevatedButton(onPressed: _login, child: Text("login".tr())),
// //               TextButton(
// //                 onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => FarmerSignupScreen())),
// //                 child: Text("signup".tr()),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
// // // import 'package:easy_localization/easy_localization.dart';
// // // import 'package:flutter/material.dart';
// // // import '../../services/auth_service.dart';
// // // import 'farmer_signup_screen.dart';
// // // import 'farmer_home_screen.dart';
// // //
// // // class FarmerLoginScreen extends StatefulWidget {
// // //   @override
// // //   _FarmerLoginScreenState createState() => _FarmerLoginScreenState();
// // // }
// // //
// // // class _FarmerLoginScreenState extends State<FarmerLoginScreen> {
// // //   final emailController = TextEditingController();
// // //   final passwordController = TextEditingController();
// // //
// // //   Future<void> _login() async {
// // //     bool success = await AuthService.login(emailController.text, passwordController.text, "farmer");
// // //     if (success) {
// // //       Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => FarmerHomeScreen()));
// // //     } else {
// // //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Login Failed")));
// // //     }
// // //   }
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(title: Text("farmer_login".tr())),
// // //       body: Column(
// // //         children: [
// // //           TextField(controller: emailController, decoration: InputDecoration(labelText: "email".tr())),
// // //           TextField(controller: passwordController, decoration: InputDecoration(labelText: "password".tr()), obscureText: true),
// // //           ElevatedButton(onPressed: _login, child: Text("login".tr())),
// // //           TextButton(onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => FarmerSignupScreen())), child: Text("signup".tr()))
// // //         ],
// // //       ),
// // //     );
// // //   }
// // // }
