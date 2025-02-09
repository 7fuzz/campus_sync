import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class JadwalHariIniScreen extends StatefulWidget {
  @override
  _JadwalHariIniScreenState createState() => _JadwalHariIniScreenState();
}

class _JadwalHariIniScreenState extends State<JadwalHariIniScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Jadwal Hari Ini"),
        centerTitle: true,
        backgroundColor: Colors.green[400],
      ),
      backgroundColor: Colors.green[50],
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: buildJadwalHariIni(),
      ),
    );
  }

  Widget buildJadwalHariIni() {
    DateTime today = DateTime.now();
    String todayStr = DateFormat('yyyy-MM-dd').format(today);

    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('dosen').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
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
            ? ListView(children: jadwalHariIni)
            : Center(child: Text("Tidak ada jadwal hari ini"));
      },
    );
  }

  Widget buildMataKuliahCard(
    String namaMataKuliah,
    DateTime tanggalMulai,
    DateTime? tanggalSelesai,
    String ruangan,
    String namaDosen,
  ) {
    String jamMulai = DateFormat('HH:mm').format(tanggalMulai);
    String jamSelesai = tanggalSelesai != null
        ? DateFormat('HH:mm').format(tanggalSelesai)
        : "";

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
}
