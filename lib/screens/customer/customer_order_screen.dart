import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CustomerOrderScreen extends StatefulWidget {
  @override
  _CustomerOrderScreenState createState() => _CustomerOrderScreenState();
}

class _CustomerOrderScreenState extends State<CustomerOrderScreen> {
  List<dynamic> orders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  /// ✅ Fetch Customer Orders
  Future<void> _fetchOrders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    try {
      final response = await http.get(
        Uri.parse("http://10.0.2.2:3000/api/orders/history"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        setState(() {
          orders = jsonDecode(response.body)["orders"];
          isLoading = false;
        });
      } else {
        log("❌ Error fetching orders: ${response.body}");
      }
    } catch (e) {
      log("❌ Exception fetching orders: $e");
    }
  }

  /// ✅ Cancel Order
  Future<void> _cancelOrder(int orderId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    try {
      final response = await http.put(
        Uri.parse("http://10.0.2.2:3000/api/orders/cancel/$orderId"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        _fetchOrders();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Order Canceled")));
      } else {
        log("❌ Error canceling order: ${response.body}");
      }
    } catch (e) {
      log("❌ Exception canceling order: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text("Order History")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text("Order ID: ${order["id"]}"),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Total: ₹${order["total_price"]}"),
                  Text("Status: ${order["order_status"]}",
                      style: TextStyle(
                          color: order["order_status"] == "Canceled"
                              ? Colors.red
                              : Colors.green)),
                ],
              ),
              trailing: order["order_status"] == "Pending"
                  ? IconButton(
                icon: Icon(Icons.cancel, color: Colors.red),
                onPressed: () => _cancelOrder(order["id"]),
              )
                  : null,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => OrderDetailsScreen(order: order),
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



class OrderDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> order;

  OrderDetailsScreen({required this.order});

  @override
  Widget build(BuildContext context) {
    List<String> statuses = ["Pending", "Confirmed", "Shipped", "Delivered", "Canceled"];
    int currentStatusIndex = statuses.indexOf(order["order_status"]);

    return Scaffold(
      appBar: AppBar(title: Text("Order Details")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Order ID: ${order["id"]}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text("Total Price: ₹${order["total_price"]}", style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text("Payment Type : UPI", style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text("Customer Address:", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(order["customer_address"]),
            SizedBox(height: 10),
            Text("Farmer Address:", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(order["farmer_address"]),
            SizedBox(height: 20),

            Text("Order Status:", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: statuses.map((status) {
                int index = statuses.indexOf(status);
                return Column(
                  children: [
                    Icon(
                      index <= currentStatusIndex ? Icons.circle : Icons.circle_outlined,
                      color: index <= currentStatusIndex ? Colors.green : Colors.grey,
                    ),
                    Text(status),
                  ],
                );
              }).toList(),
            ),

            SizedBox(height: 20),
            order["order_status"] == "Pending"
                ? Center(
              child: ElevatedButton(
                onPressed: () {
                  // Cancel Order
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: Text("Cancel Order"),
              ),
            )
                : SizedBox(),
          ],
        ),
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
// class CustomerOrderScreen extends StatefulWidget {
//   @override
//   _CustomerOrderScreenState createState() => _CustomerOrderScreenState();
// }
//
// class _CustomerOrderScreenState extends State<CustomerOrderScreen> {
//   List<dynamic> orders = [];
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchOrders();
//   }
//
//   /// ✅ Fetch Customer Orders
//   Future<void> _fetchOrders() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? token = prefs.getString("token");
//
//     try {
//       final response = await http.get(
//         Uri.parse("http://10.0.2.2:3000/api/orders/history"),
//         headers: {"Authorization": "Bearer $token"},
//       );
//
//       if (response.statusCode == 200) {
//         setState(() {
//           orders = jsonDecode(response.body)["orders"];
//           isLoading = false;
//         });
//       } else {
//         log("❌ Error fetching orders: ${response.body}");
//       }
//     } catch (e) {
//       log("❌ Exception fetching orders: $e");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Order History")),
//       body: isLoading
//           ? Center(child: CircularProgressIndicator())
//           : ListView.builder(
//         itemCount: orders.length,
//         itemBuilder: (context, index) {
//           final order = orders[index];
//           return ListTile(
//             title: Text("Order ID: ${order["id"]}"),
//             subtitle: Text("Status: ${order["order_status"]}"),
//           );
//         },
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
// // class CustomerOrderScreen extends StatefulWidget {
// //   @override
// //   _CustomerOrderScreenState createState() => _CustomerOrderScreenState();
// // }
// //
// // class _CustomerOrderScreenState extends State<CustomerOrderScreen> {
// //   List<dynamic> orders = [];
// //   bool isLoading = true;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _fetchOrders();
// //   }
// //
// //   /// ✅ Fetch Customer Orders
// //   Future<void> _fetchOrders() async {
// //     log("🛒 Fetching customer orders...");
// //
// //     SharedPreferences prefs = await SharedPreferences.getInstance();
// //     String? token = prefs.getString("token");
// //
// //     if (token == null || token.isEmpty) {
// //       log("❌ No token found! User might not be authenticated.");
// //       return;
// //     }
// //
// //     try {
// //       final response = await http.get(
// //         Uri.parse("http://10.0.2.2:3000/api/orders"),
// //         headers: {"Authorization": "Bearer $token"},
// //       );
// //
// //       log("🔍 Response Status: ${response.statusCode}");
// //       log("🔍 Response Body: ${response.body}");
// //
// //       if (response.statusCode == 200) {
// //         setState(() {
// //           orders = jsonDecode(response.body)["orders"];
// //           isLoading = false;
// //         });
// //       } else {
// //         log("❌ Error fetching orders: ${response.statusCode} - ${response.body}");
// //       }
// //     } catch (e) {
// //       log("❌ Exception fetching orders: $e");
// //     }
// //   }
// //
// //   /// ✅ Place Order (Triggered on Checkout)
// //   Future<void> _placeOrder(int productId, int quantity, double totalPrice, String customerAddress) async {
// //     log("🛍 Placing order for product ID: $productId");
// //
// //     SharedPreferences prefs = await SharedPreferences.getInstance();
// //     String? token = prefs.getString("token");
// //
// //     if (token == null || token.isEmpty) {
// //       log("❌ No token found! Cannot place order.");
// //       return;
// //     }
// //
// //     try {
// //       final response = await http.post(
// //         Uri.parse("http://10.0.2.2:3000/api/orders/place"),
// //         headers: {
// //           "Authorization": "Bearer $token",
// //           "Content-Type": "application/json"
// //         },
// //         body: jsonEncode({
// //           "product_id": productId,
// //           "quantity": quantity,
// //           "total_price": totalPrice,
// //           "customer_address": customerAddress
// //         }),
// //       );
// //
// //       log("🛍 Order Placement Response Status: ${response.statusCode}");
// //       log("🛍 Order Placement Response Body: ${response.body}");
// //
// //       if (response.statusCode == 201) {
// //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("✅ Order placed successfully!")));
// //         _fetchOrders();
// //       } else {
// //         log("❌ Error placing order: ${response.body}");
// //       }
// //     } catch (e) {
// //       log("❌ Exception placing order: $e");
// //     }
// //   }
// //
// //   /// ✅ Cancel Order
// //   Future<void> _cancelOrder(int orderId) async {
// //     log("❌ Cancelling order ID: $orderId");
// //
// //     SharedPreferences prefs = await SharedPreferences.getInstance();
// //     String? token = prefs.getString("token");
// //
// //     if (token == null || token.isEmpty) {
// //       log("❌ No token found! Cannot cancel order.");
// //       return;
// //     }
// //
// //     try {
// //       final response = await http.put(
// //         Uri.parse("http://10.0.2.2:3000/api/orders/cancel/$orderId"),
// //         headers: {"Authorization": "Bearer $token"},
// //       );
// //
// //       log("❌ Order Cancel Response Status: ${response.statusCode}");
// //       log("❌ Order Cancel Response Body: ${response.body}");
// //
// //       if (response.statusCode == 200) {
// //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("✅ Order canceled successfully!")));
// //         _fetchOrders();
// //       } else {
// //         log("❌ Error canceling order: ${response.body}");
// //       }
// //     } catch (e) {
// //       log("❌ Exception canceling order: $e");
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: Text("Your Orders")),
// //       body: isLoading
// //           ? Center(child: CircularProgressIndicator())
// //           : orders.isEmpty
// //           ? Center(child: Text("No orders found."))
// //           : ListView.builder(
// //         itemCount: orders.length,
// //         itemBuilder: (context, index) {
// //           final order = orders[index];
// //           return Card(
// //             margin: EdgeInsets.all(8.0),
// //             child: ListTile(
// //               title: Text("Order #${order["id"]}"),
// //               subtitle: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Text("Product ID: ${order["product_id"]}"),
// //                   Text("Quantity: ${order["quantity"]}"),
// //                   Text("Total Price: ₹${order["total_price"]}"),
// //                   Text("Status: ${order["order_status"]}", style: TextStyle(fontWeight: FontWeight.bold)),
// //                   Text("Farmer Address: ${order["farmer_address"]}"),
// //                 ],
// //               ),
// //               trailing: order["order_status"] == "Pending"
// //                   ? TextButton(
// //                 onPressed: () => _cancelOrder(order["id"]),
// //                 child: Text("Cancel", style: TextStyle(color: Colors.red)),
// //               )
// //                   : null,
// //             ),
// //           );
// //         },
// //       ),
// //     );
// //   }
// // }
