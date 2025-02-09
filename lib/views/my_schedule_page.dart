import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      home: JadwalHariIniScreen(),
    );
  }
}

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
        child: Column(
          children: [
            Expanded(
              child: buildJadwalHariIni(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildJadwalHariIni() {
    DateTime today = DateTime.now();
    String todayStr = DateFormat('yyyy-MM-dd').format(today);

    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('dosens').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        var filteredDocs = snapshot.data!.docs.where((doc) {
          var matakuliahList = (doc['matakuliah'] as List<dynamic>);
          return matakuliahList.any((matakuliahData) {
            Timestamp tanggalMulai = matakuliahData['tanggalmulai'];
            String tanggalMulaiStr =
                DateFormat('yyyy-MM-dd').format(tanggalMulai.toDate());
            return tanggalMulaiStr == todayStr;
          });
        }).toList();

        return ListView.builder(
          itemCount: filteredDocs.length,
          itemBuilder: (context, index) {
            var dosenData = filteredDocs[index];
            return Column(
              children: (dosenData['matakuliah'] as List<dynamic>)
                  .where((matakuliahData) {
                    Timestamp tanggalMulai = matakuliahData['tanggalmulai'];
                    String tanggalMulaiStr =
                        DateFormat('yyyy-MM-dd').format(tanggalMulai.toDate());
                    return tanggalMulaiStr ==
                        DateFormat('yyyy-MM-dd').format(DateTime.now());
                  })
                  .map<Widget>((matakuliahData) =>
                      buildmatakuliahCard(matakuliahData, dosenData['nama']))
                  .toList(),
            );
          },
        );
      },
    );
  }

  Widget buildmatakuliahCard(dynamic matakuliahData, String namaDosen) {
    Timestamp tanggalMulai = matakuliahData['tanggalmulai'];
    String formattedJam = DateFormat('HH:mm').format(tanggalMulai.toDate());
    String ruangan = matakuliahData['ruangan'] ?? "-";
    String namamatakuliah = matakuliahData['nama'];

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
              namamatakuliah,
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
                Text("Jam: $formattedJam", style: TextStyle(fontSize: 16)),
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
