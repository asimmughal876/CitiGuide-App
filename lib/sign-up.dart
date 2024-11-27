import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:citi_guide_app/profile_page.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  // Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final DatabaseReference _usersRef = FirebaseDatabase.instance.ref().child('Users');
  final cloudinary = CloudinaryPublic(
    'ds4zxcjpa', // Replace with your Cloudinary cloud name
    'Profile', // Replace with your upload preset
    cache: false,
  );

  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;
  String? _imageUrl;
  bool _isUploading = false;

  Future<void> register(BuildContext context) async {
    try {
      if (passwordController.text != confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Confirm Password does not match")),
        );
        return;
      }

      if (_imageFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select a profile image")),
        );
        return;
      }

      // Start uploading the image
      setState(() => _isUploading = true);
      _imageUrl = await _uploadToCloudinary();
      if (_imageUrl == null) throw Exception('Failed to upload image');

      // Create Firebase user
      UserCredential user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Save user data to Firebase
      await _usersRef.child(user.user!.uid).set({
        'name': nameController.text,
        'email': emailController.text,
        'phone': phoneController.text,
        'imageUrl': _imageUrl, // Save image URL
      });

      // Save user data to SharedPreferences
      SharedPreferences storage = await SharedPreferences.getInstance();
      await storage.setString("user", user.user!.uid);
      await storage.setString("name", nameController.text);
      await storage.setString("email", emailController.text);
      await storage.setString("phone", phoneController.text);
      await storage.setString("imageUrl", _imageUrl!);

      // Navigate to Profile Page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => _isUploading = false);
    }
  }

  Future<String?> _uploadToCloudinary() async {
    if (_imageFile == null) return null;

    try {
      CloudinaryResponse response;
      if (kIsWeb) {
        final bytes = await _imageFile!.readAsBytes();
        response = await cloudinary.uploadFile(
          CloudinaryFile.fromBytesData(
            bytes,
            identifier: 'profile_image',
            folder: 'profiles',
            resourceType: CloudinaryResourceType.Image,
          ),
        );
      } else {
        response = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(
            _imageFile!.path,
            folder: 'profiles',
            resourceType: CloudinaryResourceType.Image,
          ),
        );
      }
      return response.secureUrl;
    } catch (e) {
      print('Error uploading to Cloudinary: $e');
      return null;
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1080,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _imageFile = pickedFile;
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(35.0),
        child: Column(
          children: [
            // Image preview
            if (_imageFile != null) ...[
              kIsWeb
                  ? Image.network(_imageFile!.path, height: 150)
                  : Image.file(File(_imageFile!.path), height: 150),
              const SizedBox(height: 10),
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Gallery'),
                ),
              ],
            ),
            const SizedBox(height: 15),
            _buildTextField(nameController, 'Name', Icons.person),
            const SizedBox(height: 15),
            _buildTextField(emailController, 'Email', Icons.email),
            const SizedBox(height: 15),
            _buildTextField(phoneController, 'Phone Number', Icons.phone),
            const SizedBox(height: 15),
            _buildTextField(passwordController, 'Password', Icons.lock, isPassword: true),
            const SizedBox(height: 15),
            _buildTextField(confirmPasswordController, 'Confirm Password', Icons.lock, isPassword: true),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isUploading ? null : () => register(context),
              child: _isUploading
                  ? const CircularProgressIndicator()
                  : const Text("Sign up"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isPassword = false}) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.blue),
        labelText: label,
        hintText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
    );
  }
}
