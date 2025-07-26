import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projectflutter/Settings/about.dart';
import 'package:projectflutter/Details/details.dart';
import 'package:projectflutter/popup.dart';
import 'package:projectflutter/Settings/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Fst extends StatefulWidget {
  const Fst({super.key});

  @override
  State<Fst> createState() => _FstState();
}

class _FstState extends State<Fst> {
  TextEditingController search = TextEditingController();
  final CollectionReference items =
      FirebaseFirestore.instance.collection("pass");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: Drawer(
        child: Column(children: [
          Expanded(
            child: ListView(padding: EdgeInsets.zero, children: [
              DrawerHeader(
                decoration: BoxDecoration(color: Color(0xFF00695C)),
                child: Text(
                  'Settings',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
              ListTile(
                title: Text('Profile'),
                onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Pro()));
                },
              ),
              ListTile(
                title: Text('About us'),
                onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Ab()));
                },
              ),


            ]),
          ),
          Padding(
            padding:  EdgeInsets.all(12.0),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: 'By using this app, you agree to our\n ',
                style: TextStyle(color: Colors.black87),
                children: [
                  TextSpan(
                    text: 'Terms of Service',
                    style: TextStyle(color: Colors.blue),

                  ),
                  TextSpan(text: ' and '),
                  TextSpan(
                      text: 'Privacy Policy',
                      style: TextStyle(color: Colors.blue),
                      recognizer: TapGestureRecognizer()
                        ..onTap = ()=>
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return Popup(mdFilename: 'privacypolicy.md');
                                }
                            )
                  ),

                ],

              ),
            ),
          ),
          SizedBox(height: 15,)
        ]),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(color: Colors.teal),
        ),
        elevation: 2,
        title: Text(
          'Eventra',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu, color: Colors.black87),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
          ),
        ],
        iconTheme: IconThemeData(color: Colors.black87),
      ),
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              StreamBuilder(
                stream: items.snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No data found'));
                  }

                  final docs = snapshot.data!.docs;

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final data = docs[index].data() as Map<String, dynamic>;
                      final image = data['image'] ?? '';
                      final name = data['name'] ?? 'No Title';
                      final docId = docs[index].id;
                      final userId = FirebaseAuth.instance.currentUser?.uid;

                      return StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('favorites')
                            .doc('$userId-$docId')
                            .snapshots(),
                        builder: (context, favSnapshot) {
                          final isFavorited = favSnapshot.data?.exists ?? false;

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Det(documentId: docId),
                                ),
                              );
                            },
                            child: Container(
                              height: 200,
                              width: double.infinity,
                              margin: EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                image: image.isNotEmpty
                                    ? DecorationImage(
                                        image: NetworkImage(image),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 10,
                                    offset: Offset(4, 6),
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        gradient: LinearGradient(
                                          begin: Alignment.bottomRight,
                                          end: Alignment.topLeft,
                                          colors: [
                                            Colors.black.withOpacity(0.6),
                                            Colors.transparent,
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 12,
                                    right: 12,
                                    child: IconButton(
                                      icon: Icon(
                                        isFavorited
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: Colors.redAccent,
                                        size: 28,
                                      ),
                                      onPressed: () async {
                                        final favRef = FirebaseFirestore
                                            .instance
                                            .collection('favorites')
                                            .doc('$userId-$docId');

                                        if (isFavorited) {
                                          await favRef.delete();
                                        } else {
                                          await favRef.set({
                                            'userId': userId,
                                            'eventId': docId,
                                            'timestamp':
                                                FieldValue.serverTimestamp(),
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 16,
                                    right: 16,
                                    child: Text(
                                      name,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        shadows: [
                                          Shadow(
                                            offset: Offset(1.5, 1.5),
                                            blurRadius: 5.0,
                                            color: Colors.black87,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
