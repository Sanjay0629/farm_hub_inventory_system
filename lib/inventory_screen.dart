import 'package:farm_hub/farm_account.dart';
import 'package:flutter/material.dart';

class Product {
  String name;
  String description;
  int quantity;
  double pricePerKg;
  String imageAsset;

  Product({
    required this.name,
    required this.description,
    required this.quantity,
    required this.pricePerKg,
    required this.imageAsset,
  });
}

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  List<Product> products = [
    Product(
      name: "Tomatoes",
      description: "Fresh tomatoes - locally organically grown",
      quantity: 12,
      pricePerKg: 20.02,
      imageAsset: 'assets/images/tomatoes.png',
    ),
    Product(
      name: "Carrots",
      description: "Fresh carrots - orange, organically grown",
      quantity: 5,
      pricePerKg: 50.0,
      imageAsset: 'assets/images/carrots.png',
    ),
    Product(
      name: "Bananas",
      description: "Fresh bananas - yellow and juicy",
      quantity: 10,
      pricePerKg: 80.5,
      imageAsset: 'assets/images/bananas.png',
    ),
  ];

  void updateQuantity(int index, int change) {
    setState(() {
      int newQty = products[index].quantity + change;
      if (newQty >= 0) {
        products[index].quantity = newQty;
      }
    });
  }

  void updatePrice(int index, double change) {
    setState(() {
      double newPrice = products[index].pricePerKg + change;
      if (newPrice >= 0) {
        products[index].pricePerKg = double.parse(newPrice.toStringAsFixed(2));
      }
    });
  }

  void showAddItemDialog() {
    final nameController = TextEditingController();
    final descController = TextEditingController();
    final qtyController = TextEditingController();
    final priceController = TextEditingController();
    final imgController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Add New Product"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                  TextField(
                    controller: descController,
                    decoration: const InputDecoration(labelText: 'Description'),
                  ),
                  TextField(
                    controller: qtyController,
                    decoration: const InputDecoration(
                      labelText: 'Quantity (kg)',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: priceController,
                    decoration: const InputDecoration(
                      labelText: 'Price per kg',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: imgController,
                    decoration: const InputDecoration(
                      labelText: 'Image asset path (e.g. assets/apple.png)',
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    products.add(
                      Product(
                        name: nameController.text,
                        description: descController.text,
                        quantity: int.tryParse(qtyController.text) ?? 0,
                        pricePerKg:
                            double.tryParse(priceController.text) ?? 0.0,
                        imageAsset: imgController.text,
                      ),
                    );
                  });
                  Navigator.pop(context);
                },
                child: const Text("Add"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: const BoxDecoration(
                color: Color(0xFFB2E38F),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => FarmAccount()),
                      );
                    },
                    icon: Icon(Icons.arrow_back),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Inventory',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  const Icon(Icons.more_horiz),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: showAddItemDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  icon: const Icon(Icons.add),
                  label: const Text("Add new item"),
                ),
                ElevatedButton.icon(
                  onPressed: () {}, // You can extend this later.
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFCBD9D6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  icon: const Icon(Icons.update),
                  label: const Text("Update item"),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search fruits, vegetables',
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: Color(0xFFF0F0F0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9F9F9),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 5,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Image.asset(product.imageAsset, height: 60),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  product.description,
                                  style: const TextStyle(fontSize: 12),
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    const Icon(Icons.scale, size: 16),
                                    const SizedBox(width: 4),
                                    Text("${product.quantity} kg"),
                                    const SizedBox(width: 10),
                                    const Icon(Icons.currency_rupee, size: 16),
                                    Text("${product.pricePerKg}/kg"),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () => updateQuantity(index, 1),
                                    icon: const Icon(Icons.add_circle),
                                  ),
                                  IconButton(
                                    onPressed: () => updateQuantity(index, -1),
                                    icon: const Icon(Icons.remove_circle),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () => updatePrice(index, 1),
                                    icon: const Icon(Icons.attach_money),
                                  ),
                                  IconButton(
                                    onPressed: () => updatePrice(index, -1),
                                    icon: const Icon(Icons.money_off),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
