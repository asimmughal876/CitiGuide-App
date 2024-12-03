import 'package:citi_guide_app/faqs.dart';
import 'package:citi_guide_app/profile_page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:citi_guide_app/home.dart';
import 'package:citi_guide_app/aboutUs.dart';
import 'package:citi_guide_app/contact%20us.dart';
import 'package:citi_guide_app/login.dart';
import 'package:citi_guide_app/sign-up.dart';
import 'package:citi_guide_app/notification.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key, this.child, this.initialScreenIndex = 0});

  final Widget? child;
  final int initialScreenIndex;

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref().child('notification');
  int? previousCount;
  int currentCount = 0;
  bool showBadge = false;

  bool isUserLoggedIn = false;

  // Declare the screens inside the state
  late List<Widget> _screens;

  // Async check for user login state.
  Future<void> checkUserLoggedIn() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    String? user = await storage.getString('user');
    setState(() {
      isUserLoggedIn = user != null;
    });
  }

  Future<void> _checknotification() async {
    SharedPreferences storage = await SharedPreferences.getInstance();

    previousCount = storage.getInt('n_count') ?? 0;

    final snapshot = await _databaseReference.get();
    if (snapshot.exists) {
      final Map<dynamic, dynamic> categoryMap =
          snapshot.value as Map<dynamic, dynamic>;
      currentCount = categoryMap.length;

      if (currentCount > (previousCount ?? 0)) {
        setState(() {
          showBadge = true;
        });
      } else {
        setState(() {
          showBadge = false;
        });
      }
    }
  }

  int _currentScreen = 0;

  @override
  void initState() {
    super.initState();
    _currentScreen = widget.initialScreenIndex;

    // Check user login status
    checkUserLoggedIn().then((_) {
      setState(() {
        _screens = isUserLoggedIn
            ? [
                const HomePage(),
                const AboutUs(),
                const ContactUsApp(),
                const Faqs(),
                const ProfilePage(),
              ]
            : [
                const HomePage(),
                const AboutUs(),
                const ContactUsApp(),
                const Faqs(),
                const SignUp(),
                const Login(),
              ];
      });
      _checknotification();
    });
  }

  void _navigateTo(int index) {
    setState(() {
      _currentScreen = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Widget body = widget.child ?? IndexedStack(
      index: _currentScreen,
      children: _screens,
    );

    return Scaffold(
      appBar: AppBar(
        title:Image.network(
        'https://res.cloudinary.com/dgexlc4gh/image/upload/v1733056082/logo_aijv6o.png',
        height: 40,
        width: 40, color: Colors.white,
        fit: BoxFit.contain,
      ),
        backgroundColor: const Color.fromARGB(255, 0, 149, 255),
        actions: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications, color: Colors.white),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AppNotification(),
                    ),
                  );
                  _checknotification();
                },
              ),
              if (showBadge)
                Positioned(
                  right: 4,
                  top: 4,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 10,
                      minHeight: 10,
                    ),
                    child: Text(
                      '${currentCount - (previousCount ?? 0)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentScreen,
        onTap: (index) {
          if (widget.child != null) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => BottomNav(initialScreenIndex: index),
              ),
            );
          } else {
            _navigateTo(index);
          }
        },
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: "About Us",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.phone),
            label: "Contact",
          ),
         const BottomNavigationBarItem(
            icon: Icon(Icons.question_answer),
            label: "Faqs",
          ),
          if (isUserLoggedIn) // Show Profile Page if logged in
            const BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: "Profile",
            ),
          if (!isUserLoggedIn) // Show SignUp or Login if not logged in
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_add_alt_1),
              label: "Sign Up",
            ),
          if (!isUserLoggedIn)
            const BottomNavigationBarItem(
              icon: Icon(Icons.login),
              label: "Login",
            ),
        ],
        selectedItemColor: const Color.fromARGB(255, 0, 149, 255),
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: false,
      ),
    );
  }
}
