import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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
            Text("Agreementtt ID: ${agreement?["agreement_id"]}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                style: TextStyle(fontSize: 16, color: agreement?["status"] == "Canceled" ? Colors.red : Colors.green)),
          ],
        ),
      ),
    );
  }
}
