import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../homescreen.dart';
import '../model/user.dart';
import 'admin panel/admin.dart';
import 'login/log_in.dart';

class AuthCheck extends StatefulWidget {
  const AuthCheck({super.key});

  @override
  _AuthCheckState createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  bool userAvailable = false;
  bool isAdmin=false;
  late SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();

    _getCurrentUser();
  }

  void _getCurrentUser() async {
    sharedPreferences = await SharedPreferences.getInstance();

    try {
      if (sharedPreferences.getString('studentId') != null)
      {
        QuerySnapshot snap = await FirebaseFirestore.instance
            .collection("students")
            .where('id', isEqualTo: sharedPreferences.getString('studentId'))
            .get();
        if(snap.docs[0]['role']=='user'){
          setState(() {
            AppUser.id=sharedPreferences.getString('studentId')!;
            AppUser.canEdit=snap.docs[0]['canEdit'];
            AppUser.firstName = snap.docs[0]['firstName'];
            AppUser.lastName = snap.docs[0]['lastName'];
            AppUser.address = snap.docs[0]['address'];
            AppUser.department = snap.docs[0]['department'];
            AppUser.level =snap.docs[0]['level'];
            AppUser.birthDate = snap.docs[0]['birthDate'];
            userAvailable = true;

          });}
        else{
          setState(() {
            AppUser.id=sharedPreferences.getString('studentId')!;
            userAvailable = true;
            isAdmin=true;

          });
        }
      }
    } catch (e) {
      setState(() {
        userAvailable = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var Height = MediaQuery.of(context).size.height;
    var Width = MediaQuery.of(context).size.width;

    return AnimatedSplashScreen(
        splashIconSize: Width / 2,
        duration: 800,
        splash: Image(
          image: const AssetImage(
            "assets/icons/undraw_Check_boxes_re_v40f.png",
          ),
          height: Height,
          width: Width,
        ),
        nextScreen:       userAvailable ?  isAdmin?adminPage():const Home() : const Login()

        ,
        splashTransition: SplashTransition.fadeTransition,
        backgroundColor: Colors.white);

  }
}
