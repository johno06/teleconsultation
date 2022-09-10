
// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teleconsultation/starting_page/register.dart';
import 'package:http/http.dart' as http;
import 'package:teleconsultation/user.dart';
import '../components/background.dart';
import '../doctor_page/drawer.dart';
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

  UserFetch userval = UserFetch(lName: '', fName: '', id: '', birthday: '', homeAddress: '', contactNo: '', email: '', cPassword: '', password: '');
  DoctorFetch doctorrval = DoctorFetch(lName: '', fName: '', id: '', birthday: '', homeAddress: '', contactNo: '', email: '', cPassword: '', password: '');

  late SharedPreferences loginData;

   late bool new_user;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLogin();
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

    var res = await http.post(Uri.parse("https://flutter-auth-server.herokuapp.com/signin"),
        headers: <String, String>{
          'Context-Type': 'application/json;charSet=UTF-8'
        },
        body: <String, String>{
          'email': newUser.email,
          'password': newUser.password
        });

    final data = json.decode(res.body);
    // print(data);

    if (data['success'] == false) {
      // print(data);
      // print(res.body);
      // print("error");
      // Fluttertoast.showToast(
      //     msg: "Log in failed",
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.BOTTOM,
      //     backgroundColor: Colors.redAccent,
      //     textColor: Colors.white,
      //     fontSize: 16.0
      // );
    }else {
      // print(data);
      userval = UserFetch.fromJson(data['token']);
      circular = false;
      checkLogin();
      loginData.setBool('login' ,true);
      loginData.setString('_id',userval.id);
      loginData.setString('email', userval.email);
      loginData.setString('fName', userval.fName);
      loginData.setString('lName', userval.lName);
      loginData.setString('contactNo', userval.contactNo);
      loginData.setString('birthday', userval.birthday);
      loginData.setString('homeAddress', userval.homeAddress);
      loginData.setString('password', userval.password);
      // print(userval.email);
      // print(userval.id);
      // print(userval.contactNo);

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (BuildContext context){
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
    }

    var resdoc = await http.post(Uri.parse("https://flutter-auth-server.herokuapp.com/docsignin"),
        headers: <String, String>{
          'Context-Type': 'application/json;charSet=UTF-8'
        },
        body: <String, String>{
          'email': doctorrval.email,
          'password': doctorrval.password
        });

    final datadoc = json.decode(resdoc.body);
    //DoctorFetch df = DoctorFetch.fromJson(datadoc);
    if(datadoc['success'] == true){
      //print(datadoc);
      doctorrval = DoctorFetch.fromJson(datadoc['token']);
      circular = false;
      checkLogin();
      loginData.setBool('login' ,true);
      loginData.setString('id',doctorrval.id);
      loginData.setString('email', doctorrval.email);
      loginData.setString('fName', doctorrval.fName);
      loginData.setString('lName', doctorrval.lName);
      loginData.setString('contactNo', doctorrval.contactNo);
      loginData.setString('birthday', doctorrval.birthday);
      loginData.setString('homeAddress', doctorrval.homeAddress);
      loginData.setString('password', doctorrval.password);
      //print(doctorrval.id);


      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (BuildContext context){
            return const DoctorPage();
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

    if(data['success'] == false && datadoc['success'] == false){
      Fluttertoast.showToast(
          msg: "Log in failed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
  }


  User newUser = User('', '');

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
                      newUser.email = value;
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
                        newUser.password = value;
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