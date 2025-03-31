import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farm_hub/cart_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:farm_hub/payment_successful_page.dart';
import 'package:farm_hub/secrets.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'cart_data.dart';

class PaymentConsumer extends StatefulWidget {
  const PaymentConsumer({super.key});

  @override
  State<PaymentConsumer> createState() => _PaymentConsumerState();
}

class _PaymentConsumerState extends State<PaymentConsumer> {
  late Razorpay _razorpay;
  double totalAmount = 0.0;

  @override
  void initState() {
    super.initState();
    calculateCartTotal();

    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handleSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handleError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void calculateCartTotal() {
    totalAmount = 0.0;
    for (var item in cartItems) {
      double price = double.parse(
        (item["price"] ?? "").replaceAll("₹", "").replaceAll("/kg", "").trim(),
      );
      int quantity = int.parse(item["quantity"] ?? "0");
      totalAmount += price * quantity;
    }
  }

  void _openRazorpayCheckout() {
    print("Opening Razorpay Checkout...");
    var options = {
      'key': paymentapikey,
      'amount': (totalAmount * 100).toInt(), // in paise
      'name': 'FarmHub',
      'description': 'Farm Product Purchase',
      'prefill': {'contact': '9876543210', 'email': 'user@example.com'},
      'external': {
        'wallets': ['paytm'],
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print("Checkout Error: $e");
    }
  }

  void _handleSuccess(PaymentSuccessResponse response) async {
    // Optional: Get the current user ID (if using Firebase Auth)
    String userId = FirebaseAuth.instance.currentUser?.uid ?? 'guest_user';

    try {
      // Save order/payment details to Firestore
      await FirebaseFirestore.instance.collection('orders').add({
        'userId': userId,
        'paymentId': response.paymentId,
        'totalAmount': totalAmount,
        'timestamp': FieldValue.serverTimestamp(),
        'items':
            cartItems
                .map(
                  (item) => {
                    'title': item['title'],
                    'price': item['price'],
                    'quantity': item['quantity'],
                    'description': item['description'],
                  },
                )
                .toList(),
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Payment Successful!")));

      cartItems.clear();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PaymentSuccessfulPage()),
      );
    } catch (e) {
      print("Firestore Save Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("⚠️ Payment saved, but failed to store order.")),
      );
    }
  }

  void _handleError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Payment Failed")));
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("💼 Wallet: ${response.walletName}")),
    );
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFA9E06E),
      appBar: AppBar(
        title: Text("Payment", style: TextStyle(fontFamily: "Fredoka")),
        backgroundColor: Color(0xFFA9E06E),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              color: Colors.white,
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text(
                      "You are about to pay",
                      style: TextStyle(fontSize: 16, fontFamily: "Fredoka"),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "₹${totalAmount.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                        fontFamily: "Fredoka",
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _openRazorpayCheckout,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                "Pay ₹${totalAmount.toStringAsFixed(2)} with Razorpay",
                style: TextStyle(fontSize: 16, fontFamily: "Fredoka"),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed:
                  () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => CartPage()),
                  ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                "Back to Cart",
                style: TextStyle(fontSize: 16, fontFamily: "Fredoka"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
