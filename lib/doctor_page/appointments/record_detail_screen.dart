

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:teleconsultation/doctor_page/drawer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';

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
class RecordDetailScreen extends StatefulWidget {
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
  dynamic title, weeks, deliveryDate, bookingTime, bookingToday, bookingDay, date, bookingMonth, fullName, about;

  RecordDetailScreen(this.title, this.weeks, this.deliveryDate,
      this.bookingTime, this.bookingToday, this.bookingDay, this.date, this.bookingMonth, this.fullName, this.about,
      {Key? key}) : super(key: key);


  @override
  State<RecordDetailScreen> createState() => _RecordDetailScreenState();
}

class _RecordDetailScreenState extends State<RecordDetailScreen> {
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
                        "${widget.fullName}",
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
                  "Chief of Complaint:",
                  style: subTitleTextStyle,
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.label,
                      color: primaryColor500,
                    ),
                    const SizedBox(
                      width: 16.0,
                    ),
                    Flexible(
                      child: Text(
                        "${widget.title}",
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
                      Icons.label,
                      color: primaryColor500,
                    ),
                    const SizedBox(
                      width: 16.0,
                    ),
                    Flexible(
                      child: Text(
                        "Diagnosis: ${widget.about}",
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
                      "${widget.date} ( ${widget.bookingMonth} ${widget.bookingDay} ${widget.bookingToday})",
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
                      "${widget.bookingTime}",
                      style: descTextStyle,
                    ),
                  ],
                ),
                const SizedBox(height: 20,),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "EDD and Age of Gestation: (for pregnant)",
                        style: subTitleTextStyle,
                      ),
                    ],
                  ),
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
                      "${widget.deliveryDate}",
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
                      Icons.date_range_rounded,
                      color: primaryColor500,
                    ),
                    const SizedBox(
                      width: 16.0,
                    ),
                    Text(
                      "${widget.weeks}",
                      style: descTextStyle,
                    ),
                  ],
                ),
              ]),
            ),
          )
        ],
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
              "Appointment Record",
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
}


class RecordDetailScreen1 extends StatelessWidget {
  dynamic title, weeks, deliveryDate, bookingTime, bookingToday, bookingDay, date, bookingMonth, fullName, about;

  RecordDetailScreen1(this.title, this.weeks, this.deliveryDate,
      this.bookingTime, this.bookingToday, this.bookingDay, this.date, this.bookingMonth, this.fullName, this.about,
      {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery
    //     .of(context)
    //     .size;
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
                        "$fullName",
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
                  "Chief of Complain:",
                  style: subTitleTextStyle,
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.label,
                      color: primaryColor500,
                    ),
                    const SizedBox(
                      width: 16.0,
                    ),
                    Flexible(
                      child: Text(
                        "$title",
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
                      Icons.label,
                      color: primaryColor500,
                    ),
                    const SizedBox(
                      width: 16.0,
                    ),
                    Flexible(
                      child: Text(
                        "Diagnosis: $about",
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
                      "$date",
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
                      "$bookingTime",
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
        // child: Row(
        //   children: [
        //     Expanded(
        //       child: ElevatedButton(
        //           style: ElevatedButton.styleFrom(
        //               minimumSize: const Size(100, 45),
        //               shape: RoundedRectangleBorder(
        //                   borderRadius: BorderRadius.circular(
        //                       borderRadiusSize)),
        //               backgroundColor: Colors.redAccent
        //           ),
        //           onPressed: () {
        //             update = "rejected";
        //             if(update == "rejected"){
        //               updateAppointment(context, widget.appointmentId);
        //               print("this is the $deviceId");
        //               sendPushMessage('Dr: Marilyn Fuentes rejected your appointment Date:${widget.bookingDate}(${widget.bookingToday}) Time: ${widget.time}', 'Teleconsultation', '${widget.patientDevice}');
        //             }
        //
        //             // print(update);
        //           },
        //           child: const Text("Reject")),
        //     ),
        //     SizedBox(width: size.width * 0.025),
        //     Expanded(
        //       child: ElevatedButton(
        //           style: ElevatedButton.styleFrom(
        //               minimumSize: const Size(100, 45),
        //               shape: RoundedRectangleBorder(
        //                   borderRadius: BorderRadius.circular(
        //                       borderRadiusSize))),
        //           onPressed: () {
        //             update = "approved";
        //             if(update == "approved"){
        //               updateAppointment(context, widget.appointmentId);
        //               sendPushMessage('Dr: Marilyn Fuentes approved your appointment Date:${widget.bookingDate}(${widget.bookingToday}) Time: ${widget.time}', 'Teleconsultation', '${widget.patientDevice}');
        //             }
        //             // print(update);
        //           },
        //           child: const Text("Accept")),
        //     ),
        //   ],
        // ),
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
              "Appointment Record",
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
}