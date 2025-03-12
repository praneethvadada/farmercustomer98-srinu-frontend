import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'agreement_history_screen.dart';
import 'customer_responses_screen.dart';

class CustomerRequestsScreen extends StatefulWidget {
  @override
  _CustomerRequestsScreenState createState() => _CustomerRequestsScreenState();
}

class _CustomerRequestsScreenState extends State<CustomerRequestsScreen> {
  List<dynamic> requests = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRequests();
  }

  /// ✅ Fetch Customer's Requests
  Future<void> _fetchRequests() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    try {
      final response = await http.get(
        Uri.parse("http://10.0.2.2:3000/api/agri/requests"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        setState(() {
          requests = jsonDecode(response.body)["requests"];
          isLoading = false;
        });
      } else {
        log("❌ Error fetching requests: ${response.body}");
      }
    } catch (e) {
      log("❌ Exception fetching requests: $e");
    }
  }

  /// ✅ Create a New Request
  Future<void> _createRequest(String productName, String description, int quantity, String unit, double expectedPrice, String category) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    try {
      final response = await http.post(
        Uri.parse("http://10.0.2.2:3000/api/agri/request"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
        body: jsonEncode({
          "product_name": productName,
          "description": description,
          "quantity": quantity,
          "unit": unit,
          "expected_price": expectedPrice,
          "category": category
        }),
      );

      if (response.statusCode == 201) {
        _fetchRequests(); // Refresh after adding
      } else {
        log("❌ Error creating request: ${response.body}");
      }
    } catch (e) {
      log("❌ Exception creating request: $e");
    }
  }

  /// ✅ Dialog to Enter New Request
  void _showRequestDialog() {
    TextEditingController nameController = TextEditingController();
    TextEditingController descController = TextEditingController();
    TextEditingController qtyController = TextEditingController();
    TextEditingController priceController = TextEditingController();
    String unit = "kg";
    String category = "grains";

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("New Agricultural Request"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: InputDecoration(labelText: "Product Name")),
              TextField(controller: descController, decoration: InputDecoration(labelText: "Description")),
              TextField(controller: qtyController, decoration: InputDecoration(labelText: "Quantity")),
              TextField(controller: priceController, decoration: InputDecoration(labelText: "Expected Price")),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                _createRequest(
                  nameController.text,
                  descController.text,
                  int.parse(qtyController.text),
                  unit,
                  double.parse(priceController.text),
                  category,
                );
                Navigator.pop(context);
              },
              child: Text("Submit"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(Icons.history),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => CustomerAgreementHistoryScreen()));
              },
            ),
          ],
          title: Text("My Requests")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: requests.length,
        itemBuilder: (context, index) {
          final request = requests[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(request["product_name"]),
              subtitle: Text("Quantity: ${request["quantity"]} ${request["unit"]}"),
              trailing: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CustomerResponsesScreen(requestId: request["id"]),
                    ),
                  );
                },
                child: Text("View Responses"),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showRequestDialog,
        child: Icon(Icons.add),
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
// class CustomerRequestScreen extends StatefulWidget {
//   @override
//   _CustomerRequestScreenState createState() => _CustomerRequestScreenState();
// }
//
// class _CustomerRequestScreenState extends State<CustomerRequestScreen> {
//   final TextEditingController _productNameController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();
//   final TextEditingController _quantityController = TextEditingController();
//   final TextEditingController _priceController = TextEditingController();
//   final TextEditingController _unitController = TextEditingController();
//   final TextEditingController _categoryController = TextEditingController();
//   bool isLoading = false;
//
//   /// ✅ **Send a Request**
//   Future<void> _sendRequest() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? token = prefs.getString("token");
//
//     if (token == null || token.isEmpty) {
//       log("❌ No token found! Cannot send request.");
//       return;
//     }
//
//     try {
//       setState(() => isLoading = true);
//
//       final response = await http.post(
//         Uri.parse("http://10.0.2.2:3000/api/agri/request"),
//         headers: {
//           "Authorization": "Bearer $token",
//           "Content-Type": "application/json",
//         },
//         body: jsonEncode({
//           "product_name": _productNameController.text,
//           "description": _descriptionController.text,
//           "quantity": int.parse(_quantityController.text),
//           "unit": _unitController.text,
//           "expected_price": double.parse(_priceController.text),
//           "category": _categoryController.text,
//         }),
//       );
//
//       log("🛍 Request Response Status: ${response.statusCode}");
//       log("🛍 Request Response Body: ${response.body}");
//
//       if (response.statusCode == 201) {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Request sent successfully!")));
//         _clearFields();
//       } else {
//         log("❌ Error sending request: ${response.body}");
//       }
//     } catch (e) {
//       log("❌ Exception sending request: $e");
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }
//
//   void _clearFields() {
//     _productNameController.clear();
//     _descriptionController.clear();
//     _quantityController.clear();
//     _priceController.clear();
//     _unitController.clear();
//     _categoryController.clear();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//           // actions: [
//           //   IconButton(onPressed: (){
//           //     Navigator.push(
//           //       context,
//           //       MaterialPageRoute(builder: (_) => SearchProductsScreen()),
//           //     );
//           //   }, icon: Icon(Icons.search)),
//           // ],
//
//           title: Text("Request Agricultural Goods")),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(controller: _productNameController, decoration: InputDecoration(labelText: "Product Name")),
//             TextField(controller: _descriptionController, decoration: InputDecoration(labelText: "Description")),
//             TextField(controller: _quantityController, decoration: InputDecoration(labelText: "Quantity"), keyboardType: TextInputType.number),
//             TextField(controller: _unitController, decoration: InputDecoration(labelText: "Unit (kg, liters, etc.)")),
//             TextField(controller: _priceController, decoration: InputDecoration(labelText: "Expected Price"), keyboardType: TextInputType.number),
//             TextField(controller: _categoryController, decoration: InputDecoration(labelText: "Category")),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: isLoading ? null : _sendRequest,
//               child: isLoading ? CircularProgressIndicator() : Text("Send Request"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
