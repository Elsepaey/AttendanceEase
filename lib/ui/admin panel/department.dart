import 'package:abo_hany/ui/admin%20panel/finalAppBar.dart';
import 'package:flutter/material.dart';
import 'feature_widget.dart';
import 'general.dart';

class Departments extends StatelessWidget {
  static String routeName = "department";
  final List<Widget> departments = const [
    FeatureWidget(title: "SE",),
    FeatureWidget(title: "IT",),
    FeatureWidget(title: "IS"),
    FeatureWidget(title: "CS"),
  ];
  final List titles = ["SE", "IT", "IS", "CS"];

  Departments({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AdminAppBar(screenHeight),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 70,horizontal: 12),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: 22, mainAxisSpacing: 22),
          itemBuilder: (_, index) {
            return InkWell(
                onTap: () {
                  Navigator.pushNamed(context, General.routeName,
                      arguments: GeneralLevels("${titles[index]}"));
                },
                child: departments[index]);
          },
          itemCount: departments.length,
        ),
      ),
    );
  }
}

class Levels {
  String title;
  Levels(this.title);
}
