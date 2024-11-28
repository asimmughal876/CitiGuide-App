import 'package:citi_guide_app/admin_city_fatch.dart';
import 'package:flutter/material.dart';
import 'package:citi_guide_app/sign-up.dart';
import 'package:citi_guide_app/profile_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:  Scaffold(
          appBar: AppBar(
          title: const Text("Citi Guide" ,style: TextStyle(color: Colors.white),),
          backgroundColor: const Color.fromARGB(255, 244, 65, 83), // AppBar background color
         ),

        body: const AdminCityFatch(),
      ),
    );
  }
}