// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teleconsultation/doctor_page/components/patient_card.dart';
import '../constant.dart';
import 'package:http/http.dart' as http;

import '../doctor.dart';
import '../user.dart';
import 'components/patient_approved_appointment.dart';
import 'components/patient_schedule_card.dart';


class PatientDetailScreen extends StatefulWidget {
  // const PatientDetailScreen({Key? key}) : super(key: key);
  dynamic patientFullName, patientContact, patientEmail, patientId, _imageUrl;



  PatientDetailScreen(this.patientFullName, this.patientContact, this.patientEmail, this.patientId ,this._imageUrl, {Key? key}) : super(key: key);


  @override
  _PatientDetailScreenState createState() => _PatientDetailScreenState(patientFullName, patientContact, patientEmail, patientId, _imageUrl);
}

class _PatientDetailScreenState extends State<PatientDetailScreen> {
  dynamic patientFullName, patientContact, patientEmail, patientId, _imageUrl;
  _PatientDetailScreenState(this.patientFullName, this.patientContact, this.patientEmail, this.patientId ,this._imageUrl);


// class PatientDetailScreen extends StatelessWidget {

  SharedPreferences? patientData;
  String? patientDevice;
  late SharedPreferences loginData;
  String? email, fName, lastName, contactNumber,user_id;
  SharedPreferences? appointmentData;

  final todayFormat = DateFormat("EEEE");
  final monthFormat = DateFormat("MMM");
  final dayFormat = DateFormat("d");
  final timeFormat = DateFormat("hh:mm aaa");

  UserFetch userval = UserFetch(name: '', surname: '', id: '', birthdate: '', address: '',
      phone: '', email: '', password: '', gender: '', isDoctor: false, emailVerificationToken: '', verified: false,
      isAdmin: false, createdAt: '', updatedAt: '', devices:['']);

  @override
  void initState(){
    super.initState();
    initial();
  }

  void initial() async{
    loginData = await SharedPreferences.getInstance();
    patientData = await SharedPreferences.getInstance();
    setState(() {
      patientDevice = patientData?.getString('patientDevice')!;
      print(patientDevice);
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      fetchAppointments();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/picture.png'),
              alignment: Alignment.topCenter,
              fit: BoxFit.fitWidth,
            ),
          ),
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: SvgPicture.asset(
                        'assets/icons/back.svg',
                        height: 18,
                      ),
                    ),
                    SvgPicture.asset(
                      'assets/icons/3dots.svg',
                      height: 18,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.24,
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: kBackgroundColor,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(50),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                      child: Row(
                        children: <Widget>[
                          Image.asset(
                            _imageUrl,
                            height: 120,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "$patientFullName",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: kTitleTextColor,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Contact: $patientEmail",
                                style: TextStyle(
                                  color: kTitleTextColor.withOpacity(0.7),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Email: $patientContact",
                                style: TextStyle(
                                  color: kTitleTextColor.withOpacity(0.7),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: <Widget>[
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: kBlueColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: SvgPicture.asset(
                                      'assets/icons/phone.svg',
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: kYellowColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: SvgPicture.asset(
                                      'assets/icons/chat.svg',
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: kOrangeColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: SvgPicture.asset(
                                      'assets/icons/video.svg',
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
              ),
                      const SizedBox(
                        height: 50,
                      ),
                      Text(
                        'About Patient'
                            ''
                            '',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: kTitleTextColor,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Dr. Stella is the top most heart surgeon in Flower\nHospital. She has done over 100 successful sugeries\nwithin past 3 years. She has achieved several\nawards for her wonderful contribution in her own\nfield. She’s available for private consultation for\ngiven schedules.',
                        style: TextStyle(
                          height: 1.6,
                          color: kTitleTextColor.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Upcoming Schedules',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: kTitleTextColor,
                        ),
                      ),
                      buildAppointmentList(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      // bottomNavigationBar: Container(
      //   padding: const EdgeInsets.all(16),
      //   decoration: const BoxDecoration(color: Colors.white, boxShadow: [
      //     BoxShadow(
      //       color: lightBlue300,
      //       offset: Offset(0, 0),
      //       blurRadius: 10,
      //     ),
      //   ]),
      //   child: ElevatedButton(
      //       style: ElevatedButton.styleFrom(
      //           minimumSize: const Size(100, 45),
      //           shape: RoundedRectangleBorder(
      //               borderRadius: BorderRadius.circular(borderRadiusSize))),
      //       onPressed: () {
      //         Navigator.push(context, MaterialPageRoute(builder: (context) {
      //           return CheckoutScreen(
      //           );
      //         }));
      //
      //       },
      //       child: const Text("Book Now")),
      // ),
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

    print(json['data']);
    setState(() {
      appointments = json['data'];
    });
    print('fetchclients completed');
  }

  buildAppointmentList() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        // horizontal: 30,
      ),
      child: Column(
        children: <Widget>[
          Scrollbar(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                final appointment = appointments[index];
                final userData = appointment['userInfo'];
                userval = UserFetch.fromJson(userData);
                if(patientId == userval.id){
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
                  print(patientPhone);
                  return PatientApprovedScheduleCard(
                    // 'Consultation',
                    patientName, patientSurname, patientPhone, patientEmail,
                    bookingToday, time,
                    date, bookingDay, bookingMonth, appointmentId,
                    kBlueColor,
                  );
                }else{
                  // throw contactNumber;
                  return SizedBox.shrink();
                }
              },
              // separatorBuilder: (BuildContext context, int index) => const Divider(),
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


}
