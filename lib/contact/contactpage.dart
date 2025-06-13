import 'package:flutter/material.dart';
import 'creatordetailspage.dart'; // import your detail page

class ContactPage extends StatelessWidget {
  final List<Map<String, String>> creators;

  const ContactPage({super.key, required this.creators});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 182, 206, 222),
      appBar: AppBar(
        title: const Text('Contact Us'),
        backgroundColor: Colors.transparent,
      ),
      body: ListView.builder(
        itemCount: creators.length,
        itemBuilder: (context, index) {
          final creator = creators[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(creator['image']!),
            ),
            title: Text(creator['name']!, style: TextStyle(fontSize: 20)),
            subtitle: Text(creator['role'] ?? ''),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CreatorDetailPage(creator: creator),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
