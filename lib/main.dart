import 'package:citi_guide_app/firebase_options.dart';
import 'package:citi_guide_app/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

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
      home: Scaffold(
          appBar: AppBar(
          title: const Text("Citi Guide" ,style: TextStyle(color: Colors.white),),
          backgroundColor: const Color.fromRGBO(244, 65, 83, 1),
        ),

        body: const HomePage(),
      ),
    );
  }
}