import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:farm_hub/order_track_auto.dart';
import 'package:flutter/material.dart';

class MyOrdersPage extends StatelessWidget {
  const MyOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    print("🔍 Current UID: ${user?.uid}");

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Orders", style: TextStyle(fontFamily: 'Fredoka')),
        backgroundColor: const Color(0xFFA8DF6E),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body:
          user == null
              ? const Center(child: Text("Please log in to view your orders"))
              : StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance
                        .collection('orders')
                        .where('buyerId', isEqualTo: user.uid)
                        .orderBy('timestamp', descending: true)
                        .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final orders = snapshot.data!.docs;

                  if (orders.isEmpty) {
                    return const Center(
                      child: Text(
                        "No orders yet",
                        style: TextStyle(
                          fontFamily: 'Fredoka',
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      final data = order.data() as Map<String, dynamic>;

                      String status = data['status'] ?? "Pending";
                      Timestamp timestamp =
                          data['timestamp'] ?? Timestamp.now();
                      String date =
                          DateTime.fromMillisecondsSinceEpoch(
                            timestamp.millisecondsSinceEpoch,
                          ).toLocal().toString().split(' ')[0];

                      final farmerName = data['farmerName'] ?? 'Unknown';
                      final buyerName = data['buyerName'] ?? 'You';

                      return Card(
                        margin: const EdgeInsets.only(bottom: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 3,
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          leading: const Icon(
                            Icons.shopping_bag_rounded,
                            color: Colors.green,
                            size: 32,
                          ),
                          title: Text(
                            "Farmer: $farmerName",
                            style: const TextStyle(
                              fontFamily: 'Fredoka',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Buyer: $buyerName",
                                style: const TextStyle(
                                  fontFamily: 'Fredoka',
                                  fontSize: 13,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "Status: $status",
                                style: const TextStyle(
                                  fontFamily: 'Fredoka',
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                "Date: $date",
                                style: const TextStyle(
                                  fontFamily: 'Fredoka',
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.track_changes,
                              color: Colors.green,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) =>
                                          OrderTrackAutoPage(orderId: order.id),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
    );
  }
}
