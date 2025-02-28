import 'dart:convert';
import 'dart:developer';
import 'package:farmercustomer98/screens/customer/dummy_payments_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'customer_home_screen.dart';
import 'customer_order_screen.dart';



class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<dynamic> cartItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCart();
  }

  /// ✅ Fetch Cart Items
  Future<void> _fetchCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    if (token == null || token.isEmpty) {
      log("❌ No token found! User might not be authenticated.");
      return;
    }

    log("🛒 Fetching cart items with token: $token");

    try {
      final response = await http.get(
        Uri.parse("http://10.0.2.2:3000/api/cart"),
        headers: {"Authorization": "Bearer $token"},
      );

      log("🔍 Request URL: http://10.0.2.2:3000/api/cart");
      log("🔍 Response Status: ${response.statusCode}");
      log("🔍 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        setState(() {
          cartItems = jsonDecode(response.body)["cart"];
          isLoading = false;
        });
      } else {
        log("❌ Error fetching cart: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      log("❌ Exception fetching cart: $e");
    }
  }

  /// ✅ Add Product to Cart
  Future<void> _addToCart(int productId) async {
    log("🛍 Adding product ID: $productId to cart");

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    if (token == null || token.isEmpty) {
      log("❌ No token found! Cannot add product to cart.");
      return;
    }

    try {
      final response = await http.post(
        Uri.parse("http://10.0.2.2:3000/api/cart/add"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
        body: jsonEncode({"product_id": productId, "quantity": 1}),
      );

      log("🛍 Cart Add Response Status: ${response.statusCode}");
      log("🛍 Cart Add Response Body: ${response.body}");

      if (response.statusCode == 200) {
        _fetchCart();
      } else {
        log("❌ Error adding to cart: ${response.body}");
      }
    } catch (e) {
      log("❌ Exception adding to cart: $e");
    }
  }

  /// ✅ Remove Product from Cart (Decrement or Delete)
  Future<void> _removeFromCart(int productId, int currentQuantity) async {
    log("🗑 Removing product ID: $productId from cart");

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    if (token == null || token.isEmpty) {
      log("❌ No token found! Cannot remove product from cart.");
      return;
    }

    try {
      final response = await http.delete(
        Uri.parse("http://10.0.2.2:3000/api/cart/remove/$productId"),
        headers: {"Authorization": "Bearer $token"},
      );

      log("🗑 Cart Remove Response Status: ${response.statusCode}");
      log("🗑 Cart Remove Response Body: ${response.body}");

      if (response.statusCode == 200) {
        if (currentQuantity == 1) {
          // If last item is removed, remove from list
          setState(() {
            cartItems.removeWhere((item) => item["product_id"] == productId);
          });
        } else {
          _fetchCart(); // Refresh list for decrementing
        }
      } else {
        log("❌ Error removing from cart: ${response.body}");
      }
    } catch (e) {
      log("❌ Exception removing from cart: $e");
    }
  }

  /// ✅ Calculate Total Cart Price
  double _calculateTotalPrice() {
    double total = 0;
    for (var item in cartItems) {
      total += double.parse(item["subtotal"]);
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(Icons.history),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => CustomerOrderScreen()));
              },
            ),
          ],
          title: Text("Cart")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : cartItems.isEmpty
          ? Center(child: Text("Your cart is empty."))
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final product = cartItems[index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(product["name"]),
                    subtitle: Text("Price: ₹${product["price"]}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: () {
                            if (product["quantity"] > 1) {
                              _removeFromCart(product["product_id"], product["quantity"]);
                            } else {
                              _removeFromCart(product["product_id"], 0);
                            }
                          },
                        ),
                        Text("${product["quantity"]}"),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () => _addToCart(product["product_id"]),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Total: ₹${_calculateTotalPrice().toStringAsFixed(2)}",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ElevatedButton(
                  onPressed: _checkout,



                  child: Text("Checkout"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  // void _checkout() async {
  //   bool paymentSuccess = await Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (_) => DummyPaymentScreen(total: _calculateTotalPrice())),
  //   );
  //
  //   if (paymentSuccess) {
  //     _placeOrder();
  //   }
  // }
  // /// ✅ **Place Order API Call**
  // Future<void> _placeOrder() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? token = prefs.getString("token");
  //
  //   if (token == null || token.isEmpty) {
  //     log("❌ No token found! Cannot place order.");
  //     return;
  //   }
  //
  //   log("🛍 Placing order...");
  //
  //   try {
  //     final response = await http.post(
  //       Uri.parse("http://10.0.2.2:3000/api/orders/place"),
  //       headers: {
  //         "Authorization": "Bearer $token",
  //         "Content-Type": "application/json"
  //       },
  //       body: jsonEncode({}),
  //     );
  //
  //     log("🛍 Order Placement Response Status: ${response.statusCode}");
  //     log("🛍 Order Placement Response Body: ${response.body}");
  //
  //     if (response.statusCode == 201) {
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("✅ Order Placed Successfully!")));
  //       Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => CustomerHomeScreen()));
  //     } else {
  //       log("❌ Error placing order: ${response.body}");
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("❌ Order placement failed")));
  //     }
  //   } catch (e) {
  //     log("❌ Exception placing order: $e");
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("❌ Order placement error")));
  //   }
  // }

  void _checkout() async {
    // Prevent multiple taps
    if (isLoading) return;

    bool? paymentSuccess = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DummyPaymentScreen(total: _calculateTotalPrice())),
    );

    if (paymentSuccess == true) {
      _placeOrder();
    }
  }

  /// ✅ **Place Order API Call (Ensures single call)**
  Future<void> _placeOrder() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    if (token == null || token.isEmpty) {
      log("❌ No token found! Cannot place order.");
      return;
    }

    // ✅ Prevent duplicate orders
    if (isLoading) return;

    setState(() {
      isLoading = true; // Lock UI to prevent duplicate calls
    });

    log("🛍 Placing order...");

    try {
      final response = await http.post(
        Uri.parse("http://10.0.2.2:3000/api/orders/place"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
        body: jsonEncode({}),
      );

      log("🛍 Order Placement Response Status: ${response.statusCode}");
      log("🛍 Order Placement Response Body: ${response.body}");

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("✅ Order Placed Successfully!")));

        // ✅ Navigate to Order Screen after success
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => CustomerHomeScreen()));
      } else {
        log("❌ Error placing order: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("❌ Order placement failed")));
      }
    } catch (e) {
      log("❌ Exception placing order: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("❌ Order placement error")));
    } finally {
      setState(() {
        isLoading = false; // Unlock UI
      });
    }
  }

}



