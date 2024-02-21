
import 'package:abo_hany/ui/admin%20panel/finalAppBar.dart';
import 'package:abo_hany/ui/admin%20panel/student_records.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class General extends StatelessWidget {
  static String routeName = "general";
   late final double screenWidth ;
   late final double screenHeight ;
   String title="";

  @override
  Widget build(BuildContext context) {

    var args = ModalRoute.of(context)?.settings.arguments as GeneralLevels;

    String level = args.title;
     screenHeight = MediaQuery.of(context).size.height;
     screenWidth = MediaQuery.of(context).size.width;
    var ref =identifyLevel(level);

    return Scaffold(
      appBar:
AdminAppBar(screenHeight),      body: Column(
        children: [
          Card(child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(title,style: TextStyle(fontSize: screenWidth/20),),
          ),),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: ref,
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text("Error: ${snapshot.error}"),
                  );
                } else if (!snapshot.hasData) {
                  return const Center(
                    child: Text("No Records Yet"),
                  );
                } else {
                  final snap = (snapshot.data!).docs;
                  return ListView.builder(
                      itemCount: snap.length,
                      itemBuilder: (context, index) {
                        return InkWell(child: studentCard(snap, index),
                          onTap: (){
                          String id=snap [index].id;
                          String name=snap[index]["firstName"]+" "+snap[index]["lastName"];
                          Navigator.pushNamed(context,StudentRecords.routeName,arguments: StudentId(id,name));},
                        );
                      });
                }
              },
            ),
          )
        ],
      ),
    );
  }
  identifyLevel(String level)
  {
    if(level=='1'||level=='2')
      {
        title='${level}th Level';
        return
        FirebaseFirestore.instance
            .collection("students")
            .where("role", isEqualTo: 'user')
            .where('level', isEqualTo: level)
            .snapshots();}
  else
    {
      title='$level Department';

      return FirebaseFirestore.instance
          .collection("students")
          .where("role", isEqualTo: 'user')
          .where('department', isEqualTo: level)
          .snapshots();
    }
  }


  studentCard(List<QueryDocumentSnapshot>snap,int index){
    return Card(

      color: Colors.red,

      margin:  EdgeInsets.only(left: screenWidth/35,right: screenWidth/35,top: screenWidth/30),
      child: Container(
          padding: EdgeInsets.symmetric(vertical:screenWidth/45,horizontal: screenWidth/30),
      child: Text(snap[index]["firstName"]+" "+snap[index]["lastName"],
        style: TextStyle(fontSize: screenWidth/20,color: Colors.white),)),
    );
  }
}

class GeneralLevels {
  String title;

  GeneralLevels(this.title);
}
