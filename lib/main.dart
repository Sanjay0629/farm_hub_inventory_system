import 'package:farm_hub/ai_chat_screen.dart';
import 'package:farm_hub/farm_account.dart';
import 'package:farm_hub/firebase_options.dart';
import 'package:farm_hub/front_screen.dart';
import 'package:farm_hub/inventory_screen.dart';
import 'package:farm_hub/log_in.dart';
import 'package:farm_hub/sign_in.dart';
import 'package:farm_hub/sign_in_farmer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'selection_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //print("🔥 Firebase Connected Successfully!");
  runApp(MyApp());
}
//options: DefaultFirebaseOptions.currentPlatform

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: InventoryScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
// import 'package:farm_hub/log_in.dart';
// import 'package:farm_hub/sign_in.dart';
// import 'package:farm_hub/sign_in_farmer.dart';
// import 'package:flutter/material.dart';
// import 'selection_page.dart';
// // import 'log_in.dart';
// // import 'sign_in.dart';
// // import 'sign_in_farmer.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'FarmHub Authentication',
//       theme: ThemeData(primarySwatch: Colors.green),
//       initialRoute: '/',
//       routes: {
//         '/': (context) => SelectionPage(),
//         '/login':
//             (context) => LoginPage(userType: 'Consumer'), // Default to Consumer
//         '/signup_consumer': (context) => SignUpConsumer(),
//         '/signup_farmer': (context) => SignUpFarmer(),
//       },
//     );
//   }
// }
