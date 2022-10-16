import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:teleconsultation/doctor_page/drawer.dart';

import '../../constant.dart';

// class PendingDetailScreen extends StatefulWidget {
//   dynamic patientName, patientSurname, patientPhone, patientEmail, bookingToday, time, bookingDate;
//   dynamic _description;
//   dynamic _imageUrl;
//   dynamic _pemail;
//
//
//   PendingDetailScreen(this.patientName, this.patientSurname, this.patientPhone, this.patientEmail, this.bookingToday, this.time, this.bookingDate, {Key? key}) : super(key: key);
//
// //  static const routeName = "/profile";
//
//   @override
//   _PendingDetailScreenState createState() => _PendingDetailScreenState();
// }

// class _PendingDetailScreenState extends State<PendingDetailScreen> {
class ApprovedDetailScreen extends StatelessWidget {
//   String? patientEmail, patientName, patientSurname, patientPhone, date, bookingDay, time;

  // SharedPreferences? patientData;
  //
  // @override
  // void initState(){
  //   super.initState();
  //   initial();
  // }
  //
  // void initial() async{
  //   patientData = await SharedPreferences.getInstance();
  //   setState(() {
  // patientEmail = patientData?.getString('patientEmail')!;
  // patientName = patientData?.getString('patientName')!;
  // patientSurname = patientData?.getString('patientSurname')!;
  // patientPhone = patientData?.getString('patientPhone')!;
  // date = patientData?.getString('bookingDate')!;
  // bookingDay = patientData?.getString('bookingDay')!;
  // time = patientData?.getString('bookingTime')!;
  //   });
  // }
  dynamic patientName, patientSurname, patientPhone, patientEmail, bookingToday,
      time, bookingDate, appointmentId;

  ApprovedDetailScreen(this.patientName, this.patientSurname, this.patientPhone,
      this.patientEmail, this.bookingToday, this.time, this.bookingDate, this.appointmentId,
      {Key? key}) : super(key: key);

  String update = "";

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          customSliverAppBar(context),
          SliverPadding(
            padding:
            const EdgeInsets.only(right: 24, left: 24, bottom: 24, top: 8),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(
                  height: 16,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.account_circle_rounded,
                      color: primaryColor500,
                    ),
                    const SizedBox(
                      width: 16.0,
                    ),
                    Flexible(
                      child: Text(
                        "$patientName $patientSurname",
                        overflow: TextOverflow.visible,
                        style: addressTextStyle,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 32,
                ),
                Text(
                  "Contact:",
                  style: subTitleTextStyle,
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.phone,
                      color: primaryColor500,
                    ),
                    const SizedBox(
                      width: 16.0,
                    ),
                    Flexible(
                      child: Text(
                        "$patientPhone",
                        overflow: TextOverflow.visible,
                        style: addressTextStyle,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.email,
                      color: primaryColor500,
                    ),
                    const SizedBox(
                      width: 16.0,
                    ),
                    Flexible(
                      child: Text(
                        "$patientEmail",
                        overflow: TextOverflow.visible,
                        style: addressTextStyle,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 32,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Date and Time:",
                      style: subTitleTextStyle,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 4,
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.date_range_rounded,
                      color: primaryColor500,
                    ),
                    const SizedBox(
                      width: 16.0,
                    ),
                    Text(
                      "$bookingDate ($bookingToday)",
                      style: descTextStyle,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time_rounded,
                      color: primaryColor500,
                    ),
                    const SizedBox(
                      width: 16.0,
                    ),
                    Text(
                      "$time",
                      style: descTextStyle,
                    ),
                  ],
                ),
              ]),
            ),
          )
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
            color: lightBlue300,
            offset: Offset(0, 0),
            blurRadius: 10,
          ),
        ]),
        child: Row(
          children: [
            // Expanded(
            //   child: ElevatedButton(
            //       style: ElevatedButton.styleFrom(
            //           minimumSize: const Size(100, 45),
            //           shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadius.circular(
            //                   borderRadiusSize)),
            //           backgroundColor: Colors.redAccent
            //       ),
            //       onPressed: () {
            //         update = "rejected";
            //         if(update == "rejected"){
            //           updateAppointment(context, appointmentId);
            //         }
            //
            //         // print(update);
            //       },
            //       child: const Text("Reject")),
            // ),
            SizedBox(width: size.width * 0.025),
            Expanded(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(100, 45),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              borderRadiusSize)),
                      backgroundColor: Colors.green
                  ),
                  onPressed: () {
                    update = "completed";
                    if(update == "completed"){
                      updateAppointment(context, appointmentId);

                    }
                    // print(update);
                  },
                  child: const Text("COMPLETE")),
            ),
          ],
        ),
      ),
    );
  }

  Widget customSliverAppBar(context) {
    return SliverAppBar(
      shadowColor: primaryColor500.withOpacity(.2),
      backgroundColor: colorWhite,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        expandedTitleScale: 1,
        titlePadding: EdgeInsets.zero,
        title: Container(
          width: MediaQuery
              .of(context)
              .size
              .width,
          height: kToolbarHeight,
          decoration: const BoxDecoration(
              color: colorWhite,
              borderRadius: BorderRadius.vertical(
                  top: Radius.circular(borderRadiusSize))),
          child: Center(
            child: Text(
              "Appointment Details",
              style: titleTextStyle,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        // background: Image.asset(
        //   field.imageAsset,
        //   fit: BoxFit.cover,
        // ),
        collapseMode: CollapseMode.parallax,
      ),
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: const BoxDecoration(
            color: colorWhite,
            shape: BoxShape.circle,
          ),
          child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              iconSize: 26,
              icon: const Icon(
                Icons.arrow_back,
                color: darkBlue500,
              )),
        ),
      ),
      // expandedHeight: 300,
    );
  }


  Future updateAppointment(BuildContext context, id) async {
    Map data = {
      "status": update,
    };
    String body = json.encode(data);
    http.Response response = await http.patch(
      Uri.parse(
          'https://newserverobgyn.herokuapp.com/api/user/updateAppointments/$id'),
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    // print(response.body);
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: "Appointment Updated Successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  const DoctorPage()));
    } else {
      return (
          Fluttertoast.showToast(
              msg: "Appointment Updated Failed",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.redAccent,
              textColor: Colors.white,
              fontSize: 16.0));
    }
  }

}