import 'package:farmercustomer98/screens/farmer/farmer_products_screen.dart';
import 'package:farmercustomer98/screens/farmer/farmer_requests_screen.dart';
import 'package:farmercustomer98/screens/farmer/profile%20page/profile_page.dart';
import 'package:flutter/material.dart';
import '../../graphs_page.dart';

class FarmerHomeScreen extends StatefulWidget {
  @override
  _FarmerHomeScreenState createState() => _FarmerHomeScreenState();
}

class _FarmerHomeScreenState extends State<FarmerHomeScreen> {
  int _selectedIndex = 0;

  // Sample crop data to be passed to GraphPage
  final List<Map<String, dynamic>> cropData = [
    {"name": "Rice", "prices": [3300, 3500, 3600], "years": [2020, 2021, 2022]},
    {"name": "Wheat", "prices": [3200, 3300, 3400], "years": [2020, 2021, 2022]},
    {"name": "Corn", "prices": [3100, 3200, 3300], "years": [2020, 2021, 2022]},
    {"name": "Barley", "prices": [3000, 3100, 3200], "years": [2020, 2021, 2022]},
    {"name": "Soybean", "prices": [2900, 3000, 3100], "years": [2020, 2021, 2022]},
    {"name": "Cotton", "prices": [4000, 4100, 4200], "years": [2020, 2021, 2022]},
    {"name": "Sugarcane", "prices": [2900, 3000, 3100], "years": [2020, 2021, 2022]},
    {"name": "Potato", "prices": [2700, 2800, 2900], "years": [2020, 2021, 2022]},
    {"name": "Tomato", "prices": [2600, 2700, 2800], "years": [2020, 2021, 2022]},
    {"name": "Onion", "prices": [2500, 2600, 2700], "years": [2020, 2021, 2022]},
    {"name": "Peanut", "prices": [3500, 3600, 3700], "years": [2020, 2021, 2022]},
    {"name": "Sunflower", "prices": [3300, 3400, 3500], "years": [2020, 2021, 2022]},
    {"name": "Millet", "prices": [3200, 3300, 3400], "years": [2020, 2021, 2022]},
    {"name": "Lentil", "prices": [3000, 3100, 3200], "years": [2020, 2021, 2022]},
    {"name": "Chickpea", "prices": [3100, 3200, 3300], "years": [2020, 2021, 2022]},
    {"name": "Pea", "prices": [2800, 2900, 3000], "years": [2020, 2021, 2022]},
    {"name": "Oat", "prices": [2900, 3000, 3100], "years": [2020, 2021, 2022]},
    {"name": "Mustard", "prices": [3700, 3800, 3900], "years": [2020, 2021, 2022]},
    {"name": "Sesame", "prices": [3400, 3500, 3600], "years": [2020, 2021, 2022]},
    {"name": "Sorghum", "prices": [3200, 3300, 3400], "years": [2020, 2021, 2022]},
    {"name": "Cabbage", "prices": [2400, 2500, 2600], "years": [2020, 2021, 2022]},
    {"name": "Carrot", "prices": [2300, 2400, 2500], "years": [2020, 2021, 2022]},
    {"name": "Garlic", "prices": [2700, 2800, 2900], "years": [2020, 2021, 2022]},
    {"name": "Ginger", "prices": [2900, 3000, 3100], "years": [2020, 2021, 2022]},
    {"name": "Spinach", "prices": [2200, 2300, 2400], "years": [2020, 2021, 2022]},
    {"name": "Lettuce", "prices": [2300, 2400, 2500], "years": [2020, 2021, 2022]},
    {"name": "Radish", "prices": [2100, 2200, 2300], "years": [2020, 2021, 2022]},
    {"name": "Pumpkin", "prices": [2500, 2600, 2700], "years": [2020, 2021, 2022]},
    {"name": "Cucumber", "prices": [2400, 2500, 2600], "years": [2020, 2021, 2022]},
    {"name": "Eggplant", "prices": [2300, 2400, 2500], "years": [2020, 2021, 2022]},
    {"name": "Mango", "prices": [4000, 4100, 4200], "years": [2020, 2021, 2022]},
    {"name": "Banana", "prices": [3200, 3300, 3400], "years": [2020, 2021, 2022]},
    {"name": "Apple", "prices": [4500, 4600, 4700], "years": [2020, 2021, 2022]},
    {"name": "Grapes", "prices": [3800, 3900, 4000], "years": [2020, 2021, 2022]},
    {"name": "Pineapple", "prices": [3700, 3800, 3900], "years": [2020, 2021, 2022]},
    {"name": "Papaya", "prices": [3100, 3200, 3300], "years": [2020, 2021, 2022]},
    {"name": "Strawberry", "prices": [4200, 4300, 4400], "years": [2020, 2021, 2022]},
    {"name": "Watermelon", "prices": [3500, 3600, 3700], "years": [2020, 2021, 2022]},
    {"name": "Guava", "prices": [3100, 3200, 3300], "years": [2020, 2021, 2022]},
    {"name": "Pomegranate", "prices": [3400, 3500, 3600], "years": [2020, 2021, 2022]},
    {"name": "Coffee", "prices": [7000, 7100, 7200], "years": [2020, 2021, 2022]},
    {"name": "Tea", "prices": [6000, 6100, 6200], "years": [2020, 2021, 2022]},
    {"name": "Cocoa", "prices": [8000, 8100, 8200], "years": [2020, 2021, 2022]},
    {"name": "Vanilla", "prices": [7500, 7600, 7700], "years": [2020, 2021, 2022]},
    {"name": "Almond", "prices": [6200, 6300, 6400], "years": [2020, 2021, 2022]},
    {"name": "Cashew", "prices": [5800, 5900, 6000], "years": [2020, 2021, 2022]},
    {"name": "Walnut", "prices": [6600, 6700, 6800], "years": [2020, 2021, 2022]},
    {"name": "Pistachio", "prices": [6900, 7000, 7100], "years": [2020, 2021, 2022]},
    {"name": "Date", "prices": [5100, 5200, 5300], "years": [2020, 2021, 2022]},
    {"name": "Fig", "prices": [4800, 4900, 5000], "years": [2020, 2021, 2022]},
  ];


