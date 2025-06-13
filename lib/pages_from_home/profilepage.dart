import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logindemo/auth/auth_screen.dart';

class Profilepage extends StatefulWidget {
  final Map<String, String> creator;

  const Profilepage({super.key, required this.creator});

  @override
  State<Profilepage> createState() => _ProfilepageState();
}

class _ProfilepageState extends State<Profilepage> {
  String? profileImageUrl;

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final collection =
        widget.creator['gender'] == 'Male' ? 'users_male' : 'users_female';
    final doc =
        await FirebaseFirestore.instance.collection(collection).doc(uid).get();
    setState(() {
      profileImageUrl = doc['photoUrl'];
    });
  }

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final file = File(picked.path);
      final ref = FirebaseStorage.instance.ref().child(
        'profile_images/$uid.jpg',
      );
      await ref.putFile(file);
      final downloadUrl = await ref.getDownloadURL();

      final collection =
          widget.creator['gender'] == 'Male' ? 'users_male' : 'users_female';
      await FirebaseFirestore.instance.collection(collection).doc(uid).update({
        'photoUrl': downloadUrl,
      });

      setState(() {
        profileImageUrl = downloadUrl;
      });
    }
  }

  void logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const AuthScreen()),
      (Route<dynamic> route) => false,
    );
  }

  Future<void> deleteAccount() async {
    final user = FirebaseAuth.instance.currentUser!;
    final uid = user.uid;
    final collection =
        widget.creator['gender'] == 'Male' ? 'users_male' : 'users_female';

    await FirebaseFirestore.instance.collection(collection).doc(uid).delete();
    await user.delete();
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  void editInfo() {
    final nameController = TextEditingController(text: widget.creator['name']);
    final mobileController = TextEditingController(
      text: widget.creator['mobile'],
    );
    final dobController = TextEditingController(text: widget.creator['dob']);

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Edit Profile"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "Name"),
                ),
                TextField(
                  controller: mobileController,
                  decoration: const InputDecoration(labelText: "Mobile"),
                  keyboardType: TextInputType.phone,
                ),
                TextField(
                  controller: dobController,
                  decoration: const InputDecoration(
                    labelText: "DOB (YYYY-MM-DD)",
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () async {
                  final uid = FirebaseAuth.instance.currentUser!.uid;
                  final collection =
                      widget.creator['gender'] == 'Male'
                          ? 'users_male'
                          : 'users_female';

                  // Calculate new age
                  final newDob = DateTime.tryParse(dobController.text);
                  final newAge =
                      newDob != null ? DateTime.now().year - newDob.year : 0;

                  await FirebaseFirestore.instance
                      .collection(collection)
                      .doc(uid)
                      .update({
                        'name': nameController.text.trim(),
                        'mobile': mobileController.text.trim(),
                        'dob': dobController.text.trim(),
                        'age': newAge,
                      });

                  // Update local UI state
                  setState(() {
                    widget.creator['name'] = nameController.text.trim();
                    widget.creator['mobile'] = mobileController.text.trim();
                    widget.creator['dob'] = dobController.text.trim();
                    widget.creator['age'] = newAge.toString();
                  });

                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Profile updated successfully"),
                    ),
                  );
                },
                child: const Text("Save"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 182, 206, 222),
      appBar: AppBar(
        title: Text(widget.creator['name'] ?? ''),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(onPressed: editInfo, icon: const Icon(Icons.edit)),
          IconButton(onPressed: deleteAccount, icon: const Icon(Icons.delete)),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickAndUploadImage,
              child: CircleAvatar(
                radius: 60,
                backgroundImage:
                    profileImageUrl != null
                        ? NetworkImage(profileImageUrl!)
                        : const AssetImage('assets/user_default.png')
                            as ImageProvider,
              ),
            ),
            const SizedBox(height: 20),
            _infoTile(Icons.person, 'Name', widget.creator['name']),
            _infoTile(Icons.phone, 'Mobile', widget.creator['mobile']),
            _infoTile(Icons.cake, 'DOB', widget.creator['dob']),
            _infoTile(Icons.group, 'Gender', widget.creator['gender']),
            _infoTile(Icons.cake_outlined, 'Age', widget.creator['age']),
            _infoTile(Icons.email, 'Email', widget.creator['email']),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () => logout(context),
              icon: const Icon(Icons.logout),
              label: const Text("Logout"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 77, 170, 194),
              ),
            ),
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
