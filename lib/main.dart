//import 'package:farm_hub/front_screen.dart';
//import 'package:farm_hub/location_page.dart';
// import 'package:farm_hub/location_page.dart';
// import 'package:farm_hub/payment_successful_page.dart';
import 'package:farm_hub/consumer_farmer_login_page.dart';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ConsumerFarmerLoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
