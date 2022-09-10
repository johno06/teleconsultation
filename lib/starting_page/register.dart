// ignore_for_file: must_be_immutable
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:teleconsultation/starting_page/terms.dart';
import '../components/background.dart';
import '../services/registerservice.dart';
import 'login.dart';
import 'package:intl/intl.dart';

class RegisterScreen extends StatefulWidget {
  dynamic accept;
  RegisterScreen({Key? key, this.accept}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
  // void setAccepted(bool bool) {}
}

class _RegisterScreenState extends State<RegisterScreen> {

  bool agree = false;
   // TermsAndConditions tc = TermsAndConditions();

  Future addUser() async {
    if(_formkey.currentState!.validate()) {
      //print("successful");
      Map data = {
        "fName": newUser.fName,
        "lName": newUser.lName,
        "email": newUser.email,
        "contactNo": newUser.contactNo,
        "birthday": newUser.birthday,
        "homeAddress": newUser.homeAddress,
        "password": newUser.password,
        "cPassword": newUser.cPassword
      };
      //String body = json.encode(data);
      http.Response response = await http.post(
          Uri.parse('https://flutter-auth-server.herokuapp.com/signup'), headers: {
        'Content-Type': 'application/json; charset=utf-8'
      },
          body: json.encode(data)
      );
      final data1 = json.decode(response.body);
      // print(data1);

      if(data1['message'] != "email is already used"){
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const LoginScreen()));

       // print(response.body);
        Fluttertoast.showToast(
            msg: "Sign up successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }else{
        //print("UnSuccessfull");
        Fluttertoast.showToast(
            msg: "email is already used",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.redAccent,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }
    }
  }

  User newUser = User('','','','','','','','');
  // ignore: prefer_typing_uninitialized_variables
  var fname, lname, email, contactno, password, cpassword, birthday, homeAddress,token;


  //TextController to read text entered in text field
  final TextEditingController _password = TextEditingController();
  TextEditingController confirmpassword = TextEditingController();

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  TextEditingController dateinput = TextEditingController();
  //text editing controller for text field

  Future<void> _navigateAndDisplaySelection(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    var result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TermsAndConditions()),
    );

    // When a BuildContext is used from a StatefulWidget, the mounted property
    // must be checked after an asynchronous gap.
    // if (!mounted) return;

