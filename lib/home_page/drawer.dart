// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';import 'package:fluttertoast/fluttertoast.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:teleconsultation/calcu.dart';
import 'package:teleconsultation/home_page/drawers/appointment.dart';
import 'package:teleconsultation/home_page/drawers/history/history_screen.dart';

import '../app.dart';
import '../starting_page/login.dart';
import 'drawers/chat/screens/home_screen.dart';
import 'drawers/chat/screens/select_user_screen.dart';
import 'drawers/home_screen.dart';
import 'drawers/my_drawer_header.dart';
import 'drawers/profile.dart';
import 'drawers/terms.dart';
import 'package:http/http.dart' as http;


//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: HomePage(),
//     );
//   }
// }

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final client = StreamChatClient(streamKey
    // logLevel: Level.INFO,
  );
 SharedPreferences? loginData;
 String? email, name, patientDevice, id;

  @override
  void initState(){
    super.initState();
    initial();
  }

  void initial() async{
    loginData = await SharedPreferences.getInstance();
    setState(() {
      id = loginData?.getString('_id');
      email = loginData?.getString('email');
      name = loginData?.getString('name');
      patientDevice = loginData?.getString('patientDevice');
    });
  }


  // Future<void> getUser() async {
  //   try {
  //     final client = StreamChatCore.of(context).client;
  //     await client.connectUser(
  //       User(
  //         id: name,
  //         extraData: {
  //           'name': name,
  //           // 'image': user.image,
  //         },
  //       ),
  //       client.devToken(name).rawValue,
  //     );
  //
  //     Navigator.of(context).pushReplacement(
  //       MaterialPageRoute(builder: (context) => ChatScreen()),
  //     );
  //   } on Exception catch (e, st) {
  //     logger.e('Could not connect user', e, st);
  //     setState(() {
  //       // _loading = false;
  //     });
  //   }
  // }

  Future update(id ) async {
    loginData = await SharedPreferences.getInstance();

    Map data = {
      "devices": [""],
    };
    String body = json.encode(data);
    http.Response response = await http.patch(
      Uri.parse('https://newserverobgyn.herokuapp.com/api/user/checkDevice/$id'),
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    //print(response.body);
    if (response.statusCode == 200) {
      // Fluttertoast.showToast(
      //     msg: "Updated Successfully",
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.BOTTOM,
      //     backgroundColor: Colors.green,
      //     textColor: Colors.white,
      //     fontSize: 16.0);
    }else{
      // Fluttertoast.showToast(
      //     msg: "Update Failed try other email",
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.BOTTOM,
      //     backgroundColor: Colors.redAccent,
      //     textColor: Colors.white,
      //     fontSize: 16.0);
    }

    // if(response.statusCode != 200){
    //   Fluttertoast.showToast(
    //       msg: "Update Failed try other email",
    //       toastLength: Toast.LENGTH_SHORT,
    //       gravity: ToastGravity.BOTTOM,
    //       backgroundColor: Colors.redAccent,
    //       textColor: Colors.white,
    //       fontSize: 16.0);
    // }

  }

  var currentPage = DrawerSections.dashboard;

  @override
  Widget build(BuildContext context) {
    dynamic container;
    if (currentPage == DrawerSections.dashboard) {
     container = const HomeScreen();
    } else if (currentPage == DrawerSections.contacts) {
     // container = calculator();
     container = ProfileScreen();
    } else if (currentPage == DrawerSections.events) {
     container = const MyAppointment();
    } else if (currentPage == DrawerSections.notes) {
      container = SelectUserScreen();
    } else if (currentPage == DrawerSections.settings) {
     container = const HistoryScreen();
    } else if (currentPage == DrawerSections.notifications) {
//      container = NotificationsPage();
    } else if (currentPage == DrawerSections.privacy_policy) {
     container =const TermsAndConditions();
    }
    // else if (currentPage == DrawerSections.send_feedback) {
    //   container = EditProfile();
    // }
    // else if (currentPage == DrawerSections.send_feedback) {
    //  container = EditProfile();
    // }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffF8AFA6),
        title: const Text(""),
        iconTheme: const IconThemeData(color: Colors.redAccent),
      ),
      body: container,
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const MyHeaderDrawer(),
              myDrawerList(),
              ListTile(
                  leading: const Icon(LineAwesomeIcons.alternate_sign_out),
                  title: const Text("Logout",
                    style: TextStyle(fontSize: 20),),
                  onTap: () async{
                    print("this is the: $patientDevice");
                    loginData?.setBool('login', true);
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.clear();
                    // Navigator.pushReplacement(context,
                    //      MaterialPageRoute(builder: (context) => const LoginScreen()));
                    // print("this is the token: $patientDevice");
                    update(id);
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (BuildContext context) {
                          return const LoginScreen();
                        },
                        ), (router) => false);

                  })
            ],
          ),
        ),
      ),
    );
  }

  Widget myDrawerList() {
    return Container(
      padding: const EdgeInsets.only(
        top: 15,
      ),
      child: Column(
        // shows the list of menu drawer
        children: [
          menuItem(1, "Home Page", Icons.dashboard_outlined,
              currentPage == DrawerSections.dashboard ? true : false),
          menuItem(2, "Profile Information", Icons.people_alt_outlined,
              currentPage == DrawerSections.contacts ? true : false),
          menuItem(3, "Appointment Schedules", Icons.event,
              currentPage == DrawerSections.events ? true : false),
          menuItem(4, "Chat", Icons.message,
              currentPage == DrawerSections.notes ? true : false),
          // const Divider(),
          menuItem(5, "Appointment History", Icons.history_edu,
              currentPage == DrawerSections.settings ? true : false),
          // menuItem(6, "Consultation", Icons.notifications_outlined,
          //     currentPage == DrawerSections.notifications ? true : false),
         const Divider(),
         menuItem(7, "Privacy policy", Icons.privacy_tip_outlined,
             currentPage == DrawerSections.privacy_policy ? true : false),
         menuItem(8, "Send feedback", Icons.feedback_outlined,
             currentPage == DrawerSections.send_feedback ? true : false),
        ],
      ),
    );
  }

  Widget menuItem(int id, String title, IconData icon, bool selected) {
    return Material(
      color: selected ? Colors.grey[300] : Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          setState(() {
            if (id == 1) {
              currentPage = DrawerSections.dashboard;
            } else if (id == 2) {
              currentPage = DrawerSections.contacts;
            } else if (id == 3) {
              currentPage = DrawerSections.events;
            } else if (id == 4) {
              currentPage = DrawerSections.notes;
            } else if (id == 5) {
              currentPage = DrawerSections.settings;
            } else if (id == 6) {
              currentPage = DrawerSections.notifications;
            } else if (id == 7) {
              currentPage = DrawerSections.privacy_policy;
            } else if (id == 8) {
              currentPage = DrawerSections.send_feedback;
            }
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              Expanded(
                child: Icon(
                  icon,
                  size: 20,
                  color: Colors.black,
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum DrawerSections {
  dashboard,
  contacts,
  events,
  notes,
  settings,
  notifications,
  privacy_policy,
  send_feedback,
}
