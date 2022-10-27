import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teleconsultation/doctor.dart';
import 'package:teleconsultation/doctor_page/components/patient_schedule_card.dart';
import '../../constant.dart';
import 'package:http/http.dart' as http;

import '../../home_page/components/schedule_card.dart';
import '../../user.dart';
import '../components/patient_card.dart';

class DoctorHomeScreen extends StatefulWidget {
  const DoctorHomeScreen({Key? key}) : super(key: key);


  @override
  _DoctorHomeScreenState createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen> {

  // ProfileModel model = ProfileModel();


  late SharedPreferences loginData;
  String? email, fName, lastName, contactNumber,user_id, address;
  SharedPreferences? appointmentData;
  SharedPreferences? patientData;

  final todayFormat = DateFormat("EEEE");
  final monthFormat = DateFormat("MMM");
  final dayFormat = DateFormat("d");
  final timeFormat = DateFormat("hh:mm aaa");

  DoctorFetch doctorVal = DoctorFetch(userId: '', doctorName: '', doctorLastName: '');
  UserFetch userval = UserFetch(name: '', surname: '', id: '', birthdate: '', address: '',
      phone: '', email: '', password: '', gender: '', isDoctor: false, emailVerificationToken: '', verified: false,
      isAdmin: false, createdAt: '', updatedAt: '', devices:['']);
  SharedPreferences? deviceOfPatient;
  //

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
      String token2 = "cV1z2QH1QvqXXUj54LWnyt:APA91bETJ7Xzs0ds8l5T1fjpwIJWCz5ZHPdkUECeiziKL8QZ3cKt1AvablsGmBf6EhsTWgvLVfPCOZtniKhJKCuTZalqM9YgMC9rgmcOIJHqCruSEt8-b_bM-qc0COAhzGL5ZUQLbreL";
      const postUrl = 'https://fcm.googleapis.com/fcm/send';
      final data = {
        "to": token2,
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
  void initState(){
    super.initState();
    initial();
    requestPermission();
    loadFCM();
    listenFCM();
  }

  void initial() async{
    loginData = await SharedPreferences.getInstance();
    setState(() {
      email = loginData.getString('email')!;
      fName = loginData.getString('name')!;
      lastName = loginData.getString('surname')!;
      contactNumber = loginData.getString('phone')!;
      user_id = loginData.getString('_id')!;
      address = loginData.getString('address');
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      fetchPatients();
      fetchAppointments();
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Column(
        children: [
          header(context),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  ),
                ),
                Container(
                  padding:
                  const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0),
                  child: Text(
                    // "Book Appointment and \nBe Healty!",
                    "It’s not just our duty but \na passion to serve you.",
                    style: greetingTextStyle,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    'Patients',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: kTitleTextColor,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                buildPatients(),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    'Pending Appointments',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: kTitleTextColor,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                buildPendingAppointmentList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

 // buildCategoryList() {
 //   return SingleChildScrollView(
 //     scrollDirection: Axis.horizontal,
 //     child: Row(
 //       children: <Widget>[
 //         const SizedBox(
 //           width: 30,
 //         ),
 //         DoctorCategoryCard(
 //           'Dental\nSurgeon',
 //           'assets/icons/dental_surgeon.png',
 //           kBlueColor,
 //         ),
 //         const SizedBox(
 //           width: 10,
 //         ),
 //         DoctorCategoryCard(
 //           'Heart\nSurgeon',
 //           'assets/icons/heart_surgeon.png',
 //           kYellowColor,
 //         ),
 //         const SizedBox(
 //           width: 10,
 //         ),
 //         DoctorCategoryCard(
 //           'Eye\nSpecialist',
 //           'assets/icons/eye_specialist.png',
 //           kOrangeColor,
 //         ),
 //         const SizedBox(
 //           width: 30,
 //         ),
 //       ],
 //     ),
 //   );
 // }

  // buildDoctorList() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(
  //       horizontal: 30,
  //     ),
  //     child: Column(
  //       children: <Widget>[
  //         DoctorDoctorCard(
  //           'Jam Raon',
  //           'Age: 33',
  //           'Email: jam@gmail.com',
  //           'assets/images/profile.png',
  //           kBlueColor,
  //         ),
  //         const SizedBox(
  //           height: 20,
  //         ),
  //         DoctorDoctorCard(
  //           'Oliver Ruiz',
  //           'Age: 27',
  //           'Email: Oliver@gmail.com',
  //           'assets/images/profile.png',
  //           kYellowColor,
  //         ),
  //         const SizedBox(
  //           height: 20,
  //         ),
  //         DoctorDoctorCard(
  //           'Micaella Garcia',
  //           'Age: 32',
  //           'Email: mica@gmail.com',
  //           'assets/images/profile.png',
  //           kOrangeColor,
  //         ),
  //         const SizedBox(
  //           height: 20,
  //         ),
  //       ],
  //     ),
  //   );
  // }


  List<dynamic> appointments = [];
  void fetchAppointments() async {
    const url = 'https://newserverobgyn.herokuapp.com/api/user/get-pending-appointments';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);

    appointmentData = await SharedPreferences.getInstance();
    deviceOfPatient = await SharedPreferences.getInstance();
    // clientData = await SharedPreferences.getInstance();

    print(json['data']);
    setState(() {
      appointments = json['data'];
    });
    print('fetchclients completed');
  }

  buildPatients() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 30,
      ),
      child: Column(
        children: <Widget>[
          Scrollbar(
            child: ListView.separated(
                shrinkWrap: true,
                itemCount: patients.length,
                itemBuilder: (context, index) {
                  final patient = patients[index];
                  // final stylist_id = client['stylist_id'];
                  // if(stylist_id == id){
                  final patientId = patient['_id'];
                  final patientName = patient['name'];
                  final patientSurname = patient['surname'];
                  final patientEmail = patient['email'];
                  final patientPhone = patient['phone'];
                  final patientBirthdate = patient['birthdate'];
                  final patientGender = patient['gender'];
                  final patientAddress = patient['address'];
                  final patientDevice = patient['devices'][0];
                  patientData?.setString('patientDevice', patientDevice);
                  patientData?.setString('patientId', patientId);
                  patientData?.setString('patientName', patientName);
                  patientData?.setString('patientSurname', patientSurname);
                  patientData?.setString('patientEmail', patientEmail);
                  patientData?.setString('patientPhone', patientPhone);
                  patientData?.setString('patientBirthdate', patientBirthdate);
                  patientData?.setString('patientGender', patientGender);
                  patientData?.setString('patientAddress', patientAddress);
                  return PatientCard(
                    "$patientName $patientSurname",
                     patientPhone,
                     patientEmail,
                     patientBirthdate,
                     patientGender,
                     patientAddress,
                    patientId,
                    'assets/images/profile.png',
                    kBlueColor,
                  );
                  // }else{
                  //   return Container();
                  // }
                },
          separatorBuilder: (BuildContext context, int index) => const Divider(),
            ),
          ),
          // const SizedBox(
          //   height: 20,
          // ),
        ],
      ),
    );
  }


  List<dynamic> patients = [];
  void fetchPatients() async {
    const url = 'https://newserverobgyn.herokuapp.com/api/user/get-all-verified-patients';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);

    patientData = await SharedPreferences.getInstance();

    // print(json['data']);
    setState(() {
      patients = json['data'];
    });
    print('fetch patients completed');
  }

  buildPendingAppointmentList() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 30,
      ),
      child: Column(
        children: <Widget>[
          Scrollbar(
            child: ListView.separated(
                shrinkWrap: true,
                itemCount: appointments.length,
                itemBuilder: (context, index) {
                  final appointment = appointments[index];
                  final doctorData = appointment['doctorInfo'];
                  doctorVal = DoctorFetch.fromJson(doctorData);
                  if(user_id == doctorVal.userId){
                    final appointmentId = appointment['_id'];
                    final userData = appointment['userInfo'];
                    userval = UserFetch.fromJson(userData);
                    final date = appointment['date'];
                    final time = appointment['time'];
                    final parseDate = DateTime.parse(date);
                    // final parseTime = DateTime.parse(time);
                    final String bookingToday = todayFormat.format(parseDate);
                    final String bookingMonth = monthFormat.format(parseDate);
                    final String bookingDay = dayFormat.format(parseDate);

                    final patientName = userval.name;
                    final patientSurname = userval.surname;
                    final patientEmail = userval.email;
                    final patientPhone = userval.phone;
                    final patientDevice = userval.devices[0];
                    deviceOfPatient?.setString('deviceOfPatient', patientDevice);
                    return PatientScheduleCard(
                      // 'Consultation',
                      patientName, patientSurname, patientPhone, patientEmail,
                      bookingToday, time,
                      date, bookingDay, bookingMonth, patientDevice,appointmentId,
                      kBlueColor,
                    );
                  }else{
                    return Container();
                  }
                },
              separatorBuilder: (BuildContext context, int index) => const Divider(),
            ),
          ),
          // ScheduleCard(
          //   'Consultation',
          //   'Sunday . 9am - 11am',
          //   '12',
          //   'Jan',
          //   kBlueColor,
          // ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Widget header(context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: SafeArea(
        // SEARCH Icon
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(
                  width: 55,
                  height: 55,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage(
                          "assets/images/user_profile_example.png"),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome back,",
                      style: descTextStyle,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      "Dr. $fName $lastName",
                      style: subTitleTextStyle,
                    ),
                  ],
                ),
              ],
            ),
            // Container(
            //   decoration: BoxDecoration(
            //       color: primaryColor500,
            //       borderRadius: BorderRadius.circular(borderRadiusSize)),
            //   child: IconButton(
            //     onPressed: () {
            //       // Navigator.push(context, MaterialPageRoute(builder: (context) {
            //       //   return SearchScreen(
            //       //     selectedDropdownItem: "",
            //       //   );
            //       // }));
            //     },
            //     icon: const Icon(Icons.search, color: colorWhite),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
