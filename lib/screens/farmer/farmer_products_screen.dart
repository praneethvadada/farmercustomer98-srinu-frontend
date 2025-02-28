import 'dart:convert';
import 'dart:io';
import 'package:farmercustomer98/screens/farmer/farmer_orders_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductsScreen extends StatefulWidget {
  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  List<dynamic> products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  /// ✅ Fetch Products from API
  Future<void> _fetchProducts() async {
    print("Fetching products...");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    try {
      final response = await http.get(
        Uri.parse("http://10.0.2.2:3000/api/products/my-products"),
        headers: {"Authorization": "Bearer $token"},
      );

      print("Fetch response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        setState(() {
          products = jsonDecode(response.body)["products"];
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching products: $e");
    }
  }

  /// ✅ Show Product Add/Edit Dialog
  // void _showProductDialog({Map<String, dynamic>? product}) {
  //   print(product == null ? "Adding new product" : "Editing product: ${product['id']}");
  //
  //   final nameController = TextEditingController(text: product?["name"] ?? "");
  //   final descController = TextEditingController(text: product?["description"] ?? "");
  //   final priceController = TextEditingController(text: product?["price"]?.toString() ?? "");
  //   final quantityController = TextEditingController(text: product?["quantity"] ?? "");
  //   final availableQtyController = TextEditingController(text: product?["available_quantity"]?.toString() ?? "");
  //   final categoryController = TextEditingController(text: product?["category"] ?? "");
  //   final cropStageController = TextEditingController(text: product?["crop_stage"] ?? "");
  //   final availabilityController = TextEditingController(text: product?["availability"] ?? "in stock");
  //   File? imageFile;
  //
  //   Future<void> _pickImage() async {
  //     print("Picking image...");
  //     final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
  //     if (pickedFile != null) {
  //       setState(() {
  //         imageFile = File(pickedFile.path);
  //       });
  //       print("Image selected: ${pickedFile.path}");
  //     }
  //   }
  //
  //   Future<void> _saveProduct() async {
  //     print("🟢 Saving product...");
  //
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     String? token = prefs.getString("token");
  //
  //     final uri = Uri.parse("http://10.0.2.2:3000/api/products/add");
  //
  //     var request = http.MultipartRequest("POST", uri);
  //     request.headers["Authorization"] = "Bearer $token";
  //     request.headers["Content-Type"] = "multipart/form-data";
  //
  //     request.fields["name"] = nameController.text.trim();
  //     request.fields["description"] = descController.text.trim();
  //     request.fields["price"] = priceController.text.trim();
  //     request.fields["quantity"] = quantityController.text.trim();
  //     request.fields["available_quantity"] = availableQtyController.text.trim();
  //     request.fields["category"] = categoryController.text.trim();
  //     request.fields["crop_stage"] = cropStageController.text.trim();
  //     request.fields["availability"] = availabilityController.text.trim();
  //
  //     if (imageFile != null) {
  //       // request.files.add(await http.MultipartFile.fromPath("image", imageFile!.path));
  //       // request.files.add(await http.MultipartFile.fromPath("image", imageFile!.path));
  //       //    request.files.add(await http.MultipartFile.fromPath("image", imageFile!.path));
  //       request.files.add(await http.MultipartFile.fromPath("image_file", imageFile!.path));
  //
  //     }
  //
  //     print("🔍 Sending Request with Fields:");
  //     request.fields.forEach((key, value) {
  //       print("  - $key: $value");
  //     });
  //
  //     if (imageFile != null) {
  //       print("  - Image: ${imageFile!.path}");
  //     } else {
  //       print("  - No image selected");
  //     }
  //
  //     try {
  //       final response = await request.send();
  //       final responseBody = await response.stream.bytesToString();
  //
  //       print("🟢 Response Status: ${response.statusCode}");
  //       print("🟢 Response Body: $responseBody");
  //
  //       if (response.statusCode == 201 || response.statusCode == 200) {
  //         Navigator.pop(context);
  //         _fetchProducts();
  //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("✅ Product saved successfully.")));
  //       } else {
  //         print("❌ Error: $responseBody");
  //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("❌ Error: $responseBody")));
  //       }
  //     } catch (e) {
  //       print("❌ Exception while saving product: $e");
  //     }
  //   }
  //
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: Text(product == null ? "Add Product" : "Edit Product"),
  //         content: SingleChildScrollView(
  //           child: Column(
  //             children: [
  //               TextField(controller: nameController, decoration: InputDecoration(labelText: "Product Name")),
  //               TextField(controller: descController, decoration: InputDecoration(labelText: "Description")),
  //               TextField(controller: priceController, decoration: InputDecoration(labelText: "Price"), keyboardType: TextInputType.number),
  //               TextField(controller: quantityController, decoration: InputDecoration(labelText: "Quantity")),
  //               TextField(controller: availableQtyController, decoration: InputDecoration(labelText: "Available Quantity"), keyboardType: TextInputType.number),
  //               TextField(controller: categoryController, decoration: InputDecoration(labelText: "Category")),
  //               TextField(controller: cropStageController, decoration: InputDecoration(labelText: "Crop Stage")),
  //               TextField(controller: availabilityController, decoration: InputDecoration(labelText: "Availability")),
  //               SizedBox(height: 10),
  //               imageFile == null ? Text("No Image Selected") : Image.file(imageFile!, height: 100),
  //               ElevatedButton(onPressed: _pickImage, child: Text("Pick Image")),
  //             ],
  //           ),
  //         ),
  //         actions: [
  //           ElevatedButton(onPressed: _saveProduct, child: Text("Save")),
  //           TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
  //         ],
  //       );
  //     },
  //   );
  // }

  void _showProductDialog({Map<String, dynamic>? product}) {
    final isEditing = product != null;
    final nameController = TextEditingController(text: product?['name'] ?? '');
    final descController = TextEditingController(text: product?['description'] ?? '');
    final priceController = TextEditingController(text: product?['price']?.toString() ?? '');
    final quantityController = TextEditingController(text: product?['quantity'] ?? '');
    final availableQtyController = TextEditingController(text: product?['available_quantity']?.toString() ?? '');
    final categoryController = TextEditingController(text: product?['category'] ?? '');
    final cropStageController = TextEditingController(text: product?['crop_stage'] ?? '');
    final availabilityController = TextEditingController(text: product?['availability'] ?? 'in stock');
    File? imageFile;

    Future<void> _pickImage() async {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          imageFile = File(pickedFile.path);
        });
      }
    }

    Future<void> _saveProduct() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");

      final uri = isEditing
          ? Uri.parse("http://10.0.2.2:3000/api/products/update/${product!['id']}")
          : Uri.parse("http://10.0.2.2:3000/api/products/add");

      var request = http.MultipartRequest(isEditing ? "PUT" : "POST", uri);
      request.headers["Authorization"] = "Bearer $token";

      request.fields["name"] = nameController.text.trim();
      request.fields["description"] = descController.text.trim();
      request.fields["price"] = priceController.text.trim();
      request.fields["quantity"] = quantityController.text.trim();
      request.fields["available_quantity"] = availableQtyController.text.trim();
      request.fields["category"] = categoryController.text.trim();
      request.fields["crop_stage"] = cropStageController.text.trim();
      request.fields["availability"] = availabilityController.text.trim();

      if (imageFile != null) {
        request.files.add(await http.MultipartFile.fromPath("image", imageFile!.path));
      }

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200 || response.statusCode == 201) {
        Navigator.pop(context);
        _fetchProducts();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Product ${isEditing ? 'updated' : 'added'} successfully.")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $responseBody")),
        );
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEditing ? "Edit Product" : "Add Product"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(controller: nameController, decoration: InputDecoration(labelText: "Product Name")),
                TextField(controller: descController, decoration: InputDecoration(labelText: "Description")),
                TextField(controller: priceController, decoration: InputDecoration(labelText: "Price"), keyboardType: TextInputType.number),
                TextField(controller: quantityController, decoration: InputDecoration(labelText: "Quantity")),
                TextField(controller: availableQtyController, decoration: InputDecoration(labelText: "Available Quantity"), keyboardType: TextInputType.number),
                TextField(controller: categoryController, decoration: InputDecoration(labelText: "Category")),
                TextField(controller: cropStageController, decoration: InputDecoration(labelText: "Crop Stage")),
                TextField(controller: availabilityController, decoration: InputDecoration(labelText: "Availability")),
                SizedBox(height: 10),
                imageFile == null
                    ? Text("No Image Selected")
                    : Image.file(imageFile!, height: 100),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: Text("Pick Image"),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: _saveProduct,
              child: Text("Save"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  /// ✅ **Fix for the Missing build() Method**
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(Icons.history),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => FarmerOrdersScreen()));
              },
            ),
          ],

          title: Text("Manage Products")),
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
              subtitle: Text("Price: ₹${product["price"]} | Quantity: ${product["quantity"]}"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(icon: Icon(Icons.edit), onPressed: () => _showProductDialog(product: product)),
                  IconButton(icon: Icon(Icons.delete), onPressed: () => _deleteProduct(product["id"])),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showProductDialog(),
        child: Icon(Icons.add),
      ),
    );
  }

  /// ✅ **Fix for Missing _deleteProduct()**
  Future<void> _deleteProduct(int productId) async {
    print("Deleting product ID: $productId");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    try {
      final response = await http.delete(
        Uri.parse("http://10.0.2.2:3000/api/products/delete/$productId"),
        headers: {"Authorization": "Bearer $token"},
      );

      print("Delete response status: ${response.statusCode}");

      if (response.statusCode == 200) {
        _fetchProducts();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Product deleted successfully.")),
        );
      }
    } catch (e) {
      print("Error deleting product: $e");
    }
  }
}









// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class ProductsScreen extends StatefulWidget {
//   @override
//   _ProductsScreenState createState() => _ProductsScreenState();
// }
//
// class _ProductsScreenState extends State<ProductsScreen> {
//   List<dynamic> products = [];
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchProducts();
//   }
//
//   /// ✅ Fetch Products from API
//   Future<void> _fetchProducts() async {
//     print("Fetching products...");
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? token = prefs.getString("token");
//
//     try {
//       final response = await http.get(
//         Uri.parse("http://10.0.2.2:3000/api/products/my-products"),
//         headers: {"Authorization": "Bearer $token"},
//       );
//
//       print("Fetch response status: ${response.statusCode}");
//       print("Response body: ${response.body}");
//
//       if (response.statusCode == 200) {
//         setState(() {
//           products = jsonDecode(response.body)["products"];
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       print("Error fetching products: $e");
//     }
//   }
//
//   /// ✅ Delete Product
//   Future<void> _deleteProduct(int productId) async {
//     print("Deleting product ID: $productId");
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? token = prefs.getString("token");
//
//     try {
//       final response = await http.delete(
//         Uri.parse("http://10.0.2.2:3000/api/products/delete/$productId"),
//         headers: {"Authorization": "Bearer $token"},
//       );
//
//       print("Delete response status: ${response.statusCode}");
//
//       if (response.statusCode == 200) {
//         _fetchProducts();
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Product deleted successfully.")),
//         );
//       }
//     } catch (e) {
//       print("Error deleting product: $e");
//     }
//   }
//
//   /// ✅ Show Product Add/Edit Dialog
//   void _showProductDialog({Map<String, dynamic>? product}) {
//     print(product == null ? "Adding new product" : "Editing product: ${product['id']}");
//
//     final nameController = TextEditingController(text: product?["name"] ?? "");
//     final descController = TextEditingController(text: product?["description"] ?? "");
//     final priceController = TextEditingController(text: product?["price"]?.toString() ?? "");
//     final quantityController = TextEditingController(text: product?["quantity"] ?? "");
//     final availableQtyController = TextEditingController(text: product?["available_quantity"]?.toString() ?? "");
//     final categoryController = TextEditingController(text: product?["category"] ?? "");
//     final cropStageController = TextEditingController(text: product?["crop_stage"] ?? "");
//     final availabilityController = TextEditingController(text: product?["availability"] ?? "in stock");
//     File? imageFile;
//
//     Future<void> _pickImage() async {
//       print("Picking image...");
//       final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
//       if (pickedFile != null) {
//         setState(() {
//           imageFile = File(pickedFile.path);
//         });
//         print("Image selected: ${pickedFile.path}");
//       }
//     }
//
//     Future<void> _saveProduct() async {
//       print("Saving product...");
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? token = prefs.getString("token");
//
//       final uri = product == null
//           ? Uri.parse("http://10.0.2.2:3000/api/products/add")
//           : Uri.parse("http://10.0.2.2:3000/api/products/update/${product['id']}");
//
//       var request = http.MultipartRequest(product == null ? "POST" : "PUT", uri);
//       request.headers["Authorization"] = "Bearer $token";
//
//       request.fields["name"] = nameController.text;
//       request.fields["description"] = descController.text;
//       request.fields["price"] = priceController.text;
//       request.fields["quantity"] = quantityController.text;
//       request.fields["available_quantity"] = availableQtyController.text;
//       request.fields["category"] = categoryController.text;
//       request.fields["crop_stage"] = cropStageController.text;
//       request.fields["availability"] = availabilityController.text;
//
//       if (imageFile != null) {
//         request.files.add(await http.MultipartFile.fromPath("image", imageFile!.path));
//       }
//
//       try {
//         final response = await request.send();
//         print("Save response status: ${response.statusCode}");
//
//         if (response.statusCode == 201 || response.statusCode == 200) {
//           Navigator.pop(context);
//           _fetchProducts();
//           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Product saved successfully.")));
//         }
//       } catch (e) {
//         print("Error saving product: $e");
//       }
//     }
//
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text(product == null ? "Add Product" : "Edit Product"),
//           content: SingleChildScrollView(
//             child: Column(
//               children: [
//                 TextField(controller: nameController, decoration: InputDecoration(labelText: "Product Name")),
//                 TextField(controller: descController, decoration: InputDecoration(labelText: "Description")),
//                 TextField(controller: priceController, decoration: InputDecoration(labelText: "Price"), keyboardType: TextInputType.number),
//                 TextField(controller: quantityController, decoration: InputDecoration(labelText: "Quantity")),
//                 TextField(controller: availableQtyController, decoration: InputDecoration(labelText: "Available Quantity"), keyboardType: TextInputType.number),
//                 TextField(controller: categoryController, decoration: InputDecoration(labelText: "Category")),
//                 TextField(controller: cropStageController, decoration: InputDecoration(labelText: "Crop Stage")),
//                 TextField(controller: availabilityController, decoration: InputDecoration(labelText: "Availability")),
//                 SizedBox(height: 10),
//                 imageFile == null ? Text("No Image Selected") : Image.file(imageFile!, height: 100),
//                 ElevatedButton(onPressed: _pickImage, child: Text("Pick Image")),
//               ],
//             ),
//           ),
//           actions: [
//             ElevatedButton(onPressed: _saveProduct, child: Text("Save")),
//             TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
//           ],
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Manage Products")),
//       body: isLoading
//           ? Center(child: CircularProgressIndicator())
//           : ListView.builder(
//         itemCount: products.length,
//         itemBuilder: (context, index) {
//           final product = products[index];
//           return Card(
//             margin: EdgeInsets.all(8.0),
//             child: ListTile(
//               title: Text(product["name"]),
//               subtitle: Text("Price: ₹${product["price"]} | Quantity: ${product["quantity"]}"),
//               trailing: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   IconButton(icon: Icon(Icons.edit), onPressed: () => _showProductDialog(product: product)),
//                   IconButton(icon: Icon(Icons.delete), onPressed: () => _deleteProduct(product["id"])),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => _showProductDialog(),
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }
//
//
//
// // import 'dart:convert';
// // import 'dart:io';
// // import 'package:flutter/material.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:image_picker/image_picker.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// //
// // class ProductsScreen extends StatefulWidget {
// //   @override
// //   _ProductsScreenState createState() => _ProductsScreenState();
// // }
// //
// // class _ProductsScreenState extends State<ProductsScreen> {
// //   List<dynamic> products = [];
// //   bool isLoading = true;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _fetchProducts();
// //   }
// //
// //   /// ✅ Fetch Products from API
// //   Future<void> _fetchProducts() async {
// //     SharedPreferences prefs = await SharedPreferences.getInstance();
// //     String? token = prefs.getString("token");
// //
// //     final response = await http.get(
// //       Uri.parse("http://10.0.2.2:3000/api/products/my-products"),
// //       headers: {
// //         "Authorization": "Bearer $token",
// //       },
// //     );
// //
// //     if (response.statusCode == 200) {
// //       setState(() {
// //         products = jsonDecode(response.body)["products"];
// //         isLoading = false;
// //       });
// //     }
// //   }
// //
// //   /// ✅ Delete Product
// //   Future<void> _deleteProduct(int productId) async {
// //     SharedPreferences prefs = await SharedPreferences.getInstance();
// //     String? token = prefs.getString("token");
// //
// //     final response = await http.delete(
// //       Uri.parse("http://10.0.2.2:3000/api/products/delete/$productId"),
// //       headers: {
// //         "Authorization": "Bearer $token",
// //       },
// //     );
// //
// //     if (response.statusCode == 200) {
// //       _fetchProducts(); // Refresh list after deletion
// //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Product deleted successfully.")));
// //     }
// //   }
// //
// //   /// ✅ Show Product Add/Edit Dialog
// //   void _showProductDialog({Map<String, dynamic>? product}) {
// //     final nameController = TextEditingController(text: product?["name"] ?? "");
// //     final descController = TextEditingController(text: product?["description"] ?? "");
// //     final priceController = TextEditingController(text: product?["price"]?.toString() ?? "");
// //     final quantityController = TextEditingController(text: product?["quantity"] ?? "");
// //     final availableQtyController = TextEditingController(text: product?["available_quantity"]?.toString() ?? "");
// //     final categoryController = TextEditingController(text: product?["category"] ?? "");
// //     final cropStageController = TextEditingController(text: product?["crop_stage"] ?? "");
// //     final availabilityController = TextEditingController(text: product?["availability"] ?? "in stock");
// //     File? imageFile;
// //
// //     Future<void> _pickImage() async {
// //       final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
// //       if (pickedFile != null) {
// //         setState(() {
// //           imageFile = File(pickedFile.path);
// //         });
// //       }
// //     }
// //
// //     Future<void> _saveProduct() async {
// //       SharedPreferences prefs = await SharedPreferences.getInstance();
// //       String? token = prefs.getString("token");
// //
// //       final uri = product == null
// //           ? Uri.parse("http://10.0.2.2:3000/api/products/add")
// //           : Uri.parse("http://10.0.2.2:3000/api/products/update/${product['id']}");
// //
// //       var request = http.MultipartRequest(product == null ? "POST" : "PUT", uri);
// //       request.headers["Authorization"] = "Bearer $token";
// //
// //       request.fields["name"] = nameController.text;
// //       request.fields["description"] = descController.text;
// //       request.fields["price"] = priceController.text;
// //       request.fields["quantity"] = quantityController.text;
// //       request.fields["available_quantity"] = availableQtyController.text;
// //       request.fields["category"] = categoryController.text;
// //       request.fields["crop_stage"] = cropStageController.text;
// //       request.fields["availability"] = availabilityController.text;
// //
// //       if (imageFile != null) {
// //         request.files.add(await http.MultipartFile.fromPath("image", imageFile!.path));
// //       }
// //
// //       final response = await request.send();
// //
// //       if (response.statusCode == 201 || response.statusCode == 200) {
// //         Navigator.pop(context);
// //         _fetchProducts();
// //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Product saved successfully.")));
// //       }
// //
// //       print(  response );
// //     }
// //
// //     showDialog(
// //       context: context,
// //       builder: (context) {
// //         return AlertDialog(
// //           title: Text(product == null ? "Add Product" : "Edit Product"),
// //           content: SingleChildScrollView(
// //             child: Column(
// //               children: [
// //                 TextField(controller: nameController, decoration: InputDecoration(labelText: "Product Name")),
// //                 TextField(controller: descController, decoration: InputDecoration(labelText: "Description")),
// //                 TextField(controller: priceController, decoration: InputDecoration(labelText: "Price"), keyboardType: TextInputType.number),
// //                 TextField(controller: quantityController, decoration: InputDecoration(labelText: "Quantity")),
// //                 TextField(controller: availableQtyController, decoration: InputDecoration(labelText: "Available Quantity"), keyboardType: TextInputType.number),
// //                 TextField(controller: categoryController, decoration: InputDecoration(labelText: "Category")),
// //                 TextField(controller: cropStageController, decoration: InputDecoration(labelText: "Crop Stage")),
// //                 TextField(controller: availabilityController, decoration: InputDecoration(labelText: "Availability")),
// //
// //                 SizedBox(height: 10),
// //                 imageFile == null
// //                     ? Text("No Image Selected")
// //                     : Image.file(imageFile!, height: 100),
// //
// //                 ElevatedButton(
// //                   onPressed: _pickImage,
// //                   child: Text("Pick Image"),
// //                 ),
// //               ],
// //             ),
// //           ),
// //           actions: [
// //             ElevatedButton(
// //               onPressed: _saveProduct,
// //               child: Text("Save"),
// //             ),
// //             TextButton(
// //               onPressed: () => Navigator.pop(context),
// //               child: Text("Cancel"),
// //             ),
// //           ],
// //         );
// //       },
// //     );
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: Text("Manage Products")),
// //       body: isLoading
// //           ? Center(child: CircularProgressIndicator())
// //           : ListView.builder(
// //         itemCount: products.length,
// //         itemBuilder: (context, index) {
// //           final product = products[index];
// //           return Card(
// //             margin: EdgeInsets.all(8.0),
// //             child: ListTile(
// //               title: Text(product["name"]),
// //               subtitle: Text("Price: ₹${product["price"]} | Quantity: ${product["quantity"]}"),
// //               trailing: Row(
// //                 mainAxisSize: MainAxisSize.min,
// //                 children: [
// //                   IconButton(icon: Icon(Icons.edit), onPressed: () => _showProductDialog(product: product)),
// //                   IconButton(icon: Icon(Icons.delete), onPressed: () => _deleteProduct(product["id"])),
// //                 ],
// //               ),
// //             ),
// //           );
// //         },
// //       ),
// //       floatingActionButton: FloatingActionButton(
// //         onPressed: () => _showProductDialog(),
// //         child: Icon(Icons.add),
// //       ),
// //     );
// //   }
// // }
// //
// //
// //
// // // import 'package:flutter/material.dart';
// // // import '../../services/product_service.dart';
// // //
// // // class FarmerProductsScreen extends StatefulWidget {
// // //   @override
// // //   _FarmerProductsScreenState createState() => _FarmerProductsScreenState();
// // // }
// // //
// // // class _FarmerProductsScreenState extends State<FarmerProductsScreen> {
// // //   List<dynamic> products = [];
// // //
// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _fetchProducts();
// // //   }
// // //
// // //   /// ✅ Fetch Farmer's Products
// // //   Future<void> _fetchProducts() async {
// // //     try {
// // //       List<dynamic> fetchedProducts = await ProductService.fetchFarmerProducts();
// // //       setState(() {
// // //         products = fetchedProducts;
// // //       });
// // //     } catch (e) {
// // //       print("Error fetching products: $e");
// // //     }
// // //   }
// // //
// // //   /// ✅ Delete a Product
// // //   Future<void> _deleteProduct(int productId) async {
// // //     bool success = await ProductService.deleteProduct(productId);
// // //     if (success) {
// // //       _fetchProducts();
// // //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Product deleted successfully")));
// // //     } else {
// // //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to delete product")));
// // //     }
// // //   }
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(title: Text("My Products")),
// // //       body: products.isEmpty
// // //           ? Center(child: Text("No products added yet."))
// // //           : ListView.builder(
// // //         itemCount: products.length,
// // //         itemBuilder: (context, index) {
// // //           var product = products[index];
// // //           return Card(
// // //             margin: EdgeInsets.all(8.0),
// // //             child: ListTile(
// // //               title: Text(product["name"]),
// // //               subtitle: Text(product["description"]),
// // //               trailing: Row(
// // //                 mainAxisSize: MainAxisSize.min,
// // //                 children: [
// // //                   // IconButton(
// // //                   //   icon: Icon(Icons.edit, color: Colors.blue),
// // //                     // onPressed: () {
// // //                     //   Navigator.push(
// // //                     //     context,
// // //                     //     MaterialPageRoute(builder: (_) => ProductEditScreen(product)),
// // //                     //   ).then((_) => _fetchProducts());
// // //                     // },
// // //                   // ),
// // //                   IconButton(
// // //                     icon: Icon(Icons.delete, color: Colors.red),
// // //                     onPressed: () => _deleteProduct(product["id"]),
// // //                   ),
// // //                 ],
// // //               ),
// // //             ),
// // //           );
// // //         },
// // //       ),
// // //       floatingActionButton: FloatingActionButton(
// // //         child: Icon(Icons.add),
// // //         onPressed: () {
// // //           Navigator.push(
// // //             context,
// // //             MaterialPageRoute(builder: (_) => ProductAddScreen()),
// // //           ).then((_) => _fetchProducts());
// // //         },
// // //       ),
// // //     );
// // //   }
// // // }
// // //
// // //
// // //
// // // class ProductAddScreen extends StatefulWidget {
// // //   @override
// // //   _ProductAddScreenState createState() => _ProductAddScreenState();
// // // }
// // //
// // // class _ProductAddScreenState extends State<ProductAddScreen> {
// // //   final TextEditingController nameController = TextEditingController();
// // //   final TextEditingController descriptionController = TextEditingController();
// // //   final TextEditingController priceController = TextEditingController();
// // //   final TextEditingController quantityController = TextEditingController();
// // //   final TextEditingController availableQuantityController = TextEditingController();
// // //
// // //   Future<void> _addProduct() async {
// // //     Map<String, dynamic> newProduct = {
// // //       "name": nameController.text,
// // //       "description": descriptionController.text,
// // //       "price": double.parse(priceController.text),
// // //       "quantity": quantityController.text,
// // //       "available_quantity": int.parse(availableQuantityController.text),
// // //       "category": "fruits",
// // //       "availability": "in stock",
// // //       "crop_stage": "before crop"
// // //     };
// // //
// // //     bool success = await ProductService.addProduct(newProduct);
// // //     if (success) {
// // //       Navigator.pop(context);
// // //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Product added successfully")));
// // //     } else {
// // //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to add product")));
// // //     }
// // //   }
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(title: Text("Add Product")),
// // //       body: Padding(
// // //         padding: EdgeInsets.all(16.0),
// // //         child: Column(
// // //           children: [
// // //             TextField(controller: nameController, decoration: InputDecoration(labelText: "Name")),
// // //             TextField(controller: descriptionController, decoration: InputDecoration(labelText: "Description")),
// // //             TextField(controller: priceController, decoration: InputDecoration(labelText: "Price")),
// // //             TextField(controller: quantityController, decoration: InputDecoration(labelText: "Quantity")),
// // //             TextField(controller: availableQuantityController, decoration: InputDecoration(labelText: "Available Quantity")),
// // //             SizedBox(height: 10),
// // //             ElevatedButton(onPressed: _addProduct, child: Text("Add Product")),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }
