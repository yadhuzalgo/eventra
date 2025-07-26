import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projectflutter/Details/details.dart'; // make sure this import exists and points to your details screen

class Ser extends StatefulWidget {
  const Ser({super.key});

  @override
  State<Ser> createState() => _SerState();
}

class _SerState extends State<Ser> {
  TextEditingController searchController = TextEditingController();
  String searchText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QuickFind',style: GoogleFonts.poppins(color: Colors.white),),
        backgroundColor: Colors.teal,
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 🔍 Search bar
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search events...',
                  border: InputBorder.none,
                  icon: Icon(Icons.search),
                  suffixIcon: searchController.text.isNotEmpty
                      ? IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      searchController.clear();
                      setState(() {
                        searchText = '';
                      });
                    },
                  )
                      : null,
                ),
                onChanged: (value) {
                  setState(() {
                    searchText = value.trim().toLowerCase();
                  });
                },
              ),
            ),

            SizedBox(height: 20),

            // 🔁 Show results only if search is not empty
            Expanded(
              child: searchText.isEmpty
                  ? Center(
                child: Text(
                  "Start typing to search...",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
                  : StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("pass")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData ||
                      snapshot.data!.docs.isEmpty) {
                    return Center(child: Text("No events found"));
                  }

                  final docs = snapshot.data!.docs;

                  final filteredDocs = docs.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final name =
                        data['name']?.toString().toLowerCase() ?? '';
                    return name.contains(searchText);
                  }).toList();

                  if (filteredDocs.isEmpty) {
                    return Center(child: Text("No matching results"));
                  }

                  return ListView.builder(
                    itemCount: filteredDocs.length,
                    itemBuilder: (context, index) {
                      final doc = filteredDocs[index];
                      final data =
                      doc.data() as Map<String, dynamic>;
                      final image = data['image'] ?? '';
                      final name = data['name'] ?? 'No Title';
                      final docId = doc.id;

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  Det(documentId: docId),
                            ),
                          );
                        },
                        child: Card(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                          child: Container(
                            height: 160,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: image.isNotEmpty
                                  ? DecorationImage(
                                image: NetworkImage(image),
                                fit: BoxFit.cover,
                              )
                                  : null,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.black.withOpacity(0.6),
                                    Colors.transparent
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                              ),
                              child: Align(
                                alignment: Alignment.bottomLeft,
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(
                                    name,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
