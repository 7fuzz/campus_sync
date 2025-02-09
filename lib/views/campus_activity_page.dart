import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CampusActivityPage extends StatefulWidget {
  const CampusActivityPage({super.key});

  @override
  _CampusActivityPageState createState() => _CampusActivityPageState();
}

class _CampusActivityPageState extends State<CampusActivityPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                hintText: "Cari Kegiatan...",
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
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: "Himpunan"),
              Tab(text: "UKM"),
              Tab(text: "LKM"),
            ],
            indicatorColor: Colors.green,
            labelColor: Colors.green[700],
            unselectedLabelColor: Colors.grey,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOrganizationList("Himpunan Mahasiswa"),
                _buildOrganizationList("Unit Kegiatan Mahasiswa"),
                _buildOrganizationList("Lembaga Kerohanian Mahasiswa"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrganizationList(String category) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('organizations').where('category', isEqualTo: category).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("Tidak ada data"));
        }

        List<Map<String, dynamic>> orgList = snapshot.data!.docs.map((doc) {
          return {
            "title": doc["name"],
            "description": doc["description"],
            "icon": Icons.groups, // Default icon jika tidak tersedia
            "contact": doc["contact"],
          };
        }).toList();

        // Filter berdasarkan pencarian
        List<Map<String, dynamic>> filteredList = orgList
            .where((org) => org["title"].toLowerCase().contains(searchQuery.toLowerCase()))
            .toList();

        return _buildGrid(filteredList);
      },
    );
  }

  Widget _buildGrid(List<Map<String, dynamic>> list) {
    return GridView.builder(
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
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                item["description"],
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                "Kontak: ${item["contact"]}",
                style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green[400]),
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
