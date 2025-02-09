import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();

  firebase_auth.User? user;
  TextEditingController nameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  String? profilePicUrl;
  File? newProfilePic;

  final SupabaseClient supabase = SupabaseClient(
    "https://vapegcaahfkcvynmqtku.supabase.co",
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZhcGVnY2FhaGZrY3Z5bm1xdGt1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzkwNjUyOTcsImV4cCI6MjA1NDY0MTI5N30.xoyPWA6cV4II4sbHYLzpA2S7tuS0Qm3XwczyK9fO2lw"
  );

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user!.uid).get();

      if (userDoc.exists) {
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
        setState(() {
          nameController.text = data['name'] ?? "";
          bioController.text = data['bio'] ?? "";
          profilePicUrl = data['profilePicUrl'];
        });
      }
    }
  }

  Future<void> _pickImage() async {
    XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        newProfilePic = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadToSupabase() async {
    if (newProfilePic == null || user == null) return null;

    String path = "profile_pics/${user!.uid}.jpg";
    await supabase.storage.from("profile_pics").upload(path, newProfilePic!,
        fileOptions: const FileOptions(upsert: true));

    return supabase.storage.from("profile_pics").getPublicUrl(path);
  }

  Future<void> _saveProfile() async {
    if (user != null) {
      String? uploadedPicUrl = await _uploadToSupabase();

      await _firestore.collection('users').doc(user!.uid).set({
        'name': nameController.text,
        'bio': bioController.text,
        'profilePicUrl': uploadedPicUrl ?? profilePicUrl,
      }, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: const Text("Profil berhasil disimpan!"))
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: newProfilePic != null
                    ? FileImage(newProfilePic!)
                    : (profilePicUrl != null
                        ? NetworkImage(profilePicUrl!) as ImageProvider
                        : const AssetImage("assets/default_avatar.png")),
              ),
            ),
            const SizedBox(height: 10),
            const Text("Ganti foto profil"),
            const SizedBox(height: 20),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Nama"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: bioController,
              decoration: const InputDecoration(labelText: "Biodata"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveProfile,
              child: const Text("Simpan Profile")
            )
          ],
        ),
      ),
    );
  }
}
