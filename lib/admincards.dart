import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AdminCard extends StatefulWidget {
  const AdminCard({super.key});

  @override
  _AdminCardState createState() => _AdminCardState();
}

class _AdminCardState extends State<AdminCard> {
  int usercount = 0;
  final DatabaseReference userRef = FirebaseDatabase.instance.ref().child('Users');
    int attractioncount = 0;
  final DatabaseReference attractionRef = FirebaseDatabase.instance.ref().child('attraction');
   int cititescount = 0;
  final DatabaseReference cititesRef = FirebaseDatabase.instance.ref().child('cities');

  @override
  void initState() {
    super.initState();
    _checkusers();
    _checkattraction();
    _checkcities();
  }

  Future<void> _checkusers() async {
    final snapshot = await userRef.get();
    if (snapshot.exists) {
      final Map<dynamic, dynamic> userMap = snapshot.value as Map<dynamic, dynamic>;
      setState(() {
        usercount = userMap.length;
      });
    }
  }
    Future<void> _checkattraction() async {
    final snapshot = await attractionRef.get();
    if (snapshot.exists) {
      final Map<dynamic, dynamic> attractionMap = snapshot.value as Map<dynamic, dynamic>;
      setState(() {
        attractioncount = attractionMap.length;
      });
    }
  }
    Future<void> _checkcities() async {
    final snapshot = await cititesRef.get();
    if (snapshot.exists) {
      final Map<dynamic, dynamic> cititesMap = snapshot.value as Map<dynamic, dynamic>;
      setState(() {
        cititescount = cititesMap.length;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          crossAxisCount: 2, 
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          children: <Widget>[
            _buildDashboardCard('User', Icons.person, usercount),
            _buildDashboardCard('Attraction', Icons.place, attractioncount),
            _buildDashboardCard('Cities', Icons.location_city, cititescount),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard(String title, IconData icon, int index) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                icon,
                size: 50,
                color: Colors.blue,
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  index.toString(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
