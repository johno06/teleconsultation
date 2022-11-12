// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:teleconsultation/model/sport_field.dart';

import '../constant.dart';
import 'checkout_screen.dart';
import 'components/schedule_card.dart';

class DetailScreen extends StatelessWidget {
  dynamic _name;
  dynamic _description;
  dynamic _imageUrl;
  dynamic _pemail;


  DetailScreen(this._name, this._pemail, this._description, this._imageUrl, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/picture.png'),
              alignment: Alignment.topCenter,
              fit: BoxFit.fitWidth,
            ),
          ),
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: SvgPicture.asset(
                        'assets/icons/back.svg',
                        height: 18,
                      ),
                    ),
                    SvgPicture.asset(
                      'assets/icons/3dots.svg',
                      height: 18,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.24,
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: kBackgroundColor,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(50),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Image.asset(
                            _imageUrl,
                            height: 120,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                _name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: kTitleTextColor,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                _description,
                                style: TextStyle(
                                  color: kTitleTextColor.withOpacity(0.7),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                _pemail,
                                style: TextStyle(
                                  color: kTitleTextColor.withOpacity(0.7),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: <Widget>[
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: kBlueColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: SvgPicture.asset(
                                      'assets/icons/phone.svg',
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: kYellowColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: SvgPicture.asset(
                                      'assets/icons/chat.svg',
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: kOrangeColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: SvgPicture.asset(
                                      'assets/icons/video.svg',
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Text(
                        'About Doctor'
                            ''
                            '',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: kTitleTextColor,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Dr. Nery V. Fuentes is the top most heart surgeon in Flower\nHospital. She has done over 100 successful sugeries\nwithin past 3 years. She has achieved several\nawards for her wonderful contribution in her own\nfield. She’s available for private consultation for\ngiven schedules.',
                        style: TextStyle(
                          height: 1.6,
                          color: kTitleTextColor.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      // Text(
                      //   'Appointment Record',
                      //   style: TextStyle(
                      //     fontWeight: FontWeight.bold,
                      //     fontSize: 18,
                      //     color: kTitleTextColor,
                      //   ),
                      // ),
                      // Text(
                      //   'Upcoming Schedules',
                      //   style: TextStyle(
                      //     fontWeight: FontWeight.bold,
                      //     fontSize: 18,
                      //     color: kTitleTextColor,
                      //   ),
                      // ),
                      // const SizedBox(
                      //   height: 20,
                      // ),
                      // ScheduleCard(
                      //   'Consultation',
                      //   'Sunday . 9am - 11am',
                      //   '12',
                      //   'Jan',
                      //   kBlueColor,
                      // ),
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      // ScheduleCard(
                      //   'Consultation',
                      //   'Sunday . 9am - 11am',
                      //   '13',
                      //   'Jan',
                      //   kYellowColor,
                      // ),
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      // ScheduleCard(
                      //   'Consultation',
                      //   'Sunday . 9am - 11am',
                      //   '14',
                      //   'Jan',
                      //   kOrangeColor,
                      // ),
                      // const SizedBox(
                      //   height: 20,
                      // ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
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
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                minimumSize: const Size(100, 45),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(borderRadiusSize))),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return CheckoutScreen(
                );
              }));

            },
            child: const Text("Book Now")),
      ),
    );
  }
}
