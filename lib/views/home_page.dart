import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final SupabaseClient supabase = SupabaseClient(
      "https://vapegcaahfkcvynmqtku.supabase.co",
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZhcGVnY2FhaGZrY3Z5bm1xdGt1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzkwNjUyOTcsImV4cCI6MjA1NDY0MTI5N30.xoyPWA6cV4II4sbHYLzpA2S7tuS0Qm3XwczyK9fO2lw");

  firebase_auth.User? user;
  String name = "Loading...";
  String email = "";
  String bio = "";
  String? profilePicUrl;

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
          name = data['name'] ?? "Tanpa Nama";
          email = user!.email ?? "";
          bio = data['bio'] ?? "Belum ada biodata.";
          profilePicUrl = data['profilePicUrl'];
        });
      }
    }
  }

  Widget buildJadwalHariIni() {
    DateTime today = DateTime.now();
    String todayStr = DateFormat('yyyy-MM-dd').format(today);

    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('dosen').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        var dosenDocs = snapshot.data!.docs;

        List<Widget> jadwalHariIni = [];

        for (var dosen in dosenDocs) {
          var mataKuliahList = dosen['mataKuliah'] as List<dynamic>? ?? [];

          for (var mataKuliah in mataKuliahList) {
            var pertemuanList = mataKuliah['pertemuan'] as List<dynamic>? ?? [];

            for (var pertemuan in pertemuanList) {
              Timestamp? tanggalMulai = pertemuan['tanggalMulai'];
              Timestamp? tanggalSelesai = pertemuan['tanggalSelesai'];

              if (tanggalMulai != null) {
                String tanggalMulaiStr =
                    DateFormat('yyyy-MM-dd').format(tanggalMulai.toDate());

                if (tanggalMulaiStr == todayStr) {
                  jadwalHariIni.add(buildMataKuliahCard(
                    mataKuliah['nama'] ?? "(Tanpa Nama)",
                    tanggalMulai.toDate(),
                    tanggalSelesai?.toDate(),
                    mataKuliah['ruangan'] ?? "-",
                    dosen['nama'] ?? "(Tanpa Nama Dosen)",
                  ));
                }
              }
            }
          }
        }

        return jadwalHariIni.isNotEmpty
            ? ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: jadwalHariIni,
              )
            : const Center(child: Text("Tidak ada jadwal hari ini"));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
        backgroundColor: Colors.green[400],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selamat Datang, $name',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Card(
              margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 200,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                      image: DecorationImage(
                        image: NetworkImage(
                            'https://img.freepik.com/free-vector/students-walking-front-university-flat-vector-illustration-young-people-spending-time-campus-near-college-building-summer-day-relaxing-talking-landscape-leisure-concept_74855-25308.jpg?semt=ais_hybrid'), // Replace with your network image URL
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // add title "Jadwal Saya"
            const Padding(
              padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Jadwal Saya',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(1.0),
              child: buildJadwalHariIni(),
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildMataKuliahCard(
  String namaMataKuliah,
  DateTime tanggalMulai,
  DateTime? tanggalSelesai,
  String ruangan,
  String namaDosen,
) {
  String jamMulai = DateFormat('HH:mm').format(tanggalMulai);
  String jamSelesai =
      tanggalSelesai != null ? DateFormat('HH:mm').format(tanggalSelesai) : "";

  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15.0),
    ),
    elevation: 5,
    color: Colors.white,
    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            namaMataKuliah,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Divider(color: Colors.black),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Jam: $jamMulai - $jamSelesai",
                  style: TextStyle(fontSize: 16)),
              Text("Ruangan: $ruangan", style: TextStyle(fontSize: 16)),
            ],
          ),
          SizedBox(height: 8),
          Text(
            "Dosen: $namaDosen",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87),
          ),
        ],
      ),
    ),
  );
}