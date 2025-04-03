import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:farm_hub/farmer_orders_page.dart';
import 'package:farm_hub/farmer_profile.dart';
import 'package:farm_hub/inventory_screen.dart';
import 'package:farm_hub/selection_page.dart';
import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    fetchFarmerDetails();
    calculateTotalEarnings();
    calculateOrderCount();
  }

  Future<void> fetchFarmerDetails() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc =
          await FirebaseFirestore.instance
              .collection('farmers')
              .doc(user.uid)
              .get();
      if (doc.exists) {
        setState(() {
          farmName = doc.data()?['farmName'] ?? "My Farm";
          location = doc.data()?['location'] ?? "";
        });
      }
    }
  }

  Future<void> calculateTotalEarnings() async {
    double earnings = 0.0;
    final farmerId = FirebaseAuth.instance.currentUser?.uid ?? '';

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

    setState(() => totalEarnings = earnings);
  }

  Future<void> calculateOrderCount() async {
    int orders = 0;
    final farmerId = FirebaseAuth.instance.currentUser?.uid ?? '';

    final snapshot =
        await FirebaseFirestore.instance.collection('orders').get();
    for (var doc in snapshot.docs) {
      final data = doc.data();
      final items = data['items'] as List<dynamic>;
      if (items.any((item) => item['farmerId'] == farmerId)) {
        orders++;
      }
    }

    setState(() => totalOrders = orders);
  }

  Future<void> _deleteAccount(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    String password = '';

    await showDialog(
      context: context,
      builder: (ctx) {
        final _passwordController = TextEditingController();
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            "Delete Account",
            style: TextStyle(
              fontFamily: "Fredoka",
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Enter your password to confirm deletion.",
                style: TextStyle(fontFamily: "Fredoka", fontSize: 16),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Password",
                  hintStyle: const TextStyle(fontFamily: "Fredoka"),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                ),
              ),
            ],
          ),
          actionsPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text(
                "Cancel",
                style: TextStyle(
                  fontFamily: "Fredoka",
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                password = _passwordController.text;
                Navigator.of(ctx).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: const Text(
                "Confirm",
                style: TextStyle(fontFamily: "Fredoka", fontSize: 16),
              ),
            ),
          ],
        );
      },
    );

    if (password.isEmpty || user == null) return;

    try {
      final cred = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );

      await user.reauthenticateWithCredential(cred);

      // Delete farmer document
      await FirebaseFirestore.instance
          .collection('farmers')
          .doc(user.uid)
          .delete();

      // Delete farmer products
      final productsSnapshot =
          await FirebaseFirestore.instance
              .collection('products')
              .where('farmerId', isEqualTo: user.uid)
              .get();

      for (var doc in productsSnapshot.docs) {
        await doc.reference.delete();
      }

      await user.delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Account deleted successfully!")),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const SelectionPage()),
        (route) => false,
      );
    } catch (e) {
      print("Delete error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "⚠️ Error deleting account. Please check your password.",
          ),
        ),
      );
    }
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
              Center(
                child: Text(
                  farmName,
                  style: const TextStyle(
                    fontFamily: "Fredoka",
                    fontWeight: FontWeight.w500,
                    fontSize: 40,
                  ),
                ),
              ),
              Center(
                child: Text(
                  location,
                  style: const TextStyle(
                    fontFamily: "Fredoka",
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
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
                    index < 4 ? Icons.star : Icons.star_half,
                    color: Colors.orange,
                    size: 20,
                  );
                }),
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
                          fontWeight: FontWeight.w500,
                          fontFamily: "Fredoka",
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "$totalOrders",
                        style: const TextStyle(
                          fontSize: 20,
                          fontFamily: "Fredoka",
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 80,
                    width: 2,
                    color: Colors.grey,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                  ),
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
                      const SizedBox(height: 2),
                      Text(
                        "₹${totalEarnings.toStringAsFixed(0)}",
                        style: const TextStyle(
                          fontFamily: "Fredoka",
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
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
                    _buildMenuItem(Icons.person, "My Profile", context),
                    _buildMenuItem(Icons.shopping_cart, "Inventory", context),
                    _buildMenuItem(Icons.payment, "Payment Details", context),
                    _buildMenuItem(Icons.logout, "Logout", context),
                    _buildMenuItem(
                      Icons.delete_forever,
                      "Delete Account",
                      context,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: Colors.black),
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontFamily: "Fredoka",
              fontSize: 20,
            ),
          ),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            if (title == "My Profile") {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FarmerProfile()),
              );
            } else if (title == "Inventory") {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => InventoryScreen()),
              );
            } else if (title == "Payment Details") {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FarmerPaymentsPage()),
              );
            } else if (title == "Logout") {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const SelectionPage()),
                (route) => false,
              );
            } else if (title == "Delete Account") {
              _deleteAccount(context);
            }
          },
        ),
        if (title != "Delete Account")
          const Divider(height: 1, color: Colors.black26),
      ],
    );
  }
}
