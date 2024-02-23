

import 'package:flutter/material.dart';
class Appbar {

  static PreferredSize  appbar(BuildContext context){
    double screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return
      PreferredSize(preferredSize: Size.fromHeight(screenHeight/4.5), child:
      Container(
        height:screenHeight/4.5,
        decoration:  BoxDecoration(
          color: Colors.indigoAccent,
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(screenWidth/4),
            bottomLeft: Radius.circular(screenWidth/4),
          ),
        ),
        child:  Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person, size: screenWidth/6, color: Colors.white,),
            Icon(Icons.person, size: screenWidth/4, color: Colors.white),
            Icon(Icons.person, size: screenWidth/6, color: Colors.white),
          ],
        ),
      ));
  }
}

