// import 'package:flutter/material.dart';
// import 'cart_data.dart'; // Import the cart data file
// import 'cart_page.dart'; // Import CartPage for navigation

// class BuyingPage extends StatelessWidget {
//   void addToCart(String image, String title, String description, String price) {
//     cartItems.add({
//       "image": image,
//       "title": title,
//       "description": description,
//       "price": price,
//     });
//     print("Added to Cart: $title");
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Column(
//         children: [
//           Expanded(
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   Stack(
//                     children: [
//                       Image.asset(
//                         'assets/images/farm.png',
//                         width: double.infinity,
//                         fit: BoxFit.cover,
//                       ),
//                       Positioned(
//                         top: 40,
//                         left: 10,
//                         child: IconButton(
//                           icon: Icon(Icons.arrow_back, color: Colors.white),
//                           onPressed: () {
//                             Navigator.pop(context);
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Nike’s Farm",
//                           style: TextStyle(
//                             fontSize: 22,
//                             fontWeight: FontWeight.bold,
//                             fontFamily: "Fredoka",
//                           ),
//                         ),
//                         SizedBox(height: 5),
//                         Text(
//                           "Welcome to my farm, where we grow fresh, organic fruits and vegetables with love. We offer a variety of seasonal produce, including tomatoes, carrots, apples, and berries—harvested fresh for you!",
//                           style: TextStyle(
//                             fontSize: 14,
//                             color: Colors.grey[700],
//                             fontFamily: "Fredoka",
//                           ),
//                         ),
//                         SizedBox(height: 20),

//                         /// 🔹 **Product Cards**
//                         ProductCard(
//                           image: 'assets/images/tomatoes.png',
//                           title: 'Tomatoes',
//                           description:
//                               'Fresh tomatoes - locally, organically grown',
//                           price: '₹20.02/kg',
//                           onAdd: addToCart,
//                         ),
//                         ProductCard(
//                           image: 'assets/images/carrots.png',
//                           title: 'Carrots',
//                           description: 'Fresh carrots - organic and sweet',
//                           price: '₹50.00/kg',
//                           onAdd: addToCart,
//                         ),
//                         ProductCard(
//                           image: 'assets/images/bananas.png',
//                           title: 'Bananas',
//                           description: 'Fresh bananas - Yellow and juicy',
//                           price: '₹30.00/kg',
//                           onAdd: addToCart,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),

//           /// 🔹 **Go to Cart Button Below Products**
//           Container(
//             width: double.infinity,
//             padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               border: Border(
//                 top: BorderSide(color: Colors.grey.shade300, width: 1),
//               ),
//             ),
//             child: ElevatedButton.icon(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => CartPage()),
//                 );
//               },
//               icon: Icon(Icons.shopping_cart),
//               label: Text(
//                 "Go to Cart",
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontFamily: "Fredoka",
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.green,
//                 foregroundColor: Colors.white,
//                 padding: EdgeInsets.symmetric(vertical: 14),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// /// 📌 **ProductCard Widget**
// class ProductCard extends StatelessWidget {
//   final String image;
//   final String title;
//   final String description;
//   final String price;
//   final Function(String, String, String, String) onAdd;

//   ProductCard({
//     required this.image,
//     required this.title,
//     required this.description,
//     required this.price,
//     required this.onAdd,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       elevation: 3,
//       margin: EdgeInsets.symmetric(vertical: 8),
//       child: ListTile(
//         leading: Image.asset(image, width: 50),
//         title: Text(
//           title,
//           style: TextStyle(
//             fontWeight: FontWeight.w400,
//             fontFamily: "Fredoka",
//             fontSize: 24,
//           ),
//         ),
//         subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               description,
//               style: TextStyle(
//                 fontSize: 12,
//                 color: Colors.black,
//                 fontFamily: "Fredoka",
//                 fontWeight: FontWeight.w400,
//               ),
//             ),
//             Text(
//               price,
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w400,
//                 fontFamily: "Fredoka",
//                 color: Colors.green,
//               ),
//             ),
//           ],
//         ),
//         trailing: ElevatedButton(
//           onPressed: () => onAdd(image, title, description, price),
//           child: Text("Add"),
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.green,
//             foregroundColor: Colors.white,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:farm_hub/browse_farm_page.dart';
import 'package:flutter/material.dart';
import 'cart_data.dart'; // Import the cart data file
import 'cart_page.dart'; // Import CartPage for navigation

class BuyingPage extends StatelessWidget {
  const BuyingPage({super.key});
  void addToCart(String image, String title, String description, String price) {
    bool itemExists = false;

    // Check if the item already exists in the cart
    for (var item in cartItems) {
      if (item["title"] == title) {
        int currentQuantity = int.parse(
          item["quantity"].toString(),
        ); // Ensure quantity is treated as int
        item["quantity"] =
            (currentQuantity + 1)
                .toString(); // Convert back to string if necessary
        itemExists = true;
        break;
      }
    }

    // If the item is not in the cart, add it with quantity = 1
    if (!itemExists) {
      cartItems.add({
        "image": image,
        "title": title,
        "description": description,
        "price": price,
        "quantity": "1", // Store as a string for consistency
      });
    }

    print(
      "Added to Cart: $title (Quantity: ${cartItems.firstWhere((item) => item['title'] == title)["quantity"]})",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Image.asset(
                        'assets/images/farm.png',
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        top: 40,
                        left: 10,
                        child: IconButton(
                          icon: Icon(Icons.arrow_back, color: Colors.black),
                          onPressed: () {
                            Navigator.pop(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const BrowseFarmsPage(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Nike’s Farm",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Fredoka",
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Welcome to my farm, where we grow fresh, organic fruits and vegetables with love. We offer a variety of seasonal produce, including tomatoes, carrots, apples, and berries—harvested fresh for you!",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                            fontFamily: "Fredoka",
                          ),
                        ),
                        SizedBox(height: 20),

                        /// 🔹 **Product Cards**
                        ProductCard(
                          image: 'assets/images/tomatoes.png',
                          title: 'Tomatoes',
                          description:
                              'Fresh tomatoes - locally, organically grown',
                          price: '₹20.02/kg',
                          onAdd: addToCart,
                        ),
                        ProductCard(
                          image: 'assets/images/carrots.png',
                          title: 'Carrots',
                          description: 'Fresh carrots - organic and sweet',
                          price: '₹50.00/kg',
                          onAdd: addToCart,
                        ),
                        ProductCard(
                          image: 'assets/images/bananas.png',
                          title: 'Bananas',
                          description: 'Fresh bananas - Yellow and juicy',
                          price: '₹30.00/kg',
                          onAdd: addToCart,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.grey.shade300, width: 1),
              ),
            ),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CartPage()),
                );
              },
              icon: Icon(Icons.shopping_cart, color: Colors.black),
              label: Text(
                "Go to Cart",
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: "Fredoka",
                  fontWeight: FontWeight.w500,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String image;
  final String title;
  final String description;
  final String price;
  final Function(String, String, String, String) onAdd;

  ProductCard({
    required this.image,
    required this.title,
    required this.description,
    required this.price,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Image.asset(image, width: 50),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontFamily: "Fredoka",
            fontSize: 24,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              description,
              style: TextStyle(
                fontSize: 12,
                color: Colors.black,
                fontFamily: "Fredoka",
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              price,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                fontFamily: "Fredoka",
                color: Colors.green,
              ),
            ),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: () => onAdd(image, title, description, price),
          child: Text("Add"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }
}
