// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:teleconsultation/doctor_page/drawer.dart';
import 'package:teleconsultation/services/updateDoctor.dart';
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
  String? id, email, fName, lastName, contactNumber, birthday, homeAddress, doctorId, openTime, closeTime, experience, specialization;

  int firstTime = 0;
  int secondTime = 0;
  Color shrinePink400 = const Color(0xFFEAA4A4);


  UpdateUser updateDoctor = UpdateUser('','','','','','','','');
  UpdateDoctor updateUser = UpdateDoctor('', '', '', '', '', '', '', '', '');
  // ignore: prefer_typing_uninitialized_variables
  // var fname, lname, email, contactno, password, cpassword, birthday, homeAddress,token;

  var value;
  List<String> timeList = [
    "06:00",
    "07:00",
    "08:00",
    "09:00",
    "10:00",
    "11:00",
    "12:00",
    "13:00",
    "14:00",
    "15:00",
    "16:00",
    "17:00",
    "18:00",
    "19:00",
    "20:00",
    "21:00",
    "22:00",
    "23:00"
  ];


  @override
  void initState() {
    super.initState();
    initial();
  }

  void initial() async {
    loginData = await SharedPreferences.getInstance();
    setState(() {
      id = loginData.getString('_id');
      doctorId = loginData.getString('doctorId');
      email = loginData.getString('email')!;
      fName = loginData.getString('name')!;
      lastName = loginData.getString('surname')!;
      contactNumber = loginData.getString('phone')!;
      homeAddress = loginData.getString('address')!;
      openTime = loginData.getString('openTime');
      closeTime = loginData.getString('lastTime');
      experience = loginData.getString('experience');
      specialization = loginData.getString('specialization');
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      for(int i = 0; i<timeList.length; i++){
        if(openTime == timeList[i]){
          firstTime = i;
        }
        if(closeTime == timeList[i]){
          secondTime = i;
        }
      }
    });
  }

  Future update(id) async {
    loginData = await SharedPreferences.getInstance();

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
    if(updateUser.openTime == ""){
      updateUser.openTime = "$openTime";
    }
    if(updateUser.closeTime == ""){
      updateUser.closeTime = "$closeTime";
    }
    if(updateUser.experience == ""){
      updateUser.experience = "$experience";
    }
    if(updateUser.specialization == ""){
      updateUser.specialization = "$specialization";
    }

    Map data = {
      "firstName": updateUser.fName,
      "lastName": updateUser.lName,
      "phoneNumber": updateUser.contactNo,
      "address": updateUser.homeAddress,
      "specialization": updateUser.specialization,
      "experience": updateUser.experience,
      "timings": [updateUser.openTime, updateUser.closeTime],

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
      Uri.parse('https://latest-server.onrender.com/api/doctor/updateDoctorProfile/$doctorId'),
      headers: {"Content-Type": "application/json"},
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
      // loginData.setString('email', updateUser.email);
      loginData.setString('name', updateUser.fName);
      loginData.setString('surname', updateUser.lName);
      loginData.setString('phone', updateUser.contactNo);
      loginData.setString('address', updateUser.homeAddress);
      loginData.setString('specialization', updateUser.specialization);
      loginData.setString('experience', updateUser.experience);
      loginData.setString('openTime', updateUser.openTime);
      loginData.setString('lastTime', updateUser.closeTime);
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

                Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
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
                    ),
                    const SizedBox(width: 16,),
                    Expanded(
                      child: Padding(
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
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: TextFormField(
                    // controller: contactNumber_controller,
                    controller: TextEditingController(
                        text: contactNumber
                    ),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.number,
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
                          labelText:"Address",
                          hintText: homeAddress
                      ),
                      validator: (String ? value){
                        if(value!.isEmpty)
                        {
                          return 'Please Enter Your Address';
                        }
                        return null;
                      },
                      onChanged:(value){
                        updateUser.homeAddress = value;
                      },
                    )
                ),

                Row(
                  children: <Widget>[
                    Flexible(
                      child: DropdownButton(
                        isExpanded: true,
                          hint: Text("Select starting time: "),
                          value: openTime,
                          onChanged: (newValue){
                            setState(() {
                              openTime = newValue as String?;
                              updateUser.openTime = openTime!;

                              for(int i = 0; i<timeList.length; i++){
                                  if(openTime == timeList[i]){
                                    firstTime = i;
                                    print(i);
                                  }
                              }
                              // print(value);
                              // String vl = "21:00 - 22:00";
                              // var inputFormat = DateFormat('HH:mm - HH:mm');
                              // var inputDate = inputFormat.parse(vl);
                              // var outputDate = outputFormat.format(inputDate);
                              // print(outputDate);
                            });
                          },
                          items: timeList.map((valueItem){
                            return DropdownMenuItem(value: valueItem,
                              child: Text(valueItem),
                            );
                          }).toList(),
                        ),
                      // child: Padding(
                      //     padding: const EdgeInsets.only(bottom: 30),
                      //     child: TextFormField(
                      //       // controller: homeAddress_controller,
                      //       controller: TextEditingController(
                      //           text: openTime
                      //       ),
                      //       keyboardType: TextInputType.text,
                      //       decoration: InputDecoration(
                      //           labelText:"Open Time",
                      //           hintText: openTime
                      //       ),
                      //       validator: (String ? value){
                      //         if(value!.isEmpty)
                      //         {
                      //           return 'Please Enter The Open Time';
                      //         }
                      //         return null;
                      //       },
                      //       onChanged:(value){
                      //         updateUser.openTime = value;
                      //       },
                      //     )
                      // ),
                    ),
                    const SizedBox(width: 16,),
                    Flexible(
                      child: DropdownButton(
                        isExpanded: true,
                        hint: Text("Select closing time: "),
                        value: closeTime,
                        onChanged: (newValue){
                          setState(() {
                            closeTime = newValue as String?;
                            updateUser.closeTime = closeTime!;
                            for(int i = 0; i<timeList.length; i++){
                              if(closeTime == timeList[i]){
                                secondTime = i;
                                print(i);
                              }
                            }
                          });
                        },
                        items: timeList.map((valueItem){
                          return DropdownMenuItem(value: valueItem,
                            child: Text(valueItem),
                          );
                        }).toList(),
                      ),
                      // child: Padding(
                      //     padding: const EdgeInsets.only(bottom: 30),
                      //     child: TextFormField(
                      //       // controller: homeAddress_controller,
                      //       controller: TextEditingController(
                      //           text: openTime
                      //       ),
                      //       keyboardType: TextInputType.text,
                      //       decoration: InputDecoration(
                      //           labelText:"Open Time",
                      //           hintText: openTime
                      //       ),
                      //       validator: (String ? value){
                      //         if(value!.isEmpty)
                      //         {
                      //           return 'Please Enter The Open Time';
                      //         }
                      //         return null;
                      //       },
                      //       onChanged:(value){
                      //         updateUser.openTime = value;
                      //       },
                      //     )
                      // ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                          padding: const EdgeInsets.only(bottom: 30),
                          child: TextFormField(
                            // controller: homeAddress_controller,
                            controller: TextEditingController(
                                text: experience
                            ),
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                labelText:"Experience(Years)",
                                hintText: experience
                            ),
                            validator: (String ? value){
                              if(value!.isEmpty)
                              {
                                return 'Please Enter Your Experience';
                              }
                              return null;
                            },
                            onChanged:(value){
                              updateUser.experience = value;
                            },
                          )
                      ),
                    ),
                    const SizedBox(width: 16,),
                    Expanded(
                      child: Padding(
                          padding: const EdgeInsets.only(bottom: 30),
                          child: TextFormField(
                            // controller: homeAddress_controller,
                            controller: TextEditingController(
                                text: specialization
                            ),
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                labelText:"Specialization",
                                hintText: specialization
                            ),
                            validator: (String ? value){
                              if(value!.isEmpty)
                              {
                                return 'Please Enter Your Specialization';
                              }
                              return null;
                            },
                            onChanged:(value){
                              updateUser.specialization = value;
                            },
                          )
                      ),
                    ),
                  ],
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
                        if(firstTime < secondTime) {
                          updateUser.id = "$id";
                          update(
                            updateUser.id,
                          );
                        }else{
                          Fluttertoast.showToast(
                              msg: "The opening time should be earlier than closing time!",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.redAccent,
                              textColor: Colors.white,
                              fontSize: 16.0
                          );
                        }
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
