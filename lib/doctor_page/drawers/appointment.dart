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
  SharedPreferences? patientData;
  late SharedPreferences loginData;
  SharedPreferences? deviceOfPatient;
  String? email, fName, lastName, contactNumber,user_id;

  UserFetch userval = UserFetch(name: '', surname: '', id: '', birthdate: '', address: '',
      phone: '', email: '', password: '', isDoctor: false, verified: false,
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
      // fetchAppointments();
      // fetchPendingAppointments();
      fetchPatients();
    });
  }

  List<dynamic> clients = [];
  void fetchClients() async {
    const url = 'https://latest-server.onrender.com/api/user/get-all-approved-doctors';
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
                  'Patients: ',
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
              buildPatients(),
              // buildPendingAppointmentList(),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              //   child: Text(
              //     'Appointment List',
              //     style: TextStyle(
              //       fontWeight: FontWeight.bold,
              //       color: kTitleTextColor,
              //       fontSize: 21,
              //     ),
              //   ),
              // ),
              // const SizedBox(
              //   height: 20,
              // ),
              // buildAppointmentList(),
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

  List<dynamic> patients = [];
  void fetchPatients() async {
    const url = 'https://latest-server.onrender.com/api/user/get-all-verified-patients';
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


  buildPatients() {
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
                  final patientGender = "Female";
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
