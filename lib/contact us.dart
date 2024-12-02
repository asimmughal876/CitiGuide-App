import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ContactUsApp extends StatelessWidget {
  const ContactUsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ContactUsPage(),
      debugShowCheckedModeBanner: false, // Remove the debug banner
    );
  }
}

class ContactUsPage extends StatelessWidget {
  final DatabaseReference _textref =
      FirebaseDatabase.instance.ref().child('contact');

  final name = TextEditingController();
  final lname = TextEditingController();
  final email = TextEditingController();
  final mess = TextEditingController();

  Future<void> addmess(BuildContext context) async {
    if (name.text.isEmpty ||
        lname.text.isEmpty ||
        email.text.isEmpty ||
        mess.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please fill all the text Field")));
      return;
    }
    await _textref.push().set({
      'name': name,
      'lastname': lname,
      'email': email,
      'mess': mess,
    });
    name.clear();
    lname.clear();
    email.clear();
    mess.clear();
    return;
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
                      labelText: 'First Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 17, vertical: 14),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: lname,
                    decoration: InputDecoration(
                      labelText: 'Last Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 17, vertical: 14),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: email,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 17, vertical: 14),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: mess,
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: 'Message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 17, vertical: 19),
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
