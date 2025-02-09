import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

void tambahJadwalSemester() {
  List<Map<String, dynamic>> daftarJadwal = [
    {
      'namaDosen': 'Sela Octaviani, S.Kom.',
      'mataKuliah': 'Teori Bahasa Otomata',
      'ruangan': 'A201',
      'hari': DateTime.monday, // Senin
      'jamMulai': 8,
      'menitMulai': 0
    },
    {
      'namaDosen': 'Fadly Febriya, S.SI., M.Kom.',
      'mataKuliah': 'Basis Data Terdistribusi',
      'ruangan': 'A201',
      'hari': DateTime.wednesday, // Rabu
      'jamMulai': 10,
      'menitMulai': 30
    },
    {
      'namaDosen': 'Hena Sulaeman, S.T., M.Kom.',
      'mataKuliah': 'Jaringan Komputer 1',
      'ruangan': 'A201',
      'hari': DateTime.friday, // Jumat
      'jamMulai': 13,
      'menitMulai': 0
    }
  ];

  final random = Random();
  DateTime semesterMulai = DateTime(2025, 2, 5); // Awal semester
  int jumlahPertemuan = 16; // 16 minggu

  for (var jadwal in daftarJadwal) {
    List<Map<String, Timestamp>> pertemuanList = [];

    // Generate 16 pertemuan
    for (int i = 0; i < jumlahPertemuan; i++) {
      DateTime tanggalMulai = semesterMulai.add(Duration(
        days: (jadwal['hari'] - semesterMulai.weekday + 7) % 7 + (i * 7),
        hours: jadwal['jamMulai'],
        minutes: jadwal['menitMulai']
      ));
      DateTime tanggalSelesai = tanggalMulai.add(Duration(hours: 2));

      pertemuanList.add({
        'tanggalMulai': Timestamp.fromDate(tanggalMulai),
        'tanggalSelesai': Timestamp.fromDate(tanggalSelesai),
      });
    }

    FirebaseFirestore.instance.collection('dosen').add({
      'nama': jadwal['namaDosen'],
      'mataKuliah': [
        {
          'nama': jadwal['mataKuliah'],
          'ruangan': jadwal['ruangan'],
          'pertemuan': pertemuanList
        }
      ]
    });
  }

  print("Data jadwal semester berhasil ditambahkan!");
}
