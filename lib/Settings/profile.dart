import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projectflutter/login/loginpage.dart';

class Pro extends StatefulWidget {
  const Pro({super.key});

  @override
  State<Pro> createState() => _ProState();
}

class _ProState extends State<Pro> {
  String name = "";
  String email = "";
  String phone = "";

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      setState(() {
        name = doc['name'] ?? '';
        email = doc['email'] ?? '';
        phone = doc['phone'] ?? '';
      });
    }
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Log()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 2,
        title: Text(
          'My Profile',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding:  EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Avatar + Name
            Container(
              padding:  EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  )
                ],
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 48,
                    /*backgroundImage: AssetImage('assets/avatar.png'),*/
                    backgroundColor: Colors.grey[300],
                  ),
                   SizedBox(height: 12),
                  Text(
                    name.isNotEmpty ? name : 'Loading...',
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
             SizedBox(height: 24),

            // Info Section
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 3,
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.phone, color: Colors.teal),
                    title: Text('Phone Number'),
                    subtitle: Text(phone),
                  ),
                  Divider(height: 0),
                  ListTile(
                    leading: Icon(Icons.email, color: Colors.teal),
                    title: Text('Email'),
                    subtitle: Text(email),
                  ),
                ],
              ),
            ),
             SizedBox(height: 20),

            // Action Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: logout,
                icon: Icon(Icons.logout),
                label: Text("Log Out"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding:  EdgeInsets.symmetric(vertical: 14),
                  textStyle: GoogleFonts.poppins(fontSize: 16),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
