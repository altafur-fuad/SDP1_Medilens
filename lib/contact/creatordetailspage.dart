import 'package:flutter/material.dart';

class CreatorDetailPage extends StatelessWidget {
  final Map<String, String> creator;

  const CreatorDetailPage({super.key, required this.creator});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 182, 206, 222),
      appBar: AppBar(
        title: Text(creator['name'] ?? ''),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage(creator['image'] ?? ''),
            ),
            const SizedBox(height: 20),

            _infoTile(Icons.person, 'Name', creator['name']),
            _infoTile(Icons.phone, 'Mobile', creator['mobile']),
            _infoTile(Icons.school, 'University', creator['university']),
            _infoTile(Icons.code, 'Skills', creator['skills']),
            _infoTile(Icons.work, 'Expertise', creator['expertise']),
            _infoTile(Icons.facebook, 'Facebook', creator['facebook']),
            _infoTile(Icons.link, 'LinkedIn', creator['linkedin']),
            _infoTile(Icons.camera_alt, 'Instagram', creator['instagram']),
            _infoTile(Icons.email, 'Email', creator['email']),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(IconData icon, String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value ?? 'N/A'),
      ),
    );
  }
}
