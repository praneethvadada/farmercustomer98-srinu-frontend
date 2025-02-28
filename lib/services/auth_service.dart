import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static Future<bool> login(String email, String password) async {
    var response = await http.post(
      Uri.parse('http://10.0.2.2:3000/api/auth/login'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("token", data["token"]);
      prefs.setString("role", data["user"]["role"]); // Ensure role is stored correctly
      return true;
    }
    return false;
  }
}



// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
//
// class AuthService {
//   static Future<bool> login(String email, String password, String role) async {
//     var response = await http.post(
//       Uri.parse('http://10.0.2.2:3000/api/auth/login'),
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode({"email": email, "password": password}),
//     );
//
//     if (response.statusCode == 200) {
//       var data = jsonDecode(response.body);
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       prefs.setString("token", data["token"]);
//       prefs.setString("role", data["user"]["role"]);
//       return true;
//     }
//     return false;
//   }
// }
