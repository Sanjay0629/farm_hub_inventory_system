import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:farm_hub/selection_page.dart';
import 'package:farm_hub/farmer_profile.dart';
import 'package:farm_hub/farmer_orders_page.dart';
import 'package:farm_hub/inventory_screen.dart';

class FarmAccount extends StatefulWidget {
  const FarmAccount({super.key});

  @override
  State<FarmAccount> createState() => _FarmAccountState();
}

class _FarmAccountState extends State<FarmAccount> {
  String farmName = "FarmHub";
  String location = "";
  double totalEarnings = 0.0;
  int totalOrders = 0;
  double averageRating = 0.0;

  @override
  void initState() {
    super.initState();
    fetchDetails();
  }

  Future<void> fetchDetails() async {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;
    if (uid == null) return;

    final doc =
        await FirebaseFirestore.instance.collection('farmers').doc(uid).get();
    final orders = await FirebaseFirestore.instance.collection('orders').get();
    final ratingsSnapshot =
        await FirebaseFirestore.instance
            .collection('farmers')
            .doc(uid)
            .collection('ratings')
            .get();

    double earnings = 0.0;
    int orderCount = 0;
    List<int> ratings = [];

    for (var order in orders.docs) {
      final items = (order['items'] as List);
      for (var item in items) {
        if (item['farmerId'] == uid) {
          final price =
              double.tryParse(
                item['price']
                    .toString()
                    .replaceAll("₹", "")
                    .replaceAll("/kg", "")
                    .trim(),
              ) ??
              0;
          final qty = int.tryParse(item['quantity'] ?? "0") ?? 0;
          earnings += price * qty;
          orderCount++;
        }
      }
    }

    for (var r in ratingsSnapshot.docs) {
      ratings.add((r['rating'] ?? 0).toInt());
    }

    setState(() {
      farmName = doc['farmName'] ?? 'My Farm';
      location = doc['location'] ?? '';
      totalEarnings = earnings;
      totalOrders = orderCount;
      averageRating =
          ratings.isEmpty
              ? 0.0
              : ratings.reduce((a, b) => a + b) / ratings.length;
    });
  }

