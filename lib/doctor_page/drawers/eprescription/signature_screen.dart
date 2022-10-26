import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'package:teleconsultation/constant.dart';
import 'package:teleconsultation/doctor_page/drawer.dart';


class SignaturePage extends StatefulWidget {
  SignaturePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<SignaturePage> {
  final GlobalKey<SfSignaturePadState> signatureGlobalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _requestPermission();
  }

  _requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();
    final info = statuses[Permission.storage].toString();
    print(info);
    // _toastInfo(info);
  }

  void _handleClearButtonPressed() {
    signatureGlobalKey.currentState?.clear();
  }

  void _handleSaveButtonPressed() async {
    RenderSignaturePad boundary =
    signatureGlobalKey.currentContext?.findRenderObject() as RenderSignaturePad;
    ui.Image image = await boundary.toImage();
    ByteData? byteData = await (image.toByteData(format: ui.ImageByteFormat.png));
    if (byteData != null) {
      final time = DateTime.now().millisecond;
      final name = "signature_$time.png";
      final result =
      await ImageGallerySaver.saveImage(byteData.buffer.asUint8List(),quality:100,name:name);
      print(result);
      _toastInfo(result.toString());

      final isSuccess = result['isSuccess'];
      signatureGlobalKey.currentState?.clear();
      if (isSuccess) {
        Size size = MediaQuery
            .of(context)
            .size;
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: const Color(0xffF8AFA6),
                  title: const Text(""),
                  iconTheme: const IconThemeData(color: Colors.redAccent),
                ),
                body: Center(
                  child: Container(
                    color: Colors.grey[300],
                    child: Image.memory(byteData.buffer.asUint8List()),
                  ),
                ),
                bottomNavigationBar: Container(
                  padding: const EdgeInsets.all(16),
                  decoration:  const BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                      color: lightBlue300,
                      offset: Offset(0, 0),
                      blurRadius: 10,
                    ),
                  ]),
                  child: Row(
                    children: [
                      // Expanded(
                      //   child: ElevatedButton(
                      //       style: ElevatedButton.styleFrom(
                      //           minimumSize: const Size(100, 45),
                      //           shape: RoundedRectangleBorder(
                      //               borderRadius: BorderRadius.circular(
                      //                   borderRadiusSize)),
                      //           backgroundColor: Colors.redAccent
                      //       ),
                      //       onPressed: () {
                      //         update = "rejected";
                      //         if(update == "rejected"){
                      //           updateAppointment(context, appointmentId);
                      //         }
                      //
                      //         // print(update);
                      //       },
                      //       child: const Text("Reject")),
                      // ),
                      SizedBox(width: size.width * 0.025),
                      Expanded(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                minimumSize: const Size(100, 45),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        borderRadiusSize)),
                                backgroundColor: Colors.green
                            ),
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (BuildContext context){
                                    return const DoctorPage();
                                  },
                                  ), (router) => false);
                            },
                            child: const Text("Continue")),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }
    }
  }

  _toastInfo(String info) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('The Image is successfully saved!'),));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xffF8AFA6),
          title: const Text(""),
          iconTheme: const IconThemeData(color: Colors.redAccent),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
                padding: EdgeInsets.all(10),
                child: Container(
                    child: SfSignaturePad(
                        key: signatureGlobalKey,
                        backgroundColor: Colors.white,
                        strokeColor: Colors.black,
                        minimumStrokeWidth: 3.0,
                        maximumStrokeWidth: 6.0),
                    decoration:
                    BoxDecoration(border: Border.all(color: Colors.grey)))),
            SizedBox(height: 10),
            Row(children: <Widget>[
              TextButton(
                child: Text('Save As Image',style: TextStyle(fontSize: 20),),
                onPressed: _handleSaveButtonPressed,
              ),
              TextButton(
                child: Text('Clear',style:TextStyle(fontSize: 20)),
                onPressed: _handleClearButtonPressed,
              )
            ], mainAxisAlignment: MainAxisAlignment.spaceEvenly)
          ],
        ));
  }
}