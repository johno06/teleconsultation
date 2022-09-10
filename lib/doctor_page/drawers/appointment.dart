import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constant.dart';
import '../components/doctor_card.dart';
import '../components/schedule_card.dart';


class DoctorMyAppointment extends StatefulWidget {
  const DoctorMyAppointment({Key? key}) : super(key: key);


  @override
  _DoctorMyAppointmentState createState() => _DoctorMyAppointmentState();
}

class _DoctorMyAppointmentState extends State<DoctorMyAppointment> {

  // ProfileModel model = ProfileModel();


  late SharedPreferences loginData;
  String? email, fName, lastName, contactNumber;


  @override
  void initState(){
    super.initState();
    initial();
  }

  void initial() async{
    loginData = await SharedPreferences.getInstance();
    setState(() {
      email = loginData.getString('email')!;
      fName = loginData.getString('fName')!;
      lastName = loginData.getString('lName')!;
      contactNumber = loginData.getString('contactNo')!;
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
                  'Patient',
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
              buildDoctor(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
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
          DoctorDoctorCard(
            'Jam Raon',
            'Age: 33',
            'Email: jam@gmail.com',
            'assets/images/profile.png',
            kBlueColor,
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
          DoctorScheduleCard(
            'Consultation',
            'Sunday . 9am - 11am',
            '12',
            'Jan',
            kBlueColor,
          ),
          const SizedBox(
            height: 10,
          ),
          DoctorScheduleCard(
            'Consultation',
            'Sunday . 9am - 11am',
            '13',
            'Jan',
            kYellowColor,
          ),
          const SizedBox(
            height: 10,
          ),
          DoctorScheduleCard(
            'Consultation',
            'Sunday . 9am - 11am',
            '14',
            'Jan',
            kOrangeColor,
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
