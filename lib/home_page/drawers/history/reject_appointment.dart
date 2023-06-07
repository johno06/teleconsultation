import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constant.dart';
import '../../../doctor.dart';
import 'no_history_message.dart';

import 'package:http/http.dart' as http;

class HistoryScreen1 extends StatefulWidget {
  const HistoryScreen1({Key? key}) : super(key: key);


  @override
  _HistoryScreenState1 createState() => _HistoryScreenState1();
}

class _HistoryScreenState1 extends State<HistoryScreen1> {

// class HistoryScreen extends StatelessWidget {

  // const HistoryScreen({Key? key}) : super(key: key);

  DoctorFetch appointmentVal = DoctorFetch(userId: '', doctorName: '', doctorLastName: '');

  SharedPreferences? appointmentData;
  SharedPreferences? loginData;
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
    loginData = await SharedPreferences.getInstance();
    setState(() {
      user_id = loginData?.getString('_id');
      print("eto: $user_id");
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      fetchAppointments();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        body: appointmentsById.isEmpty
            ? Center(
            child: SingleChildScrollView(
                child: NoTranscationMessage(
                  messageTitle: "No Canceled Appointments.",
                  messageDesc:
                  "Book appointment now.",
                )))
            : ListView.builder(
            itemCount: appointmentsById.length,
            itemBuilder: (BuildContext context, int index) {
              final appointment = appointmentsById[index];
              final userId = appointment['userId'];
              print(userId);
              if(userId == user_id){
                final doctorData = appointment['doctorInfo'];
                final appointmentDate = appointment['date'];
                final appointmentTime = appointment['time'];
                appointmentVal = DoctorFetch.fromJson(doctorData);
                final docName = appointmentVal.doctorName;
                final docLname = appointmentVal.doctorLastName;
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
                                  image: AssetImage('assets/images/doctor1.png'
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
                                'Doctor: $docName $docLname',
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
                              "CANCELED",
                              style: normalTextStyle.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.red),
                            ))
                      ],
                    ),
                  ),
                );
              }else{
                return const SizedBox(height: 0.0,);
              }
            }));
  }


  List<dynamic> appointments = [];
  List<dynamic> appointmentsById = [];
  String status ="rejected";
  void fetchAppointments() async {
    const url = 'https://latest-server.onrender.com/api/user/get-rejected-appointments';
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

    for(int i=0; i<appointments.length; i++){
      final client = appointments[i];
      if(status == client['status'] && user_id == client['userId']){
        // print("yes");
        appointmentsById.add(client);
      }
    }
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
