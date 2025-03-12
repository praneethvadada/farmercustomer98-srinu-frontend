import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProductService {
  static const String baseUrl = "http://10.0.2.2:3000/api/products";

  /// ✅ Fetch Products of Logged-in Farmer
  static Future<List<dynamic>> fetchFarmerProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    final response = await http.get(
      Uri.parse("$baseUrl/my-products"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)["products"];
    } else {
      throw Exception("Failed to fetch products");
    }
  }

  /// ✅ Add a Product
  static Future<bool> addProduct(Map<String, dynamic> productData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    final response = await http.post(
      Uri.parse("$baseUrl/add"),
      headers: {"Content-Type": "application/json", "Authorization": "Bearer $token"},
      body: jsonEncode(productData),
    );

    return response.statusCode == 200;
  }

  /// ✅ Get Product by ID
  static Future<Map<String, dynamic>> getProductById(int productId) async {
    final response = await http.get(Uri.parse("$baseUrl/$productId"));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to fetch product details");
    }
  }

  /// ✅ Update a Product
  static Future<bool> updateProduct(int productId, Map<String, dynamic> updatedData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    final response = await http.put(
      Uri.parse("$baseUrl/update/$productId"),
      headers: {"Content-Type": "application/json", "Authorization": "Bearer $token"},
      body: jsonEncode(updatedData),
    );

    return response.statusCode == 200;
  }

  /// ✅ Delete a Product
  static Future<bool> deleteProduct(int productId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    final response = await http.delete(
      Uri.parse("$baseUrl/delete/$productId"),
      headers: {"Authorization": "Bearer $token"},
    );

    return response.statusCode == 200;
  }
}
