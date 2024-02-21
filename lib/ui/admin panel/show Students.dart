import 'package:abo_hany/ui/admin%20panel/department.dart';
import 'package:abo_hany/ui/admin%20panel/general.dart';
import 'package:flutter/material.dart';
import 'feature_widget.dart';

class ShowStudents extends StatelessWidget {
  final List<Widget> features = const [
    FeatureWidget(
      title: "First",
    ),
    FeatureWidget(
      title: "Second",
    ),
    FeatureWidget(
      title: "Third",
    ),
    FeatureWidget(
      title: "Fourth",
    )
  ];

  const ShowStudents({super.key});

  @override

  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return

      Container(
        padding: const EdgeInsets.symmetric(vertical: 70,horizontal: 12),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: 22, mainAxisSpacing: 22),
          itemBuilder: (_, index) {
            return InkWell(
                onTap: () {
                  if (index == 0 || index == 1) {
                    Navigator.pushNamed(context, General.routeName,
                        arguments: GeneralLevels("${index + 1}"));
                  } else {
                    Navigator.pushNamed(context, Departments.routeName,
                        arguments: Levels("${index + 1}th Level"));
                  }
                },
                child: features[index]);
          },
          itemCount: features.length,
        ),
      );

  }
}
