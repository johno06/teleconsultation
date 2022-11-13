import 'package:flutter/material.dart';

import '../../constant.dart';
import '../appointments/pending_appointment_detail_screen.dart';
//ignore: must_be_immutable

class PatientScheduleCard extends StatelessWidget {
  dynamic _bgColor;
  dynamic bookingDay, bookingMonth, appointmentId;

  dynamic patientName, patientSurname, patientPhone, patientEmail, bookingToday, bookingTime, date, patientDevice, consultationType;

  PatientScheduleCard(this.patientName, this.patientSurname, this.patientPhone, this.patientEmail, this.bookingToday, this.bookingTime, this.date,
      this.bookingDay, this.bookingMonth, this.patientDevice,this.appointmentId, this.consultationType, this._bgColor, {Key? key}) : super(key: key);

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
              PendingDetailScreen(patientName, patientSurname, patientPhone, patientEmail, bookingToday, bookingTime, date, appointmentId, consultationType, patientDevice),
          ),
        );
      },
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
              'consultation',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: kTitleTextColor,
              ),
            ),
            subtitle: Text(
              'Pending: $patientName $patientSurname\nConsultation Type: $consultationType \n$bookingToday . $bookingTime',
              style: TextStyle(
                color: kTitleTextColor.withOpacity(0.7),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
