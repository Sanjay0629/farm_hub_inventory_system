import 'package:flutter/material.dart';

class FarmerAccountPage extends StatelessWidget {
  const FarmerAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Top Section
              Stack(
                children: [
                  Container(
                    height: 220,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50),
                        bottomRight: Radius.circular(50),
                      ),
                    ),
                  ),
                  Positioned(
                    top: -30,
                    left: -30,
                    child: CircleAvatar(
                      radius: 70,
                      backgroundColor: Colors.green.shade100,
                    ),
                  ),
                  Positioned(
                    top: 30,
                    left: -10,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.green.shade200,
                    ),
                  ),
                  Column(
                    children: [
                      const SizedBox(height: 30),
                      const Text(
                        "Nike’s Farm",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const Text(
                        "Richie street",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 10),
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.grey[300],
                        child: Image.asset(
                          "assets/images/farmer1.png", // Add your image to assets
                          fit: BoxFit.cover,
                          width: 70,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) {
                          return Icon(
                            index == 4 ? Icons.star_border : Icons.star,
                            color: index == 4 ? Colors.grey : Colors.orange,
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
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text("50", style: TextStyle(fontSize: 18)),
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 30),
                            height: 40,
                            width: 2,
                            color: Colors.black26,
                          ),
                          Column(
                            children: const [
                              Text(
                                "Payment",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text("₹3000", style: TextStyle(fontSize: 18)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Menu Section
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.green.shade200,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    menuItem(Icons.person, "My Profile"),
                    menuItem(Icons.shopping_cart, "Inventory"),
                    menuItem(Icons.payment, "Payment Details"),
                    menuItem(Icons.update, "Update Item"),
                    menuItem(Icons.logout, "Logout"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget menuItem(IconData icon, String title) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: Colors.black),
          title: Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black),
          onTap: () {},
        ),
        if (title != "Logout") Divider(color: Colors.black26, thickness: 0.5),
      ],
    );
  }
}
