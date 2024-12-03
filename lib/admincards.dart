import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AdminCard extends StatefulWidget {
  const AdminCard({super.key});

  @override
  _AdminCardState createState() => _AdminCardState();
}

class _AdminCardState extends State<AdminCard> {
  int usercount = 0;
  final DatabaseReference userRef =
      FirebaseDatabase.instance.ref().child('Users');
  int attractioncount = 0;
  final DatabaseReference attractionRef =
      FirebaseDatabase.instance.ref().child('attraction');
  int citiescount = 0;
  final DatabaseReference citiesRef =
      FirebaseDatabase.instance.ref().child('cities');

  @override
  void initState() {
    super.initState();
    _fetchCounts();
  }

  Future<void> _fetchCounts() async {
    await Future.wait([
      _checkUsers(),
      _checkAttraction(),
      _checkCities(),
    ]);
  }

  Future<void> _checkUsers() async {
    final snapshot = await userRef.get();
    if (snapshot.exists && snapshot.value is Map) {
      setState(() {
        usercount = (snapshot.value as Map).length;
      });
    } else {
      setState(() {
        usercount = 0; // Handle case where no users exist
      });
    }
  }

  Future<void> _checkAttraction() async {
    final snapshot = await attractionRef.get();
    if (snapshot.exists && snapshot.value is Map) {
      setState(() {
        attractioncount = (snapshot.value as Map).length;
      });
    } else {
      setState(() {
        attractioncount = 0; // Handle case where no attractions exist
      });
    }
  }

  Future<void> _checkCities() async {
    final snapshot = await citiesRef.get();
    if (snapshot.exists && snapshot.value is Map) {
      setState(() {
        citiescount = (snapshot.value as Map).length;
      });
    } else {
      setState(() {
        citiescount = 0; // Handle case where no cities exist
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.extent(
          maxCrossAxisExtent: 300,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          children: <Widget>[
            _buildDashboardCard('User', Icons.person, usercount),
            _buildDashboardCard('Attraction', Icons.place, attractioncount),
            _buildDashboardCard('Cities', Icons.location_city, citiescount),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard(String title, IconData icon, int count) {
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
              const SizedBox(height: 5),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0), // Add padding
                  child: Text(
                    count.toString(),
                    style:const TextStyle(
                      fontSize: 18, // Adjusted for better legibility
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey, // Improved contrast
                    ),
                    textAlign: TextAlign.center,
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
