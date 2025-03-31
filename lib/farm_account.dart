import 'package:farm_hub/farmer_profile.dart';
import 'package:farm_hub/inventory_screen.dart';
import 'package:farm_hub/payment_farmer.dart';
import 'package:farm_hub/selection_page.dart';
import 'package:flutter/material.dart';

class FarmAccount extends StatelessWidget {
  const FarmAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
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
              const Center(
                child: Text(
                  "Nike Farm",
                  style: TextStyle(
                    fontFamily: "Fredoka",
                    fontWeight: FontWeight.w500,
                    fontSize: 40,
                  ),
                ),
              ),
              const Center(
                child: Text(
                  "Richie Street",
                  style: TextStyle(
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
                    children: const [
                      Text(
                        "Orders",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontFamily: "Fredoka",
                          fontSize: 24,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        "50",
                        style: TextStyle(
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
                    children: const [
                      Text(
                        "Payment",
                        style: TextStyle(
                          fontSize: 24,
                          fontFamily: "Fredoka",
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        "₹3000",
                        style: TextStyle(
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

              // The Container for My Profile, Inventory, Payment Details, etc.
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFB4E197), // Light green background
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    _buildMenuItem(Icons.person, "My Profile", context),
                    _buildMenuItem(Icons.shopping_cart, "Inventory", context),
                    _buildMenuItem(Icons.payment, "Payment Details", context),
                    _buildMenuItem(Icons.logout, "Logout", context),
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
          trailing: IconButton(
            onPressed: () {
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
                  MaterialPageRoute(builder: (context) => PaymentFarmer()),
                );
              } else if (title == "Logout") {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SelectionPage()),
                );
              }
            },
            icon: const Icon(Icons.arrow_forward_ios),
          ),
        ),
        if (title != "Logout") const Divider(height: 1, color: Colors.black26),
      ],
    );
  }
}
