import 'dart:convert';
import 'dart:developer';
import 'package:farmercustomer98/screens/customer/agreement_history_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CustomerResponsesScreen extends StatefulWidget {
  final int requestId;

  CustomerResponsesScreen({required this.requestId});

  @override
  _CustomerResponsesScreenState createState() => _CustomerResponsesScreenState();
}

class _CustomerResponsesScreenState extends State<CustomerResponsesScreen> {
  List<dynamic> responses = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchResponses();
  }

  /// ✅ Fetch Responses for Customer's Request
  Future<void> _fetchResponses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    try {
      final response = await http.get(
        Uri.parse("http://10.0.2.2:3000/api/agri/responses/${widget.requestId}"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        setState(() {
          responses = jsonDecode(response.body)["responses"];
          isLoading = false;
        });
      } else {
        log("❌ Error fetching responses: ${response.body}");
      }
    } catch (e) {
      log("❌ Exception fetching responses: $e");
    }
  }

  /// ✅ Accept a Farmer's Offer
  Future<void> _acceptResponse(int responseId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    final response = await http.post(
      Uri.parse("http://10.0.2.2:3000/api/agri/agree/$responseId"),
      headers: {"Authorization": "Bearer $token", "Content-Type": "application/json"},
      body: jsonEncode({
        "agreed_quantity": 100,  // Customer will enter quantity
        "agreed_price": 5000.00, // Customer will enter agreed price
      }),
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Agreement Confirmed!")));
      _fetchResponses();
    } else {
      log("❌ Error confirming agreement: ${response.body}");
    }
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
          title: Text("Farmer Responses")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: responses.length,
        itemBuilder: (context, index) {
          final response = responses[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text("Farmer ID: ${response["farmer_id"]}"),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Available: ${response["available_quantity"]} units"),
                  Text("Price per Unit: ₹${response["price_per_unit"]}"),
                  Text("Status: ${response["status"]}"),
                ],
              ),
              trailing: response["status"] == "Pending"
                  ? ElevatedButton(
                onPressed: () => _acceptResponse(response["id"]),
                child: Text("Accept Offer"),
              )
                  : Text("Accepted", style: TextStyle(color: Colors.green)),
            ),
          );
        },
      ),
    );
  }
}
