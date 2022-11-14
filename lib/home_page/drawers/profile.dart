import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teleconsultation/home_page/drawers/change_password.dart';
import 'package:teleconsultation/home_page/drawers/editprofile.dart';

import '../../constant.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

//  static const routeName = "/profile";

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
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
      fName = loginData.getString('name')!;
      lastName = loginData.getString('surname')!;
      contactNumber = loginData.getString('phone')!;
      birthday = loginData.getString('birthdate')!;
      homeAddress = loginData.getString('address')!;
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
              children: [
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
                  title: Text("Settings"),
                ),
                const Divider(
                  height: 0.6,
                  color: Colors.black87,
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  const ChangePassword()));
                  },
                 leading: const Icon(Icons.edit),
                  title: const Text("Change Password"),
                )
              ],
            ),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  const EditProfile()));
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
                      "Edit Profile",
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



class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

//  static const routeName = "/profile";

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {


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
      fName = loginData.getString('name')!;
      lastName = loginData.getString('surname')!;
      contactNumber = loginData.getString('phone')!;
      birthday = loginData.getString('birthdate')!;
      homeAddress = loginData.getString('address')!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Account",
                  style: subTitleTextStyle.copyWith(color: primaryColor500),
                ),
                const SizedBox(
                  height: 8,
                ),
                InkWell(
                  onTap: (){},
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Container(
                          width: 75,
                          height: 75,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image: AssetImage("assets/images/profile.png"),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "$fName $lastName",
                              style: subTitleTextStyle,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                    color: primaryColor100.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: primaryColor500)),
                                child: Text(
                                  "User",
                                  style: descTextStyle.copyWith(
                                      color: primaryColor500),
                                ))
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),
                Text(
                  "Profile Information",
                  style: subTitleTextStyle.copyWith(color: primaryColor500),
                ),
                InkWell(
                  onTap: () {},
                  splashColor: primaryColor100,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: colorWhite),
                          child: const Icon(
                            Icons.email,
                            size: 24,
                            color: darkBlue300,
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "$email",
                                overflow: TextOverflow.visible,
                                style: normalTextStyle,
                              ),

                              // const SizedBox(
                              //   height: 8,
                              // ),
                              // Text(
                              //   "Not Set",
                              //   style: descTextStyle,
                              // ),

                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // const SizedBox(
                //   height: 16,
                // ),
                // Text(
                //   "Other",
                //   style: subTitleTextStyle.copyWith(color: primaryColor500),
                // ),
                InkWell(
                  onTap: () {},
                  splashColor: primaryColor100,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: colorWhite),
                          child: const Icon(
                            Icons.phone,
                            size: 24,
                            color: darkBlue300,
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "$contactNumber",
                              style: normalTextStyle,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  splashColor: primaryColor100,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: colorWhite),
                          child: const Icon(
                            Icons.location_on,
                            size: 24,
                            color: darkBlue300,
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "$homeAddress",
                              style: normalTextStyle,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  splashColor: primaryColor100,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: colorWhite),
                          child: const Icon(
                            Icons.date_range_rounded,
                            size: 24,
                            color: darkBlue300,
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "$birthday",
                              style: normalTextStyle,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  const ChangePassword()));
                  },
                  splashColor: primaryColor100,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: colorWhite),
                          child: const Icon(
                            Icons.password,
                            size: 24,
                            color: darkBlue300,
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Change Password",
                              style: normalTextStyle,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  const EditProfile()));
                  },
                  splashColor: primaryColor100,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: colorWhite),
                          child: const Icon(
                            Icons.edit,
                            size: 24,
                            color: darkBlue300,
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Edit Profile Information",
                              style: normalTextStyle,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  "About App",
                  style: subTitleTextStyle.copyWith(color: primaryColor500),
                ),
                InkWell(
                  onTap: () {
                    _showSnackBar(context, "Newest Version");
                  },
                  splashColor: primaryColor100,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: colorWhite),
                          child: const Icon(
                            CupertinoIcons.info_circle_fill,
                            size: 24,
                            color: darkBlue300,
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "TeleObGyn Booking App",
                                style: normalTextStyle,
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                "Version 1.0.0",
                                style: descTextStyle,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // InkWell(
                //   // onTap: () => launch("https://github.com/mikirinkode"),
                //   splashColor: primaryColor100,
                //   child: Padding(
                //     padding: const EdgeInsets.all(16.0),
                //     child: Row(
                //       children: [
                //         Container(
                //           width: 50,
                //           height: 50,
                //           padding: const EdgeInsets.all(12.0),
                //           decoration: const BoxDecoration(
                //               shape: BoxShape.circle, color: colorWhite),
                //           // child: Image.asset(
                //           //   "assets/icons/github.png",
                //           //   color: darkBlue300,
                //           // ),
                //         ),
                //         const SizedBox(
                //           width: 16,
                //         ),
                //         Flexible(
                //           child: Column(
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //             children: [
                //               Text(
                //                 "Github",
                //                 style: normalTextStyle,
                //               ),
                //               const SizedBox(
                //                 height: 8,
                //               ),
                //               Text(
                //                 "github.com/mikirinkode",
                //                 style: descTextStyle,
                //               ),
                //             ],
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                // const SizedBox(
                //   height: 16,
                // ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Text(
                //       "Created with ",
                //       style: normalTextStyle,
                //     ),
                //     const SizedBox(
                //       width: 4,
                //     ),
                //     Text(
                //       "{code}",
                //       style: subTitleTextStyle.copyWith(color: primaryColor500),
                //     ),
                //     const SizedBox(
                //       width: 4,
                //     ),
                //     Text(
                //       "and",
                //       style: normalTextStyle,
                //     ),
                //     const SizedBox(
                //       width: 4,
                //     ),
                //     const Icon(
                //       Icons.favorite_rounded,
                //       color: Colors.red,
                //     )
                //   ],
                // ),
              ],
            ),
          ),
        ));
  }

  void _showSnackBar(BuildContext context, String message) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(SnackBar(
      content: Text(message),
      margin: const EdgeInsets.all(16),
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 2),
      // margin: EdgeInsets.all(16),
    ));
  }
}