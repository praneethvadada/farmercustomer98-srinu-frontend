import 'package:farmercustomer98/screens/farmer/farmer_products_screen.dart';
import 'package:farmercustomer98/screens/farmer/farmer_requests_screen.dart';
import 'package:farmercustomer98/screens/farmer/profile%20page/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../graphs_page.dart';
import '../role_selection_screen.dart';
import '../settings_screen.dart';

// Farmer Home Screen with Bottom Navigation
class FarmerHomeScreen extends StatefulWidget {
  @override
  _FarmerHomeScreenState createState() => _FarmerHomeScreenState();
}

class _FarmerHomeScreenState extends State<FarmerHomeScreen> {
  int _selectedIndex = 0;

  static List<Widget> _pages = <Widget>[
    GraphPage(),
    // Center(child: Text('Products - Add/Edit/Delete')),
    Center(child: ProductsScreen()),
    FarmerRequestsScreen(),
    Center(child: ProfileScreen()),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Farmer Dashboard')),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Products'),
          BottomNavigationBarItem(icon: Icon(Icons.request_page), label: 'Requests'),

          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../role_selection_screen.dart';
// import '../settings_screen.dart';

// class FarmerHomeScreen extends StatelessWidget {
//   // Future<void> _logout(BuildContext context) async {
//   //   SharedPreferences prefs = await SharedPreferences.getInstance();
//   //   await prefs.remove("token");
//   //   await prefs.remove("role");
//   //
//   //   Navigator.pushReplacement(
//   //     context,
//   //     MaterialPageRoute(builder: (_) => RoleSelectionScreen()),
//   //   );
//   // }
//
//   Future<void> _logout(BuildContext context) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.clear();  // Remove token and role
//
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (_) => RoleSelectionScreen()),
//     );
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: Text("Farmer Home"),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.logout),
//             onPressed: () => _logout(context),
//           ),
//         ],
//       ),
//       body: Center(
//         child: Column(
//           children: [
//             ElevatedButton(onPressed: (){
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (_) => SettingsScreen()),
//               );
//             }, child: Icon(Icons.settings)),
//             Text(
//               "Welcome, Farmer!",
//               style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
