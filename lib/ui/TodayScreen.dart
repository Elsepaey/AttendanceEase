import 'dart:async';
import 'package:abo_hany/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:slide_to_act/slide_to_act.dart';

class Today extends StatefulWidget {
  @override
  State<Today> createState() => _TodayState();
}
class _TodayState extends State<Today> {
  double screenWidth = 0;
  double screenHeight = 0;
  Color primary = Colors.indigoAccent;
  Color red = const Color(0xffeef444c);
  String checkIn = "--/--";
  String checkOut = "--/--";
  String location = "--";

  @override
  void initState() {
    _getRecords();

  super.initState();
  }

  void _getLocation() async {
    List<Placemark> placeMark =
        await placemarkFromCoordinates(AppUser.lat, AppUser.long);

    setState(() {
      location =
          "${placeMark[0].street}, ${placeMark[0].administrativeArea}, ${placeMark[0].postalCode}, ${placeMark[0].country}";
    });
  }

  void _getRecords() async
  {
    try {

      DocumentSnapshot docSnap =   getDocSnap()
          .get();
      setState(() {
        checkIn = docSnap['checkIn'];
        checkOut = docSnap['checkOut'];
      });
    } catch (e) {
      setState(() {
        checkIn = "--/--";
        checkOut = "--/--";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.only(
          top: screenHeight / 15,
          right: screenWidth / 20,
          left: screenWidth / 20,
          bottom: screenHeight / 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: screenHeight / 20,
          ),
          Center(
            child: Image(
              width: screenWidth/2.5,height: screenHeight/7,
              image:
              const AssetImage("assets/images/icons8-welcome-64.png"),
            fit:BoxFit.fill ,
            ),
          ),
          SizedBox(
            height: screenHeight / 15,
          ),
          Card(
            color: Colors.indigo,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Today's Status :-",
                style: TextStyle(
                    fontFamily: 'NexaBold',
                    fontSize: screenWidth / 18,
                    color: Colors.white
                ),
              ),
            ),
          ),
          SizedBox(
            height: screenHeight / 40,
          ),
          Container(
            height: screenHeight / 5,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(12)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black, offset: Offset(2, 2), blurRadius: 10)
                ]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Check In",
                      style: TextStyle(
                          fontFamily: 'NexaRegular',
                          fontSize: screenWidth / 18,
                          color: Colors.black54),
                    ),
                    Text(checkIn,
                        style: TextStyle(
                            fontFamily: 'NexaRegular',
                            fontSize: screenWidth / 20,
                            color: Colors.indigoAccent))
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Check Out",
                        style: TextStyle(
                            fontFamily: 'NexaRegular',
                            fontSize: screenWidth / 18,
                            color: Colors.black54)),
                    Text(checkOut,
                        style: TextStyle(
                            fontFamily: 'NexaRegular',
                            fontSize: screenWidth / 20,
                            color: Colors.indigoAccent))
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: screenHeight / 35,
          ),
          Text(
            DateFormat('dd MMMM yyyy').format(DateTime.now()).toString(),
            style: TextStyle(
                fontFamily: 'NexaBold',
                fontSize: screenWidth / 18,
                color: Colors.black54),
          ),
          StreamBuilder(
            stream: Stream.periodic(Duration(seconds: 1)),
            builder: (context, snapshot) {
              return Text(
                DateFormat('hh:mm:ss a').format(DateTime.now()).toString(),
                style: TextStyle(
                    fontFamily: 'NexaRegular',
                    fontSize: screenWidth / 20,
                    color: Colors.black54),
              );
            },
          ),

          checkOut == "--/--"
              ? Builder(builder: (context) {
            final GlobalKey<SlideActionState> key = GlobalKey();
            return SlideAction(
              text: checkIn == "--/--"
                  ? "Slide to check in"
                  : "Slide to check Out",
              textStyle: TextStyle(
                  fontFamily: 'NexaRegular',
                  fontSize: screenWidth / 20,
                  color: Colors.black54),
              key: key,
              innerColor: checkIn == "--/--" ? primary : red,
              outerColor: Colors.white,
              onSubmit: () async {
                if(AppUser.lat!=0){
                  _getLocation();
                  QuerySnapshot snap = await FirebaseFirestore.instance
                      .collection("students")
                      .where('id', isEqualTo: AppUser.id)
                      .get();
                  DocumentSnapshot docsnap = await FirebaseFirestore
                      .instance
                      .collection("students")
                      .doc(AppUser.id)
                      .collection("Records")
                      .doc(DateFormat('dd MMMM yyyy')
                      .format(DateTime.now()))
                      .get();
                  try {
                    String checkIn = docsnap["checkIn"];
                    setState(() {
                      checkOut =
                          DateFormat('hh:mm').format(DateTime.now());
                    });
                    await FirebaseFirestore.instance
                        .collection("students")
                        .doc(AppUser.id)
                        .collection("Records")
                        .doc(DateFormat('dd MMMM yyyy')
                        .format(DateTime.now()))
                        .update({
                      "checkIn": checkIn,
                      "checkOut":
                      DateFormat('hh:mm:ss a').format(DateTime.now()),
                      "date": Timestamp.now(),
                      "checkInlocation":location,
                    });
                  } catch (e) {
                    setState(() {
                      checkIn =
                          DateFormat('hh:mm').format(DateTime.now());
                    });

                    await FirebaseFirestore.instance
                        .collection("students")
                        .doc(AppUser.id)
                        .collection("Records")
                        .doc(DateFormat('dd MMMM yyyy')
                        .format(DateTime.now()))
                        .set({
                      "checkIn":
                      DateFormat('hh:mm:ss a').format(DateTime.now()),
                      "checkOut": "--/--",
                      "date": Timestamp.now(),
                      'checkOutLocation': location,
                    });
                  }
                  await FirebaseFirestore.instance
                      .collection("students")
                      .doc(AppUser.id)
                      .collection("Records")
                      .doc(DateFormat('dd MMMM yyyy')
                      .format(DateTime.now())
                      .toString())
                      .update({
                    "checkIn":
                    DateFormat('hh:mm:ss a').format(DateTime.now())
                  });
                  Future.delayed(const Duration(microseconds: 500), () {
                    key.currentState!.reset();
                  });
                }
                else{
                  Timer(const Duration(seconds: 3),() async {
                    _getLocation();
                    QuerySnapshot snap = await FirebaseFirestore.instance
                        .collection("students")
                        .where('id', isEqualTo: AppUser.id)
                        .get();
                    DocumentSnapshot docsnap = await FirebaseFirestore
                        .instance
                        .collection("students")
                        .doc(AppUser.id)
                        .collection("Records")
                        .doc(DateFormat('dd MMMM yyyy')
                        .format(DateTime.now()))
                        .get();
                    try {
                      String checkIn = docsnap["checkIn"];
                      setState(() {
                        checkOut =
                            DateFormat('hh:mm').format(DateTime.now());
                      });
                      await FirebaseFirestore.instance
                          .collection("students")
                          .doc(AppUser.id)
                          .collection("Records")
                          .doc(DateFormat('dd MMMM yyyy')
                          .format(DateTime.now()))
                          .update({
                        "checkIn": checkIn,
                        "checkOut":
                        DateFormat('hh:mm:ss a').format(DateTime.now()),
                        "date": Timestamp.now(),
                        "checkInlocation":location,
                      });
                    } catch (e) {
                      setState(() {
                        checkIn =
                            DateFormat('hh:mm').format(DateTime.now());
                      });

                      await FirebaseFirestore.instance
                          .collection("students")
                          .doc(AppUser.id)
                          .collection("Records")
                          .doc(DateFormat('dd MMMM yyyy')
                          .format(DateTime.now()))
                          .set({
                        "checkIn":
                        DateFormat('hh:mm:ss a').format(DateTime.now()),
                        "checkOut": "--/--",
                        'checkOutLocation': location,
                        "date": Timestamp.now()
                      });
                    }
                    await FirebaseFirestore.instance
                        .collection("students")
                        .doc(AppUser.id)
                        .collection("Records")
                        .doc(DateFormat('dd MMMM yyyy')
                        .format(DateTime.now())
                        .toString())
                        .update({
                      "checkIn":
                      DateFormat('hh:mm:ss a').format(DateTime.now())
                    });
                    Future.delayed(const Duration(microseconds: 500), () {
                      key.currentState!.reset();
                    });
                  });
                }
              },
            );
          })
              : Container(
                  margin: EdgeInsets.only(top: screenHeight / 20),
                  child: Text(
                    "You Completed Your Day",
                    style: TextStyle(
                        fontFamily: 'NexaRegular',
                        fontSize: screenWidth / 20,
                        color: Colors.black54),
                  ),
                ),
          //Location///////////////////////////////////////////////////////////
          location != "--"  ?
          Text("location+$location")
              : const SizedBox(),
        ],
      ),
    );
  }
  getDocSnap()  {
    return
      FirebaseFirestore
        .instance
        .collection("students")
        .doc(AppUser.id)
        .collection("Records")
        .doc(DateFormat('dd MMMM yyyy')
        .format(DateTime.now()));
  }
}
