import 'package:flutter/material.dart';

class CampusActivityPage extends StatefulWidget {
  const CampusActivityPage({super.key});

  @override
  _CampusActivityPageState createState() => _CampusActivityPageState();
}

class _CampusActivityPageState extends State<CampusActivityPage> {
  String searchQuery = "";
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, dynamic>> himaList = [
    {
      "icon": Icons.groups,
      "title": "Dewan Perwakilan Mahasiswa",
      "description":
          "Organisasi Legislatif Mahasiswa yang Berada di Universitas Teknologi Bandung\n Parlemen Malaka\n @dpm.utb"
    },
    {
      "icon": Icons.groups,
      "title": "Badan Eksekutif Mahasiswa",
      "description":
          "Organisasi Eksekutif Mahasiswa yang Berada di Universitas Teknologi Bandung\n Kabinet Sembagi Arutala\n @bem.utb"
    },
    {
      "icon": Icons.groups,
      "title": "Teknik Industri",
      "description":
          "Himpunan Mahasiswa Teknik Industri yang Berada di Universitas Teknologi Bandung\n @hmti.utb"
    },
    {
      "icon": Icons.groups,
      "title": "Teknik Informatika",
      "description":
          "Himpunan Mahasiswa Teknik Informatika yang Berada di Universitas Teknologi Bandung\n @himatif.utb"
    },
    {
      "icon": Icons.groups,
      "title": "Desain Komunikasi Visual",
      "description":
          "Himpunan Mahasiswa Desain Komunikasi Visual yang Berada di Universitas Teknologi Bandung\n @hmdkv.utb"
    },
    {
      "icon": Icons.groups,
      "title": "Bisnis Digital",
      "description":
          "Himpunan Mahasiswa Bisnis Digital yang Berada di Universitas Teknologi Bandung\n @hmbd.utv"
    },
  ];

  final List<Map<String, dynamic>> ukmList = [
    {
      "icon": Icons.camera,
      "title": "Unit Filmmaker & Photography",
      "description":
          "Komunitas pecinta film dan fotografi yang Berada di Universitas Teknologi Bandung\n @ufp.utb_"
    },
    {
      "icon": Icons.sports_soccer,
      "title": "Futsal UTB",
      "description":
          "Komunitas Futsal yang Berada di Universitas Teknologi Bandung\n @utbfutsal"
    },
    {
      "icon": Icons.sports_basketball,
      "title": "Basket UTB",
      "description":
          "Komunitas Basket yang Berada di Universitas Teknologi Bandung\n @griffin.utb"
    },
    {
      "icon": Icons.music_video,
      "title": "Fabulous Dance Crew",
      "description":
          "Komunitas Tari yang Berada di Universitas Teknologi Bandung\n @fdc.utb"
    },
    {
      "icon": Icons.music_note_outlined,
      "title": "Music Society",
      "description":
          "Komunitas Musik yang Berada di Universitas Teknologi Bandung\n @musicsociety.utb"
    },
    {
      "icon": Icons.theater_comedy,
      "title": "Teater Saka Daraka",
      "description":
          "Komunitas Seni dan Teater yang Berada di Universitas Teknologi Bandung\n @sakadaraka.teater"
    },
    {
      "icon": Icons.surround_sound,
      "title": "Paduan Suara Mahasiswa",
      "description":
          "Komunitas Paduan Suara yang Berada di Universitas Teknologi Bandung\n @pasuma.utb"
    },
    {
      "icon": Icons.forest,
      "title": "Mapala Suraung",
      "description":
          "Komunitas Pecinta Alam yang Berada di Universitas Teknologi Bandung\n @mapala.suraung"
    },
    {
      "icon": Icons.book,
      "title": "Literasi Ensiklopedia",
      "description":
          "Komunitas Literasi yang Berada di Universitas Teknologi Bandung"
    },
    {
      "icon": Icons.gamepad,
      "title": "E-Sport",
      "description":
          "Komunitas E-sport yang Berada di Universitas Teknologi Bandung\n @esport_utb"
    },
    {
      "icon": Icons.group,
      "title": "Senmon no Nihon",
      "description":
          "Komunitas Jejepangan yang Berada di Universitas Teknologi Bandung\n @senmonnonihon"
    },
    {
      "icon": Icons.group,
      "title": "Ikatan KWU",
      "description":
          "Komunitas Kewirausahaan yang Berada di Universitas Teknologi Bandung\n @ikm_utb"
    },
  ];

  final List<Map<String, dynamic>> lkmList = [
    {
      "icon": Icons.groups,
      "title": "Ikatan Mahasiswa Islam",
      "description":
          "Lembaga Mahasiswa Beragama Islam yang Berada di Universitas Teknologi Bandung\n @ikmi_utb"
    },
    {
      "icon": Icons.groups,
      "title": "Persekutuan Mahasiswa Kristen",
      "description":
          "Lembaga Mahasiswa Beragama Kristen yang Berada di Universitas Teknologi Bandung\n @pmkutb_"
    },
  ];

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredHima = himaList
        .where((hima) =>
            hima["title"].toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    List<Map<String, dynamic>> filteredUkm = ukmList
        .where((ukm) =>
            ukm["title"].toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
    List<Map<String, dynamic>> filteredlkm = lkmList
        .where((lkm) =>
            lkm["title"].toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Activity'),
        centerTitle: true,
        backgroundColor: Colors.green[400],
      ),
      backgroundColor: Colors.green[50],
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Cari Kegiatan",
                prefixIcon: const Icon(Icons.search, color: Colors.green),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: Scrollbar(
              thickness: 8,
              radius: const Radius.circular(10),
              thumbVisibility: true,
              controller: _scrollController,
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (filteredHima.isNotEmpty) ...[
                      _buildSectionTitle("Himpunan Mahasiswa"),
                      _buildGrid(filteredHima),
                    ],
                    if (filteredUkm.isNotEmpty) ...[
                      _buildSectionTitle("Unit Kegiatan Mahasiswa"),
                      _buildGrid(filteredUkm),
                    ],
                    if (filteredlkm.isNotEmpty) ...[
                      _buildSectionTitle("Lembaga Kerohanian Mahasiswa"),
                      _buildGrid(filteredlkm),
                    ],
                    if (filteredHima.isEmpty &&
                        filteredUkm.isEmpty &&
                        filteredlkm.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Center(
                          child: Text(
                            "Tidak ditemukan hasil untuk \"$searchQuery\"",
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildGrid(List<Map<String, dynamic>> list) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(8.0),
      itemCount: list.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
      ),
      itemBuilder: (context, index) {
        final item = list[index];
        return GestureDetector(
          onTap: () {
            _showDetailDialog(context, item);
          },
          child: _buildCard(item["icon"], item["title"]),
        );
      },
    );
  }

  Widget _buildCard(IconData icon, String title) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(icon, size: 40, color: Colors.green[400]),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDetailDialog(BuildContext context, Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: const EdgeInsets.all(20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                item["icon"],
                size: 80,
                color: Colors.green[400],
              ),
              const SizedBox(height: 10),
              Text(
                item["title"],
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                item["description"],
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[400]),
                onPressed: () => Navigator.pop(context),
                child: const Text("Tutup"),
              ),
            ],
          ),
        );
      },
    );
  }
}
