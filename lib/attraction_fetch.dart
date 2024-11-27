import 'dart:io';
import 'package:citi_guide_app/review_attraction.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AttractionFetch extends StatefulWidget {
  final String? cityId;

  const AttractionFetch({super.key, this.cityId});

  @override
  State<AttractionFetch> createState() => _AttractionState();
}

class _AttractionState extends State<AttractionFetch> {
  final DatabaseReference _categoryRef =
      FirebaseDatabase.instance.ref().child('attraction_category');
  final DatabaseReference attractionRef =
      FirebaseDatabase.instance.ref().child('attraction');
  Map<String, String> _categories = {};
  String? _selectedCategoryKey;
  String _searchQuery = '';
  List<Map<String, dynamic>> _attractions = [];
  bool _isLoading = false;

  Future<void> _fetchCategories() async {
    try {
      final snapshot = await _categoryRef.get();
      if (snapshot.exists) {
        final Map<dynamic, dynamic> categoriesMap = snapshot.value as Map;
        setState(() {
          _categories = categoriesMap.map((key, value) =>
              MapEntry(key.toString(), value['a_category'].toString()));
        });
      }
    } catch (e) {
      stdout.write('Error fetching categories: $e');
    }
  }

  Future<void> _fetchAttractions() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final snapshot = await attractionRef.get();
      if (snapshot.exists) {
        final Map<dynamic, dynamic> attractionsMap = snapshot.value as Map;
        setState(() {
          _attractions = attractionsMap.entries.where((entry) {
            if (widget.cityId != null) {
              return entry.value['city_key'] == widget.cityId;
            } else {
              return true;
            }
          }).map((entry) {
            return {
              'id': entry.key,
              'title': entry.value['title'],
              'description': entry.value['description'],
              'image': entry.value['image'],
              'a_category': entry.value['a_category'],
              'latitude': entry.value['latitude'],
              'longitude': entry.value['longitude'],
            };
          }).toList();
        });
      }
    } catch (e) {
      stdout.write('Error fetching attractions: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

void _showMapPopup(String? latitude, String? longitude) {
  if (latitude == null || longitude == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Invalid location data')),
    );
    return;
  }

  try {
    final double lat = double.parse(latitude);
    final double lng = double.parse(longitude);

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: EdgeInsets.zero, // Remove padding around the dialog
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(lat, lng),
              zoom: 18,
            ),
            markers: {
              Marker(
                markerId: const MarkerId('selectedLocation'),
                position: LatLng(lat, lng),
              ),
            },
            mapType: MapType.normal, // Ensure the map type shows POIs
            buildingsEnabled: true, // Enable 3D buildings (optional)
            indoorViewEnabled: true, // Enable indoor maps (optional)
            onMapCreated: (GoogleMapController controller) {
              controller.setMapStyle(null); // Default map style with POIs
            },
          ),
        );
      },
    );
  } catch (e) {
    print('Error parsing location: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error displaying location: $e')),
    );
  }
} 

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    _fetchAttractions();
  }

  @override
  Widget build(BuildContext context) {
    final filteredAttractions = _attractions.where((item) {
      final matchesCategory = _selectedCategoryKey == null ||
          item['a_category'] == _selectedCategoryKey;
      final matchesSearchQuery =
          item['title']!.toLowerCase().contains(_searchQuery) ||
              item['description']!.toLowerCase().contains(_searchQuery);
      return matchesCategory && matchesSearchQuery;
    }).toList();

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value.toLowerCase();
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search attractions...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(
                            color: Colors.black,
                          )),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                DropdownButtonHideUnderline(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(244, 65, 83, 1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: DropdownButton<String>(
                      dropdownColor: const Color.fromRGBO(244, 65, 83, 1),
                      value: _selectedCategoryKey,
                      hint: const Text(
                        'Category',
                        style: TextStyle(color: Colors.white),
                      ),
                      items: _categories.entries
                          .map((entry) => DropdownMenuItem<String>(
                                value: entry.key,
                                child: Text(entry.value),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategoryKey = value;
                        });
                      },
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.white,
                      ),
                      iconSize: 24,
                      elevation: 2,
                    ),
                  ),
                ),
              ],
            ),
          ),
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : filteredAttractions.isEmpty
                  ? const Center(
                      child: Text(
                        "No attractions found",
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: filteredAttractions.length,
                        itemBuilder: (context, index) {
                          final item = filteredAttractions[index];
                          return Card(
                            elevation: 12,
                            margin: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    topRight: Radius.circular(12),
                                  ),
                                  child: Image.network(
                                    item['image']!,
                                    height: 200,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['title']!,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        item['description']!,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color:
                                              Color.fromARGB(255, 70, 70, 70),
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: ElevatedButton(
                                              onPressed: () {
                                                _showMapPopup(item['latitude'],
                                                    item['longitude']);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              child:
                                                  const Text("View Location"),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          Expanded(
                                            child: ElevatedButton(
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ReviewAttraction(
                                                                attractionId:
                                                                    item[
                                                                        'id'])));
                                              },
                                              style: ElevatedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              child: const Text("Review"),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
        ],
      ),
    );
  }
}
