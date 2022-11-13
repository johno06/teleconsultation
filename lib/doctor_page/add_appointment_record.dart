import 'dart:async';
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

  String? weeksCount = "", estimatedDate = "";

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
      if (weeksCount == "" || estimatedDate == "") {
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
            weeksCount,
            estimatedDate
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
      patientId = patientData!.getString('patientID');
      });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {

    });
  }

  TextEditingController titleController = TextEditingController();
  TextEditingController aboutController = TextEditingController();
  TextEditingController weeksController = TextEditingController();
  TextEditingController eddController = TextEditingController();

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
                        "Chief Complaint:",
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
                            labelText: 'Please Input Chief Complaint',
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
                        "Diagnosis",
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
                            labelText: 'Please Input Diagnosis',
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
                      const SizedBox(height: 10,),
                      Text(
                        "Last Menstrual Period",
                        style: subTitleTextStyle,
                      ),
                      InkWell(
                        onTap: () async{
                          DateTime birthDate = await selectDate(context, DateTime.now(),
                              lastDate: DateTime.now());
                          final df = new DateFormat('yyyy-MM-dd');
                          _selectLastPeriod(birthDate);
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
                      SizedBox(height: 10,),
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
                        child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[Text("Weeks: ",style: subTitleTextStyle,), Text("  $weeksCount",style: subTitleTextStyle,)],
                      ),
                      ),
                      SizedBox(height: 10,),
                      Text(
                        "EDD (Estimated Date of Delivery)",
                        style: subTitleTextStyle,
                      ),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                            border: Border.all(color: primaryColor100, width: 2),
                            color: lightBlue100,
                            borderRadius:
                            BorderRadius.circular(borderRadiusSize)),
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[Text("EDD: ",style: subTitleTextStyle,), Text("  $estimatedDate",style: subTitleTextStyle,)],
                        ),
                      ),
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

  selectDate(BuildContext context, DateTime initialDateTime,
      {required DateTime lastDate}) async {
    Completer completer = Completer();
    String _selectedDateInString;
    showDatePicker(
        context: context,
        initialDate: initialDateTime,
        firstDate: DateTime(1970),
        lastDate: lastDate == null
            ? DateTime(initialDateTime.year + 10)
            : lastDate)
        .then((temp) {
      if (temp == null) return null;
      completer.complete(temp);
      setState(() {});
    });
    return completer.future;
  }

  void _selectLastPeriod(DateTime birthDate) async {
    DateTime currentDate = DateTime.now();
    final df = new DateFormat('yyyy-MM-dd');
    DateTime calweeks = DateTime(birthDate.year, birthDate.month, birthDate.day);

    final diff = currentDate.difference(calweeks).inDays;
    int weeks = 0;
    int daysCount = 0;
    int tilSeven = 0;
    while(daysCount < diff){
      tilSeven++;
      daysCount++;
      if(tilSeven == 7){
        weeks++;
        tilSeven =0;
      }
    }
    if(tilSeven == 1 || tilSeven == 0 || weeks == 0 || weeks == 1) {
      weeksCount = "$weeks week and $tilSeven day";
    }else{
      weeksCount = "$weeks weeks and $tilSeven days";
    }
    int month4 = birthDate.month -2;
    int month3 = birthDate.month -3;
    int year = birthDate.year +1;
    if(month3 == -1){
      year = birthDate.year;
      month3 = 11;
    }else if(month3 == -2){
      year = birthDate.year;
      month3 = 10;
    }else if(month3 == -2){
      year = birthDate.year;
      month3 = 9;
    }else if(month3 == -3){
      year = birthDate.year;
      month3 = 8;
    }else if(month3 == -4){
      year = birthDate.year;
      month3 = 7;
    }else if(month3 == -5){
      year = birthDate.year;
      month3 = 6;
    }else if(month3 == -6){
      year = birthDate.year;
      month3 = 5;
    }else if(month3 == -7){
      year = birthDate.year;
      month3 = 4;
    }else if(month3 == -8){
      year = birthDate.year;
      month3 = 3;
    }else if(month3 == -9){
      year = birthDate.year;
      month3 = 2;
    }else if(month3 == -10){
      year = birthDate.year;
      month3 = 1;
    }else if(month3 == -11){
      year = birthDate.year;
      month3 = 0;
    }
    print("$month4 $month3");
    int day = birthDate.day;
    int day1 = 1;
    int week = 0;
    int days = 0;
    var date = new DateTime(year, month3, 0);
    for(int i = 0; i<7; i++){
      if(day < date.day) {
        day ++;
        days++;
      }else{
        day = day1;
        day1++;
        days++;
      }
    }
    print(days);
    for(int i = 0; i<7; i++){

    }
    // print("Last Date: ${date.day}");
    var ed = DateTime(year,month3,day);
    estimatedDate = df.format(ed);
    // estimatedDate = "$year-$month3-$day";
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    // await showDatePicker(
    //     context: context,
    //     initialDate: DateTime.now(),
    //     firstDate: DateTime(1970),
    //     lastDate: DateTime.now()).then((value) {
      setState(() {
        _dateTime1 = birthDate!;
      });
    // });
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
