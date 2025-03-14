import 'dart:developer';
import 'package:flutter/material.dart';
import '../../graphs_page.dart';
import 'cart_screen.dart';
import 'customer_products_screen.dart';
import 'customer_request_screen.dart';
import 'profile page/c_profile_page.dart';
import 'search_page.dart';

class CustomerHomeScreen extends StatefulWidget {
  @override
  _CustomerHomeScreenState createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  int _selectedIndex = 0;

  // Define pages dynamically
  late List<Widget> _pages;
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
  @override
  void initState() {
    super.initState();
    _pages = [
      GraphPage(cropData: cropData), // ✅ No need to pass cropData explicitly
      CustomerProductsScreen(),
      CartScreen(),
      CustomerRequestsScreen(),
      ProfileScreen(),
    ];
  }

  void _onItemTapped(int index) {
    log('Bottom Nav Clicked - Index: $index');
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    log('CustomerHomeScreen Build - Selected Index: $_selectedIndex');
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Customer Dashboard',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SearchProductsScreen()),
              );
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade100, Colors.green.shade100],
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
              BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: 'Farmer Products'),
              BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
              BottomNavigationBarItem(icon: Icon(Icons.add_box_outlined), label: 'Request'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.blue,
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

// import 'dart:developer';
// import 'package:flutter/material.dart';
// import '../../graphs_page.dart';
// import 'cart_screen.dart';
// import 'customer_products_screen.dart';
// import 'customer_request_screen.dart';
// import 'profile page/c_profile_page.dart';
// import 'search_page.dart';
//
// class CustomerHomeScreen extends StatefulWidget {
//   @override
//   _CustomerHomeScreenState createState() => _CustomerHomeScreenState();
// }
//
// class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
//   int _selectedIndex = 0;
//   final List<Map<String, dynamic>> cropData = [
//     {"name": "Rice", "prices": [3300, 3500, 3600], "years": [2020, 2021, 2022]},
//     {"name": "Wheat", "prices": [3200, 3300, 3400], "years": [2020, 2021, 2022]},
//     {"name": "Corn", "prices": [3100, 3200, 3300], "years": [2020, 2021, 2022]},
//     {"name": "Barley", "prices": [3000, 3100, 3200], "years": [2020, 2021, 2022]},
//     {"name": "Soybean", "prices": [2900, 3000, 3100], "years": [2020, 2021, 2022]},
//     {"name": "Cotton", "prices": [4000, 4100, 4200], "years": [2020, 2021, 2022]},
//     {"name": "Sugarcane", "prices": [2900, 3000, 3100], "years": [2020, 2021, 2022]},
//     {"name": "Potato", "prices": [2700, 2800, 2900], "years": [2020, 2021, 2022]},
//     {"name": "Tomato", "prices": [2600, 2700, 2800], "years": [2020, 2021, 2022]},
//     {"name": "Onion", "prices": [2500, 2600, 2700], "years": [2020, 2021, 2022]},
//     {"name": "Peanut", "prices": [3500, 3600, 3700], "years": [2020, 2021, 2022]},
//     {"name": "Sunflower", "prices": [3300, 3400, 3500], "years": [2020, 2021, 2022]},
//     {"name": "Millet", "prices": [3200, 3300, 3400], "years": [2020, 2021, 2022]},
//     {"name": "Lentil", "prices": [3000, 3100, 3200], "years": [2020, 2021, 2022]},
//     {"name": "Chickpea", "prices": [3100, 3200, 3300], "years": [2020, 2021, 2022]},
//     {"name": "Pea", "prices": [2800, 2900, 3000], "years": [2020, 2021, 2022]},
//     {"name": "Oat", "prices": [2900, 3000, 3100], "years": [2020, 2021, 2022]},
//     {"name": "Mustard", "prices": [3700, 3800, 3900], "years": [2020, 2021, 2022]},
//     {"name": "Sesame", "prices": [3400, 3500, 3600], "years": [2020, 2021, 2022]},
//     {"name": "Sorghum", "prices": [3200, 3300, 3400], "years": [2020, 2021, 2022]},
//     {"name": "Cabbage", "prices": [2400, 2500, 2600], "years": [2020, 2021, 2022]},
//     {"name": "Carrot", "prices": [2300, 2400, 2500], "years": [2020, 2021, 2022]},
//     {"name": "Garlic", "prices": [2700, 2800, 2900], "years": [2020, 2021, 2022]},
//     {"name": "Ginger", "prices": [2900, 3000, 3100], "years": [2020, 2021, 2022]},
//     {"name": "Spinach", "prices": [2200, 2300, 2400], "years": [2020, 2021, 2022]},
//     {"name": "Lettuce", "prices": [2300, 2400, 2500], "years": [2020, 2021, 2022]},
//     {"name": "Radish", "prices": [2100, 2200, 2300], "years": [2020, 2021, 2022]},
//     {"name": "Pumpkin", "prices": [2500, 2600, 2700], "years": [2020, 2021, 2022]},
//     {"name": "Cucumber", "prices": [2400, 2500, 2600], "years": [2020, 2021, 2022]},
//     {"name": "Eggplant", "prices": [2300, 2400, 2500], "years": [2020, 2021, 2022]},
//     {"name": "Mango", "prices": [4000, 4100, 4200], "years": [2020, 2021, 2022]},
//     {"name": "Banana", "prices": [3200, 3300, 3400], "years": [2020, 2021, 2022]},
//     {"name": "Apple", "prices": [4500, 4600, 4700], "years": [2020, 2021, 2022]},
//     {"name": "Grapes", "prices": [3800, 3900, 4000], "years": [2020, 2021, 2022]},
//     {"name": "Pineapple", "prices": [3700, 3800, 3900], "years": [2020, 2021, 2022]},
//     {"name": "Papaya", "prices": [3100, 3200, 3300], "years": [2020, 2021, 2022]},
//     {"name": "Strawberry", "prices": [4200, 4300, 4400], "years": [2020, 2021, 2022]},
//     {"name": "Watermelon", "prices": [3500, 3600, 3700], "years": [2020, 2021, 2022]},
//     {"name": "Guava", "prices": [3100, 3200, 3300], "years": [2020, 2021, 2022]},
//     {"name": "Pomegranate", "prices": [3400, 3500, 3600], "years": [2020, 2021, 2022]},
//     {"name": "Coffee", "prices": [7000, 7100, 7200], "years": [2020, 2021, 2022]},
//     {"name": "Tea", "prices": [6000, 6100, 6200], "years": [2020, 2021, 2022]},
//     {"name": "Cocoa", "prices": [8000, 8100, 8200], "years": [2020, 2021, 2022]},
//     {"name": "Vanilla", "prices": [7500, 7600, 7700], "years": [2020, 2021, 2022]},
//     {"name": "Almond", "prices": [6200, 6300, 6400], "years": [2020, 2021, 2022]},
//     {"name": "Cashew", "prices": [5800, 5900, 6000], "years": [2020, 2021, 2022]},
//     {"name": "Walnut", "prices": [6600, 6700, 6800], "years": [2020, 2021, 2022]},
//     {"name": "Pistachio", "prices": [6900, 7000, 7100], "years": [2020, 2021, 2022]},
//     {"name": "Date", "prices": [5100, 5200, 5300], "years": [2020, 2021, 2022]},
//     {"name": "Fig", "prices": [4800, 4900, 5000], "years": [2020, 2021, 2022]},
//   ];
//   // Define pages dynamically
//   late List<Widget> _pages;
//
//   @override
//   void initState() {
//     super.initState();
//     _pages = [
//       GraphPage(cropData: cropData), // ✅ No need to pass cropData explicitly
//       CustomerProductsScreen(),
//       CartScreen(),
//       CustomerRequestsScreen(),
//       ProfileScreen(),
//     ];
//   }
//
//   void _onItemTapped(int index) {
//     log('Bottom Nav Clicked - Index: $index');
//     setState(() {
//       _selectedIndex = index;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     log('CustomerHomeScreen Build - Selected Index: $_selectedIndex');
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Customer Dashboard',
//           style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: Colors.blue,
//         centerTitle: true,
//         actions: [
//           IconButton(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (_) => SearchProductsScreen()),
//               );
//             },
//             icon: Icon(Icons.search),
//           ),
//         ],
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Colors.blue.shade100, Colors.green.shade100],
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
//               BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: 'Farmer Products'),
//               BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
//               BottomNavigationBarItem(icon: Icon(Icons.add_box_outlined), label: 'Request'),
//               BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
//             ],
//             currentIndex: _selectedIndex,
//             selectedItemColor: Colors.blue,
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
// // import 'dart:developer';
// // import 'package:flutter/material.dart';
// // import '../../graphs_page.dart';
// // import 'cart_screen.dart';
// // import 'customer_products_screen.dart';
// // import 'customer_request_screen.dart';
// // import 'profile page/c_profile_page.dart';
// // import 'search_page.dart';
// //
// // class CustomerHomeScreen extends StatefulWidget {
// //   @override
// //   _CustomerHomeScreenState createState() => _CustomerHomeScreenState();
// // }
// //
// // class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
// //   int _selectedIndex = 0;
// //
// //   // Sample crop data to be passed to GraphPage
// //   final List<Map<String, dynamic>> cropData = [
// //     {"name": "Rice", "prices": [3300, 3500, 3600], "years": [2020, 2021, 2022]},
// //     {"name": "Wheat", "prices": [3200, 3300, 3400], "years": [2020, 2021, 2022]},
// //     {"name": "Corn", "prices": [3100, 3200, 3300], "years": [2020, 2021, 2022]},
// //     {"name": "Barley", "prices": [3000, 3100, 3200], "years": [2020, 2021, 2022]},
// //     {"name": "Soybean", "prices": [2900, 3000, 3100], "years": [2020, 2021, 2022]},
// //     {"name": "Cotton", "prices": [4000, 4100, 4200], "years": [2020, 2021, 2022]},
// //     {"name": "Sugarcane", "prices": [2900, 3000, 3100], "years": [2020, 2021, 2022]},
// //     {"name": "Potato", "prices": [2700, 2800, 2900], "years": [2020, 2021, 2022]},
// //     {"name": "Tomato", "prices": [2600, 2700, 2800], "years": [2020, 2021, 2022]},
// //     {"name": "Onion", "prices": [2500, 2600, 2700], "years": [2020, 2021, 2022]},
// //     {"name": "Peanut", "prices": [3500, 3600, 3700], "years": [2020, 2021, 2022]},
// //     {"name": "Sunflower", "prices": [3300, 3400, 3500], "years": [2020, 2021, 2022]},
// //     {"name": "Millet", "prices": [3200, 3300, 3400], "years": [2020, 2021, 2022]},
// //     {"name": "Lentil", "prices": [3000, 3100, 3200], "years": [2020, 2021, 2022]},
// //     {"name": "Chickpea", "prices": [3100, 3200, 3300], "years": [2020, 2021, 2022]},
// //     {"name": "Pea", "prices": [2800, 2900, 3000], "years": [2020, 2021, 2022]},
// //     {"name": "Oat", "prices": [2900, 3000, 3100], "years": [2020, 2021, 2022]},
// //     {"name": "Mustard", "prices": [3700, 3800, 3900], "years": [2020, 2021, 2022]},
// //     {"name": "Sesame", "prices": [3400, 3500, 3600], "years": [2020, 2021, 2022]},
// //     {"name": "Sorghum", "prices": [3200, 3300, 3400], "years": [2020, 2021, 2022]},
// //     {"name": "Cabbage", "prices": [2400, 2500, 2600], "years": [2020, 2021, 2022]},
// //     {"name": "Carrot", "prices": [2300, 2400, 2500], "years": [2020, 2021, 2022]},
// //     {"name": "Garlic", "prices": [2700, 2800, 2900], "years": [2020, 2021, 2022]},
// //     {"name": "Ginger", "prices": [2900, 3000, 3100], "years": [2020, 2021, 2022]},
// //     {"name": "Spinach", "prices": [2200, 2300, 2400], "years": [2020, 2021, 2022]},
// //     {"name": "Lettuce", "prices": [2300, 2400, 2500], "years": [2020, 2021, 2022]},
// //     {"name": "Radish", "prices": [2100, 2200, 2300], "years": [2020, 2021, 2022]},
// //     {"name": "Pumpkin", "prices": [2500, 2600, 2700], "years": [2020, 2021, 2022]},
// //     {"name": "Cucumber", "prices": [2400, 2500, 2600], "years": [2020, 2021, 2022]},
// //     {"name": "Eggplant", "prices": [2300, 2400, 2500], "years": [2020, 2021, 2022]},
// //     {"name": "Mango", "prices": [4000, 4100, 4200], "years": [2020, 2021, 2022]},
// //     {"name": "Banana", "prices": [3200, 3300, 3400], "years": [2020, 2021, 2022]},
// //     {"name": "Apple", "prices": [4500, 4600, 4700], "years": [2020, 2021, 2022]},
// //     {"name": "Grapes", "prices": [3800, 3900, 4000], "years": [2020, 2021, 2022]},
// //     {"name": "Pineapple", "prices": [3700, 3800, 3900], "years": [2020, 2021, 2022]},
// //     {"name": "Papaya", "prices": [3100, 3200, 3300], "years": [2020, 2021, 2022]},
// //     {"name": "Strawberry", "prices": [4200, 4300, 4400], "years": [2020, 2021, 2022]},
// //     {"name": "Watermelon", "prices": [3500, 3600, 3700], "years": [2020, 2021, 2022]},
// //     {"name": "Guava", "prices": [3100, 3200, 3300], "years": [2020, 2021, 2022]},
// //     {"name": "Pomegranate", "prices": [3400, 3500, 3600], "years": [2020, 2021, 2022]},
// //     {"name": "Coffee", "prices": [7000, 7100, 7200], "years": [2020, 2021, 2022]},
// //     {"name": "Tea", "prices": [6000, 6100, 6200], "years": [2020, 2021, 2022]},
// //     {"name": "Cocoa", "prices": [8000, 8100, 8200], "years": [2020, 2021, 2022]},
// //     {"name": "Vanilla", "prices": [7500, 7600, 7700], "years": [2020, 2021, 2022]},
// //     {"name": "Almond", "prices": [6200, 6300, 6400], "years": [2020, 2021, 2022]},
// //     {"name": "Cashew", "prices": [5800, 5900, 6000], "years": [2020, 2021, 2022]},
// //     {"name": "Walnut", "prices": [6600, 6700, 6800], "years": [2020, 2021, 2022]},
// //     {"name": "Pistachio", "prices": [6900, 7000, 7100], "years": [2020, 2021, 2022]},
// //     {"name": "Date", "prices": [5100, 5200, 5300], "years": [2020, 2021, 2022]},
// //     {"name": "Fig", "prices": [4800, 4900, 5000], "years": [2020, 2021, 2022]},
// //   ];
// //
// //
// //   late List<Widget> _pages; // Define _pages dynamically
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _pages = [
// //       GraphPage(cropData: cropData), // ✅ Pass cropData to GraphPage
// //       CustomerProductsScreen(),
// //       CartScreen(),
// //       CustomerRequestsScreen(),
// //       ProfileScreen(),
// //     ];
// //   }
// //
// //   void _onItemTapped(int index) {
// //     log('Bottom Nav Clicked - Index: $index');
// //     setState(() {
// //       _selectedIndex = index;
// //     });
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     log('CustomerHomeScreen Build - Selected Index: $_selectedIndex');
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text(
// //           'Customer Dashboard',
// //           style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
// //         ),
// //         backgroundColor: Colors.blue,
// //         centerTitle: true,
// //         actions: [
// //           IconButton(
// //             onPressed: () {
// //               Navigator.push(
// //                 context,
// //                 MaterialPageRoute(builder: (_) => SearchProductsScreen()),
// //               );
// //             },
// //             icon: Icon(Icons.search),
// //           ),
// //         ],
// //       ),
// //       body: Container(
// //         decoration: BoxDecoration(
// //           gradient: LinearGradient(
// //             colors: [Colors.blue.shade100, Colors.green.shade100],
// //             begin: Alignment.topLeft,
// //             end: Alignment.bottomRight,
// //           ),
// //         ),
// //         child: _pages[_selectedIndex],
// //       ),
// //       bottomNavigationBar: Container(
// //         decoration: BoxDecoration(
// //           borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
// //           boxShadow: [
// //             BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 2),
// //           ],
// //         ),
// //         child: ClipRRect(
// //           borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
// //           child: BottomNavigationBar(
// //             items: const <BottomNavigationBarItem>[
// //               BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
// //               BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: 'Farmer Products'),
// //               BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
// //               BottomNavigationBarItem(icon: Icon(Icons.add_box_outlined), label: 'Request'),
// //               BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
// //             ],
// //             currentIndex: _selectedIndex,
// //             selectedItemColor: Colors.blue,
// //             unselectedItemColor: Colors.black54,
// //             backgroundColor: Colors.white,
// //             showUnselectedLabels: true,
// //             type: BottomNavigationBarType.fixed,
// //             elevation: 10,
// //             onTap: _onItemTapped,
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
// // // import 'dart:developer';
// // // import 'package:farmercustomer98/screens/customer/cart_screen.dart';
// // // import 'package:farmercustomer98/screens/customer/customer_products_screen.dart';
// // // import 'package:farmercustomer98/screens/customer/customer_request_screen.dart';
// // // import 'package:farmercustomer98/screens/customer/profile%20page/c_profile_page.dart';
// // // import 'package:farmercustomer98/screens/customer/search_page.dart';
// // // import 'package:flutter/material.dart';
// // // import '../../graphs_page.dart';
// // //
// // // class CustomerHomeScreen extends StatefulWidget {
// // //   @override
// // //   _CustomerHomeScreenState createState() => _CustomerHomeScreenState();
// // // }
// // //
// // // class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
// // //   int _selectedIndex = 0;
// // //
// // //   static final List<Widget> _pages = <Widget>[
// // //     // GraphPage(),
// // //     CustomerProductsScreen(),
// // //     CartScreen(), // Ensure this class is defined properly
// // //     CustomerRequestsScreen(),
// // //     Center(child: ProfileScreen()),
// // //   ];
// // //
// // //   void _onItemTapped(int index) {
// // //     log('Bottom Nav Clicked - Index: $index');
// // //     setState(() {
// // //       _selectedIndex = index;
// // //     });
// // //   }
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     log('CustomerHomeScreen Build - Selected Index: $_selectedIndex');
// // //     return Scaffold(
// // //       appBar: AppBar(
// // //
// // //           title: Text('Customer Dashboard'),
// // //
// // //         actions: [
// // //           IconButton(onPressed: (){
// // //             Navigator.push(
// // //               context,
// // //               MaterialPageRoute(builder: (_) => SearchProductsScreen()),
// // //             );
// // //           }, icon: Icon(Icons.search)),
// // //         ],
// // //
// // //
// // //       ),
// // //       body: _pages[_selectedIndex], // Error occurs if _pages[index] is null
// // //       bottomNavigationBar: BottomNavigationBar(
// // //         items: const <BottomNavigationBarItem>[
// // //           BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
// // //           BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: 'Farmer Products'),
// // //           BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
// // //           BottomNavigationBarItem(icon: Icon(Icons.add_box_outlined), label: 'Request'),
// // //           BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
// // //         ],
// // //         currentIndex: _selectedIndex,
// // //         unselectedItemColor: Colors.black,
// // //         selectedItemColor: Colors.blue,
// // //         onTap: _onItemTapped,
// // //       ),
// // //     );
// // //   }
// // // }
// // //
// // // // import 'dart:convert';
// // // // import 'dart:io';
// // // // import 'dart:developer';
// // // // import 'package:farmercustomer98/screens/customer/customer_products_screen.dart';
// // // // import 'package:farmercustomer98/screens/customer/profile%20page/c_profile_page.dart';
// // // // import 'package:flutter/material.dart';
// // // // import 'package:http/http.dart' as http;
// // // // import 'package:image_picker/image_picker.dart';
// // // // import 'package:shared_preferences/shared_preferences.dart';
// // // //
// // // // class CustomerHomeScreen extends StatefulWidget {
// // // //   @override
// // // //   _CustomerHomeScreenState createState() => _CustomerHomeScreenState();
// // // // }
// // // //
// // // // class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
// // // //   int _selectedIndex = 0;
// // // //
// // // //   static final List<Widget> _pages = <Widget>[
// // // //     Center(child: Text('Home - Stats (Blank)')),
// // // //     // Center(child: Text('Farmer Products (Blank)')),
// // // //     CustomerProductsScreen(),
// // // //     CartScreen(),
// // // //     Center(child: Text('My Requests (Blank)')),
// // // //     Center(child: ProfilePage()),
// // // //
// // // //   ];
// // // //
// // // //   void _onItemTapped(int index) {
// // // //     log('Bottom Nav Clicked - Index: \$index');
// // // //     setState(() {
// // // //       _selectedIndex = index;
// // // //     });
// // // //   }
// // // //
// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     log('CustomerHomeScreen Build - Selected Index: \$_selectedIndex');
// // // //     return Scaffold(
// // // //       appBar: AppBar(title: Text('Customer Dashboard')),
// // // //       body: _pages[_selectedIndex],
// // // //       bottomNavigationBar: BottomNavigationBar(
// // // //         items: const <BottomNavigationBarItem>[
// // // //           BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
// // // //           BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: 'Farmer Products'),
// // // //           BottomNavigationBarItem(icon: Icon(Icons.list), label: 'My Requests'),
// // // //           BottomNavigationBarItem(icon: Icon(Icons.add_shopping_cart), label: 'Cart'),
// // // //
// // // //           BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
// // // //         ],
// // // //         currentIndex: _selectedIndex,
// // // //         unselectedItemColor: Colors.black,
// // // //         selectedItemColor: Colors.blue,
// // // //         onTap: _onItemTapped,
// // // //       ),
// // // //     );
// // // //   }
// // // // }
// // // //
// // // //
// // // //
// // // //
// // // //
// // // // // class CustomerProductsScreen extends StatefulWidget {
// // // // //   @override
// // // // //   _CustomerProductsScreenState createState() => _CustomerProductsScreenState();
// // // // // }
// // // // //
// // // // // class _CustomerProductsScreenState extends State<CustomerProductsScreen> {
// // // // //   List<dynamic> products = [];
// // // // //   bool isLoading = true;
// // // // //
// // // // //   @override
// // // // //   void initState() {
// // // // //     super.initState();
// // // // //     _fetchProducts();
// // // // //   }
// // // // //
// // // // //   Future<void> _fetchProducts() async {
// // // // //     SharedPreferences prefs = await SharedPreferences.getInstance();
// // // // //     String? token = prefs.getString("token");
// // // // //
// // // // //     if (token == null || token.isEmpty) {
// // // // //       log("❌ No token found! User might not be authenticated.");
// // // // //       return;
// // // // //     }
// // // // //
// // // // //     log("🟢 Fetching products with token: $token");
// // // // //
// // // // //     try {
// // // // //       final response = await http.get(
// // // // //         Uri.parse("http://10.0.2.2:3000/api/products/all"),
// // // // //         headers: {"Authorization": "Bearer $token"},
// // // // //       );
// // // // //
// // // // //       log("🔍 Request URL: http://10.0.2.2:3000/api/products/all");
// // // // //       log("🔍 Request Headers: Authorization: Bearer $token");
// // // // //       log("🔍 Response Status: ${response.statusCode}");
// // // // //       log("🔍 Response Body: ${response.body}");
// // // // //
// // // // //       if (response.statusCode == 200) {
// // // // //         setState(() {
// // // // //           products = jsonDecode(response.body)["products"];
// // // // //           isLoading = false;
// // // // //         });
// // // // //       } else {
// // // // //         log("❌ Error fetching products: ${response.statusCode} - ${response.body}");
// // // // //
// // // // //         if (response.statusCode == 401) {
// // // // //           log("🚨 Unauthorized! Token might be invalid or expired.");
// // // // //         }
// // // // //       }
// // // // //     } catch (e) {
// // // // //       log("❌ Exception fetching products: $e");
// // // // //     }
// // // // //   }
// // // // //
// // // // //
// // // // //
// // // // //   Future<void> _addToCart(int productId) async {
// // // // //     log("Adding product to cart: ID \$productId");
// // // // //     final response = await http.post(
// // // // //       Uri.parse("http://10.0.2.2:3000/api/cart/add"),
// // // // //       headers: {"Content-Type": "application/json"},
// // // // //       body: jsonEncode({"product_id": productId, "quantity": 1}),
// // // // //     );
// // // // //     log("Cart Add Response Status: \${response.statusCode}");
// // // // //     log("Cart Add Response Body: \${response.body}");
// // // // //     if (response.statusCode == 200) {
// // // // //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Product added to cart")));
// // // // //     }
// // // // //   }
// // // // //
// // // // //   @override
// // // // //   Widget build(BuildContext context) {
// // // // //     return Scaffold(
// // // // //       appBar: AppBar(title: Text("Farmer Products")),
// // // // //       body: isLoading
// // // // //           ? Center(child: CircularProgressIndicator())
// // // // //           : ListView.builder(
// // // // //         itemCount: products.length,
// // // // //         itemBuilder: (context, index) {
// // // // //           final product = products[index];
// // // // //           return Card(
// // // // //             margin: EdgeInsets.all(8.0),
// // // // //             child: ListTile(
// // // // //               title: Text(product["name"]),
// // // // //               subtitle: Text("Price: ₹${product["price"]}"),
// // // // //               trailing: IconButton(
// // // // //                 icon: Icon(Icons.add_shopping_cart),
// // // // //                 onPressed: () => _addToCart(product["id"]),
// // // // //               ),
// // // // //             ),
// // // // //           );
// // // // //         },
// // // // //       ),
// // // // //     );
// // // // //   }
// // // // // }
// // // // //
// // // //
// // // //
// // // // class CartScreen extends StatefulWidget {
// // // //   @override
// // // //   _CartScreenState createState() => _CartScreenState();
// // // // }
// // // //
// // // // class _CartScreenState extends State<CartScreen> {
// // // //   List<dynamic> cartItems = [];
// // // //   bool isLoading = true;
// // // //
// // // //   @override
// // // //   void initState() {
// // // //     super.initState();
// // // //     _fetchCartItems();
// // // //   }
// // // //
// // // //   Future<void> _fetchCartItems() async {
// // // //     SharedPreferences prefs = await SharedPreferences.getInstance();
// // // //     String? token = prefs.getString("token");
// // // //     final response = await http.get(
// // // //       Uri.parse("http://10.0.2.2:3000/api/cart"),
// // // //       headers: {"Authorization": "Bearer \$token"},
// // // //     );
// // // //     if (response.statusCode == 200) {
// // // //       setState(() {
// // // //         cartItems = jsonDecode(response.body)["cart"];
// // // //         isLoading = false;
// // // //       });
// // // //     }
// // // //   }
// // // //
// // // //   Future<void> _removeFromCart(int productId) async {
// // // //     final response = await http.delete(
// // // //       Uri.parse("http://10.0.2.2:3000/api/cart/remove/\$productId"),
// // // //     );
// // // //     if (response.statusCode == 200) {
// // // //       _fetchCartItems();
// // // //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Product removed from cart")));
// // // //     }
// // // //   }
// // // //
// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return Scaffold(
// // // //       appBar: AppBar(title: Text("My Cart")),
// // // //       body: isLoading
// // // //           ? Center(child: CircularProgressIndicator())
// // // //           : ListView.builder(
// // // //         itemCount: cartItems.length,
// // // //         itemBuilder: (context, index) {
// // // //           final item = cartItems[index];
// // // //           return Card(
// // // //             margin: EdgeInsets.all(8.0),
// // // //             child: ListTile(
// // // //               title: Text(item["name"]),
// // // //               subtitle: Text("Quantity: ${item["quantity"]}, Total: ₹${item["subtotal"]}"),
// // // //               trailing: IconButton(
// // // //                 icon: Icon(Icons.remove_shopping_cart),
// // // //                 onPressed: () => _removeFromCart(item["product_id"]),
// // // //               ),
// // // //             ),
// // // //           );
// // // //         },
// // // //       ),
// // // //     );
// // // //   }
// // // // }
// // // //
// // // //
// // // //
// // // // // import 'package:flutter/material.dart';
// // // // // import 'package:shared_preferences/shared_preferences.dart';
// // // // // import '../role_selection_screen.dart';
// // // // // import '../settings_screen.dart';
// // // // //
// // // // // class CustomerHomeScreen extends StatelessWidget {
// // // // //
// // // // //   // Future<void> _logout(BuildContext context) async {
// // // // //   //   SharedPreferences prefs = await SharedPreferences.getInstance();
// // // // //   //   await prefs.remove("token");
// // // // //   //   await prefs.remove("role");
// // // // //   //
// // // // //   //   Navigator.pushReplacement(
// // // // //   //     context,
// // // // //   //     MaterialPageRoute(builder: (_) => RoleSelectionScreen()),
// // // // //   //   );
// // // // //   // }
// // // // //
// // // // //   Future<void> _logout(BuildContext context) async {
// // // // //     SharedPreferences prefs = await SharedPreferences.getInstance();
// // // // //     await prefs.clear();  // Remove token and role
// // // // //
// // // // //     Navigator.pushReplacement(
// // // // //       context,
// // // // //       MaterialPageRoute(builder: (_) => RoleSelectionScreen()),
// // // // //     );
// // // // //   }
// // // // //
// // // // //   @override
// // // // //   Widget build(BuildContext context) {
// // // // //     return Scaffold(
// // // // //       appBar: AppBar(
// // // // //         automaticallyImplyLeading: false,
// // // // //         title: Text("Customer Home"),
// // // // //         actions: [
// // // // //           IconButton(
// // // // //             icon: Icon(Icons.logout),
// // // // //             onPressed: () => _logout(context),
// // // // //           ),
// // // // //         ],
// // // // //       ),
// // // // //       body: Center(
// // // // //         child: Column(
// // // // //           children: [
// // // // //             ElevatedButton(onPressed: (){
// // // // //               Navigator.push(
// // // // //                 context,
// // // // //                 MaterialPageRoute(builder: (_) => SettingsScreen()),
// // // // //               );
// // // // //             }, child: Icon(Icons.settings)),
// // // // //             Text(
// // // // //               "Welcome, Customer!",
// // // // //               style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
// // // // //             ),
// // // // //           ],
// // // // //         ),
// // // // //       ),
// // // // //     );
// // // // //   }
// // // // // }
