import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class AdminAppBar extends StatelessWidget implements  PreferredSizeWidget {
  double screenHeight ;
  AdminAppBar(this.screenHeight, {super.key});
  @override
  Widget build(BuildContext context) {

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: 80,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          color: Colors.indigo,

        ),
        child: Center(
          child: Text(
            "Admin Panel",
            style: TextStyle(
              //fontFamily: 'NexaBold',
              foreground: Paint()
                ..shader = ui.Gradient.linear(
                  const Offset(60, 130),
                  const Offset(90, 20),
                  <Color>[
                    Colors.red,
                    Colors.white,
                  ],
                ),
              fontStyle: FontStyle.italic,
              fontSize: 40,
            ),
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize =>  Size.fromHeight(screenHeight/12);

}
