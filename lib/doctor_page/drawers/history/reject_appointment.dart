import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teleconsultation/user.dart';

import '../../../constant.dart';
import '../../../doctor.dart';
import 'no_history_message.dart';

import 'package:http/http.dart' as http;

class RejectedAppointment extends StatefulWidget {
  const RejectedAppointment({Key? key}) : super(key: key);


  @override
  _RejectedAppointmentState createState() => _RejectedAppointmentState();
}

class _RejectedAppointmentState extends State<RejectedAppointment> {

// class HistoryScreen extends StatelessWidget {

  // const HistoryScreen({Key? key}) : super(key: key);

  DoctorFetch appointmentVal = DoctorFetch(userId: '', doctorName: '',
      doctorLastName: '');
  UserFetch userFetch = UserFetch(id: '', email: '', name: '', surname: '',
      birthdate: '', address: '', phone: '', gender: '', isDoctor: false,
      emailVerificationToken: '', verified: true, isAdmin: false, createdAt: '',
      updatedAt: '', password: '', devices:['']);

  SharedPreferences? appointmentData;
  String? email, fName, lastName, contactNumber, user_id;
  DateTime _dateTime = DateTime.now();
  final todayFormat = DateFormat("EEEE");
  final monthFormat = DateFormat("MMM");
  final dayFormat = DateFormat("d");
  final timeFormat = DateFormat("hh:mm aaa");

  @override
  void initState(){
    super.initState();
    initial();
  }

  void initial() async{
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      fetchAppointments();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        body: appointments.isEmpty
            ? Center(
            child: SingleChildScrollView(
                child: NoTranscationMessage(
                  messageTitle: "No Rejected Appointments.",
                  messageDesc:
                  "",
                )))
            : ListView.builder(
            itemCount: appointments.length,
            itemBuilder: (BuildContext context, int index) {
              final appointment = appointments[index];
              final userData = appointment['userInfo'];
              final doctorData = appointment['doctorInfo'];
              final appointmentDate = appointment['date'];
              final appointmentTime = appointment['time'];
              userFetch = UserFetch.fromJson(userData);
              appointmentVal = DoctorFetch.fromJson(doctorData);
              final patientName = userFetch.name;
              final patientLname = userFetch.surname;
              final parseDate = DateTime.parse(appointmentDate);
              final String bookingToday = todayFormat.format(parseDate);
              final String bookingMonth = monthFormat.format(parseDate);
              final String bookingDay = dayFormat.format(parseDate);
              return InkWell(
                onTap: () {},
                splashColor: primaryColor100,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage('assets/images/profile.png'
                                    ''
                                    ''))),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Patient: $patientName $patientLname',
                              style: normalTextStyle,
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text('Date: $appointmentDate ($bookingToday) \nTime: $appointmentTime',
                                style: normalTextStyle),
                          ],
                        ),
                      ),
                      // const Spacer(),
                      Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.red)),
                          child: Text(
                            "REJECTED",
                            style: normalTextStyle.copyWith(
                                fontWeight: FontWeight.w500,
                                color: Colors.red),
                          ))
                    ],
                  ),
                ),
              );
            }));
  }


  List<dynamic> appointments = [];
  void fetchAppointments() async {
    const url = 'https://newserverobgyn.herokuapp.com/api/user/get-rejected-appointments';
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
                  // if(user_id == userid){
                  final date = appointment['date'];
                  final time = appointment['time'];

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
                  return Container();
                }
              // }
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