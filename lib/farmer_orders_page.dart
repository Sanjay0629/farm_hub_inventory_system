import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farm_hub/farm_account.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FarmerPaymentsPage extends StatefulWidget {
  const FarmerPaymentsPage({super.key});

  @override
  State<FarmerPaymentsPage> createState() => _FarmerPaymentsPageState();
}

class _FarmerPaymentsPageState extends State<FarmerPaymentsPage> {
  final String farmerId = FirebaseAuth.instance.currentUser?.uid ?? '';
  double totalEarnings = 0.0;

  @override
  void initState() {
    super.initState();
    _calculateEarnings();
  }

  Future<void> _calculateEarnings() async {
    double earnings = 0.0;
    final snapshot =
        await FirebaseFirestore.instance.collection('orders').get();

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final items = data['items'] as List<dynamic>;
      for (var item in items) {
        if (item['farmerId'] == farmerId) {
          final priceStr =
              (item['price'] ?? '0')
                  .toString()
                  .replaceAll('₹', '')
                  .replaceAll('/kg', '')
                  .trim();
          final double price = double.tryParse(priceStr) ?? 0;
          final int quantity = int.tryParse(item['quantity'] ?? '0') ?? 0;
          earnings += price * quantity;
        }
      }
    }

    setState(() {
      totalEarnings = earnings;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA9E06E),
      appBar: AppBar(
        title: const Text(
          "Payment Details",
          style: TextStyle(fontFamily: "Fredoka"),
        ),
        backgroundColor: const Color(0xFFA9E06E),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const FarmAccount()),
            );
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF2C6E49),
                borderRadius: BorderRadius.circular(20),
              ),
              width: double.infinity,
              child: Column(
                children: [
                  const Text(
                    "Total earnings",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Fredoka",
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "₹${totalEarnings.toStringAsFixed(0)}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Fredoka",
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance
                      .collection('orders')
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return const Center(child: CircularProgressIndicator());

                final orders = snapshot.data!.docs;
                List<Widget> earningsList = [];

                for (var order in orders) {
                  final orderData = order.data() as Map<String, dynamic>;
                  final items = orderData['items'] as List<dynamic>;
                  final buyerId = orderData['userId'] ?? '';
                  final timestamp = orderData['timestamp'] as Timestamp?;
                  final dateStr =
                      timestamp != null
                          ? DateFormat("dd MMM yyyy").format(timestamp.toDate())
                          : "Date";

                  for (var item in items) {
                    if (item['farmerId'] == farmerId) {
                      final priceStr =
                          (item['price'] ?? '0')
                              .toString()
                              .replaceAll('₹', '')
                              .replaceAll('/kg', '')
                              .trim();
                      final double price = double.tryParse(priceStr) ?? 0;
                      final int quantity =
                          int.tryParse(item['quantity'] ?? '0') ?? 0;
                      final double total = price * quantity;

                      earningsList.add(
                        FutureBuilder<DocumentSnapshot>(
                          future:
                              FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(buyerId)
                                  .get(),
                          builder: (context, buyerSnapshot) {
                            String buyerName = "Unknown Buyer";
                            if (buyerSnapshot.hasData &&
                                buyerSnapshot.data!.exists) {
                              buyerName =
                                  buyerSnapshot.data!.get("name") ?? "Unknown";
                            }

                            return Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 6,
                              ),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade300,
                                    blurRadius: 6,
                                    offset: const Offset(2, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        dateStr,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: "Fredoka",
                                        ),
                                      ),
                                      Text(
                                        "₹${total.toStringAsFixed(0)}",
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: "Fredoka",
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    "Received",
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Buyer: $buyerName",
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "Fredoka",
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    }
                  }
                }

                return ListView(children: earningsList);
              },
            ),
          ),
        ],
      ),
    );
  }
}
