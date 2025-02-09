import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

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
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...");

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
          const SnackBar(content: Text("Profile berhasil disimpan!")));

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50], // Warna latar belakang lembut
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: Colors.green[400],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Foto Profil
            GestureDetector(
              onTap: _pickImage,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: newProfilePic != null
                        ? FileImage(newProfilePic!)
                        : (profilePicUrl != null
                            ? NetworkImage(profilePicUrl!) as ImageProvider
                            : const AssetImage("assets/default_avatar.png")),
                  ),
                  const CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.white,
                    child:
                        Icon(Icons.camera_alt, color: Colors.green, size: 20),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Ubah Foto Profil",
              style: TextStyle(fontSize: 14, color: Colors.green),
            ),
            const SizedBox(height: 20),

            // Input Nama
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Nama",
                prefixIcon: const Icon(Icons.person, color: Colors.green),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Input Biodata
            TextField(
              controller: bioController,
              decoration: InputDecoration(
                labelText: "Biodata",
                prefixIcon: const Icon(Icons.info, color: Colors.green),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Tombol Simpan
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[400],
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Simpan Perubahan",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
