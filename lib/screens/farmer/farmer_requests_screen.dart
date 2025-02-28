import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FarmerRequestsScreen extends StatefulWidget {
  @override
  _FarmerRequestsScreenState createState() => _FarmerRequestsScreenState();
}

class _FarmerRequestsScreenState extends State<FarmerRequestsScreen> {
  List<dynamic> requests = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRequests();
  }

  /// ✅ Fetch Customer Requests
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

  /// ✅ Respond to a Customer Request
  Future<void> _respondToRequest(int requestId, int quantity, double price, String deliveryTime) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    try {
      final response = await http.post(
        Uri.parse("http://10.0.2.2:3000/api/agri/respond/$requestId"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
        body: jsonEncode({
          "available_quantity": quantity,
          "price_per_unit": price,
          "delivery_time": deliveryTime
        }),
      );

      if (response.statusCode == 200) {
        _fetchRequests(); // Refresh list after response
      } else {
        log("❌ Error responding to request: ${response.body}");
      }
    } catch (e) {
      log("❌ Exception responding to request: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Customer Requests")),
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
                  _respondToRequest(request["id"], request["quantity"], 2000.00, "7 days");
                },
                child: Text("Respond"),
              ),
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
// class FarmerRequestsScreen extends StatefulWidget {
//   @override
//   _FarmerRequestsScreenState createState() => _FarmerRequestsScreenState();
// }
//
// class _FarmerRequestsScreenState extends State<FarmerRequestsScreen> {
//   List<dynamic> requests = [];
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchRequests();
//   }
//
//   /// ✅ **Fetch Customer Requests**
//   Future<void> _fetchRequests() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? token = prefs.getString("token");
//
//     try {
//       final response = await http.get(
//         Uri.parse("http://10.0.2.2:3000/api/agri/requests"),
//         headers: {"Authorization": "Bearer $token"},
//       );
//
//       if (response.statusCode == 200) {
//         setState(() {
//           requests = jsonDecode(response.body)["requests"];
//           isLoading = false;
//         });
//       } else {
//         log("❌ Error fetching requests: ${response.body}");
//       }
//     } catch (e) {
//       log("❌ Exception fetching requests: $e");
//     }
//   }
//
//   /// ✅ **Respond to a Request**
//   Future<void> _respondToRequest(int requestId) async {
//     TextEditingController availableQtyController = TextEditingController();
//     TextEditingController priceController = TextEditingController();
//     TextEditingController deliveryTimeController = TextEditingController();
//
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text("Respond to Request"),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(controller: availableQtyController, decoration: InputDecoration(labelText: "Available Quantity"), keyboardType: TextInputType.number),
//             TextField(controller: priceController, decoration: InputDecoration(labelText: "Price per Unit"), keyboardType: TextInputType.number),
//             TextField(controller: deliveryTimeController, decoration: InputDecoration(labelText: "Delivery Time")),
//           ],
//         ),
//         actions: [
//           TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
//           ElevatedButton(
//             onPressed: () async {
//               SharedPreferences prefs = await SharedPreferences.getInstance();
//               String? token = prefs.getString("token");
//
//               final response = await http.post(
//                 Uri.parse("http://10.0.2.2:3000/api/agri/respond/$requestId"),
//                 headers: {"Authorization": "Bearer $token", "Content-Type": "application/json"},
//                 body: jsonEncode({
//                   "available_quantity": int.parse(availableQtyController.text),
//                   "price_per_unit": double.parse(priceController.text),
//                   "delivery_time": deliveryTimeController.text,
//                 }),
//               );
//
//               if (response.statusCode == 201) {
//                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Response sent successfully!")));
//                 _fetchRequests();
//               } else {
//                 log("❌ Error responding: ${response.body}");
//               }
//
//               Navigator.pop(context);
//             },
//             child: Text("Submit"),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Customer Requests")),
//       body: isLoading
//           ? Center(child: CircularProgressIndicator())
//           : ListView.builder(
//         itemCount: requests.length,
//         itemBuilder: (context, index) {
//           final request = requests[index];
//           return Card(
//             margin: EdgeInsets.all(8.0),
//             child: ListTile(
//               title: Text(request["product_name"]),
//               subtitle: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text("Quantity: ${request["quantity"]} ${request["unit"]}"),
//                   Text("Description: ${request["description"]}"),
//                   Text("Status: ${request["status"]}"),
//                 ],
//               ),
//               trailing: ElevatedButton(
//                 onPressed: () => _respondToRequest(request["id"]),
//                 child: Text("Respond"),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
