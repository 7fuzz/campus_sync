import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class JadwalmatakuliahScreen extends StatefulWidget {
  @override
  _JadwalmatakuliahScreenState createState() => _JadwalmatakuliahScreenState();
}

class _JadwalmatakuliahScreenState extends State<JadwalmatakuliahScreen> {
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Jadwal Mata Kuliah"),
        centerTitle: true,
        backgroundColor: Colors.green[400],
      ),
      backgroundColor: Colors.green[50],
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            buildSearchBar(),
            SizedBox(height: 10),
            Expanded(
              child: buildDosenList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSearchBar() {
    return TextField(
      onChanged: (value) {
        setState(() {
          searchQuery = value.toLowerCase();
        });
      },
      decoration: InputDecoration(
        hintText: "Cari Dosen atau Mata Kuliah",
        prefixIcon: const Icon(Icons.search, color: Colors.green),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget buildDosenList() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('dosen').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        var filteredDocs = snapshot.data!.docs.where((doc) {
          var namaDosen = doc['nama'].toLowerCase();
          var mataKuliahList = (doc['mataKuliah'] as List<dynamic>);
          bool mataKuliahMatch = mataKuliahList.any((mataKuliahData) =>
              mataKuliahData['nama'].toLowerCase().contains(searchQuery));
          return namaDosen.contains(searchQuery) || mataKuliahMatch;
        }).toList();

        return ListView.builder(
          itemCount: filteredDocs.length,
          itemBuilder: (context, index) {
            var dosenData = filteredDocs[index];
            return buildDosenCard(dosenData);
          },
        );
      },
    );
  }

  Widget buildDosenCard(QueryDocumentSnapshot dosenData) {
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
              dosenData['nama'],
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Divider(color: Colors.black),
            Column(
              children: (dosenData['mataKuliah'] as List<dynamic>)
                  .map<Widget>(
                      (mataKuliahData) => buildMataKuliahTile(mataKuliahData))
                  .toList(),
            )
          ],
        ),
      ),
    );
  }

  Widget buildMataKuliahTile(dynamic mataKuliahData) {
    Set<String> uniqueTimes = {};
    List<Widget> timeWidgets = [];

    for (var pertemuanData in (mataKuliahData['pertemuan'] as List<dynamic>)) {
      Timestamp tanggalMulai = pertemuanData['tanggalMulai'];
      Timestamp tanggalSelesai = pertemuanData['tanggalSelesai'];
      String formattedMulai = DateFormat('HH:mm').format(tanggalMulai.toDate());
      String formattedSelesai =
          DateFormat('HH:mm').format(tanggalSelesai.toDate());
      String timeRange = "$formattedMulai - $formattedSelesai";

      if (!uniqueTimes.contains(timeRange)) {
        uniqueTimes.add(timeRange);
        timeWidgets
            .add(Text(timeRange, style: TextStyle(color: Colors.grey[700])));
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.green[100],
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: ListTile(
          title: Text(
            mataKuliahData['nama'],
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: timeWidgets,
          ),
          leading: Icon(Icons.book, color: Colors.green[700]),
        ),
      ),
    );
  }
}
