import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'farmer_orders_screen.dart';

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

      if (response.statusCode == 201) {
        _fetchRequests(); // Refresh list after response
      } else {
        log("❌ Error responding to request: ${response.body}");
      }
    } catch (e) {
      log("❌ Exception responding to request: $e");
    }
  }

  /// ✅ Dialog to Enter Response
  void _showResponseDialog(int requestId) {
    TextEditingController quantityController = TextEditingController();
    TextEditingController priceController = TextEditingController();
    TextEditingController deliveryTimeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Respond to Request"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: quantityController, decoration: InputDecoration(labelText: "Available Quantity")),
              TextField(controller: priceController, decoration: InputDecoration(labelText: "Price per Unit")),
              TextField(controller: deliveryTimeController, decoration: InputDecoration(labelText: "Delivery Time")),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                _respondToRequest(
                  requestId,
                  int.parse(quantityController.text),
                  double.parse(priceController.text),
                  deliveryTimeController.text,
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
                Navigator.push(context, MaterialPageRoute(builder: (_) => FarmerAgreementHistoryScreen()));
              },
            ),
          ],
          title: Text("Customer Requests")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: requests.length,
        itemBuilder: (context, index) {
          final request = requests[index];
          // bool hasResponded = request["has_responded"] ?? false;
          bool hasResponded = (request["has_responded"] ?? 0) == 1;

          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(request["product_name"]),
              subtitle: Text("Quantity: ${request["quantity"]} ${request["unit"]}"),
              trailing: hasResponded
                  ? Text(
                "Response Sent",
                style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              )
                  : ElevatedButton(
                onPressed: () => _showResponseDialog(request["id"]),
                child: Text("Respond"),
              ),
            ),
          );
        },
      ),
    );
  }
}




class FarmerAgreementHistoryScreen extends StatefulWidget {
  @override
  _FarmerAgreementHistoryScreenState createState() => _FarmerAgreementHistoryScreenState();
}

