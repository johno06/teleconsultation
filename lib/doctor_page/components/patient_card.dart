// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import '../../constant.dart';
import '../patient_detail_screen.dart';

class PatientCard extends StatelessWidget {
  dynamic _imageUrl;
  dynamic _bgColor;

  dynamic patientFullName, patientSurname, patientPhone, patientEmail, patientGender, patientBirthdate, patientAddress, patientId;

  PatientCard(this.patientFullName, this.patientPhone,
      this.patientEmail, this.patientBirthdate, this.patientGender, this.patientAddress, this.patientId, this._imageUrl, this._bgColor, {
    Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PatientDetailScreen(patientFullName, patientEmail, patientPhone, patientId, _imageUrl),
          ),
        );
      },
      child: Container(
        height: 190,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: _bgColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: ListTile(
              leading: Image.asset(
                _imageUrl,
                height: 150,
              ),
              title: Text(
                "$patientFullName",
                style: TextStyle(
                  fontSize: 19,
                  color: kTitleTextColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                "Contact: $patientPhone \nEmail: $patientEmail \nBirthdate:  $patientBirthdate \nGender: $patientGender \nAddress: $patientAddress",
                style: TextStyle(
                  fontSize: 16,
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

