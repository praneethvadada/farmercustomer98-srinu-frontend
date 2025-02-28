import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// class FarmerOrderDetailsScreen extends StatefulWidget {
//   final Map<String, dynamic> order;
//
//   FarmerOrderDetailsScreen({required this.order});
//
//   @override
//   _FarmerOrderDetailsScreenState createState() => _FarmerOrderDetailsScreenState();
// }
//
// class _FarmerOrderDetailsScreenState extends State<FarmerOrderDetailsScreen> {
//   late String selectedStatus;
//   final List<String> orderStatusOptions = ["Pending", "Confirmed", "Shipped", "Delivered", "Canceled"];
//
//   @override
//   void initState() {
//     super.initState();
//     selectedStatus = widget.order["order_status"] ?? "Pending";
//   }
//
//   /// ✅ **Update Order Status API Call**
//   Future<void> _updateOrderStatus(int orderId, String newStatus) async {
//     log("🟢 Updating Order ID: $orderId to Status: $newStatus");
//
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? token = prefs.getString("token");
//
//     if (token == null || token.isEmpty) {
//       log("❌ No token found! Cannot update order status.");
//       return;
//     }
//
//     try {
//       final response = await http.put(
//         Uri.parse("http://10.0.2.2:3000/api/orders/update/$orderId"),
//         headers: {
//           "Authorization": "Bearer $token",
//           "Content-Type": "application/json"
//         },
//         body: jsonEncode({"order_status": newStatus}),
//       );
//
//       log("🛠 Order Status Update Response: ${response.statusCode}");
//       log("🛠 Response Body: ${response.body}");
//
//       if (response.statusCode == 200) {
//         setState(() {
//           selectedStatus = newStatus;
//         });
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("✅ Order status updated to $newStatus")));
//       } else {
//         log("❌ Error updating order status: ${response.body}");
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("❌ Failed to update order status")));
//       }
//     } catch (e) {
//       log("❌ Exception updating order status: $e");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final order = widget.order;
//
//     return Scaffold(
//       appBar: AppBar(title: Text("Order Details")),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("Order ID: ${order["order_id"] ?? "Unknown"}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             SizedBox(height: 10),
//             Text("Total Price: ₹${order["total_price"] ?? "N/A"}"),
//             Text("Customer Address: ${order["customer_address"] ?? "Not Available"}"),
//             SizedBox(height: 20),
//
//             /// ✅ **Dropdown for Order Status**
//             Text("Order Status:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//             DropdownButton<String>(
//               value: selectedStatus,
//               items: orderStatusOptions.map((String status) {
//                 return DropdownMenuItem<String>(
//                   value: status,
//                   child: Text(status),
//                 );
//               }).toList(),
//               onChanged: (String? newValue) {
//                 if (newValue != null) {
//                   _updateOrderStatus(order["order_id"], newValue);
//                 }
//               },
//             ),
//
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () => _updateOrderStatus(order["order_id"], selectedStatus),
//               child: Text("Update Status"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//






import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FarmerOrderDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> order;

  FarmerOrderDetailsScreen({required this.order});

  @override
  _FarmerOrderDetailsScreenState createState() => _FarmerOrderDetailsScreenState();
}