class _FarmerAgreementHistoryScreenState extends State<FarmerAgreementHistoryScreen> {
  List<dynamic> agreements = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAgreements();
  }

  /// ✅ Fetch Farmer Agreement History
  Future<void> _fetchAgreements() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    try {
      final response = await http.get(
        Uri.parse("http://10.0.2.2:3000/api/agri/history/farmer"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        setState(() {
          agreements = jsonDecode(response.body)["agreements"];
          isLoading = false;
        });
      } else {
        log("❌ Error fetching agreements: ${response.body}");
      }
    } catch (e) {
      log("❌ Exception fetching agreements: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Agreementssss")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: agreements.length,
        itemBuilder: (context, index) {
          final agreement = agreements[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text("Product: ${agreement["product_name"]}"),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Quantity: ${agreement["agreed_quantity"]}"),
                  Text("Total Price: ₹${agreement["agreed_price"]}"),
                  Text("Customer: ${agreement["customer_name"]}"),
                  Text("Contact: ${agreement["customer_contact"]}"),
                  Text("Status: ${agreement["status"]}",
                      style: TextStyle(color: Colors.green)),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AgreementDetailsScreen(agreementId: agreement["agreement_id"]),
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



class AgreementDetailsScreen extends StatefulWidget {
  final int agreementId;

  AgreementDetailsScreen({required this.agreementId});

  @override
  _AgreementDetailsScreenState createState() => _AgreementDetailsScreenState();
}

class _AgreementDetailsScreenState extends State<AgreementDetailsScreen> {
  Map<String, dynamic>? agreement;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAgreementDetails();
  }

  /// ✅ Fetch Agreement Details
  Future<void> _fetchAgreementDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    try {
      final response = await http.get(
        Uri.parse("http://10.0.2.2:3000/api/agri/agreement/${widget.agreementId}"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        setState(() {
          agreement = jsonDecode(response.body)["agreement"];
          isLoading = false;
        });
      } else {
        log("❌ Error fetching agreement details: ${response.body}");
      }
    } catch (e) {
      log("❌ Exception fetching agreement details: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Agreement Details")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Agreementt ID: ${agreement?["agreement_id"]}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text("Product: ${agreement?["product_name"]}", style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text("Description: ${agreement?["description"]}", style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text("Quantity: ${agreement?["agreed_quantity"]}", style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text("Total Price: ₹${agreement?["agreed_price"]}", style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text("Customer: ${agreement?["customer_name"]}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text("Contact: ${agreement?["customer_contact"]}", style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text("Farmer: ${agreement?["farmer_name"]}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text("Contact: ${agreement?["farmer_contact"]}", style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text("Status: ${agreement?["status"]}",
                style: TextStyle(fontSize: 16, color: Colors.green)),
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
//   /// ✅ Fetch Customer Requests
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
//   /// ✅ Respond to a Customer Request
//   Future<void> _respondToRequest(int requestId, int quantity, double price, String deliveryTime) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? token = prefs.getString("token");
//
//     try {
//       final response = await http.post(
//         Uri.parse("http://10.0.2.2:3000/api/agri/respond/$requestId"),
//         headers: {
//           "Authorization": "Bearer $token",
//           "Content-Type": "application/json"
//         },
//         body: jsonEncode({
//           "available_quantity": quantity,
//           "price_per_unit": price,
//           "delivery_time": deliveryTime
//         }),
//       );
//
//       if (response.statusCode == 200) {
//         _fetchRequests(); // Refresh list after response
//       } else {
//         log("❌ Error responding to request: ${response.body}");
//       }
//     } catch (e) {
//       log("❌ Exception responding to request: $e");
//     }
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
//               subtitle: Text("Quantity: ${request["quantity"]} ${request["unit"]}"),
//               trailing: ElevatedButton(
//                 onPressed: () {
//                   _respondToRequest(request["id"], request["quantity"], 2000.00, "7 days");
//                 },
//                 child: Text("Respond"),
//               ),
//             ),
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
// // class FarmerRequestsScreen extends StatefulWidget {
// //   @override
// //   _FarmerRequestsScreenState createState() => _FarmerRequestsScreenState();
// // }
// //
// // class _FarmerRequestsScreenState extends State<FarmerRequestsScreen> {
// //   List<dynamic> requests = [];
// //   bool isLoading = true;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _fetchRequests();
// //   }
// //
// //   /// ✅ **Fetch Customer Requests**
// //   Future<void> _fetchRequests() async {
// //     SharedPreferences prefs = await SharedPreferences.getInstance();
// //     String? token = prefs.getString("token");
// //
// //     try {
// //       final response = await http.get(
// //         Uri.parse("http://10.0.2.2:3000/api/agri/requests"),
// //         headers: {"Authorization": "Bearer $token"},
// //       );
// //
// //       if (response.statusCode == 200) {
// //         setState(() {
// //           requests = jsonDecode(response.body)["requests"];
// //           isLoading = false;
// //         });
// //       } else {
// //         log("❌ Error fetching requests: ${response.body}");
// //       }
// //     } catch (e) {
// //       log("❌ Exception fetching requests: $e");
// //     }
// //   }
// //
// //   /// ✅ **Respond to a Request**
// //   Future<void> _respondToRequest(int requestId) async {
// //     TextEditingController availableQtyController = TextEditingController();
// //     TextEditingController priceController = TextEditingController();
// //     TextEditingController deliveryTimeController = TextEditingController();
// //
// //     showDialog(
// //       context: context,
// //       builder: (context) => AlertDialog(
// //         title: Text("Respond to Request"),
// //         content: Column(
// //           mainAxisSize: MainAxisSize.min,
// //           children: [
// //             TextField(controller: availableQtyController, decoration: InputDecoration(labelText: "Available Quantity"), keyboardType: TextInputType.number),
// //             TextField(controller: priceController, decoration: InputDecoration(labelText: "Price per Unit"), keyboardType: TextInputType.number),
// //             TextField(controller: deliveryTimeController, decoration: InputDecoration(labelText: "Delivery Time")),
// //           ],
// //         ),
// //         actions: [
// //           TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
// //           ElevatedButton(
// //             onPressed: () async {
// //               SharedPreferences prefs = await SharedPreferences.getInstance();
// //               String? token = prefs.getString("token");
// //
// //               final response = await http.post(
// //                 Uri.parse("http://10.0.2.2:3000/api/agri/respond/$requestId"),
// //                 headers: {"Authorization": "Bearer $token", "Content-Type": "application/json"},
// //                 body: jsonEncode({
// //                   "available_quantity": int.parse(availableQtyController.text),
// //                   "price_per_unit": double.parse(priceController.text),
// //                   "delivery_time": deliveryTimeController.text,
// //                 }),
// //               );
// //
// //               if (response.statusCode == 201) {
// //                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Response sent successfully!")));
// //                 _fetchRequests();
// //               } else {
// //                 log("❌ Error responding: ${response.body}");
// //               }
// //
// //               Navigator.pop(context);
// //             },
// //             child: Text("Submit"),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: Text("Customer Requests")),
// //       body: isLoading
// //           ? Center(child: CircularProgressIndicator())
// //           : ListView.builder(
// //         itemCount: requests.length,
// //         itemBuilder: (context, index) {
// //           final request = requests[index];
// //           return Card(
// //             margin: EdgeInsets.all(8.0),
// //             child: ListTile(
// //               title: Text(request["product_name"]),
// //               subtitle: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Text("Quantity: ${request["quantity"]} ${request["unit"]}"),
// //                   Text("Description: ${request["description"]}"),
// //                   Text("Status: ${request["status"]}"),
// //                 ],
// //               ),
// //               trailing: ElevatedButton(
// //                 onPressed: () => _respondToRequest(request["id"]),
// //                 child: Text("Respond"),
// //               ),
// //             ),
// //           );
// //         },
// //       ),
// //     );
// //   }
// // }
