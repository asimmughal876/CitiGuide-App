import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ContactUsApp extends StatefulWidget {
  const ContactUsApp({super.key});

  @override
  State<ContactUsApp> createState() => _ContactUsAppState();
}

class _ContactUsAppState extends State<ContactUsApp> {
  final DatabaseReference _textref =
      FirebaseDatabase.instance.ref().child('contact');

  final name = TextEditingController();
  final email = TextEditingController();
  final mess = TextEditingController();

  Future<void> _loadProfileData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DatabaseReference userRef =
          FirebaseDatabase.instance.ref().child('Users').child(user.uid);
      DataSnapshot snapshot = await userRef.get();

      if (snapshot.exists) {
        Map userData = snapshot.value as Map;
        setState(() {
          name.text = userData['name'] ?? '';
          email.text = userData['email'] ?? '';
          userData['imageUrl'];
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> addmess(BuildContext context) async {
    if (name.text.isEmpty || email.text.isEmpty || mess.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please fill all the text Field")));
      return;
    }
    await _textref.push().set({
      'name': name.text,
      'email': email.text,
      'mess': mess.text,
    });
    name.clear();
    email.clear();
    mess.clear();
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all the text Field")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Image.asset(
                  'assets/images/city.jpeg',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200,
                ),
                const Positioned(
                  top: 80,
                  left: 20,
                  child: Text(
                    'Contact Us',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.all(14.0),
              child: Column(
                children: [
                  ContactCard(
                    icon: Icons.location_on,
                    title: 'Our Address',
                    details: '4023 Armrester Drive, Wilmington, CA 90744 - USA',
                  ),
                  SizedBox(height: 20),
                  ContactCard(
                    icon: Icons.phone,
                    title: 'Our Phone',
                    details: '+1 (009) 236 985\n+1 (009) 236 986-9',
                  ),
                  SizedBox(height: 20),
                  ContactCard(
                    icon: Icons.email,
                    title: 'Our Email',
                    details: 'CitiGuide@gmailcom',
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Get in touch with us',
                    style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Continue exploring the great places. Euismod tempor incididunt ut labore dolore magna aliqua sed enim audy lorem ipsum dolor.',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 25),
                  TextField(
                    controller: name,
                 decoration: InputDecoration(
                  labelText: "First Name",
                  labelStyle:const TextStyle(color: Colors.blueAccent),
                  filled: true,
                  fillColor: Colors.blue.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: email,
                    decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: const TextStyle(color: Colors.blueAccent),
                  filled: true,
                  fillColor: Colors.blue.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: mess,
                    maxLines: 4,
                  decoration: InputDecoration(
                  labelText: "Message",
                  labelStyle: const TextStyle(color: Colors.blueAccent),
                  filled: true,
                  fillColor: Colors.blue.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        addmess(context);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 0, 149, 255),
                          foregroundColor: Colors.white),
                      child: const Text('Send Message'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ContactCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String details;
  final String? actionText;

  const ContactCard({
    required this.icon,
    required this.title,
    required this.details,
    this.actionText,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.blue, size: 30),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(details),
                  if (actionText != null) ...[
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        actionText!,
                        style: const TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ]
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
