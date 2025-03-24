import 'package:farm_hub/cart_page.dart';
// import 'package:farm_hub/get_location.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'global_variables.dart';
import 'buyingpage.dart';
import 'location_page.dart';

class BrowseFarmsPage extends StatefulWidget {
  const BrowseFarmsPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BrowseFarmsPageState createState() => _BrowseFarmsPageState();
}

class _BrowseFarmsPageState extends State<BrowseFarmsPage> {
  String currentLocation = "Fetching location...";

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        currentLocation = "Location services disabled";
      });
      return;
    }

    // Request permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          currentLocation = "Location permission denied";
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        currentLocation = "Location permanently denied";
      });
      return;
    }

    // Get current position
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // Reverse geocode to get address
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    Placemark place = placemarks[0];

    setState(() {
      currentLocation = "${place.locality}, ${place.administrativeArea}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA8DF6E),
      appBar: AppBar(
        title: Text(
          "FarmHub",
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            fontFamily: "Fredoka",
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFFA8DF6E),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(
              context,
              MaterialPageRoute(builder: (context) => const LocationPage()),
            );
          },
          icon: Icon(Icons.arrow_back, color: Colors.black),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartPage()),
              );
            },
            icon: Icon(Icons.shopping_cart, color: Colors.black),
          ),
        ],
      ),
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: const BoxDecoration(
              color: Color(0xFFA8DF6E),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     IconButton(
                //       icon: const Icon(Icons.menu, color: Colors.black),
                //       onPressed: () {},
                //     ),
                //     const Text(
                //       "FarmHub",
                //       style: TextStyle(
                //         fontSize: 22,
                //         fontWeight: FontWeight.bold,
                //         fontFamily: "Fredoka",
                //       ),
                //     ),
                //     IconButton(
                //       icon: const Icon(
                //         Icons.shopping_cart,
                //         color: Colors.black,
                //       ),
                //       onPressed: () {},
                //     ),
                //   ],
                // ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      Image.asset("assets/images/fruit_basket.png", height: 40),
                      const SizedBox(width: 10),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "TODAY'S OFFER",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            "Free fruits with every order",
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Text(
                          "OFFER",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Location Info
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                const Icon(Icons.location_on, color: Colors.black),
                const SizedBox(width: 5),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Near You",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(currentLocation, style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Farm Cards Grid (Covers Full Screen)
          Expanded(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              padding: EdgeInsets.zero,
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.7,
                ),
                itemCount: farms.length,
                itemBuilder: (context, index) {
                  final farm = farms[index];
                  return FarmCard(farm: farm);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FarmCard extends StatelessWidget {
  final Map<String, String> farm;
  const FarmCard({super.key, required this.farm});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green[200],
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BuyingPage()),
              );
            },
            child: CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(farm["image"]!),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            farm["name"]!,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontFamily: "Fredoka",
              fontSize: 20,
            ),
          ),
          Text(
            farm["location"]!,
            style: const TextStyle(
              fontSize: 14,
              fontFamily: "Fredoka",
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return Icon(
                Icons.star,
                size: 16,
                color:
                    index < int.parse(farm["rating"]!)
                        ? Colors.orange
                        : Colors.grey,
              );
            }),
          ),
          const SizedBox(height: 5),
          Text(
            "${farm["distance"]!} km",
            style: const TextStyle(
              fontSize: 18,
              fontFamily: "Fredoka",
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
