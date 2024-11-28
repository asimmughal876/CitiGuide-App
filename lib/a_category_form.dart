import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ACategoryForm extends StatefulWidget {
  const ACategoryForm({super.key});

  @override
  State<ACategoryForm> createState() => _CitiesFormState();
}

class _CitiesFormState extends State<ACategoryForm> {
  final attraction_name = TextEditingController();
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref().child('attraction_category');
  Future<void> add(BuildContext context) async {
    if(attraction_name.text.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
      const  SnackBar(content: Text("Please fill the Text Field"))
      );
    }
    try{
      await _databaseReference.push().set({
        'a_category' : attraction_name.text
      });
      attraction_name.clear();
        ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Atrraction Category Added Successfully"))
      );
    }
    catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"))
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                "Atrration Category Form",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: attraction_name,
                cursorColor:
                    const Color.fromRGBO(244, 65, 83, 1), 
                decoration: InputDecoration(
                    labelText: "Atrration Category",
                    hintText: "Enter atrration category",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.black,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    labelStyle: TextStyle(color: Colors.grey[900])),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  add(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(244, 65, 83, 1),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                ),
                child: const Text(
                  "Submit",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
