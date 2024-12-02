import 'package:citi_guide_app/bottom_nav.dart';
import 'package:citi_guide_app/notification.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref().child('notification');
  int? previousCount;
  int currentCount = 0;
  bool showBadge = false;

  @override
  void initState() {
    super.initState();
    _checknotification();
  }


  Future<void> _checknotification() async {
    SharedPreferences storage = await SharedPreferences.getInstance();

    previousCount = storage.getInt('n_count') ?? 0;

    final snapshot = await _databaseReference.get();
    if (snapshot.exists) {
      final Map<dynamic, dynamic> categoryMap = snapshot.value as Map<dynamic, dynamic>;
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

@override
Widget build(BuildContext context) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Builder(
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: const Text(
            "Citi Guide",
            style: TextStyle(color: Colors.white),
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
                        minWidth: 20,
                        minHeight: 20,
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
        body: const BottomNav(),

      ),
    ),
  );
}
}