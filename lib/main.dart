// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teleconsultation/starting_page/onboarding_screen.dart';

import 'doctor_page/drawer.dart';
import 'home_page/drawer.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
//  await MongoDatabase.connect();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var id = prefs.getString("_id");
  var docid = prefs.getString("id");
  if (id != null) {
    runApp(MaterialApp(
        home: id == null ? const OnboardingScreen() : const HomePage()));
  } else if (docid != null) {
    runApp(MaterialApp(
    home: docid == null ? const OnboardingScreen() : const DoctorPage()));
  }else{
    runApp(const MaterialApp(
      home: OnboardingScreen()
    ));
  }
}


// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         // This is the theme of your application.
//         //
//         // Try running your application with "flutter run". You'll see the
//         // application has a blue toolbar. Then, without quitting the app, try
//         // changing the primarySwatch below to Colors.green and then invoke
//         // "hot reload" (press "r" in the console where you ran "flutter run",
//         // or simply save your changes to "hot reload" in a Flutter IDE).
//         // Notice that the counter didn't reset back to zero; the application
//         // is not restarted.
//         primarySwatch: Colors.blue,
//       ),
//       home: const OnboardingScreen(),
//     );
//   }
// }




