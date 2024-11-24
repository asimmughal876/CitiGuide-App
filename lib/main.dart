//import 'package:citi_guide_app/home.dart';
//import 'package:citi_guide_app/Aboutus.dart';
import 'package:citi_guide_app/admin.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Citi Guide",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color.fromARGB(
              255, 185, 233, 255), // AppBar background color
        ),

        //body: const HomePage(),
        //body: const Aboutus(),
        body: const AdminDashboard(),
      ),
    );
  }
}
