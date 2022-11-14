// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../services/updateservices.dart';
import '../drawer.dart';

// void main(){
//   runApp(MyApp())
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: EditProfile(),
//     );
//   }
//
// }

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

bool isObscurePassword = true;

class _ChangePasswordState extends State<ChangePassword> {
  late SharedPreferences loginData;
  String? id, email, fName, lastName, contactNumber, birthday, homeAddress, password, confirmPassword;

  Color shrinePink400 = const Color(0xFFEAA4A4);


  UpdateUser updateUser = UpdateUser('','','','','','','','');
  // ignore: prefer_typing_uninitialized_variables
  // var fname, lname, email, contactno, password, cpassword, birthday, homeAddress,token;


  @override
  void initState() {
    super.initState();
    initial();
  }

  void initial() async {
    loginData = await SharedPreferences.getInstance();
    setState(() {
      id = loginData.getString('_id');
      email = loginData.getString('email')!;
      fName = loginData.getString('name')!;
      lastName = loginData.getString('surname')!;
      contactNumber = loginData.getString('phone')!;
      birthday = loginData.getString('birthdate')!;
      homeAddress = loginData.getString('address')!;
      password = loginData.getString('password')!;
    });
  }

  Future update(id ) async {
    loginData = await SharedPreferences.getInstance();

    // if(updateUser.email == ""){
    //   updateUser.email = "$email";
    // }
    // if(updateUser.fName == ""){
    //   updateUser.fName = "$fName";
    // }
    // if(updateUser.lName == ""){
    //   updateUser.lName = "$lastName";
    // }
    // if(updateUser.contactNo == ""){
    //   updateUser.contactNo = "$contactNumber";
    // }
    // if(updateUser.homeAddress == ""){
    //   updateUser.homeAddress = "$homeAddress";
    // }
    // if(updateUser.birthday == ""){
    //   updateUser.birthday = "$birthday";
    // }
    print(updateUser.password);
    print(confirmPassword);
    if(updateUser.password != "" && confirmPassword != null) {
      if (updateUser.password == confirmPassword) {
        Map data = {
          "password": updateUser.password,
        };
        String body = json.encode(data);
        http.Response response = await http.patch(
          Uri.parse('https://newserverobgyn.herokuapp.com/api/user/updatePassword/$id'),
          headers: {"Content-Type": "application/json"},
          body: body,
        );
        print(body);
        if (response.statusCode == 200) {
          Fluttertoast.showToast(
              msg: "Change Password Success",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);
          // loginData.setString('email', updateUser.email);
          // loginData.setString('fName', updateUser.fName);
          // loginData.setString('lName', updateUser.lName);
          // loginData.setString('contactNo', updateUser.contactNo);
          // loginData.setString('birthday', updateUser.birthday);
          // loginData.setString('homeAddress', updateUser.homeAddress);
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()));
        }
      }else {
        return(
            Fluttertoast.showToast(
                msg: "Password did not match",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.redAccent,
                textColor: Colors.white,
                fontSize: 16.0));
      }
    }else{
      Fluttertoast.showToast(
                msg: "Please input all fields",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.redAccent,
                textColor: Colors.white,
                fontSize: 16.0);
    }
  }



  final email_controller = TextEditingController();
  final fName_controller = TextEditingController();
  final lastName_controller = TextEditingController();
  final contactNumber_controller = TextEditingController();
  final birthday_controller = TextEditingController();
  final homeAddress_controller = TextEditingController();
  final password_controller = TextEditingController();
  final cPassword_controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffF8AFA6),
        // title: const Text('Flutter Edit Profile UI'),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.redAccent,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: const [],
      ),
      body: Container(
          padding: const EdgeInsets.only(left: 15, top: 20, right: 15),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: ListView(
              children: [
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                            border: Border.all(width: 4, color: Colors.white),
                            boxShadow: [
                              BoxShadow(
                                  spreadRadius: 2,
                                  blurRadius: 10,
                                  color: Colors.black.withOpacity(0.1))
                            ],
                            shape: BoxShape.circle,
                            image: const DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(
                                    'assets/images/default_user_icon.png'))),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(width: 4, color: Colors.white),
                              color: shrinePink400),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: TextFormField(
                      // controller: homeAddress_controller,
                      controller: password_controller,
                      obscureText: true,
                      keyboardType: TextInputType.text,
                        decoration:const InputDecoration(
                            labelText: "Password"),
                      validator: (String ? value){
                        if(value != null && value.isEmpty)
                        {
                          return 'Please Enter Your Password';
                        }
                        return null;
                      },
                      onChanged:(value){
                        updateUser.password = value;
                      },
                    )
                ),
                const SizedBox(height: 15),
                Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: TextFormField(
                      // controller: homeAddress_controller,
                      controller: cPassword_controller,
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      decoration:const InputDecoration(
                          labelText: "Confirm Password"),
                      validator: (String ? value){
                        if(value != null && value.isEmpty)
                        {
                          return 'Please Enter Your Confirm Password';
                        }
                        return null;
                      },
                      onChanged:(value){
                        confirmPassword = value;
                      },
                    )
                ),
                // Container(
                //   alignment: Alignment.center,
                //   margin: const EdgeInsets.symmetric(horizontal: 40),
                //   child: TextFormField(
                //       //controller: _password,
                //       obscureText: true,
                //       keyboardType: TextInputType.text,
                //       decoration:const InputDecoration(
                //           labelText: "Password"),
                //       validator: (String ? value){
                //         if(value != null && value.isEmpty)
                //         {
                //           return 'Please a Enter Password';
                //         }
                //         return null;
                //       },
                //       onChanged:(value) {
                //         //newUser.password = value;
                //       }
                //   ),
                // ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("CANCEL",
                          style: TextStyle(
                              fontSize: 15,
                              letterSpacing: 2,
                              color: Colors.black)),
                      style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        updateUser.id = "$id";
                        // if(updateUser.password == "" || confirmPassword == "") {
                        //   print(confirmPassword);
                        //   Fluttertoast.showToast(
                        //       msg: "Please input fields",
                        //       toastLength: Toast.LENGTH_SHORT,
                        //       gravity: ToastGravity.BOTTOM,
                        //       backgroundColor: Colors.redAccent,
                        //       textColor: Colors.white,
                        //       fontSize: 16.0);
                        // }else{
                          update(
                            updateUser.id,
                          );
                        // }
                      },
                      child: const Text("SAVE",
                          style: TextStyle(
                              fontSize: 15,
                              letterSpacing: 2,
                              color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: shrinePink400,
                          padding: const EdgeInsets.symmetric(horizontal: 50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))),
                    )
                  ],
                )
              ],
            ),
          )),
    );
  }

  Widget buildTextField(
      String labelText, String placeholder, bool isPasswordTextField) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: TextField(
          obscureText: isPasswordTextField ? isObscurePassword : false,
          decoration: InputDecoration(
              suffixIcon: isPasswordTextField
                  ? IconButton(
                icon:
                const Icon(Icons.remove_red_eye, color: Colors.grey),
                onPressed: () {},
              )
                  : null,
              contentPadding: const EdgeInsets.only(bottom: 5),
              labelText: labelText,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              hintText: placeholder,
              hintStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey)),
        ));
  }
}
