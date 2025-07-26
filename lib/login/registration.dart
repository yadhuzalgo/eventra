import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projectflutter/login/loginpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

class Reg extends StatefulWidget {
  const Reg({super.key});

  @override
  State<Reg> createState() => _RegState();
}

class _RegState extends State<Reg> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();

  final CollectionReference users =
  FirebaseFirestore.instance.collection('users');

  Future signup() async {
    try {
      UserCredential result = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
          email: email.text.trim(), password: password.text.trim());

      User? user = result.user;

      if (user != null) {
        await users.doc(user.uid).set({
          'uid': user.uid,
          'email': user.email,
          'name': name.text.trim(),
          'phone': phone.text.trim(),
          'createdAt': FieldValue.serverTimestamp(),
        });

        final SharedPreferences preferences =
        await SharedPreferences.getInstance();
        preferences.setBool('islogged', true);

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Log()));

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green,
          content: Text("Signup successful"),
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text('Signup failed: $e'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 4,
        title: Text(
          "Signup",
          style: TextStyle(
              fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.blueGrey.shade900,
      ),
      body: Container(
        height: 800,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueGrey.shade900, Colors.blueGrey.shade700],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: SafeArea(

          child: SingleChildScrollView(
            child: Column(

              children: [
                SizedBox(height: 30),
                _buildTextField(email, "Email"),
                SizedBox(height: 10),
                _buildTextField(password, "Password", obscureText: true),
                SizedBox(height: 10),
                _buildTextField(name, "Name"),
                SizedBox(height: 10),
                _buildTextField(phone, "Phone",
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(10),
                      FilteringTextInputFormatter.digitsOnly,
                    ]),
                SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding:
                    EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  onPressed: () {
                    if (email.text.isEmpty ||
                        password.text.isEmpty ||
                        name.text.isEmpty ||
                        phone.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: Colors.red,
                        content: Text("Please fill all fields"),
                      ));
                    } else {
                      signup();
                    }
                  },
                  child: Text("Sign Up", style: TextStyle(fontSize: 16)),
                ),
                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {bool obscureText = false,
        TextInputType? keyboardType,
        List<TextInputFormatter>? inputFormatters}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      cursorColor: Colors.grey,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(20),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
