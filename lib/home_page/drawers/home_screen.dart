import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teleconsultation/starting_page/login.dart';
import '../../constant.dart';
import '../components/doctor_card.dart';
import '../components/schedule_card.dart';
import '../components/search_bar.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);


  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {



  // ProfileModel model = ProfileModel();


  late SharedPreferences loginData;
  SharedPreferences? doctorData;
  SharedPreferences? appointmentData;
  String? email, name, surname, phone, user_id;
  final todayFormat = DateFormat("EEEE");
  final monthFormat = DateFormat("MMM");
  final dayFormat = DateFormat("d");
  final timeFormat = DateFormat("hh:mm aaa");

  @override
  void initState() {
    super.initState();
    initial();
  }

  void initial() async {
    loginData = await SharedPreferences.getInstance();
    setState(() {
      email = loginData.getString('email')!;
      name = loginData.getString('name')!;
      surname = loginData.getString('surname')!;
      phone = loginData.getString('phone')!;
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
      body: Column(
        children: [
          header(context),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  ),
                ),
                Container(
                  padding:
                  const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0),
                  child: Text(
                    "Book Appointment and \nBe Healty!",
                    style: greetingTextStyle,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    'Doctors',
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
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    'Appointments',
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
                buildAppointmentList(),
              ],
            ),
          ),
        ],
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

  List<dynamic> clients = [];

  void fetchClients() async {
    const url = 'https://newserverobgyn.herokuapp.com/api/user/get-all-approved-doctors';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);


    // clientData = await SharedPreferences.getInstance();

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


  buildDoctorList() {
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

  Widget header(context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: SafeArea(
        // SEARCH Icon
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(
                  width: 55,
                  height: 55,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage(
                          "assets/images/user_profile_example.png"),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome back,",
                      style: descTextStyle,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      "$name $surname",
                      style: subTitleTextStyle,
                    ),
                  ],
                ),
              ],
            ),
            // Container(
            //   decoration: BoxDecoration(
            //       color: primaryColor500,
            //       borderRadius: BorderRadius.circular(borderRadiusSize)),
            //   child: IconButton(
            //     onPressed: () {
            //       // Navigator.push(context, MaterialPageRoute(builder: (context) {
            //       //   return SearchScreen(
            //       //     selectedDropdownItem: "",
            //       //   );
            //       // }));
            //     },
            //     icon: const Icon(Icons.search, color: colorWhite),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
