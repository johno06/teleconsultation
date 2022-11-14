import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class calculator extends StatefulWidget {
  const calculator({Key? key}) : super(key: key);

  @override
  State<calculator> createState() => _calculatorState();
}

class _calculatorState extends State<calculator> {
  String birthDate = "";
  String age = "";
  String weeksCount = "";
  TextStyle valueTextStyle=TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 20,
  );
  TextStyle textTextStyle=TextStyle(

    fontSize: 16,
  );
  TextStyle buttonTextStyle=TextStyle(
    color: Colors.white,
    fontSize: 16,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Age Calculator"),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // (age > -1)
                 Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.elliptical(12, 12)),
                      border: Border.all(color: Colors.grey)
                  ),
                  padding: EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("LMP: ",style: textTextStyle,),
                      Text("$birthDate",style: valueTextStyle,)
                    ],
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Container(
                  padding: EdgeInsets.all(16),

                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.elliptical
                        (12, 12)),
                      border: Border.all(color: Colors.grey)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[Text("Weeks: ",style: textTextStyle,), Text("$weeksCount",style: valueTextStyle,)],
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Container(
                  padding: EdgeInsets.all(16),

                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.elliptical
                        (12, 12)),
                      border: Border.all(color: Colors.grey)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[Text("EDD: ",style: textTextStyle,), Text("$age",style: valueTextStyle,)],
                  ),
                )
              ],
            )
            ,Text("Press button to see age"),
            SizedBox(
              height: 32,
            ),
            ElevatedButton(
              // color: Colors.blue,
              // splashColor: Colors.blue.shade300,
              onPressed: () async {
                DateTime birthDate = await selectDate(context, DateTime.now(),
                    lastDate: DateTime.now());
                final df = new DateFormat('yyyy-MM-dd');
                this.birthDate = df.format(birthDate);
                this.age = calculateAge(birthDate);

                setState(() {});
              },
              child: Container(
                  padding: EdgeInsets.all(16),
                  child: Text("Select birthdate".toUpperCase(),style: buttonTextStyle,)),
            )
          ],
        ),
      ),
    );
  }

  calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    final df = new DateFormat('yyyy-MM-dd');
    DateTime calweeks = DateTime(birthDate.year, birthDate.month, birthDate.day);

    final diff = currentDate.difference(calweeks).inDays;
    int weeks = 0;
    int daysCount = 0;
    int tilSeven = 0;
    while(daysCount < diff){
      tilSeven++;
      daysCount++;
      if(tilSeven == 7){
        weeks++;
        tilSeven =0;
      }
    }
    if(tilSeven == 1 && tilSeven == 0) {
      weeksCount = "$weeks week and $tilSeven day";
    }else{
      weeksCount = "$weeks week and $tilSeven days";
    }
    int month4 = birthDate.month -2;
    int month3 = birthDate.month -3;
    int year = birthDate.year +1;
    if(month3 == -1){
      year = birthDate.year;
      month3 = 11;
    }else if(month3 == -2){
      year = birthDate.year;
      month3 = 10;
    }else if(month3 == -2){
      year = birthDate.year;
      month3 = 9;
    }else if(month3 == -3){
      year = birthDate.year;
      month3 = 8;
    }else if(month3 == -4){
      year = birthDate.year;
      month3 = 7;
    }else if(month3 == -5){
      year = birthDate.year;
      month3 = 6;
    }else if(month3 == -6){
      year = birthDate.year;
      month3 = 5;
    }else if(month3 == -7){
      year = birthDate.year;
      month3 = 4;
    }else if(month3 == -8){
      year = birthDate.year;
      month3 = 3;
    }else if(month3 == -9){
      year = birthDate.year;
      month3 = 2;
    }else if(month3 == -10){
      year = birthDate.year;
      month3 = 1;
    }else if(month3 == -11){
      year = birthDate.year;
      month3 = 0;
    }
    print("$month4 $month3");
    int day = birthDate.day;
    int day1 = 1;
    int week = 0;
    int days = 0;
    var date = new DateTime(year, month3, 0);
    for(int i = 0; i<7; i++){
        if(day < date.day) {
          day ++;
          days++;
        }else{
          day = day1;
          day1++;
          days++;
        }
    }
    print(days);
    for(int i = 0; i<7; i++){

    }
    // print("Last Date: ${date.day}");
    String edd = "$year-$month3-$day";
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return edd;
  }

  selectDate(BuildContext context, DateTime initialDateTime,
      {required DateTime lastDate}) async {
    Completer completer = Completer();
    String _selectedDateInString;
      showDatePicker(
          context: context,
          initialDate: initialDateTime,
          firstDate: DateTime(1970),
          lastDate: lastDate == null
              ? DateTime(initialDateTime.year + 10)
              : lastDate)
          .then((temp) {
        if (temp == null) return null;
        completer.complete(temp);
        setState(() {});
      });
    return completer.future;
  }
}
