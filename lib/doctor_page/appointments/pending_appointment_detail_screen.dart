import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:teleconsultation/doctor_page/drawer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';

import '../../constant.dart';

// class PendingDetailScreen extends StatefulWidget {
//   dynamic patientName, patientSurname, patientPhone, patientEmail, bookingToday, time, bookingDate;
//   dynamic _description;
//   dynamic _imageUrl;
//   dynamic _pemail;
//
//
//   PendingDetailScreen(this.patientName, this.patientSurname, this.patientPhone, this.patientEmail, this.bookingToday, this.time, this.bookingDate, {Key? key}) : super(key: key);
//
// //  static const routeName = "/profile";
//
//   @override
//   _PendingDetailScreenState createState() => _PendingDetailScreenState();
// }

// class _PendingDetailScreenState extends State<PendingDetailScreen> {
class PendingDetailScreen extends StatefulWidget {
//   String? patientEmail, patientName, patientSurname, patientPhone, date, bookingDay, time;

  // SharedPreferences? patientData;
  //
  // @override
  // void initState(){
  //   super.initState();
  //   initial();
  // }
  //
  // void initial() async{
  //   patientData = await SharedPreferences.getInstance();
  //   setState(() {
  // patientEmail = patientData?.getString('patientEmail')!;
  // patientName = patientData?.getString('patientName')!;
  // patientSurname = patientData?.getString('patientSurname')!;
  // patientPhone = patientData?.getString('patientPhone')!;
  // date = patientData?.getString('bookingDate')!;
  // bookingDay = patientData?.getString('bookingDay')!;
  // time = patientData?.getString('bookingTime')!;
  //   });
  // }
  dynamic patientName, patientSurname, patientPhone, patientEmail, bookingToday,
      time, bookingDate, appointmentId;

  PendingDetailScreen(this.patientName, this.patientSurname, this.patientPhone,
      this.patientEmail, this.bookingToday, this.time, this.bookingDate, this.appointmentId,
      {Key? key}) : super(key: key);

  @override
  State<PendingDetailScreen> createState() => _PendingDetailScreenState();
}

class _PendingDetailScreenState extends State<PendingDetailScreen> {
  String update = "";

  //
  late SharedPreferences deviceOfPatient;
  late String deviceId;
  @override
  void initState(){
    super.initState();
    initial();
    requestPermission();
    loadFCM();
    listenFCM();
  }

  void initial() async{
    deviceOfPatient = await SharedPreferences.getInstance();
    setState(() {
      deviceId = deviceOfPatient.getString('deviceOfPatient')!;
      print(deviceId);
    });
  }

  var channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    importance: Importance.high,
    enableVibration: true,
  );

  var flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  String? mtoken = " ";

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        mtoken = token;
      });
    });
  }

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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          customSliverAppBar(context),
          SliverPadding(
            padding:
            const EdgeInsets.only(right: 24, left: 24, bottom: 24, top: 8),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(
                  height: 16,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.account_circle_rounded,
                      color: primaryColor500,
                    ),
                    const SizedBox(
                      width: 16.0,
                    ),
                    Flexible(
                      child: Text(
                        "${widget.patientName} ${widget.patientSurname}",
                        overflow: TextOverflow.visible,
                        style: addressTextStyle,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 32,
                ),
                Text(
                  "Contact:",
                  style: subTitleTextStyle,
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.phone,
                      color: primaryColor500,
                    ),
                    const SizedBox(
                      width: 16.0,
                    ),
                    Flexible(
                      child: Text(
                        "${widget.patientPhone}",
                        overflow: TextOverflow.visible,
                        style: addressTextStyle,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.email,
                      color: primaryColor500,
                    ),
                    const SizedBox(
                      width: 16.0,
                    ),
                    Flexible(
                      child: Text(
                        "${widget.patientEmail}",
                        overflow: TextOverflow.visible,
                        style: addressTextStyle,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 32,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Date and Time:",
                      style: subTitleTextStyle,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 4,
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.date_range_rounded,
                      color: primaryColor500,
                    ),
                    const SizedBox(
                      width: 16.0,
                    ),
                    Text(
                      "${widget.bookingDate} (${widget.bookingToday})",
                      style: descTextStyle,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time_rounded,
                      color: primaryColor500,
                    ),
                    const SizedBox(
                      width: 16.0,
                    ),
                    Text(
                      "${widget.time}",
                      style: descTextStyle,
                    ),
                  ],
                ),
              ]),
            ),
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
          ),
        ]),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(100, 45),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              borderRadiusSize)),
                      backgroundColor: Colors.redAccent
                  ),
                  onPressed: () {
                    update = "rejected";
                    if(update == "rejected"){
                      updateAppointment(context, widget.appointmentId);

                      sendPushMessage('Dr: Marilyn Fuentes rejected your appointment', 'Teleconsultation', '$deviceId');
                    }

                    // print(update);
                  },
                  child: const Text("Reject")),
            ),
            SizedBox(width: size.width * 0.025),
            Expanded(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(100, 45),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              borderRadiusSize))),
                  onPressed: () {
                    update = "approved";
                    if(update == "approved"){
                      updateAppointment(context, widget.appointmentId);

                      sendPushMessage('Dr: Marilyn Fuentes approved your appointment', 'Teleconsultation', '$deviceId');
                    }
                    // print(update);
                  },
                  child: const Text("Accept")),
            ),
          ],
        ),
      ),
    );
  }

  Widget customSliverAppBar(context) {
    return SliverAppBar(
      shadowColor: primaryColor500.withOpacity(.2),
      backgroundColor: colorWhite,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        expandedTitleScale: 1,
        titlePadding: EdgeInsets.zero,
        title: Container(
          width: MediaQuery
              .of(context)
              .size
              .width,
          height: kToolbarHeight,
          decoration: const BoxDecoration(
              color: colorWhite,
              borderRadius: BorderRadius.vertical(
                  top: Radius.circular(borderRadiusSize))),
          child: Center(
            child: Text(
              "Pending Appointment",
              style: titleTextStyle,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        // background: Image.asset(
        //   field.imageAsset,
        //   fit: BoxFit.cover,
        // ),
        collapseMode: CollapseMode.parallax,
      ),
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: const BoxDecoration(
            color: colorWhite,
            shape: BoxShape.circle,
          ),
          child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              iconSize: 26,
              icon: const Icon(
                Icons.arrow_back,
                color: darkBlue500,
              )),
        ),
      ),
      // expandedHeight: 300,
    );
  }

  Future updateAppointment(BuildContext context, id) async {
    Map data = {
      "status": update,
    };
    String body = json.encode(data);
    http.Response response = await http.patch(
      Uri.parse(
          'https://newserverobgyn.herokuapp.com/api/user/updateAppointments/$id'),
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    // print(response.body);
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: "Appointment Updated Successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  const DoctorPage()));
    } else {
      return (
          Fluttertoast.showToast(
              msg: "Appointment Updated Failed",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.redAccent,
              textColor: Colors.white,
              fontSize: 16.0));
    }
  }
}