class _FarmerOrderDetailsScreenState extends State<FarmerOrderDetailsScreen> {
  late String selectedStatus;
  final List<String> orderStatusOptions = ["Pending", "Confirmed", "Shipped", "Delivered", "Canceled"];
  bool isUpdating = false;

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.order["order_status"] ?? "Pending";
  }

  /// ✅ **Update Order Status API Call**
  Future<void> _updateOrderStatus(int orderId, String newStatus) async {
    log("🟢 Updating Order ID: $orderId to Status: $newStatus");

    if (isUpdating) {
      log("⚠ Update already in progress. Skipping...");
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    if (token == null || token.isEmpty) {
      log("❌ No token found! Cannot update order status.");
      return;
    }

    setState(() {
      isUpdating = true; // Prevent multiple updates
    });

    try {
      final response = await http.put(
        Uri.parse("http://10.0.2.2:3000/api/orders/update/$orderId"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
        body: jsonEncode({"new_status": newStatus}), // ✅ Correct Key
      );

      log("🛠 Order Status Update Response: ${response.statusCode}");
      log("🛠 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        setState(() {
          selectedStatus = newStatus;
          isUpdating = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("✅ Order status updated to $newStatus")));
      } else {
        log("❌ Error updating order status: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("❌ Failed to update order status")));
        setState(() {
          isUpdating = false;
        });
      }
    } catch (e) {
      log("❌ Exception updating order status: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("❌ Error updating order")));
      setState(() {
        isUpdating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.order;
    final String customerAddress = order["customer_address"] ?? "No Address Available";
    final double totalPrice = double.tryParse(order["total_price"]?.toString() ?? "0") ?? 0;

    return Scaffold(
      appBar: AppBar(title: Text("Order Details")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Order ID: ${order["order_id"] ?? "Unknown"}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text("Total Price: ₹${totalPrice.toStringAsFixed(2)}"),
            Text("Customer Address: $customerAddress"),
            SizedBox(height: 20),

            /// ✅ **Dropdown for Order Status**
            Text("Order Status:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              value: selectedStatus,
              items: orderStatusOptions.map((String status) {
                return DropdownMenuItem<String>(
                  value: status,
                  child: Text(status),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  _updateOrderStatus(order["order_id"], newValue);
                }
              },
            ),

            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isUpdating ? null : () => _updateOrderStatus(order["order_id"], selectedStatus),
              child: isUpdating
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text("Update Status"),
            ),
          ],
        ),
      ),
    );
  }
}



class FarmerOrdersScreen extends StatefulWidget {
  @override
  _FarmerOrdersScreenState createState() => _FarmerOrdersScreenState();
}

class _FarmerOrdersScreenState extends State<FarmerOrdersScreen> {
  Map<int, List<dynamic>> groupedOrders = {}; // Grouped by Customer ID
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    if (token == null || token.isEmpty) {
      log("❌ No token found! User might not be authenticated.");
      return;
    }

    log("🛒 Fetching farmer orders with token: $token");

    try {
      final response = await http.get(
        Uri.parse("http://10.0.2.2:3000/api/orders/requests"),
        headers: {"Authorization": "Bearer $token"},
      );

      log("🔍 Response Status: ${response.statusCode}");
      log("🔍 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        List<dynamic> orders = jsonDecode(response.body)["orders"];

        // ✅ **Group orders by `customer_id`**
        setState(() {
          groupedOrders.clear();
          for (var order in orders) {
            int customerId = order["customer_id"];
            if (!groupedOrders.containsKey(customerId)) {
              groupedOrders[customerId] = [];
            }
            groupedOrders[customerId]!.add(order);
          }
          isLoading = false;
        });
      } else {
        log("❌ Error fetching orders: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      log("❌ Exception fetching orders: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Farmer Orders")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: groupedOrders.keys.length,
        itemBuilder: (context, index) {
          int customerId = groupedOrders.keys.elementAt(index);
          List<dynamic> customerOrders = groupedOrders[customerId]!;

          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text("Customer ID: $customerId"),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: customerOrders.map((order) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Order ID: ${order["order_id"] ?? "Unknown"}"),
                      Text("Total: ₹${order["total_price"] ?? "N/A"}"),
                      Text(
                        "Status: ${order["order_status"] ?? "Unknown"}",
                        style: TextStyle(color: Colors.green),
                      ),
                    ],
                  );
                }).toList(),
              ),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FarmerOrderDetailsScreen(order: customerOrders.first),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// import 'dart:convert';
// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
//
// class FarmerOrdersScreen extends StatefulWidget {
//   @override
//   _FarmerOrdersScreenState createState() => _FarmerOrdersScreenState();
// }
//
// class _FarmerOrdersScreenState extends State<FarmerOrdersScreen> {
//   List<dynamic> orders = [];
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchOrders();
//   }
//
//   Future<void> _fetchOrders() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? token = prefs.getString("token");
//
//     if (token == null || token.isEmpty) {
//       log("❌ No token found! User might not be authenticated.");
//       return;
//     }
//
//     log("🛒 Fetching farmer orders with token: $token");
//
//     try {
//       final response = await http.get(
//         Uri.parse("http://10.0.2.2:3000/api/orders/requests"),
//         headers: {"Authorization": "Bearer $token"},
//       );
//
//       log("🔍 Response Status: ${response.statusCode}");
//       log("🔍 Response Body: ${response.body}");
//
//       if (response.statusCode == 200) {
//         setState(() {
//           orders = jsonDecode(response.body)["orders"];
//           isLoading = false;
//         });
//       } else {
//         log("❌ Error fetching orders: ${response.statusCode} - ${response.body}");
//       }
//     } catch (e) {
//       log("❌ Exception fetching orders: $e");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Farmer Orders")),
//       body: isLoading
//           ? Center(child: CircularProgressIndicator())
//           : ListView.builder(
//         itemCount: orders.length,
//         itemBuilder: (context, index) {
//           final order = orders[index];
//           return Card(
//             margin: EdgeInsets.all(8.0),
//             child: ListTile(
//               title: Text("Order ID: ${order["order_id"] ?? "Unknown"}"),
//               subtitle: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text("Total: ₹${order["total_price"] ?? "N/A"}"),
//                   Text(
//                     "Status: ${order["order_status"] ?? "Unknown"}",
//                     style: TextStyle(color: Colors.green),
//                   ),
//                 ],
//               ),
//               trailing: Icon(Icons.check, color: Colors.green),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (_) => FarmerOrderDetailsScreen(order: order),
//                   ),
//                 );
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
//
//
//
// class FarmerOrderDetailsScreen extends StatelessWidget {
//   final Map<String, dynamic> order;
//
//   FarmerOrderDetailsScreen({required this.order});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Order Details")),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("Order ID: ${order["order_id"] ?? "Unknown"}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             SizedBox(height: 10),
//             Text("Total Price: ₹${order["total_price"] ?? "N/A"}"),
//             Text("Customer Address: ${order["customer_address"] ?? "Not Available"}"),
//             Text("Order Status: ${order["order_status"] ?? "Pending"}"),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 log("✅ Confirming Order ID: ${order["order_id"]}");
//               },
//               child: Text("Confirm Order"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // import 'dart:convert';
// // import 'dart:developer';
// // import 'package:flutter/material.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:shared_preferences/shared_preferences.dart';
// //
// // class FarmerOrdersScreen extends StatefulWidget {
// //   @override
// //   _FarmerOrdersScreenState createState() => _FarmerOrdersScreenState();
// // }
// //
// // class _FarmerOrdersScreenState extends State<FarmerOrdersScreen> {
// //   List<dynamic> orders = [];
// //   bool isLoading = true;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _fetchFarmerOrders();
// //   }
// //
// //   /// ✅ Fetch Orders for Farmer
// //   Future<void> _fetchFarmerOrders() async {
// //     SharedPreferences prefs = await SharedPreferences.getInstance();
// //     String? token = prefs.getString("token");
// //
// //     try {
// //       final response = await http.get(
// //         Uri.parse("http://10.0.2.2:3000/api/orders/requests"),
// //         headers: {"Authorization": "Bearer $token"},
// //       );
// //
// //       if (response.statusCode == 200) {
// //         setState(() {
// //           orders = jsonDecode(response.body)["orders"];
// //           isLoading = false;
// //         });
// //       } else {
// //         log("❌ Error fetching farmer orders: ${response.body}");
// //       }
// //     } catch (e) {
// //       log("❌ Exception fetching farmer orders: $e");
// //     }
// //   }
// //
// //   /// ✅ Confirm Order
// //   Future<void> _confirmOrder(int orderId) async {
// //     SharedPreferences prefs = await SharedPreferences.getInstance();
// //     String? token = prefs.getString("token");
// //
// //     try {
// //       final response = await http.put(
// //         Uri.parse("http://10.0.2.2:3000/api/orders/confirm/$orderId"),
// //         headers: {"Authorization": "Bearer $token"},
// //       );
// //
// //       if (response.statusCode == 200) {
// //         _fetchFarmerOrders();
// //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Order Confirmed")));
// //       } else {
// //         log("❌ Error confirming order: ${response.body}");
// //       }
// //     } catch (e) {
// //       log("❌ Exception confirming order: $e");
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //
// //           title: Text("Farmer Orders")),
// //       body: isLoading
// //           ? Center(child: CircularProgressIndicator())
// //           : ListView.builder(
// //         itemCount: orders.length,
// //         itemBuilder: (context, index) {
// //           final order = orders[index];
// //           return Card(
// //             margin: EdgeInsets.all(8.0),
// //             child: ListTile(
// //               title: Text("Order ID: ${order["id"]}"),
// //               subtitle: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Text("Total: ₹${order["total_price"]}"),
// //                   Text("Status: ${order["order_status"]}",
// //                       style: TextStyle(
// //                           color: order["order_status"] == "Canceled"
// //                               ? Colors.red
// //                               : Colors.green)),
// //                 ],
// //               ),
// //               trailing: order["order_status"] == "Pending"
// //                   ? IconButton(
// //                 icon: Icon(Icons.check, color: Colors.green),
// //                 onPressed: () => _confirmOrder(order["id"]),
// //               )
// //                   : null,
// //               onTap: () {
// //                 Navigator.push(
// //                   context,
// //                   MaterialPageRoute(
// //                     builder: (_) => FarmerOrderDetailsScreen(order: order),
// //                   ),
// //                 );
// //               },
// //             ),
// //           );
// //         },
// //       ),
// //     );
// //   }
// // }
// //
// //
// //
// // class FarmerOrderDetailsScreen extends StatefulWidget {
// //   final Map<String, dynamic> order;
// //
// //   FarmerOrderDetailsScreen({required this.order});
// //
// //   @override
// //   _FarmerOrderDetailsScreenState createState() => _FarmerOrderDetailsScreenState();
// // }
// //
// // class _FarmerOrderDetailsScreenState extends State<FarmerOrderDetailsScreen> {
// //   /// ✅ Update Order Status
// //   Future<void> _updateOrderStatus(String status) async {
// //     SharedPreferences prefs = await SharedPreferences.getInstance();
// //     String? token = prefs.getString("token");
// //
// //     try {
// //       final response = await http.put(
// //         Uri.parse("http://10.0.2.2:3000/api/orders/update/${widget.order["id"]}"),
// //         headers: {
// //           "Authorization": "Bearer $token",
// //           "Content-Type": "application/json"
// //         },
// //         body: jsonEncode({"order_status": status}),
// //       );
// //
// //       if (response.statusCode == 200) {
// //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Order marked as $status")));
// //         setState(() {
// //           widget.order["order_status"] = status;
// //         });
// //       } else {
// //         log("❌ Error updating order status: ${response.body}");
// //       }
// //     } catch (e) {
// //       log("❌ Exception updating order status: $e");
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     List<String> statuses = ["Pending", "Confirmed", "Shipped", "Delivered", "Canceled"];
// //     int currentStatusIndex = statuses.indexOf(widget.order["order_status"]);
// //
// //     return Scaffold(
// //       appBar: AppBar(title: Text("Order Details")),
// //       body: Padding(
// //         padding: EdgeInsets.all(16.0),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Text("Order ID: ${widget.order["id"]}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
// //             SizedBox(height: 10),
// //             Text("Total Price: ₹${widget.order["total_price"]}", style: TextStyle(fontSize: 16)),
// //             SizedBox(height: 10),
// //             Text("Customer Address:", style: TextStyle(fontWeight: FontWeight.bold)),
// //             Text(widget.order["customer_address"]),
// //             SizedBox(height: 10),
// //             Text("Farmer Address:", style: TextStyle(fontWeight: FontWeight.bold)),
// //             Text(widget.order["farmer_address"]),
// //             SizedBox(height: 20),
// //
// //             Text("Order Status:", style: TextStyle(fontWeight: FontWeight.bold)),
// //             SizedBox(height: 10),
// //             Row(
// //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //               children: statuses.map((status) {
// //                 int index = statuses.indexOf(status);
// //                 return Column(
// //                   children: [
// //                     Icon(
// //                       index <= currentStatusIndex ? Icons.circle : Icons.circle_outlined,
// //                       color: index <= currentStatusIndex ? Colors.green : Colors.grey,
// //                     ),
// //                     Text(status),
// //                   ],
// //                 );
// //               }).toList(),
// //             ),
// //
// //             SizedBox(height: 20),
// //             widget.order["order_status"] == "Confirmed"
// //                 ? Row(
// //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //               children: [
// //                 ElevatedButton(
// //                   onPressed: () => _updateOrderStatus("Shipped"),
// //                   child: Text("Mark as Shipped"),
// //                 ),
// //                 ElevatedButton(
// //                   onPressed: () => _updateOrderStatus("Delivered"),
// //                   child: Text("Mark as Delivered"),
// //                 ),
// //               ],
// //             )
// //                 : SizedBox(),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
