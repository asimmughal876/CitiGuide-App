import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ContactFetchPage extends StatefulWidget {
  const ContactFetchPage({super.key});

  @override
  _ContactFetchPageState createState() => _ContactFetchPageState();
}

class _ContactFetchPageState extends State<ContactFetchPage> {
  final DatabaseReference _databaseRef =
      FirebaseDatabase.instance.ref().child('contact'); // Reference to 'contact'

  List<Map<dynamic, dynamic>> _messages = [];

  @override
  void initState() {
    super.initState();
    _fetchMessages();
  }

  void _fetchMessages() async {
    _databaseRef.onValue.listen((event) {
      final Map<dynamic, dynamic>? data =
          event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        setState(() {
          _messages = data.entries
              .map((entry) => {'key': entry.key, ...entry.value as Map})
              .toList();
        });
      }
    });
  }

  void _deleteMessage(String key) async {
    await _databaseRef.child(key).remove();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Message deleted!")),
    );
    _fetchMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messages'),
      ),
      body: _messages.isEmpty
          ? Center(child: Text('No messages found!'))
          : ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text("${message['name']} ${message['lastname']}"),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Email: ${message['email']}"),
                        Text("Message: ${message['mess']}"),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteMessage(message['key']),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
