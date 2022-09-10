import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import '../../starting_page/login.dart';
// import '../../users.dart';

class MyHeaderDrawer extends StatefulWidget {
  const MyHeaderDrawer({Key? key}) : super(key: key);

  @override
  _MyHeaderDrawerState createState() => _MyHeaderDrawerState();
}

class _MyHeaderDrawerState extends State<MyHeaderDrawer> {
  // ProfileModel model = ProfileModel(id: '', email: '', contactNo: '', fName: '', lName: '');
  // User1 userval = User1(lName: '', fName: '', id: '', contactNo: '', email: '', cPassword: '', password: '');


  late SharedPreferences loginData;
  String? email, fName, lastName, contactNumber;


  @override
  void initState(){
    initial();
    super.initState();
  }

  void initial() async{
    loginData = await SharedPreferences.getInstance();
    setState(() {
      email = loginData.getString('email')!;
      // print(email);
      fName = loginData.getString('fName')!;
      lastName = loginData.getString('lName')!;
      contactNumber = loginData.getString('contactNo')!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xffFADCD9),
      width: double.infinity,
      height: 200,
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            height: 70,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage('assets/images/default_user_icon.png'),
              ),
            ),
          ),
          Text(
            fName??"",
            style: const TextStyle(color: Colors.black, fontSize: 20),
          ),
          Text(
            email??"",
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
