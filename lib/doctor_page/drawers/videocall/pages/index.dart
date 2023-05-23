import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teleconsultation/components/background.dart';
import 'package:teleconsultation/components/background1.dart';
import '../../../../constant.dart';
import './call.dart';

class IndexPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => IndexState();
}

class IndexState extends State<IndexPage> {
  late SharedPreferences loginData;
  String? doctorId;
  SharedPreferences? videocallToken;
  /// create a channelController to retrieve text value
  final _channelController = TextEditingController();
  final _createChannelController = TextEditingController();

  /// if channel textField is validated to have error
  bool _validateError = false;
  bool _validateError1 = false;

  ClientRole _role = ClientRole.Broadcaster;

  @override
  void initState() {
    super.initState();
    initial();
  }

  void initial() async {
    loginData = await SharedPreferences.getInstance();
    setState(() {
      doctorId = loginData.getString('_id');
    });
  }

  @override
  void dispose() {
    // dispose input controller
    _channelController.dispose();
    super.dispose();
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
                Text("---------------------------------------"),
                SizedBox(height: 10,),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: _createChannelController,
                        decoration: InputDecoration(
                          errorText:
                          _validateError1 ? 'Channel name is mandatory' : null,
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(width: 1),
                          ),
                          hintText: 'Create Channel Name',
                        ),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: ElevatedButton(
                          onPressed: (){
                            // print(_createChannelController.text);
                            onCreate(_createChannelController.text);
                          },
                          child: Text('Create Channel'),
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
              ],
            ),
          ),
        ),
      ),
    );
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

  String token = "";

  Future update(token) async{
    Map data1 = {
      "rtcToken": token,
    };

    String bodyDoc1 = json.encode(data1);
    http.Response responseDoc = await http.patch(
      Uri.parse('https://latest-server.onrender.com/api/user/updateRtcToken/$doctorId'),
      headers: {"Content-Type": "application/json"},
      body: bodyDoc1,
    );
  }

  Future<void> onCreate(String channelName) async {
    // update input validation
    setState(() {
      _createChannelController.text.isEmpty
          ? _validateError1 = true
          : _validateError1 = false;
    });
    if (_createChannelController.text.isNotEmpty) {
      videocallToken = await SharedPreferences.getInstance();
      String url = 'https://token-server-20wg.onrender.com/rtc/$channelName/publisher/uid/0';
      final uri = Uri.parse(url);
      final response = await http.get(uri);
      final body = response.body;
      final json = jsonDecode(body);
      token = json['rtcToken'];
      update(token);
      videocallToken?.setString('rtcToken', token);
      // print(json['data']);
      print(token);



      Fluttertoast.showToast(
          msg: "Create channel completed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
  }

  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    print(status);
  }
}
