import 'package:farm_hub/payment_consumer.dart';
import 'package:flutter/material.dart';
import 'cart_data.dart'; // Import the cart data file

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  /// **Function to Update Quantity**
  void updateQuantity(int index, int change) {
    setState(() {
      int currentQuantity = int.parse(
        cartItems[index]["quantity"] ?? "0",
      ); // Ensure it's an int
      currentQuantity += change;

      if (currentQuantity <= 0) {
        cartItems.removeAt(index); // Remove item if quantity is 0
      } else {
        cartItems[index]["quantity"] =
            currentQuantity.toString(); // Convert back to string
      }
    });
  }

  /// **Calculate Total Price**
  double calculateTotal() {
    double total = 0.0;
    for (var item in cartItems) {
      double price = double.parse(
        (item["price"] ?? "").replaceAll("₹", "").replaceAll("/kg", "").trim(),
      );
      int quantity = int.parse(item["quantity"] ?? "0");
      total += price * quantity;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFA9E06E),
      appBar: AppBar(
        title: Text("My Cart", style: TextStyle(fontFamily: "Fredoka")),
        backgroundColor: Color(0xFFA9E06E),
        centerTitle: true,
      ),
      body:
          cartItems.isEmpty
              ? Center(
                child: Text(
                  "Your cart is empty!",
                  style: TextStyle(fontSize: 18, fontFamily: "Fredoka"),
                ),
              )
              : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        var item = cartItems[index];
                        return Card(
                          margin: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 3,
                          child: ListTile(
                            leading: Image.asset(
                              (item["image"] ?? "")
                                  .toString(), // Ensures it's a valid string
                              width: 50,
                            ),
                            title: Text(
                              item["title"] ?? "",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Fredoka",
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item["description"] ?? "",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: "Fredoka",
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "${item["price"]} x ${item["quantity"]} = ₹${(double.parse((item["price"] ?? "").replaceAll("₹", "").replaceAll("/kg", "").trim()) * int.parse(item["quantity"] ?? "0")).toStringAsFixed(2)}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.remove_circle,
                                    color: Colors.red,
                                  ),
                                  onPressed: () => updateQuantity(index, -1),
                                ),
                                Text(
                                  item["quantity"] ??
                                      "0", // Ensure it displays correctly
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.add_circle,
                                    color: Colors.green,
                                  ),
                                  onPressed: () => updateQuantity(index, 1),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  /// **Total Price & Checkout Button**
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        top: BorderSide(color: Colors.grey.shade300, width: 1),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Total:",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Fredoka",
                              ),
                            ),
                            Text(
                              "₹${calculateTotal().toStringAsFixed(2)}",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                                fontFamily: "Fredoka",
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PaymentConsumer(),
                              ),
                            );
                          },
                          child: Text(
                            "Checkout",
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: "Fredoka",
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            minimumSize: Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
    );
  }
}
