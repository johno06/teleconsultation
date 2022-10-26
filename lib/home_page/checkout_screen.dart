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


class CheckoutScreen extends StatefulWidget {
  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {


  @override
  void initState(){
    super.initState();
    initial();
    requestPermission();
    loadFCM();
    listenFCM();
  }
  //
  var channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    importance: Importance.high,
    enableVibration: true,
  );

  var flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  String? mtoken = " ";


  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  void loadFCM() async {
    if (!kIsWeb) {
      var channel = const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        importance: Importance.high,
        enableVibration: true,
      );

      var flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      /// Create an Android Notification Channel.
      ///
      /// We use this channel in the `AndroidManifest.xml` file to override the
      /// default FCM channel to enable heads up notifications.
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      /// Update the iOS foreground notification presentation options to allow
      /// heads up notifications.
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  void listenFCM() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              // TODO add a proper drawable resource to android, for now using
              //      one that already exists in example app.
              icon: 'launch_background',
            ),
          ),
        );
      }
    });
  }

  Future sendPushMessage(String body, String title, String token) async {
    try {
      // String token2 = "dt47JLsvRbGs4DVtb68FpC:APA91bGRmXTZzpSkJ-setdQqNWsEoNqmIMDnr-fErut6lZ9UwT8atcFb2cQuHOvgLtgHlQSdHlnbkKVJ8pgfuHhTuz44PQ_Im3xdDlJjdK0TaP5T0mYUhvevg23R26bk6wCubJQiYAjJ";
      const postUrl = 'https://fcm.googleapis.com/fcm/send';
      final data = {
        "to": token,
        "notification": {
          "title": title,
          "body": body,
          "sound" : "default"
        },
        "data": {
          "type": '0rder',
          "id": '28',
          "click_action": 'FLUTTER_NOTIFICATION_CLICK',
        },
      };

      final headers = {
        'content-type': 'application/json',
        'Authorization':
        'key=AAAAIwPjrWE:APA91bEEQEXPtx7sNQzuR7mMer8ypL8v7w-JKtMuiAKt9S2xovbiuvKLyv40oUcmG3jHzTSb0vEfJpFZUBdv3s6pVsXf1CCLr4REjuvvP_YeE9aH4NRkVj5V_Uzfe5BssluGiy0zixiE'};


      final response = await http.post(Uri.parse(postUrl),
          body: json.encode(data),
          encoding: Encoding.getByName('utf-8'),
          headers: headers);

      if (response.statusCode == 200) {
        // on success do sth
        print('test ok push CFM');
      } else {
        print(' CFM error');
        // on failure do sth
      }
      //
      //
      // await http.post(
      //   Uri.parse('https://fcm.googleapis.com/fcm/send'),
      //   headers: <String, String>{
      //     'Content-Type': 'application/json',
      //     'Authorization':
      //     'key=AAAAIwPjrWE:APA91bEEQEXPtx7sNQzuR7mMer8ypL8v7w-JKtMuiAKt9S2xovbiuvKLyv40oUcmG3jHzTSb0vEfJpFZUBdv3s6pVsXf1CCLr4REjuvvP_YeE9aH4NRkVj5V_Uzfe5BssluGiy0zixiE',
      //   },
      //   body: jsonEncode(
      //     <String, dynamic>{
      //       'notification': <String, dynamic>{
      //         'body': body,
      //         'title': title,
      //       },
      //       'priority': 'high',
      //       'data': <String, dynamic>{
      //         'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      //         'id': '1',
      //         'status': 'done'
      //       },
      //       "to": token,
      //     },
      //   ),
      // );
      // print('done');
    } catch (e) {
      print("error push notification");
    }
  }

  //

  final TextEditingController _controller = TextEditingController();
  DateTime _dateTime = DateTime.now();

  var outputFormat = DateFormat('hh:mm a');

  final dateFormat = DateFormat("EEEE, dd MMM yyyy");
  final df = DateFormat("yyyy-MM-dd");

  SharedPreferences? doctorData;
  SharedPreferences? loginData;

  var availableBookTime = [
    CheckBoxState(title: ""),
  ];

  var availTime = [
    // "06:00",
    // "07:00",
  ];

  String? value, date;
  int _totalBill = 0;
  bool _enableCreateOrderBtn = false;
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
  // List<String> timeList = timeToBook;
  var currentTime = "00:00";
  var closeTime = "22:00";

  String? doctorName, doctorLname, doctorOpenTime, doctorCloseTime, doctorId,
      docUserId, website, docaddress, status, doccreatedAt, docupdateAt, docphone, exp, specialization,doctorDevice;

  bool? isDoctor, isAdmin, verified;
  String ? userId, emailVerificationToken, createdAt, updatedAt,
      email, name, surname, phone, birthdate, address, gender,patientDevice;
  late int doctorFee;

  void initial() async{
    doctorData = await SharedPreferences.getInstance();
    loginData = await SharedPreferences.getInstance();
    setState(() {
      doctorName = doctorData!.getString('docName');
      doctorLname = doctorData!.getString('docLname');
      doctorFee = doctorData!.getInt('fee')!;
      doctorOpenTime = doctorData!.getString('openTime');
      doctorCloseTime = doctorData!.getString('closeTime');
      doctorId = doctorData!.getString('doctorId');
      docUserId = doctorData?.getString('docUserId');
      website = doctorData?.getString('website');
      docaddress = doctorData?.getString('address');
      status = doctorData?.getString('status');
      doccreatedAt = doctorData?.getString('createdAt');
      docupdateAt = doctorData?.getString('updatedAt');
      docphone = doctorData?.getString('phone');
      exp = doctorData?.getString('exp');
      specialization = doctorData?.getString('specialization');
      doctorDevice = doctorData?.getString('doctorDevice');


      userId = loginData!.getString('_id');
      email = loginData!.getString('email');
      name = loginData!.getString('name');
      surname = loginData!.getString('surname');
      phone = loginData!.getString('phone');
      birthdate = loginData!.getString('birthdate');
      address = loginData!.getString('address');
      gender = loginData!.getString('gender');
      emailVerificationToken = loginData!.getString('emailVerificationToken');
      isDoctor = loginData!.getBool('isDoctor');
      verified = loginData!.getBool('verified');
      isAdmin = loginData!.getBool('isAdmin');
      createdAt = loginData!.getString('createdAt');
      updatedAt = loginData!.getString('updatedAt');
      patientDevice = loginData!.getString('patientDevice');
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // pickings();
      print(doctorDevice);
      for (var time in timeList) {
        if (time == doctorOpenTime) {
          currentTime = time;
          print("$currentTime and $time");
        }
      }
      pickings();
      pickings2();
    });
  }

  Future pickings() async {
    _controller.addListener(() {
      setState(() {});
    });



    print(doctorOpenTime);

    availableBookTime.removeAt(0);
    // availTime.removeAt(0);
    for (int i = timeList.indexOf(currentTime); i < 24; i++) {
      if (currentTime == doctorCloseTime) {
        break;
      } else {
        availableBookTime
            .add(CheckBoxState(title: "${timeList[i]} - ${timeList[i + 1]}"));
        availTime.add("${timeList[i]} - ${timeList[i + 1]}");
        currentTime = timeList[i + 1];

      }
    }
  }

  Future pickings2() async {
    pickings();
  }

  Appointment newAppointment = Appointment('','','','');

  Future bookAppointment() async {
      Map data = {
        "userId": newAppointment.userId,
        "doctorId": newAppointment.doctorId,
        "time": newAppointment.time,
        "date": newAppointment.date,
        "doctorInfo": {
          "_id": doctorId,
          "userId": docUserId,
          "firstName": doctorName,
          "lastName": doctorLname,
          "phoneNumber": docphone,
          "website": website,
          "address": docaddress,
          "specialization": specialization,
          "experience": exp,
          "fee": doctorFee,
          "timings": [
            doctorOpenTime,
            doctorCloseTime
          ],
          "status": status,
          "createdAt": doccreatedAt,
          "updatedAt": docupdateAt,
          "__v": "0",
          "devices": [
            doctorDevice
          ],
        },
        "userInfo": {
          "_id": userId,
          "name": name,
          "surname": surname,
          "phone": phone,
          "email": email,
          "emailVerificationToken": emailVerificationToken,
          "verified": verified,
          "isDoctor": isDoctor,
          "isAdmin": isAdmin,
          "seenNotifications": [
          ],
          "unseenNotifications": [
          ],
          "createdAt": createdAt,
          "updatedAt": updatedAt,
          "__v": "0",
          "devices": [
            patientDevice
          ],
        }
      };
      http.Response response = await http.post(
          Uri.parse('https://newserverobgyn.herokuapp.com/api/user/bookAppointment'), headers: {
        'Content-Type': 'application/json; charset=utf-8'
      },
          body: json.encode(data)
      );
      final data1 = json.decode(response.body);
      // print(data1);

      if(data1['message'] == "The Date and Time is not available." || data1['success'] == false){
        // print(response.body);
        Fluttertoast.showToast(
            msg: data1['message'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.redAccent,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }else{
        //print("UnSuccessfull");
        Fluttertoast.showToast(
            msg: "Appointment booked successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0
        );
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => const HomePage()));
      }
    // }
  }


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
            title: Text("Book Appointment"),
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
                        "Doctor Name",
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
                                "$doctorName $doctorLname",
                                style: normalTextStyle.copyWith(
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      Text(
                        "Pick a date",
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
                        height: 32,
                      ),
                      Text(
                        "Pick the time",
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
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Total:",
                  style: descTextStyle,
                ),
                Text(
                  "650",
                  style: priceTextStyle,
                ),
              ],
            ),
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
                    final String bookingDate = df.format(_dateTime);
                    newAppointment.time = value!;
                    newAppointment.date = bookingDate;
                    newAppointment.userId = userId!;
                    newAppointment.doctorId = doctorId!;
                    bookAppointment();
                    print(doctorDevice);
                    sendPushMessage('Patient: $name $surname has booked an appointment.\n'
                        'Date: $bookingDate, Time: $value', 'Teleconsultation', '$doctorDevice');
                    // print(newAppointment.time);
                    // print(newAppointment.doctorId);
                    // print("Booking: "+newAppointment.date);
                    // print(userId);

                  },
                  child: Text(
                    "Book Appointment",
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
