import 'package:abo_hany/ui/admin%20panel/Add%20Student.dart';
import 'package:abo_hany/ui/admin%20panel/finalAppBar.dart';
import 'package:abo_hany/ui/admin%20panel/remove%20Student.dart';
import 'package:abo_hany/ui/admin%20panel/show%20Students.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class adminPage extends StatefulWidget {
  static String Route_Name = "adminScreen";

  @override
  State<adminPage> createState() => _adminPageState();
}

class _adminPageState extends State<adminPage> {
  int currentIndex = 0;
  double screenWidth = 0;
  double screenHeight = 0;
  bool securedPass = true;
  String ID = "";
  String pass = "";
  Color primary = Colors.indigoAccent;
  Color red = const Color(0xffeef444c);
  List navBarTitles = ["Add Student", "Remove Student", "All Students"];
  List<IconData> navBarItems = [
    Icons.person_add,
    Icons.person_remove,
    FontAwesomeIcons.users,
  ];
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AdminAppBar(screenHeight),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
        child:
        BottomNavigationBar(
          currentIndex: currentIndex,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.black,
          backgroundColor: Colors.indigo,
          items: [
            for (int i = 0;
            i < navBarItems.length;
            i++) ...<BottomNavigationBarItem>{
              BottomNavigationBarItem(
                  label: navBarTitles[i],
                  backgroundColor: Colors.white,
                  icon: InkWell(
                      onTap: () {
                        setState(() {
                          currentIndex = i;
                        });
                      },
                      child: Icon(navBarItems[i],
                          color:
                          i == currentIndex ? Colors.white : Colors.black)))
            }
          ],
        ),
      ),
      body: IndexedStack(
        index: currentIndex,
        children: [
          const AddStudent(),
          RemoveStudent(),
          const ShowStudents(),
        ],
      ),
    );
  }
}
