import 'package:citi_guide_app/admincards.dart';
import 'package:citi_guide_app/contact_fetch.dart';
import 'package:flutter/material.dart';
import 'package:citi_guide_app/a_category_form.dart';
import 'package:citi_guide_app/admin_attraction_fatch.dart';
import 'package:citi_guide_app/admin_attraction_form.dart';
import 'package:citi_guide_app/admin_review_attrctn_fatch.dart';
import 'package:citi_guide_app/cities_form.dart';
import 'package:citi_guide_app/admin_city_fatch.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0; 

  final List<Widget> _pages = [
    const AdminCard(),
    const AttractionForm(),
    const ACategoryForm(),
    const AdminAttractionFetch(),
    const AdminReviewAttrctnFatch(),
    const CitiesForm(),
    const AdminCityFatch(),
    const ContactFetchPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.all(0),
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Admin Panel',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
                ListTile(
              title: const Text('Admin Dashboard '),
              onTap: () {
                _onItemTapped(0);
                Navigator.of(context).pop(); // Close the drawer
              },
            ),
            ListTile(
              title: const Text('Attraction Form'),
              onTap: () {
                _onItemTapped(1);
                Navigator.of(context).pop(); // Close the drawer
              },
            ),
            ListTile(
              title: const Text('Attraction Category'),
              onTap: () {
                _onItemTapped(2);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: const Text('Attraction Fetching'),
              onTap: () {
                _onItemTapped(3);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: const Text('Attraction Reviews'),
              onTap: () {
                _onItemTapped(4);
                Navigator.of(context).pop();
              },
            ),
           ListTile(
              title: const Text('City Form'),
              onTap: () {
                _onItemTapped(5);
                Navigator.of(context).pop();
              },
            ),
             ListTile(
              title: const Text('City Fetch'),
              onTap: () {
                _onItemTapped(6);
                Navigator.of(context).pop();
              },
            ),
               ListTile(
              title: const Text('Contact Message'),
              onTap: () {
                _onItemTapped(7);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex]
    );
  }
}
