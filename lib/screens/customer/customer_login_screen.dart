import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../services/auth_service.dart';
import '../customer/customer_home_screen.dart';
import 'customer_signup_screen.dart';
import '../role_selection_screen.dart';

class CustomerLoginScreen extends StatefulWidget {
  @override
  _CustomerLoginScreenState createState() => _CustomerLoginScreenState();
}

class _CustomerLoginScreenState extends State<CustomerLoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  /// ✅ Check if User is Already Logged In
  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    String? role = prefs.getString("role");

    if (token != null && role == "customer") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => CustomerHomeScreen()),
      );
    }
  }


  // Future<void> _loginCustomer() async {
  //   bool success = await AuthService.login(emailController.text, passwordController.text, "customer");
  //   if (success) {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     await prefs.setString("role", "customer");
  //
  //     Navigator.pushAndRemoveUntil(
  //       context,
  //       MaterialPageRoute(builder: (_) => CustomerHomeScreen()),
  //           (route) => false, // Removes all previous routes from the stack
  //     );
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("invalid_credentials".tr())));
  //   }
  // }

  Future<void> _loginCustomer() async {
    bool success = await AuthService.login(emailController.text, passwordController.text);
    if (success) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => CustomerHomeScreen()),
            (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("invalid_credentials".tr())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,  // Disable back button to prevent navigation back
      child: Scaffold(
        resizeToAvoidBottomInset : false,
        appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text("customer_login".tr())),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(controller: emailController, decoration: InputDecoration(labelText: "email".tr())),
              TextField(controller: passwordController, decoration: InputDecoration(labelText: "password".tr()), obscureText: true),
              SizedBox(height: 10),
              ElevatedButton(onPressed: _loginCustomer, child: Text("login".tr())),
              TextButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CustomerSignupScreen())),
                child: Text("signup".tr()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../customer/customer_home_screen.dart';
// import 'customer_signup_screen.dart';
//
// class CustomerLoginScreen extends StatefulWidget {
//   @override
//   _CustomerLoginScreenState createState() => _CustomerLoginScreenState();
// }
//
// class _CustomerLoginScreenState extends State<CustomerLoginScreen> {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//
//   Future<void> _loginCustomer() async {
//     var response = await http.post(
//       Uri.parse('http://10.0.2.2:3000/api/auth/login'),
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode({
//         "email": emailController.text,
//         "password": passwordController.text
//       }),
//     );
//
//     if (response.statusCode == 200) {
//       var data = jsonDecode(response.body);
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       prefs.setString("token", data["token"]);
//       prefs.setString("role", data["user"]["role"]);
//
//       Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => CustomerHomeScreen()));
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Invalid Credentials")));
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("customer_login".tr())),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(controller: emailController, decoration: InputDecoration(labelText: "email".tr())),
//             TextField(controller: passwordController, decoration: InputDecoration(labelText: "password".tr()), obscureText: true),
//             ElevatedButton(onPressed: _loginCustomer, child: Text("login".tr())),
//             TextButton(
//               onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => CustomerSignupScreen())),
//               child: Text("signup".tr()),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
