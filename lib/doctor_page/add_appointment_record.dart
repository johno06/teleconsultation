import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teleconsultation/services/appointmentservice.dart';
import 'package:http/http.dart' as http;
import '../constant.dart';
import '../model/checkbox_state.dart';
import 'drawer.dart';


class AddAppointmentRecord extends StatefulWidget {
  @override
  State<AddAppointmentRecord> createState() => _AddAppointmentRecordState();
}

class _AddAppointmentRecordState extends State<AddAppointmentRecord> {

  @override
  void initState(){
    super.initState();
    initial();
  }

  final TextEditingController _controller = TextEditingController();
  DateTime _dateTime = DateTime.now();
  DateTime _dateTime1 = DateTime.now();
  DateTime _dateTime2 = DateTime.now();

  var outputFormat = DateFormat('hh:mm a');

  final dateFormat = DateFormat("EEEE, dd MMM yyyy");
  final df = DateFormat("yyyy-MM-dd");
  SharedPreferences? doctorData;
  SharedPreferences? loginData;
  SharedPreferences? patientData;

  var availableBookTime = [
    CheckBoxState(title: ""),
  ];

  var availTime = [
    "06:00 - 07:00",
    "07:00 - 08:00",
    "09:00 - 10:00",
    "10:00 - 11:00",
    "11:00 - 12:00",
    "12:00 - 13:00",
    "13:00 - 14:00",
    "14:00 - 15:00",
    "15:00 - 16:00",
    "16:00 - 17:00",
    "17:00 - 18:00",
    "18:00 - 19:00",
    "19:00 - 20:00",
    "20:00 - 21:00",
    "21:00 - 22:00"
  ];

  String? value, date;
  bool _enableCreateOrderBtn = false;
  // List<String> timeList = timeToBook;
  var currentTime = "00:00";
  var closeTime = "22:00";

  String? patientFullName, patientId;

