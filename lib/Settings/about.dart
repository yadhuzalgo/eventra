import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Ab extends StatelessWidget {
  const Ab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.teal,
        title: Text(
          "About Us",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding:  EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
               SizedBox(height: 20),


              CircleAvatar(
                radius: 48,
                backgroundColor: Colors.teal.withOpacity(0.1),
                child: Icon(Icons.event, size: 48, color: Colors.teal),
              ),

               SizedBox(height: 20),

              // Title
              Text(
                "Welcome to Eventra",
                style: GoogleFonts.poppins(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal[800],
                ),
                textAlign: TextAlign.center,
              ),

               SizedBox(height: 16),


              Text(
                "Your all-in-one event planning solution.",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.center,
              ),

               SizedBox(height: 30),


              Text(
                "At Eventra, we believe organizing an event should be as enjoyable as attending one. Whether you're planning a wedding, corporate meetup, birthday party, or a cultural fest – we've got the tools you need.",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  height: 1.6,
                  color: Colors.grey[800],
                ),
              ),

               SizedBox(height: 20),

              Text(
                "We provide an easy-to-use platform that helps you browse venues, compare packages, book events, and track your reservations – all in one place. Our goal is to save your time and deliver a seamless experience.",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  height: 1.6,
                  color: Colors.grey[800],
                ),
              ),

               SizedBox(height: 20),

              Text(
                "Trusted by event managers, planners, and individuals alike – Eventra is more than just an app; it's your event planning partner.",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  height: 1.6,
                  color: Colors.grey[800],
                ),
              ),

               SizedBox(height: 30),

              Divider(color: Colors.teal[200]),

               SizedBox(height: 10),

              Text(
                "Crafted with in India",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),

               SizedBox(height: 20),
              Card(
                color: Colors.white,
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.contact_mail, color: Color(0xFF00695C), size: 28),
                          SizedBox(width: 10),
                          Text(
                            'Contact Us',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF00695C),
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 30, thickness: 1.2),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(Icons.phone, color: Colors.teal[700]),
                        title: Text(
                          '+91 80784 08056',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(Icons.email, color: Colors.teal[700]),
                        title: Text(
                          'eventra0@gmail.com',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
