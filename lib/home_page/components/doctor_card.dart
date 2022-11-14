// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import '../../constant.dart';
import '../detail_screen.dart';

class DoctorCard extends StatelessWidget {
  dynamic _name;
  dynamic _description;
  dynamic _imageUrl;
  dynamic _bgColor;
  dynamic _pemail;
  dynamic _timings;
  dynamic _exp;

  DoctorCard(this._name, this._pemail, this._description, this._timings, this._exp, this._imageUrl, this._bgColor, {
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(_name, _pemail, _description, _imageUrl),
          ),
        );
      },
      child: Container(
        height: 150,
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
                _name,
                style: TextStyle(
                  fontSize: 19,
                  color: kTitleTextColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                _pemail+"\n"+_description+"\n"+_timings+"\n"+_exp,
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

