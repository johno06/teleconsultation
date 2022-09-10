import 'package:flutter/material.dart';

import '../../constant.dart';
//ignore: must_be_immutable
class DoctorScheduleCard extends StatefulWidget {
  dynamic _title;
  dynamic _description;
  dynamic _date;
  dynamic _month;
  dynamic _bgColor;

  DoctorScheduleCard(this._title, this._description, this._date, this._month, this._bgColor, {Key? key}) : super(key: key);

  @override
  State<DoctorScheduleCard> createState() => _DoctorScheduleCardState();
}

class _DoctorScheduleCardState extends State<DoctorScheduleCard> {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: widget._bgColor.withOpacity(0.1),
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
              color: widget._bgColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  widget._date,
                  style: TextStyle(
                    color: widget._bgColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget._month,
                  style: TextStyle(
                    color: widget._bgColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          title: Text(
            widget._title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: kTitleTextColor,
            ),
          ),
          subtitle: Text(
            widget._description,
            style: TextStyle(
              color: kTitleTextColor.withOpacity(0.7),
            ),
          ),
        ),
      ),
    );
  }
}
