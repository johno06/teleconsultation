// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/background.dart';
import '../home_page/drawer.dart';
import 'login.dart';


class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();

}


class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  String url = "https://flutterauth1-demog.herokuapp.com/login";
  bool circular = true;
  // ProfileModel model = ProfileModel();

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
          context, MaterialPageRoute(builder: (context) => const HomePage()));
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


//  Future login() async {
//    var res = await http.post("https://flutterauth1-demog.herokuapp.com/login",
//        headers: <String, String>{
//          'Context-Type': 'application/json;charSet=UTF-8'
//        },
//        body: <String, String>{
//          'email': newUser.email,
//          'password': newUser.password
//        });
//
//    final data = json.decode(res.body);
//
//
//    model = ProfileModel.fromJson(data);
//    circular = false;
//
//    if (data['success']== false) {
//      print(data);
//      print(res.body);
//      print("error");
//      Fluttertoast.showToast(
//          msg: "Log in failed",
//          toastLength: Toast.LENGTH_SHORT,
//          gravity: ToastGravity.BOTTOM,
//          backgroundColor: Colors.green,
//          textColor: Colors.white,
//          fontSize: 16.0
//      );
//    }else {
//      checkLogin();
//      loginData.setBool('login' ,true);
//      loginData.setString('id',model.id);
//      loginData.setString('email', model.email);
//      loginData.setString('fName', model.fName);
//      loginData.setString('lName', model.lName);
//      loginData.setString('contactNo', model.contactNo);
//      print(model.id);
//      print(model.contactNo);
//      Navigator.push(
//          context,
//          new MaterialPageRoute(builder: (context) => HomePage()));
//      Fluttertoast.showToast(
//            msg: "Log in successfully",
//            toastLength: Toast.LENGTH_SHORT,
//            gravity: ToastGravity.BOTTOM,
//            backgroundColor: Colors.green,
//            textColor: Colors.white,
//            fontSize: 16.0
//        );
//    }
//  }

//  User newUser = new User('', '');

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
                    "Forgot Password",
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
//                    onChanged: (value) {
//                      newUser.email = value;
//                    },
                  ),
                ),

                SizedBox(height: size.height * 0.03),

//                Container(
//                  alignment: Alignment.center,
//                  margin: EdgeInsets.symmetric(horizontal: 40),
//                  child: TextFormField(
//                      controller: passController,
//                      obscureText: true,
//                      keyboardType: TextInputType.text,
//                      decoration: InputDecoration(
//                          labelText: "Password"),
//                      validator: (String value) {
//                        if (value.isEmpty) {
//                          return 'Please a Enter Password';
//                        }
//                        return null;
//                      },
//                      onChanged: (value) {
//                        newUser.password = value;
//                      }
//                  ),
//                ),

                Container(
                  alignment: Alignment.centerRight,
                  margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: TextButton(
                    child: const Text(
                      "Already have an Account?",
                      style: TextStyle(
                          fontSize: 12,
                          color: Color(0XFFef4369)
                      ),
                    ),
                    onPressed: () => {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => const LoginScreen()))
                    },
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
//                        login();

                      } else {
                        //print("not ok");
                      }
                    },
                    // shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(80.0)),
                    // textColor: Colors.white,
                    // padding: const EdgeInsets.all(0),
                    child: Container(
                      alignment: Alignment.center,
                      height: 50.0,
                      width: size.width * 0.5,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(80.0),
                          gradient: const LinearGradient(
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
                        "Recover Account",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                ),
//                Container(
//                  alignment: Alignment.centerRight,
//                  margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
//                  child: GestureDetector(
//                    onTap: () =>
//                    {
//                      Navigator.push(context, MaterialPageRoute(
//                          builder: (context) => RegisterScreen()))
//                    },
//                    child: Text(
//                      "Don't Have an Account? Sign up",
//                      style: TextStyle(
//                          fontSize: 12,
//                          fontWeight: FontWeight.bold,
//                          color: Color(0xFFf07590)
//                      ),
//                    ),
//                  ),
//                )
              ],
            ),
          ),
        ),
      ),
    );
  }


}