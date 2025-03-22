import 'package:farm_hub/buyingpage.dart';
import 'package:farm_hub/cart_page.dart';
import 'package:farm_hub/front_screen.dart';
import 'package:farm_hub/location_page.dart';
import 'package:farm_hub/location_page.dart';
import 'package:farm_hub/payment_successful_page.dart';
import 'package:farm_hub/consumer_farmer_login_page.dart';
import 'package:farm_hub/browse_farm_page.dart';
import 'get_location.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: BuyingPage(), debugShowCheckedModeBanner: false);
  }
}
