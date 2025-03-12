import 'dart:convert';
import 'dart:developer';
import 'package:farmercustomer98/screens/customer/agreement_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CustomerAgreementHistoryScreen extends StatefulWidget {
  @override
  _CustomerAgreementHistoryScreenState createState() => _CustomerAgreementHistoryScreenState();
}

class _CustomerAgreementHistoryScreenState extends State<CustomerAgreementHistoryScreen> {
  List<dynamic> agreements = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAgreements();
  }

  /// ✅ Fetch Customer Agreement History
  Future<void> _fetchAgreements() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    try {
      final response = await http.get(
        Uri.parse("http://10.0.2.2:3000/api/agri/history/customer"),
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

  /// ✅ Cancel Agreement
  Future<void> _cancelAgreement(int agreementId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    try {
      final response = await http.put(
        Uri.parse("http://10.0.2.2:3000/api/agri/agreement/cancel/$agreementId"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        _fetchAgreements(); // Refresh history after cancellation
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Agreement Canceled")));
      } else {
        log("❌ Error canceling agreement: ${response.body}");
      }
    } catch (e) {
      log("❌ Exception canceling agreement: $e");
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
                  Text("Farmer: ${agreement["farmer_name"]}"),
                  Text("Contact: ${agreement["farmer_contact"]}"),
                  Text("Status: ${agreement["status"]}",
                      style: TextStyle(color: agreement["status"] == "Canceled" ? Colors.red : Colors.green)),
                ],
              ),
              trailing: agreement["status"] == "Active"
                  ? IconButton(
                icon: Icon(Icons.cancel, color: Colors.red),
                onPressed: () => _cancelAgreement(agreement["agreement_id"]),
              )
                  : null,
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
