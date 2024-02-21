import 'package:abo_hany/homescreen.dart';
import 'package:abo_hany/ui/admin%20panel/admin.dart';
import 'package:abo_hany/ui/admin%20panel/department.dart';
import 'package:abo_hany/ui/admin%20panel/general.dart';
import 'package:abo_hany/ui/admin%20panel/student_records.dart';
import 'package:abo_hany/ui/login/log_in.dart';
import 'package:abo_hany/ui/auth_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:month_year_picker/month_year_picker.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp( const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      routes: {
        Login.routeName: (context) => const Login(),
        Home.routeName: (context) => const Home(),
        adminPage.Route_Name:(context)=>adminPage(),
        General.routeName:(context)=>General(),
        Departments.routeName:(context)=>Departments(),
        StudentRecords.routeName:(context)=>StudentRecords(),
      },
      home: const AuthCheck(),
      localizationsDelegates:const [
        MonthYearPickerLocalizations.delegate
      ],
    );
  }
}


