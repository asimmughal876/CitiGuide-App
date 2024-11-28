import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:citi_guide_app/profile_page.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

  final _formKey = GlobalKey<FormState>(); // Added global key for form validation

  // Google Sign-In setup
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: '163196966457-rug057tbccdobo1uvj2oeeq0al3qlo53.apps.googleusercontent.com',  // Replace with your Web Client ID from Firebase console
  );

  Future<void> register(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return; // If form is not valid, return without registering
    }

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

  // Google Sign-In method
  Future<void> _googleSignInMethod() async {
    try {
      // Start Google sign-in process
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return; // User canceled the sign-in process
      }

      // Obtain the Google authentication details
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential for Firebase Authentication
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      // Get user details
      User? user = userCredential.user;

      // Check if the user exists in the database, else create a new user
      if (user != null) {
        final userData = {
          'name': user.displayName ?? 'No Name',
          'email': user.email ?? 'No Email',
          'phone': 'Not Provided',
          'imageUrl': user.photoURL ?? 'No Photo',
        };
        await _usersRef.child(user.uid).set(userData);

        // Save user data to SharedPreferences
        SharedPreferences storage = await SharedPreferences.getInstance();
        await storage.setString("user", user.uid);
        await storage.setString("name", user.displayName ?? 'No Name');
        await storage.setString("email", user.email ?? 'No Email');
        await storage.setString("phone", 'Not Provided');
        await storage.setString("imageUrl", user.photoURL ?? 'No Photo');

        // Navigate to Profile Page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Google Sign-In Error: $e")),
      );
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
        child: Form( // Wrap the entire form in a Form widget
          key: _formKey, // Attach form key for validation
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
  icon: Icon(
    Icons.photo_library,
    color: const Color.fromARGB(255, 19, 70, 146), // Set the icon color
  ),
  label: Text(
    'Gallery',
    style: TextStyle(color: Colors.blue), // Set the text color
  ),
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.white, // Set the background color of the button
    foregroundColor: Colors.blue, // Set the text/icon color when not pressed
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
  ),
)

                ],
              ),
              const SizedBox(height: 15),
              _buildTextField(nameController, 'Name', Icons.person, (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              }),
              const SizedBox(height: 15),
              _buildTextField(emailController, 'Email', Icons.email, (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                return null;
              }),
              const SizedBox(height: 15),
              _buildTextField(phoneController, 'Phone Number', Icons.phone, (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your phone number';
                }
                return null;
              }),
              const SizedBox(height: 15),
              _buildTextField(passwordController, 'Password', Icons.lock, (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a password';
                }
                return null;
              }, isPassword: true),
              const SizedBox(height: 15),
              _buildTextField(confirmPasswordController, 'Confirm Password', Icons.lock, (value) {
                if (value == null || value.isEmpty) {
                  return 'Please confirm your password';
                }
                if (value != passwordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              }, isPassword: true),
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
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _googleSignInMethod,
                icon: const Icon(Icons.login),
                label: const Text('Continue with Google'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // Google color
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, String? Function(String?) validator, {bool isPassword = false}) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.blue),
        labelText: label,
        hintText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
      validator: validator,
    );
  }
}
