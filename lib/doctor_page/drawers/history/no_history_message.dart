import 'package:flutter/material.dart';
import 'package:teleconsultation/home_page/drawer.dart';
import 'package:teleconsultation/home_page/drawers/appointment.dart';
import 'package:teleconsultation/home_page/drawers/home_screen.dart';

import '../../../constant.dart';

class NoTranscationMessage extends StatelessWidget {
  String messageTitle;
  String messageDesc;

  NoTranscationMessage({required this.messageTitle, required this.messageDesc});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16,),
            Image.asset(
              "assets/images/no_history.png",
              width: 150,
            ),
            const SizedBox(height: 8,),
            Text(
              messageTitle,
              style: titleTextStyle.copyWith(color: darkBlue300),
            ),
            const SizedBox(
              height: 8.0,
            ),
            Text(
              messageDesc,
              style: descTextStyle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 32.0,
            ),
            // TextButton.icon(
            //     onPressed: () {
            //       // Navigator.pop(
            //       //     context, MaterialPageRoute(builder: (context) => const Hi()));
            //     },
            //     icon: const Icon(Icons.search),
            //     label: Text(
            //       "Book Appointment",
            //       style: buttonTextStyle.copyWith(color: primaryColor500),
            //     ))
          ],
        ),
      ),
    );
  }
}
