
// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:teleconsultation/starting_page/register.dart';
import 'package:http/http.dart' as http;
import 'package:teleconsultation/user.dart';
import '../app.dart';
import '../components/background.dart';
import '../doctor_page/drawer.dart';
import '../doctornew.dart';
import '../home_page/drawer.dart';
import '../services/doctor.dart';
import '../services/loginservices.dart';
import '../../users.dart';
import 'package:teleconsultation/starting_page/forgotpassword.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  _LoginScreenState createState() => _LoginScreenState();

}

class _LoginScreenState extends State<LoginScreen> {
  String url = "https://flutter-auth-server.herokuapp.com/signin";
  bool circular = true;
  ProfileModel model = ProfileModel(lName: '', fName: '', id: '', contactNo: '', email: '');

  UserFetch userval = UserFetch(name: '', surname: '', id: '', birthdate: '', address: '',
      phone: '', email: '', password: '', isDoctor: false, verified: false,
    isAdmin: false, createdAt: '', updatedAt: '', devices:['']);

  DoctorNewFetch doctorNew = DoctorNewFetch(id: '', userId: '', firstName: '', lastName: '', phoneNumber: '',
      address: '', specialization: '', experience: '', timings: [], status: '',
      createdAt: '', updatedAt: '', devices:[]);

  DoctorFetch doctorrval = DoctorFetch(lName: '', fName: '', id: '', birthday: '', homeAddress: '', contactNo: '', email: '', cPassword: '', password: '');

  late SharedPreferences loginData;

   late bool new_user;