  late List<Widget> _pages; // Define _pages dynamically

  @override
  void initState() {
    super.initState();
    _pages = [
      GraphPage(cropData: cropData), // Pass cropData here
      ProductsScreen(),
      FarmerRequestsScreen(),
      ProfileScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Farmer Dashboard',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
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
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 2),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          child: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Products'),
              BottomNavigationBarItem(icon: Icon(Icons.request_page), label: 'Requests'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.green,
            unselectedItemColor: Colors.black54,
            backgroundColor: Colors.white,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            elevation: 10,
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }
}

// import 'package:farmercustomer98/screens/farmer/farmer_products_screen.dart';
// import 'package:farmercustomer98/screens/farmer/farmer_requests_screen.dart';
// import 'package:farmercustomer98/screens/farmer/profile%20page/profile_page.dart';
// import 'package:flutter/material.dart';
// import '../../graphs_page.dart';
//
// // Farmer Home Screen with Bottom Navigation
// class FarmerHomeScreen extends StatefulWidget {
//   @override
//   _FarmerHomeScreenState createState() => _FarmerHomeScreenState();
// }
//
// class _FarmerHomeScreenState extends State<FarmerHomeScreen> {
//   int _selectedIndex = 0;
//
//   static List<Widget> _pages = <Widget>[
//     GraphPage(),
//     ProductsScreen(),
//     FarmerRequestsScreen(),
//     ProfileScreen(),
//   ];
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Farmer Dashboard',
//           style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: Colors.green,
//         centerTitle: true,
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Colors.green.shade100, Colors.blue.shade100],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: _pages[_selectedIndex],
//       ),
//       bottomNavigationBar: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//           boxShadow: [
//             BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 2),
//           ],
//         ),
//         child: ClipRRect(
//           borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//           child: BottomNavigationBar(
//             items: const <BottomNavigationBarItem>[
//               BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
//               BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Products'),
//               BottomNavigationBarItem(icon: Icon(Icons.request_page), label: 'Requests'),
//               BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
//             ],
//             currentIndex: _selectedIndex,
//             selectedItemColor: Colors.green,
//             unselectedItemColor: Colors.black54,
//             backgroundColor: Colors.white,
//             showUnselectedLabels: true,
//             type: BottomNavigationBarType.fixed,
//             elevation: 10,
//             onTap: _onItemTapped,
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // import 'package:farmercustomer98/screens/farmer/farmer_products_screen.dart';
// // import 'package:farmercustomer98/screens/farmer/farmer_requests_screen.dart';
// // import 'package:farmercustomer98/screens/farmer/profile%20page/profile_page.dart';
// // import 'package:flutter/material.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// // import '../../graphs_page.dart';
// // import '../role_selection_screen.dart';
// // import '../settings_screen.dart';
// //
// // // Farmer Home Screen with Bottom Navigation
// // class FarmerHomeScreen extends StatefulWidget {
// //   @override
// //   _FarmerHomeScreenState createState() => _FarmerHomeScreenState();
// // }
// //
// // class _FarmerHomeScreenState extends State<FarmerHomeScreen> {
// //   int _selectedIndex = 0;
// //
// //   static List<Widget> _pages = <Widget>[
// //     GraphPage(),
// //     // Center(child: Text('Products - Add/Edit/Delete')),
// //     Center(child: ProductsScreen()),
// //     FarmerRequestsScreen(),
// //     Center(child: ProfileScreen()),
// //   ];
// //
// //   void _onItemTapped(int index) {
// //     setState(() {
// //       _selectedIndex = index;
// //     });
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: Text('Farmer Dashboard')),
// //       body: _pages[_selectedIndex],
// //       bottomNavigationBar: BottomNavigationBar(
// //         items: const <BottomNavigationBarItem>[
// //           BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
// //           BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Products'),
// //           BottomNavigationBarItem(icon: Icon(Icons.request_page), label: 'Requests'),
// //
// //           BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
// //         ],
// //         currentIndex: _selectedIndex,
// //         selectedItemColor: Colors.blue,
// //         unselectedItemColor: Colors.black,
// //         onTap: _onItemTapped,
// //       ),
// //     );
// //   }
// // }
// //
// // // import 'package:flutter/material.dart';
// // // import 'package:shared_preferences/shared_preferences.dart';
// // // import '../role_selection_screen.dart';
// // // import '../settings_screen.dart';
// //
// // // class FarmerHomeScreen extends StatelessWidget {
// // //   // Future<void> _logout(BuildContext context) async {
// // //   //   SharedPreferences prefs = await SharedPreferences.getInstance();
// // //   //   await prefs.remove("token");
// // //   //   await prefs.remove("role");
// // //   //
// // //   //   Navigator.pushReplacement(
// // //   //     context,
// // //   //     MaterialPageRoute(builder: (_) => RoleSelectionScreen()),
// // //   //   );
// // //   // }
// // //
// // //   Future<void> _logout(BuildContext context) async {
// // //     SharedPreferences prefs = await SharedPreferences.getInstance();
// // //     await prefs.clear();  // Remove token and role
// // //
// // //     Navigator.pushReplacement(
// // //       context,
// // //       MaterialPageRoute(builder: (_) => RoleSelectionScreen()),
// // //     );
// // //   }
// // //
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         automaticallyImplyLeading: false,
// // //         title: Text("Farmer Home"),
// // //         actions: [
// // //           IconButton(
// // //             icon: Icon(Icons.logout),
// // //             onPressed: () => _logout(context),
// // //           ),
// // //         ],
// // //       ),
// // //       body: Center(
// // //         child: Column(
// // //           children: [
// // //             ElevatedButton(onPressed: (){
// // //               Navigator.push(
// // //                 context,
// // //                 MaterialPageRoute(builder: (_) => SettingsScreen()),
// // //               );
// // //             }, child: Icon(Icons.settings)),
// // //             Text(
// // //               "Welcome, Farmer!",
// // //               style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }
