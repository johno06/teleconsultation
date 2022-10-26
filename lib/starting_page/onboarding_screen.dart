import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
// import 'package:shared_preferences/shared_preferences.dart';

import '../constant.dart';
import 'login.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {

  String? mtoken = " ";

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        mtoken = token;
        print(mtoken);
      });
    });
  }

  // final StreamChatClient client;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                'assets/images/onboarding_illustration.png',
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.fitWidth,
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height / 6,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
//                      '$email',
                      'Choose The Doctor\nYou Want',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                        color: kTitleTextColor,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Start your consultation now',
                      style: TextStyle(
                        fontSize: 16,
                        color: kTitleTextColor.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0)),
                          // textColor: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        getToken();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        );
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 50.0,
                        width: size.width * 0.35,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(80.0),
                            gradient:  const LinearGradient(
                                colors: [
//                              Color.fromARGB(255, 255, 136, 34),
//                              Color.fromARGB(255, 255, 177, 41)
//                              Color(0xFFff0066),
//                              Color(0xFFff99cc)
                                  Color(0xffEF716B),
                                  Color(0xffff9999),
                                ]
                            )
                        ),
                        padding: const EdgeInsets.all(0),
                        child: const Text(
                          "GET STARTED",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
//                     MaterialButton(
//                       onPressed: () {
// //                        loginData.setBool("login", true);
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => const OnboardingScreen(),
//                           ),
//                         );
//                       },
//                       color: const Color(0xffF8AFA6),
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 30,
//                       ),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: Text(
//                         'Login as Doctor',
//                         style: TextStyle(
//                           color: kWhiteColor,
//                           fontSize: 16,
//                         ),
//                       ),
//                     ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