  String? mtoken = " ";

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        mtoken = token;
        print(mtoken);
      });
    });
  }

  Future update(id) async {
    loginData = await SharedPreferences.getInstance();

    Map data = {
      "devices": ["$mtoken"],
    };
    String body = json.encode(data);
    http.Response response = await http.patch(
      Uri.parse('https://newserverobgyn.herokuapp.com/api/user/checkDevice/$id'),
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    //print(response.body);
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



  Future doctorupdate(id) async {
    loginData = await SharedPreferences.getInstance();

    Map data = {
      "devices": ["$mtoken"],
    };
    String body = json.encode(data);
    http.Response response = await http.patch(
      Uri.parse('https://newserverobgyn.herokuapp.com/api/doctor/checkDevice/$id'),
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    //print(response.body);
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

  // List<dynamic> clients = [];
  // void fetchDoctorCollection(id) async {
  //   const url = 'https://newserverobgyn.herokuapp.com/api/doctor/get-doctor-info-by-its-id';
  //   Map data2 = {
  //     'userId': id
  //   };
  //   var body2 = json.encode(data2);
  //   var res = await http.post(Uri.parse("https://newserverobgyn.herokuapp.com/api/doctor/get-doctor-info-by-its-id"),
  //       headers: {"Content-Type": "application/json"},
  //       body: body2);
  //
  //   final data = json.decode(res.body);
  //   doctorNew = DoctorNewFetch.fromJson(data['data']);
  //   loginData.setString('doctorId', doctorNew.id);
  //   doctorupdate(doctorNew.id);
  //   // firstName = doctorNew.firstName;
  //   // lastName = doctorNew.lastName;
  //   // phoneNumber = doctorNew.phoneNumber;
  //   // website = doctorNew.website;
  //   // specialization = doctorNew.specialization;
  //   // docAddress = doctorNew.address;
  //   // fee = doctorNew.fee;
  //   // openTime = doctorNew.timings[0];
  //   // lastTime = doctorNew.timings[1];
  //   loginData.setString('name', doctorNew.firstName);
  //   print(doctorNew.firstName);
  //   loginData.setString('surname', doctorNew.lastName);
  //   loginData.setString('phone', doctorNew.phoneNumber);
  //   loginData.setString('website', doctorNew.website);
  //   loginData.setString('specialization', doctorNew.specialization);
  //   loginData.setString('address', doctorNew.address);
  //   loginData.setInt('fee', doctorNew.fee);
  //   loginData.setString('openTime', doctorNew.timings[0]);
  //   loginData.setString('lastTime', doctorNew.timings[1]);
  //   loginData.setString('docDevice', mtoken!);
  // }

  List<String> deviceList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLogin();
    getToken();
  }


  void checkLogin() async {
    loginData = await SharedPreferences.getInstance();
    new_user = (loginData.getBool('login') ?? true);

    //print(new_user);
    if(new_user == false){
      Navigator.pushReplacement(
          context,  MaterialPageRoute(builder: (context) => const HomePage()));
    }
  }

  @override
  void dispose(){
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }


  final emailController = TextEditingController();
  final passController = TextEditingController();


  Future login() async {
    var link = 'https://newserverobgyn.herokuapp.com/api/utility/login';
    Map data2 = {
      'email': email,
      'password': password
    };
    var body2 = json.encode(data2);
    var res = await http.post(Uri.parse("https://newserverobgyn.herokuapp.com/api/utility/login"),
        // headers: <String, String>{
        //   'Context-Type': 'application/json;charSet=UTF-8'
        // },
        // body: <String, String>{
        //   'email': newUser.email,
        //   'password': newUser.password
        // });
        headers: {"Content-Type": "application/json"},
        body: body2);


    final data = json.decode(res.body);
    print(data);
    if (data['success'] == false) {
      // print(res.body);
      // print("error");
      Fluttertoast.showToast(
          msg: "Log in failed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }else {
      // print(data);
      userval = UserFetch.fromJson(data['data']);
      circular = false;
      checkLogin();
      loginData.setBool('isDoctor', userval.isDoctor);
      if(userval.isDoctor == false) {
        loginData.setBool('login' ,true);
        update(userval.id);
        loginData.setString('_id',userval.id);
        loginData.setString('email', userval.email);
        loginData.setString('name', userval.name);
        loginData.setString('surname', userval.surname);
        loginData.setString('phone', userval.phone);
        loginData.setString('birthdate', userval.birthdate);
        loginData.setString('address', userval.address);
        // loginData.setString('gender', userval.gender);
        // loginData.setString('emailVerificationToken', userval.emailVerificationToken);
        loginData.setBool('isDoctor', userval.isDoctor);
        loginData.setBool('verified', userval.verified);
        loginData.setBool('isAdmin', userval.isAdmin);
        loginData.setString('createdAt', userval.createdAt);
        loginData.setString('updatedAt', userval.updatedAt);
        loginData.setString('password', userval.password);
        // for(var i = 0; i<userval.devices.length; i++){
        //   if(mtoken == userval.devices[i]){
        loginData.setString('patientDevice', mtoken!);
          // }
          // deviceList.add(userval.devices[i]);
          // print(deviceList[i]);
        // }

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (BuildContext context) {
              return const HomePage();
            },
            ), (router) => false);

        // Navigator.push(
        //     context,
        //      MaterialPageRoute(builder: (context) => const HomePage()));
        Fluttertoast.showToast(
            msg: "Log in successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }else if(userval.isDoctor == true){
        loginData.setBool('login' ,true);
        loginData.setString('_id',userval.id);
        // fetchDoctorCollection(userval.id);
        //
        const url = 'https://newserverobgyn.herokuapp.com/api/doctor/get-doctor-info-by-its-id';
        Map data2 = {
          'userId': userval.id
        };
        var body2 = json.encode(data2);
        var res = await http.post(Uri.parse("https://newserverobgyn.herokuapp.com/api/doctor/get-doctor-info-by-its-id"),
            headers: {"Content-Type": "application/json"},
            body: body2);

        final data = json.decode(res.body);
        doctorNew = DoctorNewFetch.fromJson(data['data']);
        loginData.setString('doctorId', doctorNew.id);
        doctorupdate(doctorNew.id);
        // firstName = doctorNew.firstName;
        // lastName = doctorNew.lastName;
        // phoneNumber = doctorNew.phoneNumber;
        // website = doctorNew.website;
        // specialization = doctorNew.specialization;
        // docAddress = doctorNew.address;
        // fee = doctorNew.fee;
        // openTime = doctorNew.timings[0];
        // lastTime = doctorNew.timings[1];
        loginData.setString('name', doctorNew.firstName);
        loginData.setString('surname', doctorNew.lastName);
        loginData.setString('phone', doctorNew.phoneNumber);
        loginData.setString('specialization', doctorNew.specialization);
        loginData.setString('experience', doctorNew.experience);
        loginData.setString('address', doctorNew.address);
        loginData.setString('openTime', doctorNew.timings[0]);
        loginData.setString('lastTime', doctorNew.timings[1]);
        loginData.setString('docDevice', mtoken!);
        //
        loginData.setString('docDevice', mtoken!);
        loginData.setString('email', userval.email);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (BuildContext context){
              return  const DoctorPage();
            },
            ), (router) => false);

        // Navigator.push(
        //     context,
        //     MaterialPageRoute(builder: (context) => const DoctorPage()));
        Fluttertoast.showToast(
            msg: "Doctors Log in successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }
    }
  }


  // ignore: prefer_typing_uninitialized_variables
  var email, password, token;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      body: Background(
        child: Form(
          key: _formkey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: const Text(
                    "LOGIN",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFf07590),
                        fontSize: 36
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),

                SizedBox(height: size.height * 0.03),

                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  child: TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                        labelText: "Email"),
                    validator: (String ? value) {
                      if (value != null && value.isEmpty) {
                        return 'Please Enter Email';
                      }
                      if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                          .hasMatch(value!)) {
                        return 'Please a valid Email';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      email = value;
                      doctorrval.email = value;
                    },
                  ),
                ),

                SizedBox(height: size.height * 0.03),

                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  child: TextFormField(
                      controller: passController,
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                          labelText: "Password"),
                      validator: (String ? value) {
                        if (value != null && value.isEmpty) {
                          return 'Please a Enter Password';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        password = value;
                        doctorrval.password = value;
                      }
                  ),
                ),

                Container(
                  alignment: Alignment.centerRight,
                  margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: TextButton(
                    onPressed:() => {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => const ForgotPasswordScreen()))
                    },
                    child: const Text(
                      "Forgot your password?",
                      style: TextStyle(
                          fontSize: 12,
                          color: Color(0XFFef4369)
                      ),
                    ),
                  ),
                ),

                SizedBox(height: size.height * 0.05),

                Container(
                  alignment: Alignment.centerRight,
                  margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: ElevatedButton(
                    style: ButtonStyle(
                        padding:  MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(80.0)),
                        // textColor: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      if (_formkey.currentState!.validate()) {
                        login();
//                      Navigator.push(context, MaterialPageRoute(
//                      builder: (context) =>  const HomePage()));

                      } else {
                        //print("not ok");
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 50.0,
                      width: size.width * 0.5,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(80.0),
                          gradient:  const LinearGradient(
                              colors: [
//                              Color.fromARGB(255, 255, 136, 34),
//                              Color.fromARGB(255, 255, 177, 41)
//                              Color(0xFFff0066),
//                              Color(0xFFff99cc)
                                Color(0xffEF716B),
                                Color(0xffff9999),
                              ]
                          )
                      ),
                      padding: const EdgeInsets.all(0),
                      child: const Text(
                        "LOGIN",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: TextButton(
                    onPressed:() => {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) =>  RegisterScreen()))
                    },
                    child: const Text(
                      "Don't have an Account? Sign Up",
                      style: TextStyle(
                          fontSize: 12,
                          color: Color(0XFFef4369)
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


}