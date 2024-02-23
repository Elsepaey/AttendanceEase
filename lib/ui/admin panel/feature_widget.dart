import 'package:flutter/material.dart';

class FeatureWidget extends StatelessWidget {
  final String title;
  const FeatureWidget({super.key, required this.title});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(

          color: Color(0xFF041A45).withOpacity(0.7),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24))),
      child: Center(
          child: Text(
        title,
        style: const TextStyle(
            fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      )),
    );
  }
}
