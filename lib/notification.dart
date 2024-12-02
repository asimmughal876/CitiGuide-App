import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppNotification extends StatefulWidget {
  const AppNotification({super.key});

  @override
  State<AppNotification> createState() => _AppNotificationState();
}

class _AppNotificationState extends State<AppNotification> {
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref().child('notification');
  List<Map<String, dynamic>> notification = [];
  bool? new_a = false;

  Future<void> _fetchnotification() async {
    try {
      final snapshot = await _databaseReference.get();
      if (snapshot.exists) {
        final Map<dynamic, dynamic> categoryMap =
            snapshot.value as Map<dynamic, dynamic>;
        final notifications = categoryMap.entries.map((entry) {
          return {
            'title': entry.value['title'],
            'desc': entry.value['description'],
            'category': entry.value['category'],
          };
        }).toList();

        SharedPreferences storage = await SharedPreferences.getInstance();
        int? storedCount = storage.getInt('n_count');

        if (storedCount != null && storedCount < notifications.length) {
          setState(() {
            new_a = true;
          });
        }

        storage.remove('n_count');
        storage.setInt('n_count', notifications.length);

        setState(() {
          notification = notifications;
        });
      }
    } catch (e) {
      print("Error fetching notifications: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchnotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: notification.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: notification.length,
              itemBuilder: (context, index) {
                final item = notification[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title'] ?? 'No Title',
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          item['desc'] != null && item['desc'].length > 100
                              ? "${item['desc'].substring(0, 100)}..." // Truncate
                              : item['desc'] ?? 'No Description',
                          style: const TextStyle(fontSize: 14.0),
                        ),
                        if (item['desc'] != null && item['desc'].length > 100)
                          TextButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text(item['title'] ?? 'No Title'),
                                  content:
                                      Text(item['desc'] ?? 'No Description'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: const Text('Close'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: const Text(
                              "Read more",
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        const SizedBox(height: 8.0),
                        new_a == true
                            ? Text(
                                "New ${item['category']?? 'No Category'} has been Added",
                                style: const TextStyle(color: Colors.blue),
                              )
                            : Text(
                                item['category'] ?? 'No Category',
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
