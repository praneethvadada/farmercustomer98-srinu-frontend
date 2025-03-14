import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SearchProductsScreen extends StatefulWidget {
  @override
  _SearchProductsScreenState createState() => _SearchProductsScreenState();
}

class _SearchProductsScreenState extends State<SearchProductsScreen> {
  List<dynamic> allProducts = [];
  List<dynamic> filteredProducts = [];
  bool isLoading = true;
  String searchQuery = "";
  String selectedSort = "Name"; // Default sorting option

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }


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

      log("🔍 Response Status: ${response.statusCode}");
      log("🔍 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        List<dynamic> allFetchedProducts = jsonDecode(response.body)["products"];

        setState(() {
          allProducts = allFetchedProducts;
          // ✅ Initially show only first 5 products
          filteredProducts = allProducts.take(5).toList();
          isLoading = false;
        });
      } else {
        log("❌ Error fetching products: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      log("❌ Exception fetching products: $e");
    }
  }


  void _searchProducts(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      if (searchQuery.isEmpty) {
        // ✅ Show only 5 products when search is empty
        filteredProducts = allProducts.take(5).toList();
      } else {
        // ✅ Show all matching products when searching
        filteredProducts = allProducts.where((product) {
          final name = product["name"].toLowerCase();
          final description = product["description"].toLowerCase();
          final category = product["category"].toLowerCase();
          final price = product["price"].toString();

          return name.contains(searchQuery) ||
              description.contains(searchQuery) ||
              category.contains(searchQuery) ||
              price.contains(searchQuery);
        }).toList();
      }
      _sortProducts();
    });
  }


  /// ✅ Sort Products Based on Selection
  void _sortProducts() {
    setState(() {
      if (selectedSort == "Price (Low to High)") {
        filteredProducts.sort((a, b) => double.parse(a["price"]).compareTo(double.parse(b["price"])));
      } else if (selectedSort == "Price (High to Low)") {
        filteredProducts.sort((a, b) => double.parse(b["price"]).compareTo(double.parse(a["price"])));
      } else if (selectedSort == "Category") {
        filteredProducts.sort((a, b) => a["category"].compareTo(b["category"]));
      } else {
        filteredProducts.sort((a, b) => a["name"].compareTo(b["name"]));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search Products"),
        actions: [
          // Dropdown for sorting options
          DropdownButton<String>(
            value: selectedSort,
            onChanged: (value) {
              setState(() {
                selectedSort = value!;
                _sortProducts();
              });
            },
            items: ["Name", "Price (Low to High)", "Price (High to Low)", "Category"]
                .map((sortOption) => DropdownMenuItem(value: sortOption, child: Text(sortOption)))
                .toList(),
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          // Search Bar
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: "Search Products",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _searchProducts,
            ),
          ),
          Expanded(
            child: filteredProducts.isEmpty
                ? Center(child: Text("No products found"))
                : ListView.builder(
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    title: _highlightText(product["name"], searchQuery),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _highlightText("₹${product["price"]}", searchQuery),
                        _highlightText("Category: ${product["category"]}", searchQuery),
                      ],
                    ),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Navigate to Product Details
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductDetailsScreen(product: product),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// ✅ Highlight Matching Search Query in Text
  Widget _highlightText(String text, String query) {
    if (query.isEmpty) return Text(text);
    final queryIndex = text.toLowerCase().indexOf(query);
    if (queryIndex == -1) return Text(text);

    return RichText(
      text: TextSpan(
        style: TextStyle(color: Colors.black),
        children: [
          TextSpan(text: text.substring(0, queryIndex)),
          TextSpan(
            text: text.substring(queryIndex, queryIndex + query.length),
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
          ),
          TextSpan(text: text.substring(queryIndex + query.length)),
        ],
      ),
    );
  }
}

class ProductDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  ProductDetailsScreen({required this.product});

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int cartQuantity = 0;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    cartQuantity = widget.product["cart_quantity"] ?? 0;
  }

  /// ✅ **Add Product to Cart**
  Future<void> _addToCart(int productId) async {
    log("🛍 Adding product ID: $productId to cart");

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    if (token == null || token.isEmpty) {
      log("❌ No token found! Cannot add product to cart.");
      return;
    }

    try {
      setState(() => isLoading = true);

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
          cartQuantity += 1;
        });
      } else {
        log("❌ Error adding to cart: ${response.body}");
      }
    } catch (e) {
      log("❌ Exception adding to cart: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  /// ✅ **Remove Product from Cart**
  Future<void> _removeFromCart(int productId) async {
    log("🗑 Removing product ID: $productId from cart");

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    if (token == null || token.isEmpty) {
      log("❌ No token found! Cannot remove product from cart.");
      return;
    }

    try {
      setState(() => isLoading = true);

      final response = await http.delete(
        Uri.parse("http://10.0.2.2:3000/api/cart/remove/$productId"),
        headers: {"Authorization": "Bearer $token"},
      );

      log("🗑 Cart Remove Response Status: ${response.statusCode}");
      log("🗑 Cart Remove Response Body: ${response.body}");

      if (response.statusCode == 200) {
        setState(() {
          if (cartQuantity > 1) {
            cartQuantity -= 1;
          } else {
            cartQuantity = 0;
          }
        });
      } else if (response.statusCode == 404) {
        log("❌ Product not found in cart. Ensure it's added first.");
      } else {
        log("❌ Error removing from cart: ${response.body}");
      }
    } catch (e) {
      log("❌ Exception removing from cart: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      appBar: AppBar(title: Text(product["name"])),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Name
            Text(product["name"], style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),

            SizedBox(height: 10),

            // Price
            Text("Price: ₹${product["price"]}", style: TextStyle(fontSize: 18, color: Colors.green)),

            SizedBox(height: 10),

            // Description
            Text("Description:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(product["description"], style: TextStyle(fontSize: 16)),

            SizedBox(height: 10),

            // Available Quantity
            Text("Available Quantity: ${product["available_quantity"]}",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),

            SizedBox(height: 20),

            // Cart Controls (Add, Remove, Increment, Decrement)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: cartQuantity > 0 ? () => _removeFromCart(product["id"]) : null,
                ),
                Text("$cartQuantity", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () => _addToCart(product["id"]),
                ),
              ],
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
