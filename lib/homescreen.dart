import 'package:abo_hany/model/user.dart';
import 'package:abo_hany/services/location_service.dart';
import 'package:abo_hany/ui/CalenderScreen.dart';
import 'package:abo_hany/ui/ProfileScreen.dart';
import 'package:abo_hany/ui/TodayScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Home extends StatefulWidget {
  static String routeName = "homeScreen";

  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double screenWidth = 0;
  double screenHeight = 0;
  String id="";
  int currentIndex = 0;
  Color primary = Colors.indigoAccent;
  List navBarItems = [
    AssetImage("assets/icons/check.png"),
    AssetImage("assets/icons/img_5.png"),
    AssetImage("assets/icons/img_4.png"),

  ];
  List<String> navbarTitles = [ "Today","Calender", "Profile"];

  @override
  void initState() {
    super.initState();
    getId().then((value) {
      _getCredentials();
    });
    _startLocationService();
  }

  void _getCredentials() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection("students")
          .doc(AppUser.id)
          .get();
      setState(() {
        AppUser.canEdit = doc['canEdit'];
        AppUser.firstName = doc['firstName'];
        AppUser.lastName = doc['lastName'];
        AppUser.address = doc['address'];
      });
    } catch (e) {
      return;
    }
  }

  Future<void> getId() async {
    QuerySnapshot snap = await FirebaseFirestore.instance
        .collection("students")
        .where("id", isEqualTo: AppUser.id)
        .get();
    setState(() {
      AppUser.id = snap.docs[0].id;
      id=snap.docs[0].id;
    });
  }

  void _startLocationService() async {
    LocationService().initialize();

    LocationService().getLongitude().then((value) {
      setState(() {
        AppUser.long = value!;
      });

      LocationService().getLatitude().then((value) {
        setState(() {
          AppUser.lat = value!;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
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
                  label: navbarTitles[i],
                  backgroundColor: Colors.white,
                  icon: InkWell(
                      onTap: () {
                        setState(() {
                          currentIndex = i;
                        });
                      },
                      child: ImageIcon(navBarItems[i],
                          size:screenWidth/11 ,
                          color:
                              i == currentIndex ? Colors.white : Colors.black)))
            }
          ],
        ),
      ),
      body: IndexedStack(
        index: currentIndex,
        children: [
          Today(),
          const Calender(),

          const ProfileScreen(),
        ],
      ),
    );
  }
}
