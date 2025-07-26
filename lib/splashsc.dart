import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:projectflutter/bottomnav.dart';
import 'package:projectflutter/login/loginpage.dart';
import 'package:projectflutter/main.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Spc extends StatefulWidget {
  const Spc({super.key});

  @override
  State<Spc> createState() => _SpcState();
}

class _SpcState extends State<Spc> {
  @override
  void initState() {
    super.initState();
    getdatalogged().whenComplete((){
if(finaldata == true){
  Navigator.push(context, MaterialPageRoute(builder: (context) => Btn()));
}else{
  Future.delayed(Duration(seconds: 4), () {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => Log()));
  });
}
    });

  }
  bool? finaldata;

  Future getdatalogged()async{
final SharedPreferences preferences = await SharedPreferences.getInstance();
var getdata = preferences.getBool('islogged');
setState(() {
finaldata = getdata;
});
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: screenHeight,
        width: screenWidth,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("lib/images/Background.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: Center(
          child: TyperAnimatedTextKit(
            text: ['EVENTRA'],
            textStyle: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 2,
            ),
            speed: Duration(milliseconds: 200),
            isRepeatingAnimation: false,
          ),
        ),
      ),
    );
  }

}
