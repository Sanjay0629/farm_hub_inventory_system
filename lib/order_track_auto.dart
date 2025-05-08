import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderTrackAutoPage extends StatelessWidget {
  final String orderId;

  OrderTrackAutoPage({required this.orderId});

  final List<String> statusStages = [
    "Order Placed",
    "Farmer Processing",
    "Ready for Delivery",
    "Out for Delivery",
    "Delivered",
  ];

  String calculateStatus(DateTime orderTime) {
    final now = DateTime.now();
    final diff = now.difference(orderTime);

    if (diff.inHours < 6) return "Order Placed";
    if (diff.inHours < 24) return "Farmer Processing";
    if (diff.inHours < 48) return "Ready for Delivery";
    if (diff.inHours < 72) return "Out for Delivery";
    return "Delivered";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFA8DF6E),
        title: const Text(
          'Track Order',
          style: TextStyle(fontFamily: 'Fredoka', fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('orders')
                .doc(orderId)
                .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final orderTime = data['timestamp'].toDate();
          final currentStatus = calculateStatus(orderTime);
          final currentIndex = statusStages.indexOf(currentStatus);

          final farmerName = data['farmerName'] ?? 'Unknown Farm';
          final totalAmount = data['totalAmount'] ?? 0.0;
          final formattedDate = orderTime.toLocal().toString().split(' ')[0];

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Order Summary',
                    style: TextStyle(
                      fontFamily: 'Fredoka',
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Farmer: $farmerName",
                    style: const TextStyle(fontFamily: 'Fredoka', fontSize: 16),
                  ),
                  Text(
                    "Total: ₹${totalAmount.toStringAsFixed(2)}",
                    style: const TextStyle(fontFamily: 'Fredoka', fontSize: 16),
                  ),
                  Text(
                    "Ordered On: $formattedDate",
                    style: const TextStyle(fontFamily: 'Fredoka', fontSize: 16),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Order Progress',
                    style: TextStyle(
                      fontFamily: 'Fredoka',
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111A2C),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ...statusStages.asMap().entries.map((entry) {
                    int index = entry.key;
                    String label = entry.value;
                    bool isDone = index <= currentIndex;

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Icon(
                              Icons.check_circle_rounded,
                              size: 30,
                              color:
                                  isDone
                                      ? const Color(0xFFA8DF6E)
                                      : Colors.grey[400],
                            ),
                            if (index < statusStages.length - 1)
                              Container(
                                width: 2,
                                height: 50,
                                color:
                                    isDone
                                        ? const Color(0xFFA8DF6E)
                                        : Colors.grey[300],
                              ),
                          ],
                        ),
                        const SizedBox(width: 15),
                        Padding(
                          padding: const EdgeInsets.only(top: 6.0),
                          child: Text(
                            label,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight:
                                  isDone ? FontWeight.w600 : FontWeight.normal,
                              fontFamily: 'Fredoka',
                              color:
                                  isDone
                                      ? const Color(0xFF111A2C)
                                      : Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
