import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projectflutter/Details/details.dart';

class Fag extends StatefulWidget {
  const Fag({super.key,});

  @override
  State<Fag> createState() => _FagState();
}

class _FagState extends State<Fag> {
  final userId = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Favorites",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(color: Colors.teal),
        ),
      ),
      backgroundColor: Colors.grey[100],
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('favorites')
            .where('userId', isEqualTo: userId)
        .snapshots(),
        builder: (context, favSnapshot) {
          if (favSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!favSnapshot.hasData || favSnapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                "No favorites yet.",
                style: GoogleFonts.poppins(fontSize: 16),
              ),
            );
          }

          final favoriteDocs = favSnapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: favoriteDocs.length,
            itemBuilder: (context, index) {

              final favData =
              favoriteDocs[index].data() as Map<String, dynamic>;
              final eventId = favData['eventId'];
              final favDocId = favoriteDocs[index].id;

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('pass')
                    .doc(eventId)
                    .get(),
                builder: (context, eventSnapshot) {
                  if (eventSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const ListTile(title: Text("Loading event..."));
                  }

                  if (!eventSnapshot.hasData || !eventSnapshot.data!.exists) {
                    return const ListTile(title: Text("Event not found"));
                  }

                  final eventData =
                  eventSnapshot.data!.data() as Map<String, dynamic>;
                  final image = eventData['image'] ?? '';
                  final name = eventData['name'] ?? 'No Title';

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: image.isNotEmpty
                            ? FadeInImage.assetNetwork(
                          placeholder: 'assets/loading.gif',
                          image: image,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        )
                            : const Icon(Icons.image_not_supported, size: 50),
                      ),
                      title: Text(
                        name,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.favorite,
                            color: Colors.redAccent),
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection('favorites')
                              .doc(favDocId)
                              .delete();
                        },
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Det(documentId: eventId),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
