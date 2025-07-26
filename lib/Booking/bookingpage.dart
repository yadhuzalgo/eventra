import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Book extends StatefulWidget {
  const Book({super.key});

  @override
  State<Book> createState() => _BookState();
}

class _BookState extends State<Book> {
  String? userId;

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser?.uid;
  }

  @override
  Widget build(BuildContext context) {
    if (userId == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text("My Bookings", style: GoogleFonts.poppins()),
          backgroundColor: Color(0xFF00695C), // dark teal
          centerTitle: true,
        ),
        body: Center(child: Text("Please log in to view your bookings")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("My Bookings", style: GoogleFonts.poppins()),
        backgroundColor: Color(0xFF00695C),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('bookings')
            .where('userId', isEqualTo: userId)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No bookings found"));
          }

          final bookings = snapshot.data!.docs;

          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index].data() as Map<String, dynamic>;
              final stage = booking['stage'] ?? 'No Stage';
              final stageImage = booking['stageImage'] ?? '';
              final package = booking['package'] ?? 'No Package';
              final price = booking['price'] ?? '0';
              final date = booking['date'] ?? 'No Date';
              final status = booking['status'] ?? 'Pending';

              Color statusColor;
              if (status == 'Approved') {
                statusColor = Colors.green;
              } else if (status == 'Declined') {
                statusColor = Colors.red;
              } else {
                statusColor = Colors.orange;
              }

              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                child: ListTile(
                  leading: stageImage.isNotEmpty
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      stageImage,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  )
                      : Icon(Icons.image_not_supported),
                  title: Text(stage, style: GoogleFonts.poppins(fontSize: 16)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Package: $package", style: GoogleFonts.poppins(fontSize: 14)),
                      Text("Date: $date", style: GoogleFonts.poppins(fontSize: 14)),
                      Text("₹$price", style: GoogleFonts.poppins(fontSize: 14)),
                      Text("Status: $status",
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: statusColor,
                          )),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