  Future AddRecord(id) async {
    if(titleController.text != "" && aboutController.text != "" && df.format(_dateTime) != "" && value != "") {
      Map data = {
      };
      if (weeksController.text == "" ||
          df.format(_dateTime1) == df.format(_dateTime2)) {
        data = {
          "phr": [
            titleController.text,
            aboutController.text,
            df.format(_dateTime),
            value
          ]
        };
      } else {
        data = {
          "phr": [
            titleController.text,
            aboutController.text,
            df.format(_dateTime),
            value,
            weeksController.text,
            df.format(_dateTime1)
          ]
        };
      }

      String bodyDoc = json.encode(data);
      http.Response responseDoc = await http.patch(
        Uri.parse(
            'https://newserverobgyn.herokuapp.com/api/user/addRecord/$patientId'),
        headers: {"Content-Type": "application/json"},
        body: bodyDoc,
      );
      if (responseDoc.statusCode == 200) {
        Fluttertoast.showToast(
            msg: "Add Record succeed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DoctorPage()));
      }

      if (responseDoc.statusCode != 200) {
        Fluttertoast.showToast(
            msg: "Add Record failed, please try again later.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.redAccent,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }else{
        Fluttertoast.showToast(
            msg: "Please fill all fields.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.redAccent,
            textColor: Colors.white,
            fontSize: 16.0);
    }
  }

  void initial() async{
    doctorData = await SharedPreferences.getInstance();
    loginData = await SharedPreferences.getInstance();
    patientData = await SharedPreferences.getInstance();
    setState(() {
      patientFullName = patientData!.getString('patientName');
      patientId = patientData!.getString('patientId');
      });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {

    });
  }

  TextEditingController titleController = TextEditingController();
  TextEditingController aboutController = TextEditingController();
  TextEditingController weeksController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: colorWhite,
              statusBarIconBrightness: Brightness.dark,
            ),
            title: Text("Add Record"),
            backgroundColor: colorWhite,
            centerTitle: true,
            foregroundColor: primaryColor500,
          ),
          SliverPadding(
            padding:
            const EdgeInsets.only(right: 24, left: 24, bottom: 24, top: 8),
            sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "Patient Name",
                        style: subTitleTextStyle,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                            border: Border.all(color: primaryColor100, width: 2),
                            color: lightBlue100,
                            borderRadius: BorderRadius.circular(borderRadiusSize)),
                        child: Row(
                          children: [
                            // Image.asset(
                            //   "assets/icons/pin.png",
                            //   width: 24,
                            //   height: 24,
                            //   color: primaryColor500,
                            // ),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                                "$patientFullName",
                                style: normalTextStyle.copyWith(
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        "Booking Date",
                        style: subTitleTextStyle,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      InkWell(
                        onTap: () {
                          _selectDate();
                          // pickings();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                              border: Border.all(color: primaryColor100, width: 2),
                              color: lightBlue100,
                              borderRadius:
                              BorderRadius.circular(borderRadiusSize)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.date_range_rounded,
                                color: primaryColor500,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                _dateTime == null
                                    ? "date not selected.."
                                    : dateFormat.format(_dateTime).toString(),
                                style: normalTextStyle,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        "Appointment time",
                        style: subTitleTextStyle,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                            border: Border.all(color: primaryColor100, width: 2),
                            color: lightBlue100,
                            borderRadius:
                            BorderRadius.circular(borderRadiusSize)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.access_time,
                              color: primaryColor500,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            DropdownButton(
                              hint: Text("Select Time of appointment: "),
                              value: value,
                              onChanged: (newValue){
                                setState(() {
                                  value = newValue as String?;
                                  _enableCreateOrderBtn = true;
                                  // print(value);
                                  // String vl = "21:00 - 22:00";
                                  // var inputFormat = DateFormat('HH:mm - HH:mm');
                                  // var inputDate = inputFormat.parse(vl);
                                  // var outputDate = outputFormat.format(inputDate);
                                  // print(outputDate);
                                });
                              },
                              items: availTime.map((valueItem){
                                return DropdownMenuItem(value: valueItem,
                                  child: Text(valueItem),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        "Title:",
                        style: subTitleTextStyle,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                            border: Border.all(color: primaryColor100, width: 2),
                            color: lightBlue100,
                            borderRadius:
                            BorderRadius.circular(borderRadiusSize)),
                        child: TextFormField(
                          controller: titleController,
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Please Input Title',
                          ),
                          validator: (value){
                            if (value!.isEmpty) {
                              return 'Enter Title';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        "Consultation About",
                        style: subTitleTextStyle,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                            border: Border.all(color: primaryColor100, width: 2),
                            color: lightBlue100,
                            borderRadius:
                            BorderRadius.circular(borderRadiusSize)),
                        child: TextFormField(
                          controller: aboutController,
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'About',
                          ),
                          validator: (value){
                            if (value!.isEmpty) {
                              return 'Enter About';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 20,),
                      Text(
                        "For Pregnant Patient:",
                        style: subTitleTextStyle,
                      ),
                      Text(
                        "Weeks",
                        style: subTitleTextStyle,
                      ),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                            border: Border.all(color: primaryColor100, width: 2),
                            color: lightBlue100,
                            borderRadius:
                            BorderRadius.circular(borderRadiusSize)),
                        child: TextFormField(
                          controller: weeksController,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Input Weeks of Pregnant',
                          ),
                          validator: (value){
                            if (value!.isEmpty) {
                              return 'Enter Weeks of being pregnant';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 10,),
                      Text(
                        "Estimated Due Date",
                        style: subTitleTextStyle,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      InkWell(
                        onTap: () {
                          _selectDueDate();
                          // pickings();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                              border: Border.all(color: primaryColor100, width: 2),
                              color: lightBlue100,
                              borderRadius:
                              BorderRadius.circular(borderRadiusSize)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.date_range_rounded,
                                color: primaryColor500,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                _dateTime1 == null
                                    ? "date not selected.."
                                    : dateFormat.format(_dateTime1).toString(),
                                style: normalTextStyle,
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Text(
                      //   "Pick the Time",
                      //   style: subTitleTextStyle,
                      // ),
                      // const SizedBox(
                      //   height: 8,
                      // ),
                      // DropdownButton(
                      //     hint: Text("Select Items: "),
                      // value: value,
                      // onChanged: (newValue){
                      //       setState(() {
                      //         value = newValue as String?;
                      //       });
                      // },
                      // items: timeList.map((valueItem){
                      //   return DropdownMenuItem(value: valueItem,
                      //   child: Text(valueItem),
                      //     );
                      // }).toList(),
                      // )
                      // DropdownButton<String>(
                      //     items: availableBookTime.map(buildMenuItem).toList(),
                      //     onChanged: (value) => setState(() => this.value = value),
                      // ),
                      // ...availableBookTime.map(buildSingleCheckBox).toList(),
                    ],
                  ),
                ])),
          )
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
            color: lightBlue300,
            offset: Offset(0, 0),
            blurRadius: 10,
          )
        ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(100, 45),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(borderRadiusSize))),
                  onPressed: !_enableCreateOrderBtn
                      ? null
                      : () {
                    AddRecord('');
                  },
                  child: Text(
                    "Add Appointment Record",
                    style: buttonTextStyle,
                  )),
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(SnackBar(
      content: Text(message),
      margin: const EdgeInsets.all(16),
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 2),
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _selectDate() async {
    await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 6))
        .then((value) {
      setState(() {
        _dateTime = value!;
      });
    });
  }

  void _selectDueDate() async {
    await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 330))
        .then((value) {
      setState(() {
        _dateTime1 = value!;
      });
    });
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
      child: Text(
        item,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      )
  );

  Widget buildSingleCheckBox(CheckBoxState checkbox) {
    return CheckboxListTile(
      controlAffinity: ListTileControlAffinity.leading,
      title: Text(checkbox.title),
      value: checkbox.value,
      onChanged: (bool? value) {
        setState(() {
          checkbox.value = value!;
        });
        int totalSelectedTime = 0;
        for (int i = 0; i < availableBookTime.length; i++) {
          if (availableBookTime[i].value == true) {
            totalSelectedTime++;
          }
        }
        setState(() {
          // _totalBill = widget.field.price * totalSelectedTime;
          // if (totalSelectedTime > 0) {
          //   _enableCreateOrderBtn = true;
          // } else {
          //   _enableCreateOrderBtn = false;
          // }
        });
      },
    );
  }
}
