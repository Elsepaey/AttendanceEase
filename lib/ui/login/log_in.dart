import 'package:abo_hany/ui/admin%20panel/admin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../homescreen.dart';
import '../../model/user.dart';
import 'app_bar.dart';

class Login extends StatefulWidget {
  static String routeName = "login";

  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late SharedPreferences sharedPreferences;

  double screenWidth = 0;
  double screenHeight = 0;
  String id = "";
  String pass = "";

  final _formKey = GlobalKey<FormState>();
  bool securedPass = true;
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: Appbar.appbar(context),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: screenHeight/15,),
              decoratedContainer(
                TextFormField(
                  validator: (text) {
                    if (text == null || text.trim().isEmpty) {
                      return ("please enter your Id");
                    }
                    return null;
                  },
                  onChanged: (text) {
                    id = text;
                  },
                  decoration: InputDecoration(
                    hintText: "enter student Id",
                    contentPadding: EdgeInsets.symmetric(
                      vertical: screenHeight / 35,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              decoratedContainer(
                TextFormField(
                  validator: (text) {
                    if (text == null || text.trim().isEmpty) {
                      return ("please enter your password");
                    }
                    if (text.length < 8) {
                      return ('password must consist of 8 digits or more');
                    }
                    return null;
                  },
                  onChanged: (text) {
                    pass = text;
                  },
                  obscureText: securedPass,
                  decoration: InputDecoration(
                    hintText: "enter password",
                    suffixIcon: InkWell(
                      child: Icon(securedPass
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onTap: () {
                        securedPass = !securedPass;
                        setState(() {});
                      },
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: screenHeight / 35,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 25, left: 20, right: 20),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(22)),
                ),
                child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.indigoAccent),
                    ),
                    onPressed: () {
                      validate();
                    },
                    child: const Text(
                      'Sign In',
                      style: TextStyle(fontSize: 32, color: Colors.white),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void validate() async {
    if (_formKey.currentState?.validate() == true) {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection("students")
          .where('id', isEqualTo: id)
          .get();

      try {
        if (pass == snap.docs[0]['password']) {
          sharedPreferences = await SharedPreferences.getInstance();
          sharedPreferences.setString('studentId', id).then((_) {

            if (snap.docs[0]['role'] == 'user') {
              AppUser.id=sharedPreferences.getString('studentId')!;
              Navigator.pushReplacementNamed(context, Home.routeName);
            } else if (snap.docs[0]['role'] == 'admin') {
              Navigator.pushReplacementNamed(context, adminPage.Route_Name);
            }
          });
        } else {
          showSnackBar("Password is not correct!");
        }
      } catch (e) {
        String error = " ";

        if (e.toString() ==
            "RangeError (index): Invalid value: Valid value range is empty: 0") {
          setState(() {
            error = "student id does not exist!";
          });
        } else {
          setState(() {
            error = e.toString();
            if (kDebugMode) {
              print(error);
            }
          });
        }

        showSnackBar(error);
      }
    }
  }

  decoratedContainer(TextFormField textFormField) {
    return Container(
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.all(15),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(12)),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: textFormField);
  }

  void showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(
          text,
        ),
      ),
    );
  }
}
