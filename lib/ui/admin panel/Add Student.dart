import 'dart:math';

import 'package:abo_hany/services/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddStudent extends StatefulWidget {
  const AddStudent({super.key});

  @override
  State<AddStudent> createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  double screenWidth = 0;

  double screenHeight = 0;
  var formKey = GlobalKey<FormState>();
  bool securedPass = true;

  Color primary = Colors.indigoAccent;
  Color red = const Color(0xffeef444c);
  TextEditingController idController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: screenHeight / 15,
            ),
            Card(
              color: red,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Add Student",
                  style: TextStyle(
                      fontFamily: 'NexaBold',
                      fontSize: screenWidth / 18,
                      color: Colors.white),
                ),
              ),
            ),
            SizedBox(
              height: screenHeight / 35,
            ),

            decoratedContainer(TextFormField(
              controller: idController,
              validator: (text) {
                if (text == null || text.trim().isEmpty) {
                  return ("please enter  Id");
                }

                return null;
              },

              decoration: InputDecoration(
                hintText: "enter student Id",
                contentPadding: EdgeInsets.symmetric(
                  vertical: screenHeight / 35,
                ),
                border: InputBorder.none,
              ),
            )),
            decoratedContainer(TextFormField(
              controller: passwordController,
              validator: (text) {
                if (text == null || text.trim().isEmpty) {
                  return ("please enter your password");
                }
                if (text.length < 8) {
                  return ('password must consist of 8 digits or more');
                }
                return null;
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
            )),
            Container(
              margin: const EdgeInsets.only(top: 25, left: 90, right: 90),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(22)),
              ),
              child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(red),
                  ),
                  onPressed: () {
                    validate();
                    showMessage(context, 'Todo was added successfully', 'OK', (context) {
                      Navigator.pop(context);
                    });
                    setState(() {
                      idController.text='';
                      passwordController.text='';
                    });

                  },
                  child: const Text(
                    'Confirm',
                    style: TextStyle(fontSize: 32, color: Colors.white),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  String getRandomGeneratedId() {
    const int autoIdLength = 20;
    const String autoIdAlphabet =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';

    const int maxRandom = autoIdAlphabet.length;
    final Random randomGen = Random();

    String id = '';
    for (int i = 0; i < autoIdLength; i++) {
      id = id + autoIdAlphabet[randomGen.nextInt(maxRandom)];
    }
    return id;
  }

  void validate() async {
    String? randomIndex = getRandomGeneratedId();
    if (formKey.currentState?.validate() == true) {
      await FirebaseFirestore.instance
          .collection("students")
          .doc(randomIndex)
          .set({"id": idController.text, "password": passwordController.text, "role": "user"});
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
}
