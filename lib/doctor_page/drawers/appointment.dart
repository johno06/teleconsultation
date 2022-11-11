import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constant.dart';
import '../../doctor.dart';
import '../../user.dart';
import '../components/patient_appointment.dart';
import '../components/patient_approved_appointment.dart';
import '../components/patient_card.dart';
import 'package:http/http.dart' as http;
import '../components/patient_schedule_card.dart';


class DoctorMyAppointment extends StatefulWidget {
  const DoctorMyAppointment({Key? key}) : super(key: key);


  @override
  _DoctorMyAppointmentState createState() => _DoctorMyAppointmentState();
}

class _DoctorMyAppointmentState extends State<DoctorMyAppointment> {

  // ProfileModel model = ProfileModel();
  final todayFormat = DateFormat("EEEE");
  final monthFormat = DateFormat("MMM");
  final dayFormat = DateFormat("d");
  final timeFormat = DateFormat("hh:mm aaa");

  SharedPreferences? appointmentData;
  late SharedPreferences loginData;
  SharedPreferences? deviceOfPatient;
  String? email, fName, lastName, contactNumber,user_id;

  UserFetch userval = UserFetch(name: '', surname: '', id: '', birthdate: '', address: '',
      phone: '', email: '', password: '', gender: '', isDoctor: false, emailVerificationToken: '', verified: false,
      isAdmin: false, createdAt: '', updatedAt: '', devices:['']);

  DoctorFetch doctorVal = DoctorFetch(userId: '', doctorName: '', doctorLastName: '');

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
      user_id = loginData.getString('_id')!;
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      fetchAppointments();
      fetchPendingAppointments();
    });
  }

  List<dynamic> clients = [];
  void fetchClients() async {
    const url = 'https://newserverobgyn.herokuapp.com/api/user/get-all-approved-doctors';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);


    // clientData = await SharedPreferences.getInstance();

    print(json['data']);
    setState(() {
      clients = json['data'];
    });
    print('fetchclients completed');
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
                  'Pending Appointments',
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
              buildPendingAppointmentList(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Text(
                  'Appointment List',
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


  buildDoctor() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 30,
      ),
      child: Column(
        children: <Widget>[
          // PatientCard(
          //   'Jam Raon',
          //   'Age: 33',
          //   'Email: jam@gmail.com',
          //   'assets/images/profile.png',
          //   kBlueColor,
          // ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  List<dynamic> pendingAppointments = [];
  void fetchPendingAppointments() async {
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
      pendingAppointments = json['data'];
    });
    print('fetchclients completed');
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
              itemCount: pendingAppointments.length,
              itemBuilder: (context, index) {
                final appointment = pendingAppointments[index];
                final doctorData = appointment['doctorInfo'];
                final consultationType = appointment['consultationType'];
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
                    date, bookingDay, bookingMonth, patientDevice,appointmentId, consultationType,
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







  List<dynamic> appointments = [];
  void fetchAppointments() async {
    const url = 'https://newserverobgyn.herokuapp.com/api/user/get-approved-appointments';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);

    // appointmentData = await SharedPreferences.getInstance();
    // clientData = await SharedPreferences.getInstance();
    deviceOfPatient = await SharedPreferences.getInstance();

    print(json['data']);
    setState(() {
      appointments = json['data'];
    });
    print('fetchclients completed');
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
              itemBuilder: (context, index) {
                final appointment = appointments[index];
                final userData = appointment['userInfo'];
                userval = UserFetch.fromJson(userData);
                final doctorData = appointment['doctorInfo'];
                final consultationType = appointment['consultationType'];
                doctorVal = DoctorFetch.fromJson(doctorData);
                // if(patientId == userval.id){
                if(user_id == doctorVal.userId){
                  final appointmentId = appointment['_id'];
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
                  // print("this is the patient: $patientDevice");
                  deviceOfPatient?.setString('deviceToken', patientDevice);
                  return PatientAppointmentScheduleCard(
                    // 'Consultation',
                    patientName, patientSurname, patientPhone, patientEmail,
                    bookingToday, time,
                    date, bookingDay, bookingMonth, patientDevice ,appointmentId, consultationType,
                    kBlueColor,
                  );
                }else{
                  // throw contactNumber;
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

  // buildAppointmentList() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(
  //       horizontal: 30,
  //     ),
  //     child: Column(
  //       children: <Widget>[
  //         // PatientScheduleCard(
  //         //   'Consultation',
  //         //   'Sunday . 9am - 11am',
  //         //   '12',
  //         //   'Jan',
  //         //   kBlueColor,
  //         // ),
  //         // const SizedBox(
  //         //   height: 10,
  //         // ),
  //         // PatientScheduleCard(
  //         //   'Consultation',
  //         //   'Sunday . 9am - 11am',
  //         //   '13',
  //         //   'Jan',
  //         //   kYellowColor,
  //         // ),
  //         // const SizedBox(
  //         //   height: 10,
  //         // ),
  //         // PatientScheduleCard(
  //         //   'Consultation',
  //         //   'Sunday . 9am - 11am',
  //         //   '14',
  //         //   'Jan',
  //         //   kOrangeColor,
  //         // ),
  //         const SizedBox(
  //           height: 20,
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
