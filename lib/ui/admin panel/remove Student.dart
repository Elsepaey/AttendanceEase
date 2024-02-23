import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../services/utils.dart';

class RemoveStudent extends StatefulWidget {
  @override
  State<RemoveStudent> createState() => _RemoveStudentState();
}

class _RemoveStudentState extends State<RemoveStudent> {
  double screenWidth = 0;

  double screenHeight = 0;

  var formKey = GlobalKey<FormState>();

  Color primary = Colors.indigoAccent;

  Color grayBlue = Color(0xFF041A45).withOpacity(0.7);

  TextEditingController idController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: screenHeight / 15,
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Remove Student",
                  style: TextStyle(
                      fontFamily: 'NexaBold',
                      fontSize: screenWidth / 18,
                      color: Colors.black),
                ),
              ),
            ),
            SizedBox(
              height: screenHeight / 20,
            ),
            Container(
              padding: EdgeInsets.all(5),
              margin: EdgeInsets.only(top: 30, bottom: 20, left: 10, right: 10),
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
              child: TextFormField(
                controller: idController,
                validator: (text) {
                  if (text == null || text.trim().isEmpty) {
                    return ("please enter your email");
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
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 35, left: 90, right: 90),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(22)),
              ),
              child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(grayBlue),
                  ),
                  onPressed: () {
                    validate();
                    showMessage(
                        context, 'student was deleted  successfully', 'OK',
                        (context) {
                      Navigator.pop(context);
                    });
                    setState(() {
                      idController.text = '';
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

  void validate() async {
    if (formKey.currentState?.validate() == true) {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection("students")
          .where("id", isEqualTo: idController.text)
          .get();
      FirebaseFirestore.instance
          .collection("students")
          .doc(snap.docs[0].id)
          .delete();
    }
  }
}
