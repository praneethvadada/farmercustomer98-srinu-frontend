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
      appBar: AppBar(title: Text("select_role".tr())),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => FarmerLoginScreen())),
              child: Text("farmer_login".tr()),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CustomerLoginScreen())),
              child: Text("customer_login".tr()),
            ),
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'farmer/farmer_login_screen.dart';
// import 'customer/customer_login_screen.dart';
//
// class RoleSelectionScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("select_role".tr())),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
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
//
//
//
//
// // import 'package:flutter/material.dart';
// //
// // import 'customer/customer_login_screen.dart';
// // import 'farmer/farmer_login_screen.dart';
// //
// //
// // class RoleSelectionScreen extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: Text("Select Role")),
// //       body: Center(
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             ElevatedButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => FarmerLoginScreen())), child: Text("Farmer Login")),
// //             ElevatedButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CustomerLoginScreen())), child: Text("Customer Login")),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