    // After the Selection Screen returns a result, hide any previous snackbars
    // and show the new result.
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('$result')));
    agree = result;
    widget.accept = result;
  }

  @override
  void initState() {
    dateinput.text = ""; //set the initial value of text field
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if(widget.accept == "true"){
      agree = true;
    }
    return Scaffold(
      body: Background(
        child: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: const Text(
                    "REGISTER",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFf07590),
                        fontSize: 36
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),

                SizedBox(height: size.height * 0.01),

                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    decoration:const InputDecoration(
                        labelText: "Email"),
                    validator: (value){
                      if(value!.isEmpty)
                      {
                        return 'Please a Enter';
                      }
                      if(!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)){
                        return 'Please a valid Email';
                      }
                      return null;
                    },
                    onChanged:(value){
                      newUser.email = value;
                    },
                  ),
                ),

                SizedBox(height: size.height * 0.00),

                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                        labelText:"First Name"),
                    validator: (String ? value){
                      if(value != null && value.isEmpty)
                      {
                        return 'Please Enter Your First Name';
                      }
                      return null;
                    },
                    onChanged:(value){
                      newUser.fName = value;
                    },
                  ),
                ),

                SizedBox(height: size.height * 0.01),

                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                        labelText:"Last Name"),
                    validator: (String ? value){
                      if(value != null && value.isEmpty)
                      {
                        return 'Please Enter Your Last Name';
                      }
                      return null;
                    },
                    onChanged:(value){
                      newUser.lName = value;
                    },
                  ),
                ),

                SizedBox(height: size.height * 0.01),

                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  child: TextFormField(
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        labelText: "Phone No"),
                    validator: (String ? value){
                      if(value != null && value.isEmpty)
                      {
                        return 'Please enter phone no ';
                      }
                      return null;
                    },
                    onChanged:(value){
                      newUser.contactNo = value;
                    },
                  ),
                ),

                SizedBox(height: size.height * 0.01),

                SizedBox(height: size.height * 0.01),

                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  // child: TextFormField(
                  //   keyboardType: TextInputType.number,
                  //   decoration: const InputDecoration(
                  //       labelText: "Birthday"),
                  //   validator: (String ? value){
                  //     if(value != null && value.isEmpty)
                  //     {
                  //       return 'Please enter your birthday ';
                  //     }
                  //     return null;
                  //   },
                  //   onChanged:(value){
                  //     newUser.birthday = value;
                  //   },
                  // ),
                    child:Center(
                        child:TextFormField(
                          controller: dateinput, //editing controller of this TextField
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
                                newUser.birthday = formattedDate;
                                dateinput.text = formattedDate; //set output date to TextField value.
                              });
                            }
                          },
                    )
                )
          ),


                SizedBox(height: size.height * 0.01),

                SizedBox(height: size.height * 0.01),

                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        labelText: "City"),
                    validator: (String ? value){
                      if(value != null && value.isEmpty)
                      {
                        return 'Please enter City ';
                      }
                      return null;
                    },
                    onChanged:(value){
                      newUser.homeAddress = value;
                    },
                  ),
                ),

                SizedBox(height: size.height * 0.01),

                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  child: TextFormField(
                      controller: _password,
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      decoration:const InputDecoration(
                          labelText: "Password"),
                      validator: (String ? value){
                        if(value != null && value.isEmpty)
                        {
                          return 'Please a Enter Password';
                        }
                        return null;
                      },
                      onChanged:(value) {
                        newUser.password = value;
                      }
                  ),
                ),

                SizedBox(height: size.height * 0.01),

                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  child: TextFormField(
                      controller: confirmpassword,
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                          labelText: "Confirm Password"),
                      validator: (String ? value){
                        if(value != null && value.isEmpty)
                        {
                          return 'Please re-enter password';
                        }
//                        print(_password.text);
//
//                        print(confirmpassword.text);

                        if(_password.text!=confirmpassword.text){
                          return "Password does not match";
                        }

                        return null;
                      },
                      onChanged:(value) {
                        newUser.cPassword = value;
                      }
                  ),
                ),

                SizedBox(height: size.height * 0.01),

                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: agree,
                              onChanged: (value) {
                                setState(() {
                                  // value = widget.accept;
                                  agree = value!;
                                });
                              },
                            ),
                            RichText(
                              text: TextSpan(children: [
                                const TextSpan(
                                text: ' ',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            TextSpan(
                              text: 'Terms and conditions.',
                              style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.blueAccent),
                              recognizer: TapGestureRecognizer()..onTap = () {
                                // Navigator.push(context, MaterialPageRoute(builder: (context) => const TermsAndConditions()));
                                _navigateAndDisplaySelection(context);
                              }),
                            ]),
                            )],
                        ),
                      ]),
                ),

                SizedBox(height: size.height * 0.01),


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
                    onPressed: agree ? addUser : null, child: Container(
                    alignment: Alignment.center,
                    height: 50.0,
                    width: size.width * 0.5,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(80.0),
                        gradient: const LinearGradient(
                            colors: [
//                          Color.fromARGB(255, 255, 136, 34),
//                          Color.fromARGB(255, 255, 177, 41)
                              Color(0xffEF716B),
                              Color(0xffff9999),
                            ]
                        )
                    ),
                    padding: const EdgeInsets.all(0),
                    child: const Text(
                      "SIGN UP",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                    // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                    // textColor: Colors.white,
                    // padding: const EdgeInsets.all(0),
                  ),
                ),

                Container(
                  alignment: Alignment.centerRight,
                  margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: TextButton(
                    onPressed:() => {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => const LoginScreen()))
                    },
                    child: const Text(
                      "Already have an Account? Sign In",
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