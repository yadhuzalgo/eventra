import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projectflutter/Details/theplan.dart';

class Det extends StatefulWidget {
  final String documentId;

  const Det({super.key, required this.documentId});

  @override
  State<Det> createState() => _DetState();
}

class _DetState extends State<Det> {
  final CollectionReference items =
  FirebaseFirestore.instance.collection("pass");

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        elevation: 4,
        toolbarHeight: 80,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            color: Colors.teal
          ),
        ),
        centerTitle: true,
        title: StreamBuilder<DocumentSnapshot>(
          stream: items.doc(widget.documentId).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Text('No data found');
            }
            final data = snapshot.data!.data() as Map<String, dynamic>;
            return Text(
              data['name'] ?? '',
              style: GoogleFonts.poppins(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: StreamBuilder(
          stream: items.doc(widget.documentId).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Center(child: Text('No data found'));
            }

            final data = snapshot.data!.data() as Map<String, dynamic>;
            final image = data['image'] ?? '';
            final stageImages = data['stageImages'] ?? [];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Banner
                Container(
                  height: screenHeight * 0.3,
                  width: screenWidth,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: image.isNotEmpty
                            ? Image.network(
                          image,
                          width: screenWidth,
                          height: screenHeight * 0.3,
                          fit: BoxFit.cover,
                        )
                            : Container(color: Colors.grey),
                      ),

                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 60,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Color.fromARGB(200, 0, 0, 0),
                                Colors.black87,
                              ],
                            ),
                            borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(16),
                            ),
                          ),
                        ),
                      ),
                      // Text container
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(16),
                            ),
                          ),
                          child: Text(
                            data['about'] ?? '',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),


                const SizedBox(height: 20),




                if (stageImages is List && stageImages.isNotEmpty)
                  SizedBox(
                    height: 160,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: stageImages.length,
                      itemBuilder: (context, i) {
                        final stage = stageImages[i];
                        if (stage is Map &&
                            stage.containsKey('url') &&
                            stage.containsKey('stageName')) {
                          return Container(
                            margin: const EdgeInsets.only(right: 10),
                            width: 240,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.network(
                                    stage['url'],
                                    height: 100,
                                    width: 240,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  stage['stageName'] ?? '',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    ),
                  ),

                const SizedBox(height: 28),
                Text(
                  "Secure your ideal package and stage setup now by tapping the button below ⬇️",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Tpl(documentId: widget.documentId)));
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: Colors.teal,
                    ),
                    child: Text(
                      "Explore Packages",
                      style: GoogleFonts.poppins(
                          fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                const Divider(thickness: 1.2),
                const SizedBox(height: 16),
                Text(
                  "Contact Us",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  color: Colors.white,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    children: [
                      ListTile(
                        leading:
                        const Icon(Icons.phone, color: Colors.black54),
                        title: Text(data['number'] ?? ''),
                      ),
                      ListTile(
                        leading:
                        const Icon(Icons.email, color: Colors.black54),
                        title: Text(data['email'] ?? ''),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
              ],
            );
          },
        ),
      ),
    );
  }
}
