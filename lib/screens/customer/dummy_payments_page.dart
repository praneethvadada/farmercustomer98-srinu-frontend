import 'package:flutter/material.dart';

class DummyPaymentScreen extends StatelessWidget {
  final double total;

  DummyPaymentScreen({required this.total});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Payment")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Total Amount: ₹${total.toStringAsFixed(2)}",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // After payment, navigate back and place the order
                Navigator.pop(context, true);
              },
              child: Text("Proceed to Payment"),
            ),
          ],
        ),
      ),
    );
  }
}
