import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'change_password_doctor.dart';
import 'doctor_editprofile.dart';

class DoctorProfile extends StatefulWidget {
  const DoctorProfile({Key? key}) : super(key: key);

//  static const routeName = "/profile";

  @override
  _DoctorProfileState createState() => _DoctorProfileState();
}

class _DoctorProfileState extends State<DoctorProfile> {
  // ProfileModel model = ProfileModel();


  late SharedPreferences loginData;
  String? email, fName, lastName, contactNumber, birthday, homeAddress;

  Color shrinePink400 = const Color(0xFFEAA4A4);

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
      lastName = loginData.getString('lName')!;
      contactNumber = loginData.getString('contactNo')!;
      birthday = loginData.getString('birthday')!;
      homeAddress = loginData.getString('homeAddress')!;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              //for circle avtar image
              _getHeader(),
//                SizedBox(
//                  height: 10,
//                ),
//                _profileName("Raj Jani"),
//                SizedBox(
//                  height: 14,
//                ),
//                _heading("Personal Details"),
//                SizedBox(
//                  height: 6,
//                ),
//                _detailsCard(),
//                SizedBox(
//                  height: 10,
//                ),
//                _heading("Settings"),
//                SizedBox(
//                  height: 6,
//                ),
//                _settingsCard(),
//                Spacer(),
//                logoutButton()
            ],
          ),
        )
    );
  }

  Widget _getHeader() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child:Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: const BoxDecoration(
//                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      shape: BoxShape.circle,
                      image: DecorationImage(
//                      fit: BoxFit.fill,
                          image: AssetImage(
                              'assets/images/default_user_icon.png'))
                    // color: Colors.orange[100],
                  ),
                ),
              ),),
          ],
        ),SizedBox(
          width: MediaQuery.of(context).size.width * 0.80, //80% of width,
          child: Center(
            child: Text(
              fName??"",
              style: const TextStyle(
                  color: Colors.black, fontSize: 24, fontWeight: FontWeight.w800),
            ),
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.80, //80% of width,
          child: const Text(
            "Personal Details",
            style: TextStyle(fontSize: 16),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            elevation: 4,
            child: Column(
              children: [
                //row for each deatails
                ListTile(
                  leading: const Icon(Icons.email),
                  title: Text(email??""),
                ),
                const Divider(
                  height: 0.6,
                  color: Colors.black87,
                ),
                ListTile(
                  leading: const Icon(Icons.phone),
                  title: Text(contactNumber??""),
                ),
                const Divider(
                  height: 0.6,
                  color: Colors.black87,
                ),
                 ListTile(
                  leading: const Icon(Icons.location_on),
                  title: Text(homeAddress??""),
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            elevation: 4,
            child: Column(
              children:  [
                //row for each deatails
                ListTile(
                  leading: const Icon(Icons.date_range_rounded),
                  title: Text(birthday??""),
                ),
                const Divider(
                  height: 0.6,
                  color: Colors.black87,
                ),
                const ListTile(
                 leading: Icon(Icons.settings),
                  title:  Text("Settings"),
                ),
                const Divider(
                  height: 0.6,
                  color: Colors.black87,
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  const ChangePasswordDoctor()));
                  },
                 leading: const Icon(Icons.edit),
                  title: const Text("Change Password"),
                )
              ],
            ),
          ),
        ),InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DoctorEditProfile()));
          },
          child: Container(
              color: shrinePink400,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Edit",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    )
                  ],
                ),
              )),
        )],
    );
  }

  // Widget _profileName(String name) {
  //   return SizedBox(
  //     width: MediaQuery.of(context).size.width * 0.80, //80% of width,
  //     child: Center(
  //       child: Text(
  //         name,
  //         style: const TextStyle(
  //             color: Colors.black, fontSize: 24, fontWeight: FontWeight.w800),
  //       ),
  //     ),
  //   );
  // }
  //
  // Widget _heading(String heading) {
  //   return SizedBox(
  //     width: MediaQuery.of(context).size.width * 0.80, //80% of width,
  //     child: Text(
  //       heading,
  //       style: const TextStyle(fontSize: 16),
  //     ),
  //   );
  // }
  //
  // Widget _detailsCard() {
  //   return Padding(
  //     padding: const EdgeInsets.all(8.0),
  //     child: Card(
  //       elevation: 4,
  //       child: Column(
  //         children: const [
  //           //row for each deatails
  //           ListTile(
  //             leading: Icon(Icons.email),
  //             title: Text("Something@gmail.com"),
  //           ),
  //           Divider(
  //             height: 0.6,
  //             color: Colors.black87,
  //           ),
  //           ListTile(
  //             leading: Icon(Icons.phone),
  //             title: Text("1234567890"),
  //           ),
  //           Divider(
  //             height: 0.6,
  //             color: Colors.black87,
  //           ),
  //           ListTile(
  //             leading: Icon(Icons.location_on),
  //             title: Text("SomeWhere"),
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }
  //
  // Widget _settingsCard() {
  //   return Padding(
  //     padding: const EdgeInsets.all(8.0),
  //     child: Card(
  //       elevation: 4,
  //       child: Column(
  //         children: const [
  //           //row for each deatails
  //           ListTile(
  //             leading: Icon(Icons.settings),
  //             title: Text("Settings"),
  //           ),
  //           Divider(
  //             height: 0.6,
  //             color: Colors.black87,
  //           ),
  //           ListTile(
  //             leading: Icon(Icons.dashboard_customize),
  //             title: Text("About Us"),
  //           ),
  //           Divider(
  //             height: 0.6,
  //             color: Colors.black87,
  //           ),
  //           ListTile(
  //             leading: Icon(Icons.topic),
  //             title: Text("Change Theme"),
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget logoutButton() {
    return InkWell(
      onTap: () {},
      child: Container(
        // height: 56.0,
          color: Colors.orange,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
                SizedBox(width: 10),
                Text(
                  "Logout",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                )
              ],
            ),
          )),
    );
  }
}