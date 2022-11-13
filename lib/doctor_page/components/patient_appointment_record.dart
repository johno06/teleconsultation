import 'package:flutter/material.dart';
import 'package:teleconsultation/doctor_page/appointments/record_detail_screen.dart';

import '../../constant.dart';
import '../appointments/pending_appointment_detail_screen.dart';
//ignore: must_be_immutable

class PatientAppointmentRecord extends StatelessWidget {
  dynamic _bgColor;
  dynamic bookingDay, bookingMonth, appointmentId, about;

  dynamic title, weeks, deliveryDate, bookingToday, bookingTime, date, fullName;

  PatientAppointmentRecord(this.title, this.weeks, this.deliveryDate, this.bookingToday, this.bookingTime, this.date,
      this.bookingDay, this.bookingMonth, this.about, this.fullName, this._bgColor, {Key? key}) : super(key: key);

//   @override
//   State<PatientScheduleCard> createState() => _PatientScheduleCardState();
// }

// class _PatientScheduleCardState extends State<PatientScheduleCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
            RecordDetailScreen(title, weeks, deliveryDate, bookingTime, bookingToday, bookingDay, date, bookingMonth, fullName, about),
          ),
        );
      },
      child: Container(
        // height: 190,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: _bgColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: _bgColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '$bookingDay',
                      style: TextStyle(
                        color: _bgColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '$bookingMonth',
                      style: TextStyle(
                        color: _bgColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              title: Text(
                '$title',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: kTitleTextColor,
                ),
              ),
              subtitle: Text(
                'Diagnosis: $about\n$bookingToday . $bookingTime\nAOG: $weeks\nEDD: $deliveryDate',
                style: TextStyle(
                  color: kTitleTextColor.withOpacity(0.7),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
