import 'package:abo_hany/model/user.dart';
import 'package:abo_hany/services/firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';

class Calender extends StatefulWidget {
  const Calender({super.key});


  @override
  State<Calender> createState() => _CalenderState();
}

class _CalenderState extends State<Calender> {
  double screenWidth = 0;
  double screenHeight = 0;
  Color primary = Colors.indigoAccent;
  String _month = DateFormat('MMMM').format(DateTime.now());
@override



  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
        child: Container(
        padding: const EdgeInsets.all(20),
        margin: EdgeInsets.only(top: screenHeight / 15, bottom: 20),
        child: Column(children: [
        Container(
          alignment: Alignment.centerLeft,
          child: Card(
            color: Colors.red,
            borderOnForeground: true,
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Text(
                "My Attendance",
                style: TextStyle(
                  fontFamily: 'NexaRegular',
                  fontSize: screenWidth / 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: screenHeight / 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Card(
                color: Colors.indigo,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                      onTap: () async {
                        final month = await showMonthYearPicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2022),
                            lastDate: DateTime(2033),
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: const ColorScheme.light(
                                    primary: Colors.red,
                                    secondary: Colors.red,
                                    onSecondary: Colors.white,
                                  ),
                                  textButtonTheme: TextButtonThemeData(
                                    style: TextButton.styleFrom(
                                      foregroundColor: primary,
                                    ),
                                  ),
                                  textTheme:  const TextTheme(
                                    headlineMedium: TextStyle(
                                      fontFamily: "NexaBold",
                                    ),
                                    labelSmall: TextStyle(
                                      fontFamily: "NexaBold",
                                    ),
                                    labelLarge: TextStyle(
                                      fontFamily: "NexaBold",
                                    ),
                                  ),
                                ),
                                child: child!,
                              );
                            });
                        if (month != null) {
                          setState(() {
                            _month = DateFormat('MMMM').format(month);
                          });
                        }
                      },
                      child: Text(
                        "Pick a Month ",
                        style: TextStyle(
                            color: Colors.white, fontSize: screenWidth / 25),
                      )),
                )),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "$_month ",
                  style: TextStyle(
                      color: Colors.black, fontSize: screenWidth / 30),
                ),
              ),
              //color: Colors.indigo,
            ),
          ],
        ),
        //####################################################################//
        SizedBox(
          height: screenHeight - (screenHeight / 4),
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseCores.getRecords(AppUser.id),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if(snapshot.connectionState==ConnectionState.waiting){
                return const CircularProgressIndicator();
              }
              else if (snapshot.hasError){
                return Center(
                  child: Text("Error: ${snapshot.error}"),
                );
              }
              else if(!snapshot.hasData)
              {
                return const Center(
                  child: Text("No Records Yet"),
                );
              }
              else
                {
                final snap = (snapshot.data!).docs;

                return ListView.builder(
                    itemCount: snap.length,
                    itemBuilder: (context, index) {
                      return DateFormat("MMMM")
                                  .format(snap[index]["date"].toDate()) ==
                              _month
                          ? Container(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              height: screenHeight / 5,
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black,
                                        offset: Offset(2, 2),
                                        blurRadius: 10)
                                  ]),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                      child: Container(
                                    decoration: const BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12))),
                                    child: Center(
                                      child: Text(
                                        DateFormat("EE\ndd").format(
                                            snap[index]["date"].toDate()),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: "NexaBold",
                                            fontSize: screenWidth / 18),
                                      ),
                                    ),
                                  )),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Check In",
                                          style: TextStyle(
                                              fontFamily: 'NexaRegular',
                                              fontSize: screenWidth / 18,
                                              color: Colors.black54),
                                        ),
                                        Text(snap[index]["checkIn"],
                                            style: TextStyle(
                                                fontFamily: 'NexaRegular',
                                                fontSize: screenWidth / 22,
                                                color: Colors.indigoAccent))
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text("Check Out",
                                            style: TextStyle(
                                                fontFamily: 'NexaRegular',
                                                fontSize: screenWidth / 18,
                                                color: Colors.black54)),
                                        Text(snap[index]["checkOut"],
                                            style: TextStyle(
                                                fontFamily: 'NexaRegular',
                                                fontSize: screenWidth / 22,
                                                color: Colors.indigoAccent))
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                          : Container()
                      ;
                    });
              }


            },
          ),
        ),
      ]),
    ));
  }


}
