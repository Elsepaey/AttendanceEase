import 'package:abo_hany/ui/form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:io';
import '../model/user.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});


  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  double screenHeight = 0;
  double screenWidth = 0;
  Color primary = Colors.indigo;

@override
  void initState() {
super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;


   return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    pickUploadProfilePic();
                  },
                  child: Container(
                    margin: const EdgeInsets.only(top: 80, bottom: 24),
                    height: 120,
                    width: 120,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: primary,
                    ),
                    child: Center(
                      child: AppUser.profilePicLink == " "
                          ? const Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 80,
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(AppUser.profilePicLink),
                            ),
                    ),
                  ),
                ),
                 MyForm()
              ],
            ));

  }

  void pickUploadProfilePic() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: 512,
      maxWidth: 512,
      imageQuality: 90,
    );

    Reference ref = FirebaseStorage.instance
        .ref()
        .child("${AppUser.id.toLowerCase()}_profilepic.jpg");

    await ref.putFile(File(image!.path));

    ref.getDownloadURL().then((value) async {
      setState(() {
        AppUser.profilePicLink = value;
      });

      await FirebaseFirestore.instance
          .collection("students")
          .doc(AppUser.id)
          .update({
        'profilePic': value,
      });
    });
  }



}