  Future<void> _showDeleteAccountDialog() async {
    final user = FirebaseAuth.instance.currentUser;
    final TextEditingController _passwordController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (ctx) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            backgroundColor: const Color(0xFFEFFFE9),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    size: 60,
                    color: Colors.redAccent,
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Delete Account?",
                    style: TextStyle(
                      fontFamily: "Fredoka",
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Please confirm your password to delete your FarmHub account. This action cannot be undone.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "Fredoka",
                      fontSize: 15,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Enter Password",
                      hintStyle: const TextStyle(fontFamily: 'Fredoka'),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.black,
                            textStyle: const TextStyle(fontFamily: "Fredoka"),
                            side: const BorderSide(color: Colors.grey),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () => Navigator.of(ctx).pop(),
                          child: const Text("Cancel"),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            foregroundColor: Colors.white,
                            textStyle: const TextStyle(fontFamily: "Fredoka"),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () async {
                            final password = _passwordController.text.trim();
                            if (password.isEmpty || user == null) return;

                            try {
                              final cred = EmailAuthProvider.credential(
                                email: user.email!,
                                password: password,
                              );
                              await user.reauthenticateWithCredential(cred);

                              await FirebaseFirestore.instance
                                  .collection('farmers')
                                  .doc(user.uid)
                                  .delete();

                              final products =
                                  await FirebaseFirestore.instance
                                      .collection('products')
                                      .where('farmerId', isEqualTo: user.uid)
                                      .get();

                              for (var doc in products.docs) {
                                await doc.reference.delete();
                              }

                              await user.delete();

                              Navigator.of(ctx).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "✅ Account deleted successfully!",
                                    style: TextStyle(fontFamily: "Fredoka"),
                                  ),
                                  backgroundColor: Color(0xFFA8DF6E),
                                  behavior: SnackBarBehavior.floating,
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(12),
                                    ),
                                  ),
                                ),
                              );

                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const SelectionPage(),
                                ),
                                (_) => false,
                              );
                            } catch (e) {
                              Navigator.of(ctx).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text(
                                    "❌ Error deleting account. Check password.",
                                    style: TextStyle(fontFamily: "Fredoka"),
                                  ),
                                  backgroundColor: Colors.redAccent,
                                  behavior: SnackBarBehavior.floating,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              );
                            }
                          },
                          child: const Text("Delete"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Future<void> _showLogoutDialog() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (ctx) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            backgroundColor: const Color(0xFFEFFFE9),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.logout, size: 60, color: Colors.red),
                  const SizedBox(height: 15),
                  const Text(
                    "Logout Confirmation",
                    style: TextStyle(
                      fontFamily: "Fredoka",
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Are you sure you want to log out of your FarmHub account?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "Fredoka",
                      fontSize: 15,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.black,
                            textStyle: const TextStyle(fontFamily: "Fredoka"),
                            side: const BorderSide(color: Colors.grey),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () => Navigator.of(ctx).pop(),
                          child: const Text("Cancel"),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            textStyle: const TextStyle(fontFamily: "Fredoka"),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(ctx).pop();

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "✅ Logged out successfully!",
                                  style: TextStyle(fontFamily: "Fredoka"),
                                ),
                                backgroundColor: Color(0xFFA8DF6E),
                                behavior: SnackBarBehavior.floating,
                                margin: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12),
                                  ),
                                ),
                              ),
                            );

                            Future.delayed(
                              const Duration(milliseconds: 1500),
                              () {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const SelectionPage(),
                                  ),
                                  (_) => false,
                                );
                              },
                            );
                          },
                          child: const Text("Logout"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: Colors.black),
          title: Text(
            title,
            style: const TextStyle(
              fontFamily: "Fredoka",
              fontSize: 20,
              fontWeight: FontWeight.w400,
            ),
          ),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            if (title == "My Profile") {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => FarmerProfile()),
              );
            } else if (title == "Inventory") {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => InventoryScreen()),
              );
            } else if (title == "Payment Details") {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => FarmerPaymentsPage()),
              );
            } else if (title == "Logout") {
              _showLogoutDialog();
            } else if (title == "Delete Account") {
              _showDeleteAccountDialog();
            }
          },
        ),
        if (title != "Delete Account")
          const Divider(height: 1, color: Colors.black26),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Circles
          Positioned(
            left: -68,
            top: -87,
            child: CircleAvatar(
              radius: 130,
              backgroundColor: const Color(0xBFA8DF6E),
            ),
          ),
          Positioned(
            left: -68,
            top: 119,
            child: CircleAvatar(
              radius: 80,
              backgroundColor: const Color(0xBFEAE86C),
            ),
          ),
          Positioned(
            left: 143,
            top: 814,
            child: CircleAvatar(
              radius: 104,
              backgroundColor: const Color(0xBFA8DF6E),
            ),
          ),
          Positioned(
            left: 275,
            top: 670,
            child: CircleAvatar(
              radius: 130,
              backgroundColor: const Color(0xBFEAE86C),
            ),
          ),
          Column(
            children: [
              const SizedBox(height: 25),
              Text(
                farmName,
                style: const TextStyle(
                  fontSize: 40,
                  fontFamily: "Fredoka",
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                location,
                style: const TextStyle(
                  fontSize: 18,
                  fontFamily: "Fredoka",
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 15),
              const CircleAvatar(
                radius: 65,
                backgroundImage: AssetImage("assets/images/farmer1.png"),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return Icon(
                    Icons.star,
                    color:
                        index < averageRating.round()
                            ? Colors.orange
                            : Colors.grey,
                    size: 20,
                  );
                }),
              ),
              const SizedBox(height: 4),
              Text(
                averageRating > 0
                    ? "${averageRating.toStringAsFixed(1)} stars"
                    : "No ratings yet",
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: "Fredoka",
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      const Text(
                        "Orders",
                        style: TextStyle(
                          fontSize: 24,
                          fontFamily: "Fredoka",
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "$totalOrders",
                        style: const TextStyle(
                          fontSize: 20,
                          fontFamily: "Fredoka",
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Column(
                    children: [
                      const Text(
                        "Payment",
                        style: TextStyle(
                          fontSize: 24,
                          fontFamily: "Fredoka",
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "₹${totalEarnings.toStringAsFixed(0)}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontFamily: "Fredoka",
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFB4E197),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    _buildMenuItem(Icons.person, "My Profile"),
                    _buildMenuItem(Icons.shopping_cart, "Inventory"),
                    _buildMenuItem(Icons.payment, "Payment Details"),
                    _buildMenuItem(Icons.logout, "Logout"),
                    _buildMenuItem(Icons.delete_forever, "Delete Account"),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
