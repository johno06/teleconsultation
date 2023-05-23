import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constant.dart';
import '../../user.dart';
import '../components/doctor_card.dart';
import '../components/schedule_card.dart';
import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'notificationservice/local_notification_service.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class MyAppointment extends StatefulWidget {
  const MyAppointment({Key? key}) : super(key: key);


  @override
  _MyAppointmentState createState() => _MyAppointmentState();
}

class _MyAppointmentState extends State<MyAppointment> {

  late SharedPreferences loginData;
  SharedPreferences? doctorData;
  SharedPreferences? appointmentData;
  String? email, fName, lastName, contactNumber, user_id;
  DateTime _dateTime = DateTime.now();
  final todayFormat = DateFormat("EEEE");
  final monthFormat = DateFormat("MMM");
  final dayFormat = DateFormat("d");
  final timeFormat = DateFormat("hh:mm aaa");
  DateTime dateTime = DateTime.now();
  final TextEditingController _time = TextEditingController();
  late String date1, time1, time05;

  UserFetch userval = UserFetch(name: '', surname: '', id: '', birthdate: '', address: '',
      phone: '', email: '', password: '', isDoctor: false, verified: false,
      isAdmin: false, createdAt: '', updatedAt: '', devices:['']);

  late final LocalNotificationService service;
  late final LocalNotificationService service1;


  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  @override
  void initState(){
    super.initState();
    initial();
    const AndroidInitializationSettings androidInitializationSettings =
    AndroidInitializationSettings("@mipmap/ic_launcher");

    const DarwinInitializationSettings iosInitializationSettings =
    DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
    InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
      macOS: null,
      linux: null,
    );

    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      // onSelectNotification: (dataYouNeedToUseWhenNotificationIsClicked) {},
    );
  }

  showNotification() {
    // if (_title.text.isEmpty || _desc.text.isEmpty) {
    //   return;
    // }

    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      "ScheduleNotification001",
      "Notify Me",
      importance: Importance.high,
    );

    const DarwinNotificationDetails iosNotificationDetails =
    DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
      macOS: null,
      linux: null,
    );

    tz.initializeTimeZones();
    var inputFormat = DateFormat('yyyy-MM-dd HH:mm');
    var inputDate = inputFormat.parse('$date1 $time1');
    print(date1);
    final tz.TZDateTime scheduledAt = tz.TZDateTime.from(inputDate, tz.local);

    flutterLocalNotificationsPlugin.zonedSchedule(
        01, "Teleconsultation", "Your booking will start in 1 hour.", scheduledAt, notificationDetails,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.wallClockTime,
        androidAllowWhileIdle: true,
        payload: 'Ths s the data');
  }
  showNotification5() {

    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      "ScheduleNotification002",
      "Notify Me",
      importance: Importance.high,
    );

    const DarwinNotificationDetails iosNotificationDetails =
    DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
      macOS: null,
      linux: null,
    );

    tz.initializeTimeZones();
    var inputFormat = DateFormat('yyyy-MM-dd HH:mm');
    var inputDate = inputFormat.parse('$date1 $time05');
    print(date1);
    final tz.TZDateTime scheduledAt = tz.TZDateTime.from(inputDate, tz.local);

    flutterLocalNotificationsPlugin.zonedSchedule(
        02, "Teleconsultation", "Your booking will start in 5 minutes.", scheduledAt, notificationDetails,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.wallClockTime,
        androidAllowWhileIdle: true,
        payload: 'Ths s the data');
  }

  void initial() async{
    loginData = await SharedPreferences.getInstance();
    setState(() {
      email = loginData.getString('email')!;
      fName = loginData.getString('name')!;
      lastName = loginData.getString('surname')!;
      contactNumber = loginData.getString('phone')!;
      user_id = loginData.getString('_id');
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      fetchClients();
      fetchAppointments();
      fetchPendingAppointments();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Text(
                  'Doctor',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: kTitleTextColor,
                    fontSize: 21,
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              buildDoctor(),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 30),
              //   child: Text(
              //     'Pending Appointments',
              //     style: TextStyle(
              //       fontWeight: FontWeight.bold,
              //       color: kTitleTextColor,
              //       fontSize: 21,
              //     ),
              //   ),
              // ),
              // const SizedBox(
              //   height: 15,
              // ),
              // buildAppointmentList(),
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  'Pending Appointments',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: kTitleTextColor,
                    fontSize: 21,
                  ),
                ),
              ),
              const SizedBox(height: 15,),
              buildPendingAppointmentList(),
              const SizedBox(height: 15,),
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      'Appointments',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: kTitleTextColor,
                        fontSize: 21,
                      ),
                    ),
                  ),
                  Flexible(
                    // child: Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: shrinePink400,
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))
                        ),
                        onPressed: () {
                          showNotification();
                          showNotification5();
                          Fluttertoast.showToast(
                              msg: "You will be notify 1 hour and 5 minutes before your consultation.",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                              fontSize: 16.0
                          );
                        },
                        child: const Text('Reminder 🔔'),
                      ),
                    ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              buildAppointmentList(),
            ],
          ),
        ),
      ),
    );
  }

  List<dynamic> clients = [];
  void fetchClients() async {
    const url = 'https://latest-server.onrender.com/api/user/get-all-approved-doctors';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);

    doctorData = await SharedPreferences.getInstance();

    // print(json['data']);
    setState(() {
      clients = json['data'];
    });
    print('fetchclients completed');
  }

  List<dynamic> appointments = [];
  void fetchAppointments() async {
    const url = 'https://latest-server.onrender.com/api/user/get-approved-appointments';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);

    appointmentData = await SharedPreferences.getInstance();
    // clientData = await SharedPreferences.getInstance();

    // print(json['data']);
    setState(() {
      appointments = json['data'];
    });
    // print('fetchclients completed');
  }
  List<dynamic> pendingAppointments = [];
  void fetchPendingAppointments() async {
    const url = 'https://latest-server.onrender.com/api/user/get-pending-appointments';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);

    appointmentData = await SharedPreferences.getInstance();
    // clientData = await SharedPreferences.getInstance();

    // print(json['data']);
    setState(() {
      pendingAppointments = json['data'];
    });
    // print('fetchclients completed');
  }

  buildDoctor() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 30,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Scrollbar(
              child: ListView.separated(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: clients.length,
                  separatorBuilder: (_ , __ ) => Divider(height: 0.6,
                    color: Colors.black87,),
                  itemBuilder: (context, index) {
                    final client = clients[index];
                    // final stylist_id = client['stylist_id'];
                    // if(stylist_id == id){
                    final id = client['_id'];
                    final userId = client['userId'];
                    final address = client['address'];
                    final status = client['status'];
                    final createdAt = client['createdAt'];
                    final updatedAt = client['updatedAt'];
                    final name = client['firstName'];
                    final email = client['email'];
                    final lastname = client['lastName'];
                    final phone = client['phoneNumber'];
                    final openTime = client['timings'][0];
                    final closeTime = client['timings'][1];
                    final specialization = client['specialization'];
                    final exp = client['experience'];
                    final doctorDevice = client['devices'][0];

                    doctorData?.setString('docName', name);
                    doctorData?.setString('docLname', lastname);
                    doctorData?.setString('openTime', openTime);
                    doctorData?.setString('closeTime', closeTime);

                    doctorData?.setString('doctorId', id);
                    doctorData?.setString('docUserId', userId);
                    doctorData?.setString('address1', address);
                    doctorData?.setString('status', status);
                    doctorData?.setString('createdAt', createdAt);
                    doctorData?.setString('updatedAt', updatedAt);
                    doctorData?.setString('phone1', phone);
                    doctorData?.setString('exp', exp);
                    doctorData?.setString('specialization', specialization);
                    doctorData?.setString('doctorDevice', doctorDevice);
                    // final verified = client['verified'];
                    return DoctorCard(
                      'Dr. $name $lastname',
                      'Contact: $phone',
                      'Specialization: $specialization',
                      'Time available: $openTime - $closeTime',
                      'Experience: $exp Years',
                      'assets/images/doctor1.png',
                      kBlueColor,
                    );
                    // }else{
                    //   return Container();
                    // }
                  }
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  buildPendingAppointmentList() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 30,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Scrollbar(
              child: ListView.separated(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: pendingAppointments.length,
                  separatorBuilder: (_ , __ ) => Divider(height: 0.6,
                    color: Colors.black87,),
                  itemBuilder: (context, index) {
                    final appointment = pendingAppointments[index];
                    final userid = appointment['userId'];
                    if(user_id == userid){
                      final date = appointment['date'];
                      final time = appointment['time'];

                      final userName = appointment['userInfo'];
                      userval = UserFetch.fromJson(userName);

                      final parseDate = DateTime.parse(date);
                      // final parseTime = DateTime.parse(time);
                      final String bookingToday = todayFormat.format(parseDate);
                      final String bookingMonth = monthFormat.format(parseDate);
                      final String bookingDay = dayFormat.format(parseDate);

                      if(time == "08:00 - 09:00"){
                        time1 = "07:00";
                        time05 = "07:55";
                      }else if(time == "09:00 - 10:00"){
                        time1 = "08:00";
                        time05 = "08:55";
                      }
                      else if(time == "10:00 - 11:00"){
                        time1 = "09:00";
                        time05 = "09:55";
                      }
                      else if(time == "11:00 - 12:00"){
                        time1 = "10:00";
                        time05 = "10:55";
                      }
                      else if(time == "12:00 - 13:00"){
                        time1 = "11:00";
                        time05 = "11:55";
                      }
                      else if(time == "13:00 - 14:00"){
                        time1 = "12:00";
                        time05 = "12:55";
                      }
                      else if(time == "14:00 - 15:00"){
                        time1 = "13:00";
                        time05 = "13:55";
                      }
                      else if(time == "15:00 - 16:00"){
                        time1 = "14:00";
                        time05 = "14:55";
                      }
                      else if(time == "16:00 - 17:00"){
                        time1 = "15:00";
                        time05 = "15:55";
                      }
                      date1 = date;
                      // time1 = "19:55";
                      // time05 = "19:57";

                      // final String bookingTime = dayFormat.format(parseTime);
                      //
                      // final email = appointment['email'];
                      // final lastname = appointment['lastName'];
                      // final verified = client['verified'];
                      return ScheduleCard(
                        'Consultation',
                        '$bookingToday . $time',
                        '$bookingDay',
                        bookingMonth,
                        kBlueColor,
                      );
                    }else{
                      return Container();
                    }
                  }
              ),
            ),
            // ScheduleCard(
            //   'Consultation',
            //   'Sunday . 9am - 11am',
            //   '12',
            //   'Jan',
            //   kBlueColor,
            // ),
            // const SizedBox(
            //   height: 20,
            // ),
          ],
        ),
      ),
    );
  }


  buildAppointmentList() {
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
                separatorBuilder: (_ , __ ) => Divider(height: 0.6,
                  color: Colors.black87,),
                itemBuilder: (context, index) {
                  final appointment = appointments[index];

                  final userid = appointment['userId'];
                  if(user_id == userid){
                  final date = appointment['date'];
                  final time = appointment['time'];

                  final userName = appointment['userInfo'];
                  userval = UserFetch.fromJson(userName);

                  final parseDate = DateTime.parse(date);
                  // final parseTime = DateTime.parse(time);
                  final String bookingToday = todayFormat.format(parseDate);
                  final String bookingMonth = monthFormat.format(parseDate);
                  final String bookingDay = dayFormat.format(parseDate);

                  if(time == "08:00 - 09:00"){
                    time1 = "07:00";
                    time05 = "07:55";
                  }else if(time == "09:00 - 10:00"){
                    time1 = "08:00";
                    time05 = "08:55";
                  }
                  else if(time == "10:00 - 11:00"){
                    time1 = "09:00";
                    time05 = "09:55";
                  }
                  else if(time == "11:00 - 12:00"){
                    time1 = "10:00";
                    time05 = "10:55";
                  }
                  else if(time == "12:00 - 13:00"){
                    time1 = "11:00";
                    time05 = "11:55";
                  }
                  else if(time == "13:00 - 14:00"){
                    time1 = "12:00";
                    time05 = "12:55";
                  }
                  else if(time == "14:00 - 15:00"){
                    time1 = "13:00";
                    time05 = "13:55";
                  }
                  else if(time == "15:00 - 16:00"){
                    time1 = "14:00";
                    time05 = "14:55";
                  }
                  else if(time == "16:00 - 17:00"){
                    time1 = "15:00";
                    time05 = "15:55";
                  }
                  date1 = date;
                  // time1 = "19:55";
                  // time05 = "19:57";

                  // final String bookingTime = dayFormat.format(parseTime);
                  //
                  // final email = appointment['email'];
                  // final lastname = appointment['lastName'];
                  // final verified = client['verified'];
                  return ScheduleCard(
                    'Consultation',
                    '$bookingToday . $time',
                    '$bookingDay',
                    bookingMonth,
                    kBlueColor,
                  );
                  }else{
                    return Container();
                  }
                }
            ),
          ),
          // ScheduleCard(
          //   'Consultation',
          //   'Sunday . 9am - 11am',
          //   '12',
          //   'Jan',
          //   kBlueColor,
          // ),
          // const SizedBox(
          //   height: 20,
          // ),
        ],
      ),
    );
  }
}
