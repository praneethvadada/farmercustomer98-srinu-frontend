import 'dart:convert';
import 'dart:developer';
import 'package:farmercustomer98/screens/customer/search_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CustomerProductsScreen extends StatefulWidget {
  @override
  _CustomerProductsScreenState createState() => _CustomerProductsScreenState();
}

class _CustomerProductsScreenState extends State<CustomerProductsScreen> {
  List<dynamic> products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  /// ✅ **Fetch Products from API**
  Future<void> _fetchProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    if (token == null || token.isEmpty) {
      log("❌ No token found! User might not be authenticated.");
      return;
    }

    log("🟢 Fetching products with token: $token");

    try {
      final response = await http.get(
        Uri.parse("http://10.0.2.2:3000/api/products/all"),
        headers: {"Authorization": "Bearer $token"},
      );

      log("🔍 Request URL: http://10.0.2.2:3000/api/products/all");
      log("🔍 Response Status: ${response.statusCode}");
      log("🔍 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        setState(() {
          products = jsonDecode(response.body)["products"];
          isLoading = false;
        });
      } else {
        log("❌ Error fetching products: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      log("❌ Exception fetching products: $e");
    }
  }

  /// ✅ **Add Product to Cart**
  Future<void> _addToCart(int productId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    if (token == null || token.isEmpty) {
      log("❌ No token found! Cannot add product to cart.");
      return;
    }

    log("🛒 Adding product ID: $productId to cart");

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
        setState(() {
          _updateProductCartQuantity(productId, 1);
        });
      } else {
        log("❌ Error adding to cart: ${response.body}");
      }
    } catch (e) {
      log("❌ Exception adding to cart: $e");
    }
  }

  /// ✅ **Remove Product from Cart (Fix for 404 issue)**
  Future<void> _removeFromCart(int productId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    if (token == null || token.isEmpty) {
      log("❌ No token found! Cannot remove product from cart.");
      return;
    }

    log("🗑 Removing product ID: $productId from cart");

    try {
      final response = await http.delete(
        Uri.parse("http://10.0.2.2:3000/api/cart/remove/$productId"),
        headers: {"Authorization": "Bearer $token"},
      );

      log("🗑 Cart Remove Response Status: ${response.statusCode}");
      log("🗑 Cart Remove Response Body: ${response.body}");

      if (response.statusCode == 200) {
        setState(() {
          _updateProductCartQuantity(productId, -1);
        });
      } else if (response.statusCode == 404) {
        log("❌ Product not found in cart. Ensure it's added first.");
      } else {
        log("❌ Error removing from cart: ${response.body}");
      }
    } catch (e) {
      log("❌ Exception removing from cart: $e");
    }
  }

  /// ✅ **Update Cart Quantity Locally**
  void _updateProductCartQuantity(int productId, int change) {
    for (var product in products) {
      if (product["id"] == productId) {
        int currentQuantity = product["cart_quantity"];
        product["cart_quantity"] = (currentQuantity + change).clamp(0, 999);
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
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
                      if (product["cart_quantity"] > 0) {
                        _removeFromCart(product["id"]);
                      } else {
                        log("⚠️ Cannot decrement below 0");
                      }
                    },
                  ),
                  Text("${product["cart_quantity"]}"),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () => _addToCart(product["id"]),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}


