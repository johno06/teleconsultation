import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constant.dart';
import '../components/doctor_card.dart';
import '../components/search_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);


  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

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
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SvgPicture.asset('assets/icons/profile.svg'),
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  'Hello $fName',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                    color: kTitleTextColor,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: SearchBar(),
              ),
              const SizedBox(
                height: 20,
              ),
             // Padding(
             //   padding: const EdgeInsets.symmetric(horizontal: 30),
             //   child: Text(
             //     'Categories',
             //     style: TextStyle(
             //       fontWeight: FontWeight.bold,
             //       color: kTitleTextColor,
             //       fontSize: 18,
             //     ),
             //   ),
             // ),
             const SizedBox(
               height: 20,
             ),
             // buildCategoryList(),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  'Doctors List',
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
              buildDoctorList(),
            ],
          ),
        ),
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
 //         CategoryCard(
 //           'Dental\nSurgeon',
 //           'assets/icons/dental_surgeon.png',
 //           kBlueColor,
 //         ),
 //         const SizedBox(
 //           width: 10,
 //         ),
 //         CategoryCard(
 //           'Heart\nSurgeon',
 //           'assets/icons/heart_surgeon.png',
 //           kYellowColor,
 //         ),
 //         const SizedBox(
 //           width: 10,
 //         ),
 //         CategoryCard(
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

  buildDoctorList() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 30,
      ),
      child: Column(
        children: <Widget>[
          DoctorCard(
            'Dr. Jam Raon',
            'Age: 33',
            'Email: jam@gmail.com',
            'assets/images/doctor1.png',
            kBlueColor,
          ),
          const SizedBox(
            height: 20,
          ),
          DoctorCard(
            'Dr. Oliver Ruiz',
            'Age: 27',
            'Email: Oliver@gmail.com',
            'assets/images/doctor2.png',
            kYellowColor,
          ),
          const SizedBox(
            height: 20,
          ),
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
}
