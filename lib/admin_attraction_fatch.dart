import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloudinary_public/cloudinary_public.dart';

class AdminAttractionFetch extends StatefulWidget {
  const AdminAttractionFetch({super.key});

  @override
  State<AdminAttractionFetch> createState() => _AdminAttractionFetchState();
}

class _AdminAttractionFetchState extends State<AdminAttractionFetch> {
  final DatabaseReference attractionRef =
      FirebaseDatabase.instance.ref().child('attraction');
  final ImagePicker _picker = ImagePicker();
  final cloudinary = CloudinaryPublic('djhjm9vtp', 'images', cache: false);

  List<Map<String, dynamic>> attractions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAttractions();
  }

  Future<void> fetchAttractions() async {
  try {
    final snapshot = await attractionRef.get();
    if (snapshot.value == null) {
      setState(() {
        attractions = [];
        isLoading = false;
      });
      print('No data available');
      return;
    }

    // Ensure snapshot.value is a Map
    final data = Map<dynamic, dynamic>.from(snapshot.value as Map);

    setState(() {
      attractions = data.entries.map((entry) {
        final value = Map<String, dynamic>.from(entry.value);
        return {
          'key': entry.key,
          ...value,
        };
      }).toList();
      isLoading = false;
    });
  } catch (e) {
    print('Error fetching attractions: $e');
    setState(() {
      isLoading = false;
    });
  }
}


  Future<void> deleteAttraction(String key) async {
    try {
      await attractionRef.child(key).remove();
      setState(() {
        attractions.removeWhere((attraction) => attraction['key'] == key);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Attraction deleted successfully')),
      );
    } catch (e) {
      print('Error deleting attraction: $e');
    }
  }

  Future<void> updateAttraction(
      String key, Map<String, dynamic> updatedData) async {
    try {
      await attractionRef.child(key).update(updatedData);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Attraction updated successfully')),
      );
      fetchAttractions(); // Refresh the list
    } catch (e) {
      print('Error updating attraction: $e');
    }
  }

  Future<String?> uploadToCloudinary(XFile? image) async {
    if (image == null) return null;

    try {
      final response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          image.path,
          folder: 'attraction',
          resourceType: CloudinaryResourceType.Image,
        ),
      );
      return response.secureUrl;
    } catch (e) {
      print('Error uploading to Cloudinary: $e');
      return null;
    }
  }

  Future<void> showEditDialog(Map<String, dynamic> attraction) async {
    final titleController = TextEditingController(text: attraction['title']);
    final descController =
        TextEditingController(text: attraction['description']);
    final latController = TextEditingController(text: attraction['latitude']);
    final lngController = TextEditingController(text: attraction['longitude']);
    XFile? updatedImage;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Attraction'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: descController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: latController,
                  decoration: const InputDecoration(labelText: 'Latitude'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: lngController,
                  decoration: const InputDecoration(labelText: 'Longitude'),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () async {
                    updatedImage =
                        await _picker.pickImage(source: ImageSource.gallery);
                  },
                  child: const Text('Change Image'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();

                String? imageUrl = attraction['image'];
                if (updatedImage != null) {
                  imageUrl = await uploadToCloudinary(updatedImage);
                }

                final updatedData = {
                  'title': titleController.text,
                  'description': descController.text,
                  'latitude': latController.text,
                  'longitude': lngController.text,
                  'image': imageUrl,
                };

                await updateAttraction(attraction['key'], updatedData);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Attractions'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : attractions.isEmpty
              ? const Center(child: Text('No attractions available'))
              : ListView.builder(
                  itemCount: attractions.length,
                  itemBuilder: (context, index) {
                    final attraction = attractions[index];
                    return Card(
                      margin: const EdgeInsets.all(8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(attraction['image']),
                        ),
                        title: Text(attraction['title']),
                        subtitle: Text(attraction['description']),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => showEditDialog(attraction),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => deleteAttraction(attraction['key']),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
