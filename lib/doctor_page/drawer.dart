// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../starting_page/login.dart';
import 'drawers/appointment.dart';
import 'drawers/chat/modules/main_page.dart';
import 'drawers/home_screen.dart';
import 'drawers/my_drawer_header.dart';
import 'drawers/profile.dart';
import 'drawers/terms.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DoctorPage(),
    );
  }
}

class DoctorPage extends StatefulWidget {
  const DoctorPage({Key? key}) : super(key: key);

  @override
  _DoctorPageState createState() => _DoctorPageState();
}

class _DoctorPageState extends State<DoctorPage> {
  late SharedPreferences loginData;
  late String email, fName;

  @override
  void initState(){
    super.initState();
    initial();
  }

  void initial() async{
    loginData = await SharedPreferences.getInstance();
    setState(() {
      email = loginData.getString('email')!;
      fName = loginData.getString('fName')!;
    });
  }

  var currentPage = DrawerSections.dashboard;

  @override
  Widget build(BuildContext context) {
    dynamic container;
    if (currentPage == DrawerSections.dashboard) {
      container = const DoctorHomeScreen();
    } else if (currentPage == DrawerSections.contacts) {
      container = const DoctorProfile();
    } else if (currentPage == DrawerSections.events) {
      container = const DoctorMyAppointment();
    } else if (currentPage == DrawerSections.notes) {
      container = const DoctorMainPage();
    } else if (currentPage == DrawerSections.settings) {
//      container = SettingsPage();
    } else if (currentPage == DrawerSections.notifications) {
//      container = NotificationsPage();
    } else if (currentPage == DrawerSections.privacy_policy) {
     container = const TermsAndConditions();
    }
//     else if (currentPage == DrawerSections.send_feedback) {
// //      container = SendFeedbackPage();
//     }
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
              const DoctorMyHeaderDrawer(),
              myDrawerList(),
              ListTile(
                  leading: const Icon(LineAwesomeIcons.alternate_sign_out),
                  title: const Text("Logout",
                    style: TextStyle(fontSize: 20),),
                  onTap: () async{
                    //print("Logout Users");
                    loginData.setBool('login', true);
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.clear();
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()));

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
          menuItem(1, "DHome Page", Icons.dashboard_outlined,
              currentPage == DrawerSections.dashboard ? true : false),
          menuItem(2, "Profile Information", Icons.people_alt_outlined,
              currentPage == DrawerSections.contacts ? true : false),
          menuItem(3, "Appointment Schedules", Icons.event,
              currentPage == DrawerSections.events ? true : false),
          menuItem(4, "Chat", Icons.message,
              currentPage == DrawerSections.notes ? true : false),
          // const Divider(),
          // menuItem(5, "Transaction History", Icons.storage,
          //     currentPage == DrawerSections.settings ? true : false),
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
            }
            // else if (id == 8) {
            //   currentPage = DrawerSections.send_feedback;
            // }
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
