import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';
import 'farmer/farmer_login_screen.dart';
import 'customer/customer_login_screen.dart';
import 'customer/customer_home_screen.dart';
import 'farmer/farmer_home_screen.dart';

class RoleSelectionScreen extends StatefulWidget {
  @override
  _RoleSelectionScreenState createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  /// ✅ Redirect If User is Already Logged In
  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    String? role = prefs.getString("role");

    if (token != null) {
      if (role == "customer") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => CustomerHomeScreen()),
        );
      } else if (role == "farmer") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => FarmerHomeScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Role", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green, // Custom app bar color
        centerTitle: true, // Center the title
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade100, Colors.green.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Title Text
                Text(
                  "Select Role",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black54),
                ),
                SizedBox(height: 50), // Spacer between the text and buttons

                // Farmer Login Button
                ElevatedButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => FarmerLoginScreen())),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.green, // Background color
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)), // Rounded corners
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                    elevation: 5, // Button shadow
                  ),
                  child: Text(
                    "farmer_login".tr(),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(height: 20), // Spacer between buttons

                // Customer Login Button
                ElevatedButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CustomerLoginScreen())),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.blue, // Background color
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)), // Rounded corners
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                    elevation: 5, // Button shadow
                  ),
                  child: Text(
                    "customer_login".tr(),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
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
// import 'farmer/farmer_login_screen.dart';
// import 'customer/customer_login_screen.dart';
// import 'customer/customer_home_screen.dart';
// import 'farmer/farmer_home_screen.dart';
//
// class RoleSelectionScreen extends StatefulWidget {
//   @override
//   _RoleSelectionScreenState createState() => _RoleSelectionScreenState();
// }
//
// class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
//   @override
//   void initState() {
//     super.initState();
//     _checkLoginStatus();
//   }
//
//   /// ✅ Redirect If User is Already Logged In
//   Future<void> _checkLoginStatus() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? token = prefs.getString("token");
//     String? role = prefs.getString("role");
//
//     if (token != null) {
//       if (role == "customer") {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (_) => CustomerHomeScreen()),
//         );
//       } else if (role == "farmer") {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (_) => FarmerHomeScreen()),
//         );
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("select_role".tr())),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//
//             ElevatedButton(
//               onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => FarmerLoginScreen())),
//               child: Text("farmer_login".tr()),
//             ),
//             ElevatedButton(
//               onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CustomerLoginScreen())),
//               child: Text("customer_login".tr()),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
