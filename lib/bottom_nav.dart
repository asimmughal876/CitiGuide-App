import 'package:citi_guide_app/contact%20us.dart';
import 'package:flutter/material.dart';
import 'package:citi_guide_app/home.dart';
import 'package:citi_guide_app/aboutUs.dart';
import 'package:citi_guide_app/login.dart';
import 'package:citi_guide_app/sign-up.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _currentScreen = 0;
  final List<Widget> _screens = [
    const HomePage(),
    const Aboutus(),
    const ContactUsApp(),
    const SignUp(),
    const Login(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentScreen,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentScreen,
        onTap: (int screen) {
          setState(() {
            _currentScreen = screen;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: "About Us",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.phone),
            activeIcon: Icon(Icons.phone),
            label: "Contact",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add_alt_1),
            label: "Sign Up",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.login),
            label: "Login",
          ),
        ],
        selectedItemColor:const Color.fromARGB(255, 0, 149, 255),
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: false,
      ),
    );
  }
}
