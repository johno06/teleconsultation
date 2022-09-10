import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constant.dart';
import '../components/doctor_card.dart';
import '../components/schedule_card.dart';

class MyAppointment extends StatefulWidget {
  const MyAppointment({Key? key}) : super(key: key);


  @override
  _MyAppointmentState createState() => _MyAppointmentState();
}

class _MyAppointmentState extends State<MyAppointment> {

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
                  'Doctor',
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
          DoctorCard(
            'Dr. Micaella Garcia',
            'Age: 32',
            'Email: mica@gmail.com',
            'assets/images/doctor3.png',
            kOrangeColor,
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
          ScheduleCard(
            'Consultation',
            'Sunday . 9am - 11am',
            '12',
            'Jan',
            kBlueColor,
          ),
          const SizedBox(
            height: 10,
          ),
          ScheduleCard(
            'Consultation',
            'Sunday . 9am - 11am',
            '13',
            'Jan',
            kYellowColor,
          ),
          const SizedBox(
            height: 10,
          ),
          ScheduleCard(
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
