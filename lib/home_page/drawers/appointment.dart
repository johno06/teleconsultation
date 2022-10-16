import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constant.dart';
import '../../user.dart';
import '../components/doctor_card.dart';
import '../components/schedule_card.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart' as http;

class MyAppointment extends StatefulWidget {
  const MyAppointment({Key? key}) : super(key: key);


  @override
  _MyAppointmentState createState() => _MyAppointmentState();
}

class _MyAppointmentState extends State<MyAppointment> {

  // ProfileModel model = ProfileModel();


  late SharedPreferences loginData;
  SharedPreferences? doctorData;
  SharedPreferences? appointmentData;
  String? email, fName, lastName, contactNumber, user_id;
  DateTime _dateTime = DateTime.now();
  final todayFormat = DateFormat("EEEE");
  final monthFormat = DateFormat("MMM");
  final dayFormat = DateFormat("d");
  final timeFormat = DateFormat("hh:mm aaa");

  UserFetch userval = UserFetch(name: '', surname: '', id: '', birthdate: '', address: '',
      phone: '', email: '', password: '', gender: '', isDoctor: false, emailVerificationToken: '', verified: false,
      isAdmin: false, createdAt: '', updatedAt: '');


  @override
  void initState(){
    super.initState();
    initial();
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
              const SizedBox(
                height: 20,
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
    const url = 'https://newserverobgyn.herokuapp.com/api/user/get-all-approved-doctors';
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
    const url = 'https://newserverobgyn.herokuapp.com/api/user/get-approved-appointments';
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

  buildDoctor() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 30,
      ),
      child: Column(
        children: <Widget>[
          Scrollbar(
            child: ListView.separated(
                shrinkWrap: true,
                itemCount: clients.length,
                separatorBuilder: (_ , __ ) => Divider(height: 0.6,
                  color: Colors.black87,),
                itemBuilder: (context, index) {
                  final client = clients[index];
                  // final stylist_id = client['stylist_id'];
                  // if(stylist_id == id){
                  final id = client['_id'];
                  final userId = client['userId'];
                  final website = client['website'];
                  final address = client['address'];
                  final status = client['status'];
                  final createdAt = client['createdAt'];
                  final updatedAt = client['updatedAt'];
                  final name = client['firstName'];
                  final email = client['email'];
                  final lastname = client['lastName'];
                  final phone = client['phoneNumber'];
                  final fee = client['fee'];
                  final openTime = client['timings'][0];
                  final closeTime = client['timings'][1];
                  final specialization = client['specialization'];
                  final exp = client['experience'];

                  doctorData?.setString('docName', name);
                  doctorData?.setString('docLname', lastname);
                  doctorData?.setInt('fee', fee);
                  doctorData?.setString('openTime', openTime);
                  doctorData?.setString('closeTime', closeTime);
                  doctorData?.setString('doctorId', id);
                  doctorData?.setString('docUserId', userId);
                  doctorData?.setString('website', website);
                  doctorData?.setString('address', address);
                  doctorData?.setString('status', status);
                  doctorData?.setString('createdAt', createdAt);
                  doctorData?.setString('updatedAt', updatedAt);
                  doctorData?.setString('phone', phone);
                  doctorData?.setString('exp', exp);
                  doctorData?.setString('specialization', specialization);
                  // final verified = client['verified'];
                  return DoctorCard(
                    'Dr. $name $lastname',
                    'Contact: $phone',
                    'Specialization: $specialization',
                    'Fee: $fee',
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
