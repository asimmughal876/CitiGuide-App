import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController passwordController;

  String? profileImageURL;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    passwordController = TextEditingController();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DatabaseReference userRef = FirebaseDatabase.instance.ref().child('Users').child(user.uid);
      DataSnapshot snapshot = await userRef.get();

      if (snapshot.exists) {
        Map userData = snapshot.value as Map;
        setState(() {
          nameController.text = userData['name'] ?? '';
          emailController.text = userData['email'] ?? '';
          phoneController.text = userData['phone'] ?? '';
          profileImageURL = userData['imageUrl']; // Fetching the profile image URL
        });
      }
    }
  }

  Future<void> _updateProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await prefs.setString("name", nameController.text);
      await prefs.setString("email", emailController.text);
      await prefs.setString("phone", phoneController.text);

      DatabaseReference userRef = FirebaseDatabase.instance.ref().child('Users').child(user.uid);
      await userRef.update({
        'name': nameController.text,
        'email': emailController.text,
        'phone': phoneController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User not logged in!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Profile', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.blue,
                backgroundImage: profileImageURL != null
                    ? NetworkImage(profileImageURL!)
                    : null,
                child: profileImageURL == null
                    ? const Icon(Icons.person, size: 40, color: Colors.white)
                    : null,
              ),
              const SizedBox(height: 10),
              Text(
                nameController.text.isEmpty ? 'Username' : nameController.text,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(height: 20),
              _buildTextField(nameController, 'Name', Icons.person),
              const SizedBox(height: 15),
              _buildTextField(emailController, 'Email', Icons.email),
              const SizedBox(height: 15),
              _buildTextField(phoneController, 'Phone Number', Icons.phone),
              const SizedBox(height: 15),
              _buildTextField(passwordController, 'Password', Icons.lock, isPassword: true),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await _updateProfileData();
                },
                child: const Text("Save Changes"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, IconData icon, {bool isPassword = false}) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.blue),
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
    );
  }
}
