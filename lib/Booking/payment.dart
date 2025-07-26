import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projectflutter/bottomnav.dart';
import 'package:projectflutter/main.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class Pay extends StatefulWidget {
  final String stageName;
  final String stageImageUrl;
  final String packageName;
  final String packagePrice;
  final String selectedDate;

  const Pay({
    super.key,
    required this.stageName,
    required this.stageImageUrl,
    required this.packageName,
    required this.packagePrice,
    required this.selectedDate,
  });

  @override
  State<Pay> createState() => _PayState();
}

class _PayState extends State<Pay> {
  late Razorpay razorpay;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    razorpay = Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    razorpay.clear();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Payment successful! Confirming booking...")),
    );

    await confirmBooking(response.paymentId);
  }


  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(content: Text("Payment failed. Please try again.")),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(content: Text("External wallet selected")),
    );
  }

  void checkOut(int price) {
    var options = {
      'key': 'rzp_test_GJHAwjTodLj9JP',
      'amount': price * 100,
      'name': 'Eventra',
      'description': 'Event Booking',
      'currency': 'INR',
      'prefill': {
        'contact': '8078408056',
        'email': 'krishnayadhu361@gmail.com',
      }
    };

    try {
      razorpay.open(options);
    } catch (e) {
      log("Razorpay Error: $e");
    }
  }


  Future confirmBooking(String? paymentId) async {
    if (isLoading) return; // Prevent double calls

    setState(() => isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;

      await FirebaseFirestore.instance.collection("bookings").add({
        'stage': widget.stageName,
        'stageImage': widget.stageImageUrl,
        'package': widget.packageName,
        'price': widget.packagePrice,
        'date': widget.selectedDate,
        'timestamp': FieldValue.serverTimestamp(),
        'status': 'Pending',
        'userId': user?.uid,
        'paymentId': paymentId,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Booking Confirmed!")),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Btn()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Booking failed. Try again.")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    int priceInt = int.tryParse(widget.packagePrice) ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: Text("Payment", style: GoogleFonts.poppins()),
        backgroundColor: Colors.teal,
      ),
      body: isLoading
          ?  Center(child: CircularProgressIndicator())
          : Padding(
        padding:  EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("Booking Summary",
                style: GoogleFonts.poppins(
                    fontSize: 20, fontWeight: FontWeight.w600)),
             SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(widget.stageImageUrl,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover),
            ),
             SizedBox(height: 10),
            Text("Stage: ${widget.stageName}",
                style: GoogleFonts.poppins(fontSize: 16)),
            Text("Package: ${widget.packageName}",
                style: GoogleFonts.poppins(fontSize: 16)),
            Text("Date: ${widget.selectedDate}",
                style: GoogleFonts.poppins(fontSize: 16)),
             SizedBox(height: 20),
             Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Total",
                    style: GoogleFonts.poppins(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                Text("₹${widget.packagePrice}",
                    style: GoogleFonts.poppins(
                        fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
             SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding:  EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () => checkOut(priceInt),
                child: Text("Pay Now",
                    style: GoogleFonts.poppins(
                        fontSize: 16, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