// import 'dart:convert';
// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
//
// class CartScreen extends StatefulWidget {
//   @override
//   _CartScreenState createState() => _CartScreenState();
// }
//
// class _CartScreenState extends State<CartScreen> {
//   List<dynamic> products = [];
//   bool isLoading = true;
//   double totalAmount = 0.0;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchCartItems();
//   }
//
//   /// ✅ **Fetch Cart Products**
//   Future<void> _fetchCartItems() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? token = prefs.getString("token");
//
//     if (token == null || token.isEmpty) {
//       log("❌ No token found! User might not be authenticated.");
//       return;
//     }
//
//     log("🛒 Fetching cart items with token: $token");
//
//     try {
//       final response = await http.get(
//         Uri.parse("http://10.0.2.2:3000/api/cart"),
//         headers: {"Authorization": "Bearer $token"},
//       );
//
//       log("🔍 Request URL: http://10.0.2.2:3000/api/cart");
//       log("🔍 Response Status: ${response.statusCode}");
//       log("🔍 Response Body: ${response.body}");
//
//       if (response.statusCode == 200) {
//         List<dynamic> cartData = jsonDecode(response.body)["cart"];
//         double total = cartData.fold(0.0, (sum, item) => sum + (double.parse(item["subtotal"])));
//
//         setState(() {
//           products = cartData;
//           totalAmount = total;
//           isLoading = false;
//         });
//       } else {
//         log("❌ Error fetching cart items: ${response.statusCode} - ${response.body}");
//       }
//     } catch (e) {
//       log("❌ Exception fetching cart items: $e");
//     }
//   }
//
//   /// ✅ **Update Cart - Add/Remove Product**
//   Future<void> _updateCart(int productId, int newQuantity) async {
//     log("Updating cart for product ID: $productId with quantity: $newQuantity");
//
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? token = prefs.getString("token");
//
//     if (token == null || token.isEmpty) {
//       log("❌ No token found! Cannot update cart.");
//       return;
//     }
//
//     if (newQuantity > 0) {
//       // ✅ If quantity > 0, update the cart
//       try {
//         final response = await http.post(
//           Uri.parse("http://10.0.2.2:3000/api/cart/add"),
//           headers: {
//             "Authorization": "Bearer $token",
//             "Content-Type": "application/json"
//           },
//           body: jsonEncode({"product_id": productId, "quantity": 1}),
//         );
//
//         log("🛍 Cart Update Response Status: ${response.statusCode}");
//         log("🛍 Cart Update Response Body: ${response.body}");
//
//         if (response.statusCode == 200) {
//           _fetchCartItems(); // Refresh cart items
//         } else {
//           log("❌ Error updating cart: ${response.body}");
//         }
//       } catch (e) {
//         log("❌ Exception updating cart: $e");
//       }
//     } else {
//       // ✅ If quantity is 0, remove the product
//       _removeFromCart(productId);
//     }
//   }
//
//   /// ✅ **Remove Item from Cart**
//   Future<void> _removeFromCart(int productId) async {
//     log("🗑 Removing product ID: $productId from cart");
//
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? token = prefs.getString("token");
//
//     if (token == null || token.isEmpty) {
//       log("❌ No token found! Cannot remove product from cart.");
//       return;
//     }
//
//     try {
//       final response = await http.delete(
//         Uri.parse("http://10.0.2.2:3000/api/cart/remove/$productId"),
//         headers: {"Authorization": "Bearer $token"},
//       );
//
//       log("🗑 Cart Remove Response Status: ${response.statusCode}");
//       log("🗑 Cart Remove Response Body: ${response.body}");
//
//       if (response.statusCode == 200) {
//         setState(() {
//           products.removeWhere((p) => p["product_id"] == productId);
//           totalAmount = products.fold(0.0, (sum, item) => sum + (double.parse(item["subtotal"])));
//         });
//
//         if (products.isEmpty) {
//           log("🛒 Cart is now empty!");
//         }
//       } else {
//         log("❌ Error removing from cart: ${response.body}");
//       }
//     } catch (e) {
//       log("❌ Exception removing from cart: $e");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Cart")),
//       body: isLoading
//           ? Center(child: CircularProgressIndicator())
//           : products.isEmpty
//           ? Center(child: Text("🛒 Your cart is empty!"))
//           : Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               itemCount: products.length,
//               itemBuilder: (context, index) {
//                 final product = products[index];
//                 return Card(
//                   margin: EdgeInsets.all(8.0),
//                   child: ListTile(
//                     title: Text(product["name"]),
//                     subtitle: Text("Price: ₹${product["price"]} | Subtotal: ₹${product["subtotal"]}"),
//                     trailing: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         IconButton(
//                           icon: Icon(Icons.remove),
//                           onPressed: () {
//                             if (product["quantity"] > 1) {
//                               _updateCart(product["product_id"], product["quantity"] - 1);
//                             } else {
//                               _removeFromCart(product["product_id"]);
//                             }
//                           },
//                         ),
//                         Text("${product["quantity"]}"),
//                         IconButton(
//                           icon: Icon(Icons.add),
//                           onPressed: () => _updateCart(product["product_id"], product["quantity"] + 1),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 Text("Total Amount: ₹$totalAmount", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                 SizedBox(height: 10),
//                 ElevatedButton(
//                   onPressed: () => log("🚀 Checkout clicked!"),
//                   child: Text("Checkout"),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
//
//
//
// // import 'dart:convert';
// // import 'dart:developer';
// // import 'package:flutter/material.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:shared_preferences/shared_preferences.dart';
// //
// // class CartScreen extends StatefulWidget {
// //   @override
// //   _CartScreenState createState() => _CartScreenState();
// // }
// //
// // class _CartScreenState extends State<CartScreen> {
// //   List<dynamic> cartItems = [];
// //   bool isLoading = true;
// //   double totalPrice = 0.0;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _fetchCart();
// //   }
// //
// //   /// ✅ **Fetch Cart Items**
// //   Future<void> _fetchCart() async {
// //     SharedPreferences prefs = await SharedPreferences.getInstance();
// //     String? token = prefs.getString("token");
// //
// //     if (token == null || token.isEmpty) {
// //       log("❌ No token found! User might not be authenticated.");
// //       return;
// //     }
// //
// //     log("🛒 Fetching cart with token: $token");
// //
// //     try {
// //       final response = await http.get(
// //         Uri.parse("http://10.0.2.2:3000/api/cart"),
// //         headers: {"Authorization": "Bearer $token"},
// //       );
// //
// //       log("🔍 Cart Request URL: http://10.0.2.2:3000/api/cart");
// //       log("🔍 Response Status: ${response.statusCode}");
// //       log("🔍 Response Body: ${response.body}");
// //
// //       if (response.statusCode == 200) {
// //         setState(() {
// //           cartItems = jsonDecode(response.body)["cart"];
// //           _calculateTotal();
// //           isLoading = false;
// //         });
// //       } else {
// //         log("❌ Error fetching cart: ${response.statusCode} - ${response.body}");
// //       }
// //     } catch (e) {
// //       log("❌ Exception fetching cart: $e");
// //     }
// //   }
// //
// //   /// ✅ **Calculate Total Price**
// //   void _calculateTotal() {
// //     totalPrice = cartItems.fold(0.0, (sum, item) {
// //       return sum + (double.parse(item["price"]) * item["quantity"]);
// //     });
// //   }
// //
// //   /// ✅ **Increase Cart Item Quantity**
// //   Future<void> _addToCart(int productId) async {
// //     SharedPreferences prefs = await SharedPreferences.getInstance();
// //     String? token = prefs.getString("token");
// //
// //     if (token == null || token.isEmpty) {
// //       log("❌ No token found! Cannot add product to cart.");
// //       return;
// //     }
// //
// //     log("🛍 Increasing quantity for product ID: $productId");
// //
// //     try {
// //       final response = await http.post(
// //         Uri.parse("http://10.0.2.2:3000/api/cart/add"),
// //         headers: {
// //           "Authorization": "Bearer $token",
// //           "Content-Type": "application/json"
// //         },
// //         body: jsonEncode({"product_id": productId, "quantity": 1}),
// //       );
// //
// //       log("🛍 Cart Add Response Status: ${response.statusCode}");
// //       log("🛍 Cart Add Response Body: ${response.body}");
// //
// //       if (response.statusCode == 200) {
// //         _fetchCart(); // Refresh cart
// //       } else {
// //         log("❌ Error adding to cart: ${response.body}");
// //       }
// //     } catch (e) {
// //       log("❌ Exception adding to cart: $e");
// //     }
// //   }
// //
// //   /// ✅ **Decrease Cart Item Quantity**
// //   Future<void> _removeFromCart(int cartId) async {
// //     SharedPreferences prefs = await SharedPreferences.getInstance();
// //     String? token = prefs.getString("token");
// //
// //     if (token == null || token.isEmpty) {
// //       log("❌ No token found! Cannot remove product from cart.");
// //       return;
// //     }
// //
// //     log("🗑 Removing product from cart ID: $cartId");
// //
// //     try {
// //       final response = await http.delete(
// //         Uri.parse("http://10.0.2.2:3000/api/cart/remove/$cartId"),
// //         headers: {"Authorization": "Bearer $token"},
// //       );
// //
// //       log("🗑 Cart Remove Response Status: ${response.statusCode}");
// //       log("🗑 Cart Remove Response Body: ${response.body}");
// //
// //       if (response.statusCode == 200) {
// //         _fetchCart(); // Refresh cart
// //       } else {
// //         log("❌ Error removing from cart: ${response.body}");
// //       }
// //     } catch (e) {
// //       log("❌ Exception removing from cart: $e");
// //     }
// //   }
// //
// //   /// ✅ **Checkout Function (For Now, Just Logs a Message)**
// //   void _checkout() {
// //     log("✅ Checkout clicked! (Implement payment gateway here)");
// //     ScaffoldMessenger.of(context).showSnackBar(
// //       SnackBar(content: Text("🚀 Checkout functionality to be implemented!")),
// //     );
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: Text("Cart")),
// //       body: isLoading
// //           ? Center(child: CircularProgressIndicator())
// //           : cartItems.isEmpty
// //           ? Center(child: Text("🛒 Your cart is empty!"))
// //           : Column(
// //         children: [
// //           Expanded(
// //             child: ListView.builder(
// //               itemCount: cartItems.length,
// //               itemBuilder: (context, index) {
// //                 final item = cartItems[index];
// //                 return Card(
// //                   margin: EdgeInsets.all(8.0),
// //                   child: ListTile(
// //                     title: Text(item["name"]),
// //                     subtitle: Text("Price: ₹${item["price"]}"),
// //                     trailing: Row(
// //                       mainAxisSize: MainAxisSize.min,
// //                       children: [
// //                         IconButton(
// //                           icon: Icon(Icons.remove),
// //                           onPressed: () {
// //                             if (item["quantity"] > 1) {
// //                               _removeFromCart(item["product_id"]);
// //                             }
// //                           },
// //                         ),
// //                         Text("${item["quantity"]}"),
// //                         IconButton(
// //                           icon: Icon(Icons.add),
// //                           onPressed: () => _addToCart(item["product_id"]),
// //                         ),
// //                         SizedBox(width: 10),
// //                         Text("₹${(double.parse(item["price"]) * item["quantity"]).toStringAsFixed(2)}"),
// //                       ],
// //                     ),
// //                   ),
// //                 );
// //               },
// //             ),
// //           ),
// //           Divider(),
// //           Padding(
// //             padding: EdgeInsets.all(16.0),
// //             child: Row(
// //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //               children: [
// //                 Text("Total: ₹${totalPrice.toStringAsFixed(2)}",
// //                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
// //                 ElevatedButton(
// //                   onPressed: _checkout,
// //                   child: Text("Checkout"),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
