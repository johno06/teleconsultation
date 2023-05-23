import 'dart:async';
import 'dart:convert';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teleconsultation/components/background1.dart';
import '../../../../constant.dart';
import './call.dart';

class IndexPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => IndexState();
}

class IndexState extends State<IndexPage> {
  SharedPreferences? videocallToken;
  SharedPreferences? doctorData;
  /// create a channelController to retrieve text value
  final _channelController = TextEditingController();
  final _createChannelController = TextEditingController();

  String? doctorId;

  /// if channel textField is validated to have error
  bool _validateError = false;
  bool _validateError1 = false;

  ClientRole _role = ClientRole.Broadcaster;

  @override
  void dispose() {
    // dispose input controller
    _channelController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initial();
  }

  void initial() async{
    doctorData = await SharedPreferences.getInstance();
    setState(() {
      doctorId = doctorData?.getString('docUserId')!;
      print(doctorId);
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      fetchDoctor();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffF8AFA6),
        title: Text('Video Call'),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.redAccent,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Background1(
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            height: 400,
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: _channelController,
                        decoration: InputDecoration(
                          errorText:
                              _validateError ? 'Channel name is mandatory' : null,
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(width: 1),
                          ),
                          hintText: 'Channel name',
                        ),
                      ),
                    )
                  ],
                ),
                Column(
                  children: [
                    // ListTile(
                    //   title: Text(ClientRole.Broadcaster.toString()),
                    //   leading: Radio(
                    //     value: ClientRole.Broadcaster,
                    //     groupValue: _role,
                    //     onChanged: (ClientRole? value) {
                    //       setState(() {
                    //         _role = value!;
                    //       });
                    //     },
                    //   ),
                    // ),
                    // ListTile(
                    //   title: Text(ClientRole.Audience.toString()),
                    //   leading: Radio(
                    //     value: ClientRole.Audience,
                    //     groupValue: _role,
                    //     onChanged: (ClientRole? value) {
                    //       setState(() {
                    //         _role = value!;
                    //       });
                    //     },
                    //   ),
                    // )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: ElevatedButton(
                          onPressed: onJoin,
                          child: Text('Join'),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: shrinePink400,
                              padding: const EdgeInsets.symmetric(horizontal: 50),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20))),
                        ),
                      ),
                      // Expanded(
                      //   child: RaisedButton(
                      //     onPressed: onJoin,
                      //     child: Text('Join'),
                      //     color: Colors.blueAccent,
                      //     textColor: Colors.white,
                      //   ),
                      // )
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                // Text("---------------------------------------"),
                // SizedBox(height: 10,),
                // Row(
                //   children: <Widget>[
                //     Expanded(
                //       child: TextField(
                //         controller: _createChannelController,
                //         decoration: InputDecoration(
                //           errorText:
                //           _validateError1 ? 'Channel name is mandatory' : null,
                //           border: UnderlineInputBorder(
                //             borderSide: BorderSide(width: 1),
                //           ),
                //           hintText: 'Create Channel Name',
                //         ),
                //       ),
                //     )
                //   ],
                // ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(vertical: 20),
                //   child: Row(
                //     children: <Widget>[
                //       Expanded(
                //         child: ElevatedButton(
                //           onPressed: (){
                //             // print(_createChannelController.text);
                //             onCreate(_createChannelController.text);
                //           },
                //           child: Text('Create Channel'),
                //           style: ButtonStyle(
                //               backgroundColor:
                //               MaterialStateProperty.all(Colors.blueAccent),
                //               foregroundColor:
                //               MaterialStateProperty.all(Colors.white)),
                //         ),
                //       ),
                //       // Expanded(
                //       //   child: RaisedButton(
                //       //     onPressed: onJoin,
                //       //     child: Text('Join'),
                //       //     color: Colors.blueAccent,
                //       //     textColor: Colors.white,
                //       //   ),
                //       // )
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String token = "";
  void fetchDoctor() async {
    String url = 'https://latest-server.onrender.com/api/user/getByIdPatient/$doctorId';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);

    doctorData = await SharedPreferences.getInstance();
    videocallToken = await SharedPreferences.getInstance();

    // print(json['data']);
    setState(() {
     token = json['rtcToken'];
     print(token);
    });
    videocallToken?.setString('rtcToken', token);
    print('fetchclients completed');
  }

  Future<void> onJoin() async {
    // update input validation
    setState(() {
      _channelController.text.isEmpty
          ? _validateError = true
          : _validateError = false;
    });
    if (_channelController.text.isNotEmpty) {
      // await for camera and mic permissions before pushing video page
      await _handleCameraAndMic(Permission.camera);
      await _handleCameraAndMic(Permission.microphone);
      // push video page with given channel name
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallPage(
            channelName: _channelController.text,
            role: _role,
          ),
        ),
      );
    }
  }


  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    print(status);
  }
}
