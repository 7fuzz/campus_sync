import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

void tambahBanyakDummyData() {
  List<Map<String, dynamic>> daftarJadwal = [
    {
      'namaDosen': 'Sela Octaviani, S.Kom.',
      'matakuliah': 'Teori Bahasa Otomata',
      'ruangan': 'A201'
    },
    {
      'namaDosen': 'Fadly Febriya, S.SI., M.Kom.',
      'matakuliah': 'Basis Data Terdistribusi',
      'ruangan': 'A201'
    },
    {
      'namaDosen': 'Hena Sulaeman, S.T., M.Kom.',
      'matakuliah': 'Jaringan Komputer 1',
      'ruangan': 'A201'
    },
    {
      'namaDosen': 'Muhammad Ikhwan Fathulloh, S.Kom.',
      'matakuliah': 'Pemrograman Berorientasi Objek 1',
      'ruangan': 'A201'
    },
    {
      'namaDosen': 'Widi Linggih Jaelani, S.Kom., M.T.',
      'matakuliah': 'Rekayasa Perangkat Lunak',
      'ruangan': 'A201'
    },
    {
      'namaDosen': 'Asep Tasdik, S.Pd., M.MPd.',
      'matakuliah': 'Statistika',
      'ruangan': 'A201'
    },
    {
      'namaDosen': 'Muhamad Malik Mutoffar, S.T., M.M.',
      'matakuliah': 'Sistem Operasi',
      'ruangan': 'A201'
    },
    {
      'namaDosen': 'Drs. Muslim Arief, M.Pd.I.',
      'matakuliah': 'Agama',
      'ruangan': 'A302'
    },
    {
      'namaDosen': 'Dr. Yayat Hidayat, M.Pd.',
      'matakuliah': 'Pancasila',
      'ruangan': 'A302'
    },
    {
      'namaDosen': 'Indra Julias Pradana, S.Kom.',
      'matakuliah': 'Pengantar Teknologi Informasi',
      'ruangan': 'A302'
    }
  ];

  final random = Random();

  for (var jadwal in daftarJadwal) {
    DateTime now = DateTime.now();
    DateTime randomMulai = now
        .add(Duration(days: random.nextInt(30), hours: random.nextInt(5) + 8));
    DateTime randomSelesai = randomMulai.add(Duration(hours: 2));

    FirebaseFirestore.instance.collection('dosens').add({
      'nama': jadwal['namaDosen'],
      'matakuliah': [
        {
          'nama': jadwal['matakuliah'],
          'tanggalmulai': Timestamp.fromDate(randomMulai),
          'tanggalselesai': Timestamp.fromDate(randomSelesai),
          'ruangan': jadwal['ruangan']
        }
      ]
    });
  }

  print("Data dummy berhasil ditambahkan!");
}
