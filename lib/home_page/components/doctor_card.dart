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


  DoctorCard(this._name, this._pemail, this._description, this._imageUrl, this._bgColor, {
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
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: _bgColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: ListTile(
            leading: Image.asset(_imageUrl),
            title: Text(
              _name,
              style: TextStyle(
                color: kTitleTextColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              _pemail+""
                  "  "+""
                  ""+_description,
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

