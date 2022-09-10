// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:teleconsultation/doctor_page/drawer.dart';
import '../../services/updateservices.dart';

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

class DoctorEditProfile extends StatefulWidget {
  const DoctorEditProfile({Key? key}) : super(key: key);

  @override
  State<DoctorEditProfile> createState() => _DoctorEditProfileState();
}

bool isObscurePassword = true;

class _DoctorEditProfileState extends State<DoctorEditProfile> {
  late SharedPreferences loginData;
  String? id, email, fName, lastName, contactNumber, birthday, homeAddress;

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
      id = loginData.getString('id');
      email = loginData.getString('email')!;
      fName = loginData.getString('fName')!;
      lastName = loginData.getString('lName')!;
      contactNumber = loginData.getString('contactNo')!;
      birthday = loginData.getString('birthday')!;
      homeAddress = loginData.getString('homeAddress')!;
    });
  }

  Future update(id) async {
    loginData = await SharedPreferences.getInstance();

    if(updateUser.email == ""){
      updateUser.email = "$email";
    }
    if(updateUser.fName == ""){
      updateUser.fName = "$fName";
    }
    if(updateUser.lName == ""){
      updateUser.lName = "$lastName";
    }
    if(updateUser.contactNo == ""){
      updateUser.contactNo = "$contactNumber";
    }
    if(updateUser.homeAddress == ""){
      updateUser.homeAddress = "$homeAddress";
    }
    if(updateUser.birthday == ""){
      updateUser.birthday = "$birthday";
    }


    Map data = {
      "email": updateUser.email,
      "fName": updateUser.fName,
      "lName": updateUser.lName,
      "contactNo": updateUser.contactNo,
      "homeAddress": updateUser.homeAddress,
      "birthday": updateUser.birthday,
    };

    // else{
    //   Fluttertoast.showToast(
    //       msg: "Update Failed try other email",
    //       toastLength: Toast.LENGTH_SHORT,
    //       gravity: ToastGravity.BOTTOM,
    //       backgroundColor: Colors.redAccent,
    //       textColor: Colors.white,
    //       fontSize: 16.0);
    // }

    String bodyDoc = json.encode(data);
    http.Response responseDoc = await http.patch(
      Uri.parse('https://flutter-auth-server.herokuapp.com/doctor/$id'),
      headers: {'Content-Type': 'application/json; charset=utf-8'},
      body: bodyDoc,
    );
    if (responseDoc.statusCode == 200) {
      Fluttertoast.showToast(
          msg: "Doctor Profile Updated",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      loginData.setString('email', updateUser.email);
      loginData.setString('fName', updateUser.fName);
      loginData.setString('lName', updateUser.lName);
      loginData.setString('contactNo', updateUser.contactNo);
      loginData.setString('birthday', updateUser.birthday);
      loginData.setString('homeAddress', updateUser.homeAddress);
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DoctorPage()));
    }

    if(responseDoc.statusCode != 200){
      Fluttertoast.showToast(
          msg: "Update Failed try other email",
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
                // const SizedBox(height: 15),
                // Padding(
                //     padding: const EdgeInsets.only(bottom: 30),
                //     child: TextFormField(
                //       // controller: email_controller,
                //       controller: TextEditingController(
                //           text: email
                //       ),
                //       keyboardType: TextInputType.text,
                //       decoration: InputDecoration(
                //           labelText: "Email",
                //           hintText: email
                //       ),
                //       validator: (String ? value) {
                //         if (value != null && value.isEmpty) {
                //           return 'Please Enter Email';
                //         }
                //         if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                //             .hasMatch(value!)) {
                //           return 'Please a valid Email';
                //         }
                //         return null;
                //       },
                //       onChanged: (value) {
                //         updateUser.email = value;
                //       },
                //     )
                // ),
                Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: TextFormField(
                      // controller: fName_controller,
                      controller: TextEditingController(
                          text: fName
                      ),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText:"First Name",
                          hintText: fName
                      ),
                      validator: (String ? value){
                        if(value != null && value.isEmpty)
                        {
                          return 'Please Enter Your First Name';
                        }
                        return null;
                      },
                      onChanged:(value){
                        updateUser.fName = value;
                      },
                    )
                ),
                Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: TextFormField(
                      // controller: lastName_controller,
                      controller: TextEditingController(
                          text: lastName
                      ),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText:"Last Name",
                          hintText: lastName
                      ),
                      validator: (String ? value){
                        if(value != null && value.isEmpty)
                        {
                          return 'Please Enter Your Last Name';
                        }
                        return null;
                      },
                      onChanged:(value){
                        updateUser.lName = value;
                      },
                    )
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: TextFormField(
                    // controller: contactNumber_controller,
                    controller: TextEditingController(
                        text: contactNumber
                    ),
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        labelText:"Phone #",
                        hintText: contactNumber
                    ),
                    validator: (String ? value){
                      if(value != null && value.isEmpty)
                      {
                        return 'Please Enter Your Phone Number';
                      }
                      return null;
                    },
                    onChanged:(value){
                      updateUser.contactNo = value;
                    },
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: TextFormField(
                      // controller: homeAddress_controller,
                      controller: TextEditingController(
                          text: homeAddress
                      ),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText:"City",
                          hintText: homeAddress
                      ),
                      validator: (String ? value){
                        if(value!.isEmpty)
                        {
                          return 'Please Enter Your City';
                        }
                        return null;
                      },
                      onChanged:(value){
                        updateUser.homeAddress = value;
                      },
                    )
                ),
                Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    // child: TextFormField(
                    //   // controller: birthday_controller,
                    //   controller: TextEditingController(
                    //       text: birthday
                    //   ),
                    //   keyboardType: TextInputType.text,
                    //   decoration: InputDecoration(
                    //       labelText:"Birthday",
                    //       hintText: birthday
                    //   ),
                    //   validator: (String ? value){
                    //     if(value != null && value.isEmpty)
                    //     {
                    //       return 'Please Enter Your Birthday';
                    //     }
                    //     return null;
                    //   },
                    //   onChanged:(value){
                    //     updateUser.birthday = value;
                    //   },
                    // )
                    child:Center(
                        child:TextFormField(
                          controller: TextEditingController(
                              text: birthday
                          ), //editing controller of this TextField
                          decoration: const InputDecoration(
                            // icon: Icon(Icons.calendar_today), //icon of text field
                              labelText: "Birthday" //label text of field
                          ),
                          validator: (String ? value){
                            if(value != null && value.isEmpty){
                              return 'Please enter your birthday ';
                            }
                          },
                          readOnly: true,  //set it true, so that user will not able to edit text
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                                context: context, initialDate: DateTime.now(),
                                firstDate: DateTime(1950), //DateTime.now() - not to allow to choose before today.
                                lastDate: DateTime(2101)
                            );

                            if(pickedDate == null){
                              // return 'Please enter your birthday ';
                            }else{
                              //print(pickedDate);  //pickedDate output format => 2021-03-10 00:00:00.000
                              String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                              //print(formattedDate); //formatted date output using intl package =>  2021-03-16
                              //you can implement different kind of Date Format here according to your requirement

                              setState(() {
                                //newUser.birthday = formattedDate;
                                birthday = formattedDate; //set output date to TextField value.
                              });
                            }
                          },
                        )
                    )
                ),
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
                        update(
                          updateUser.id,
                        );
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
