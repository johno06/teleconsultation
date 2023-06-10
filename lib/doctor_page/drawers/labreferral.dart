import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pdfWidgets;
import 'package:open_file/open_file.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:teleconsultation/doctor_page/drawers/eprescription/signature_screen.dart';
import '../../../constant.dart';

// class LabReferralForm extends StatefulWidget {
//   @override
//   State<LabReferralForm> createState() => _LabReferralFormState();
// }
//
// class _LabReferralFormState extends State<LabReferralForm> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//
//   late TextEditingController _patientName,
//       _patientAddress,
//       _patientAge,
//       _patientEmail,
//       _patientPhone;
//
//   late String patientName, patientAddress, patientAge, patientEmail, patientPhone;
//
//   late SharedPreferences loginData;
//
//   String? doctorEmail,
//       doctorName,
//       doctorLname,
//       doctorAddress,
//       doctorPhone;
//
//   SharedPreferences? appointmentData;  List<bool> reasonsForReferralCheckboxes = [false, false, false, false];
//   List<bool> investigationsCheckboxes = [false, false, false, false];
//   SharedPreferences? patientData;
//
//
//
//   void initial() async {
//     loginData = await SharedPreferences.getInstance();
//     setState(() {
//       doctorEmail = loginData.getString('email')!;
//       doctorName = loginData.getString('name')!;
//       doctorLname = loginData.getString('surname')!;
//       doctorAddress = loginData.getString('address')!;
//       doctorPhone = loginData.getString('phone')!;
//     });
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     initial();
//     _patientAddress = TextEditingController();
//     _patientName = TextEditingController();
//     _patientAge = TextEditingController();
//     _patientEmail = TextEditingController();
//     _patientPhone = TextEditingController();
//   }
//
//   @override
//   void dispose() {
//     _patientAddress.dispose();
//     _patientName.dispose();
//     _patientAge.dispose();
//     _patientEmail.dispose();
//     _patientPhone.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Scaffold(
//       body: Form(
//         key: _formKey,
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 'Patient Information',
//                 style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
//               ),
//               const SizedBox(height: 10,),
//               Padding(
//                 padding: const EdgeInsets.only(right: 32.0),
//                 child: TextFormField(
//                   controller: _patientName,
//                   decoration: const InputDecoration(
//                       hintText: 'Enter Patient Name'
//                   ),
//                   validator: (v) {
//                     if (v!.trim().isEmpty) {
//                       return 'Please enter Patient Name';
//                     } else {
//                       patientName = v;
//                     }
//                   },
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(right: 32.0),
//                 child: TextFormField(
//                   controller: _patientEmail,
//                   decoration: const InputDecoration(
//                       hintText: 'Enter Email'
//                   ),
//                   validator: (String ? value) {
//                     if (value != null && value.isEmpty) {
//                       return 'Please Enter Email';
//                     }
//                     if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
//                         .hasMatch(value!)) {
//                       return 'Please a valid Email';
//                     }
//                     return null;
//                   },
//                   onChanged: (value) {
//                     patientEmail = value;
//                   },
//                 ),
//               ),
//               const SizedBox(height: 10,),
//               Padding(
//                 padding: const EdgeInsets.only(right: 32.0),
//                 child: TextFormField(
//                   controller: _patientAddress,
//                   decoration: const InputDecoration(
//                       hintText: 'Enter Patient Address'
//                   ),
//                   validator: (v){
//                     if(v!.trim().isEmpty) {
//                       return 'Please enter Address';
//                     }else {
//                       patientAddress = v;
//                     }
//                   },
//                 ),
//               ),
//               const SizedBox(height: 10,),
//               Padding(
//                 padding: const EdgeInsets.only(right: 32.0),
//                 child: TextFormField(
//                   keyboardType: TextInputType.number,
//                   controller: _patientAge,
//                   inputFormatters: <TextInputFormatter>[
//                     FilteringTextInputFormatter.digitsOnly
//                   ],
//                   decoration: const InputDecoration(
//                       hintText: 'Enter Patient Age'
//                   ),
//                   validator: (v){
//                     if(v!.trim().isEmpty) {
//                       return 'Please enter age';
//                     }else {
//                       patientAge = v;
//                     }
//                   },
//                 ),
//               ),
//               const SizedBox(height: 10,),
//               Padding(
//                 padding: const EdgeInsets.only(right: 32.0),
//                 child: TextFormField(
//                   keyboardType: TextInputType.number,
//                   controller: _patientPhone,
//                   inputFormatters: <TextInputFormatter>[
//                     FilteringTextInputFormatter.digitsOnly
//                   ],
//                   decoration: const InputDecoration(
//                       hintText: 'Enter Patient Phone'
//                   ),
//                   validator: (v){
//                     if(v!.trim().isEmpty) {
//                       return 'Please enter phone';
//                     }else {
//                       patientPhone = v;
//                     }
//                   },
//                 ),
//               ),
//               // Rest of the form fields...
//
//               // Checkbox section
//               const SizedBox(height: 20,),
//               const Text(
//                 'Reason for Referral',
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               CheckboxListTile(
//                 value: reasonsForReferralCheckboxes[0],
//                 onChanged: (value) {
//                   setState(() {
//                     reasonsForReferralCheckboxes[0] = value!;
//                   });
//                 },
//                 title: const Text('Hemophilia'),
//               ),
//               CheckboxListTile(
//                 value: reasonsForReferralCheckboxes[1],
//                 onChanged: (value) {
//                   setState(() {
//                     reasonsForReferralCheckboxes[1] = value!;
//                   });
//                 },
//                 title: const Text('Anemia'),
//               ),
//               CheckboxListTile(
//                 value: reasonsForReferralCheckboxes[2],
//                 onChanged: (value) {
//                   setState(() {
//                     reasonsForReferralCheckboxes[2] = value!;
//                   });
//                 },
//                 title: const Text('Heavy menstrual bleeding'),
//               ),
//               CheckboxListTile(
//                 value: reasonsForReferralCheckboxes[3],
//                 onChanged: (value) {
//                   setState(() {
//                     reasonsForReferralCheckboxes[3] = value!;
//                   });
//                 },
//                 title: const Text('Other (please indicate)'),
//               ),
//
//               const SizedBox(height: 20,),
//               const Text(
//                 'Investigations Included',
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               CheckboxListTile(
//                 value: investigationsCheckboxes[0],
//                 onChanged: (value) {
//                   setState(() {
//                     investigationsCheckboxes[0] = value!;
//                   });
//                 },
//                 title: const Text('Ultrasound, CT, MRI'),
//               ),
//               CheckboxListTile(
//                 value: investigationsCheckboxes[1],
//                 onChanged: (value) {
//                   setState(() {
//                     investigationsCheckboxes[1] = value!;
//                   });
//                 },
//                 title: const Text('Bloodwork'),
//               ),
//               CheckboxListTile(
//                 value: investigationsCheckboxes[2],
//                 onChanged: (value) {
//                   setState(() {
//                     investigationsCheckboxes[2] = value!;
//                   });
//                 },
//                 title: const Text('Pathology'),
//               ),
//               CheckboxListTile(
//                 value: investigationsCheckboxes[3],
//                 onChanged: (value) {
//                   setState(() {
//                     investigationsCheckboxes[3] = value!;
//                   });
//                 },
//                 title: const Text('Other (please indicate)'),
//               ),
//
//               const SizedBox(height: 40,),
//               ElevatedButton(
//                 onPressed: () async {
//                   if (_formKey.currentState!.validate()) {
//                     _formKey.currentState!.save();
//
//                     final Uint8List pdfData = await generatePdf();
//                     final String path = await savePdf(pdfData);
//                     openPdf(path);
//                   }
//                 },
//                 child: const Text('Submit'),
//                 style: ElevatedButton.styleFrom(
//                     backgroundColor: shrinePink400,
//                     padding: const EdgeInsets.symmetric(horizontal: 50),
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(20))),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Future<Uint8List> generatePdf() async {
//     final pdfWidgets.Document pdf = pdfWidgets.Document();
//     pdf.addPage(
//       pdfWidgets.Page(
//         build: (pdfWidgets.Context context) => buildPdfContent(),
//       ),
//     );
//     return pdf.save();
//   }
//
//   Future<String> savePdf(Uint8List pdfData) async {
//     final directory = await getApplicationDocumentsDirectory();
//     final String path = '${directory.path}/$patientName lab_referral_form.pdf';
//     final File file = File(path);
//     await file.writeAsBytes(pdfData.toList());
//     return file.path;
//   }
//
//   void openPdf(String path) {
//     OpenFile.open(path);
//   }
//
//   pdfWidgets.Widget buildPdfContent() {
//     return pdfWidgets.Container(
//       padding: pdfWidgets.EdgeInsets.all(16),
//       child: pdfWidgets.Column(
//         children: [
//           pdfWidgets.Text(
//             'Patient Information',
//             style: pdfWidgets.TextStyle(fontWeight: pdfWidgets.FontWeight.bold, fontSize: 16),
//           ),
//           pdfWidgets.SizedBox(height: 10),
//           pdfWidgets.Text('Patient Name: $patientName'),
//           // Rest of the patient information...
//
//           pdfWidgets.SizedBox(height: 20),
//           pdfWidgets.Text(
//             'Reason for Referral',
//             style: pdfWidgets.TextStyle(fontWeight: pdfWidgets.FontWeight.bold),
//           ),
//           if (reasonsForReferralCheckboxes[0])
//             pdfWidgets.Text('Hemophilia'),
//           if (reasonsForReferralCheckboxes[1])
//             pdfWidgets.Text('Anemia'),
//           if (reasonsForReferralCheckboxes[2])
//             pdfWidgets.Text('Heavy menstrual bleeding'),
//           if (reasonsForReferralCheckboxes[3])
//             pdfWidgets.Text('Other (please indicate)'),
//
//           pdfWidgets.SizedBox(height: 20),
//           pdfWidgets.Text(
//             'Investigations Included',
//             style: pdfWidgets.TextStyle(fontWeight: pdfWidgets.FontWeight.bold),
//           ),
//           if (investigationsCheckboxes[0])
//             pdfWidgets.Text('Ultrasound, CT, MRI'),
//           if (investigationsCheckboxes[1])
//             pdfWidgets.Text('Bloodwork'),
//           if (investigationsCheckboxes[2])
//             pdfWidgets.Text('Pathology'),
//           if (investigationsCheckboxes[3])
//             pdfWidgets.Text('Other (please indicate)'),
//         ],
//       ),
//     );
//   }
// }


class LabReferralForm extends StatefulWidget {

  @override
  State<LabReferralForm> createState() => _LabReferralFormState();
}

class _LabReferralFormState extends State<LabReferralForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController _patientName, _patientAddress, _patientAge, _patientEmail, _patientPhone, _other;

  late String patientName, patientAddress, patientAge, patientEmail, patientPhone, other;

  List<bool> reasonsForReferralCheckboxes = [false, false, false, false];
  List<bool> investigationsCheckboxes = [false, false, false, false];
  late SharedPreferences loginData;

  String? doctorEmail, doctorName, doctorLname, doctorAddress, doctorPhone;

  SharedPreferences? appointmentData;

  SharedPreferences? patientData;

  void initial() async{
    loginData = await SharedPreferences.getInstance();
    setState(() {
      doctorEmail = loginData.getString('email')!;
      doctorName = loginData.getString('name')!;
      doctorLname = loginData.getString('surname')!;
      doctorAddress = loginData.getString('address')!;
      doctorPhone = loginData.getString('phone')!;
    });
  }

  @override
  void initState() {
    super.initState();
    initial();
    _patientAddress = TextEditingController();
    _patientName = TextEditingController();
    _patientAge = TextEditingController();
    _patientEmail = TextEditingController();
    _patientPhone = TextEditingController();
    _other = TextEditingController();
  }

  @override
  void dispose() {
    _patientAddress.dispose();
    _patientName.dispose();
    _patientAge.dispose();
    _patientEmail.dispose();
    _patientPhone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Patient Information', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),),
              const SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.only(right: 32.0),
                child: TextFormField(
                  controller: _patientName,
                  decoration: const InputDecoration(
                      hintText: 'Enter Patient Name'
                  ),
                  validator: (v){
                    if(v!.trim().isEmpty) {
                      return 'Please enter Patient Name';
                    }else {
                      patientName = v;
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 32.0),
                child: TextFormField(
                  controller: _patientEmail,
                  decoration: const InputDecoration(
                      hintText: 'Enter Email'
                  ),
                  validator: (String ? value) {
                    if (value != null && value.isEmpty) {
                      return 'Please Enter Email';
                    }
                    if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                        .hasMatch(value!)) {
                      return 'Please a valid Email';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    patientEmail = value;
                  },
                ),
              ),
              const SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.only(right: 32.0),
                child: TextFormField(
                  controller: _patientAddress,
                  decoration: const InputDecoration(
                      hintText: 'Enter Patient Address'
                  ),
                  validator: (v){
                    if(v!.trim().isEmpty) {
                      return 'Please enter Address';
                    }else {
                      patientAddress = v;
                    }
                  },
                ),
              ),
              const SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.only(right: 32.0),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _patientAge,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: const InputDecoration(
                      hintText: 'Enter Patient Age'
                  ),
                  validator: (v){
                    if(v!.trim().isEmpty) {
                      return 'Please enter age';
                    }else {
                      patientAge = v;
                    }
                  },
                ),
              ),
              const SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.only(right: 32.0),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _patientPhone,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: const InputDecoration(
                      hintText: 'Enter Patient Phone'
                  ),
                  validator: (v){
                    if(v!.trim().isEmpty) {
                      return 'Please enter phone';
                    }else {
                      patientPhone = v;
                    }
                  },
                ),
              ),
              const SizedBox(height: 20,),
              const SizedBox(height: 20,),
              const Text(
                'Reason for Referral',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              CheckboxListTile(
                value: reasonsForReferralCheckboxes[0],
                onChanged: (value) {
                  setState(() {
                    reasonsForReferralCheckboxes[0] = value!;
                  });
                },
                title: const Text('Hemophilia'),
              ),
              CheckboxListTile(
                value: reasonsForReferralCheckboxes[1],
                onChanged: (value) {
                  setState(() {
                    reasonsForReferralCheckboxes[1] = value!;
                  });
                },
                title: const Text('Anemia'),
              ),
              CheckboxListTile(
                value: reasonsForReferralCheckboxes[2],
                onChanged: (value) {
                  setState(() {
                    reasonsForReferralCheckboxes[2] = value!;
                  });
                },
                title: const Text('Heavy menstrual bleeding'),
              ),
              CheckboxListTile(
                value: reasonsForReferralCheckboxes[3],
                onChanged: (value) {
                  setState(() {
                    reasonsForReferralCheckboxes[3] = value!;
                  });
                },
                title: const Text('Other (please indicate)'),
              ),
              const SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.only(right: 32.0),
                child: TextFormField(
                  enabled: reasonsForReferralCheckboxes[3],
                  controller: _other,
                  decoration: const InputDecoration(
                      hintText: 'Other please indicate'
                  ),
                  validator: (v){
                    if(v!.trim().isEmpty && reasonsForReferralCheckboxes[3] == true) {
                      return 'Please enter reason';
                    }else {
                      other = v;
                    }
                  },
                ),
              ),

              // const SizedBox(height: 20,),
              // const Text(
              //   'Investigations Included',
              //   style: TextStyle(fontWeight: FontWeight.bold),
              // ),
              // CheckboxListTile(
              //   value: investigationsCheckboxes[0],
              //   onChanged: (value) {
              //     setState(() {
              //       investigationsCheckboxes[0] = value!;
              //     });
              //   },
              //   title: const Text('Ultrasound, CT, MRI'),
              // ),
              // CheckboxListTile(
              //   value: investigationsCheckboxes[1],
              //   onChanged: (value) {
              //     setState(() {
              //       investigationsCheckboxes[1] = value!;
              //     });
              //   },
              //   title: const Text('Bloodwork'),
              // ),
              // CheckboxListTile(
              //   value: investigationsCheckboxes[2],
              //   onChanged: (value) {
              //     setState(() {
              //       investigationsCheckboxes[2] = value!;
              //     });
              //   },
              //   title: const Text('Pathology'),
              // ),
              // CheckboxListTile(
              //   value: investigationsCheckboxes[3],
              //   onChanged: (value) {
              //     setState(() {
              //       investigationsCheckboxes[3] = value!;
              //     });
              //   },
              //   title: const Text('Other (please indicate)'),
              // ),
              const SizedBox(height: 40,),
              ElevatedButton(
                onPressed: () async {
                  if(_formKey.currentState!.validate()){
                    _formKey.currentState!.save();

                    final Uint8List pdfData = await generatePdf();
                    final String path = await savePdf(pdfData);
                    openPdf(path);
                  }
                },
                child: const Text('Submit'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: shrinePink400,
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
                // color: Colors.green,
              ),

            ],
          ),
        ),
      ),

    );
  }

  Future<Uint8List> generatePdf() async {
    final pdfWidgets.Document pdf = pdfWidgets.Document();
    pdf.addPage(
      pdfWidgets.Page(
        build: (pdfWidgets.Context context) => buildPdfContent(),
      ),
    );
    return pdf.save();
  }

  Future<String> savePdf(Uint8List pdfData) async {
    final directory = await getApplicationDocumentsDirectory();
    final String path = '${directory.path}/$patientName lab_referral_form.pdf';
    final File file = File(path);
    await file.writeAsBytes(pdfData.toList());
    return file.path;
  }

  void openPdf(String path) {
    OpenFile.open(path);
  }

  pdfWidgets.Widget buildPdfContent() {
    return pdfWidgets.Container(
      padding: pdfWidgets.EdgeInsets.all(16),
      child: pdfWidgets.Column(
        children: [
          pdfWidgets.Text(
            'Fuentes Clinic Referral Form',
            style: pdfWidgets.TextStyle(
              fontSize: 20,
              fontWeight: pdfWidgets.FontWeight.bold,
            ),
          ),
          pdfWidgets.SizedBox(height: 20),
          pdfWidgets.Text('Clinic Address: Nepa corner rodriguez st. balut'),
          pdfWidgets.Divider(height: 20),
          pdfWidgets.Text(
            'Patient Information:',
            style: pdfWidgets.TextStyle(fontWeight: pdfWidgets.FontWeight.bold),
          ),
          pdfWidgets.SizedBox(height: 10),
          pdfWidgets.Text('Full Name: $patientName'),
          pdfWidgets.Text('Age: $patientAge'),
          pdfWidgets.Text('Phone: $patientPhone'),
          pdfWidgets.Text('Email: $patientEmail'),
          pdfWidgets.Text('Address: $patientAddress'),
          pdfWidgets.Divider(height: 20),
          pdfWidgets.Text(
            'Referring Physician:',
            style: pdfWidgets.TextStyle(fontWeight: pdfWidgets.FontWeight.bold),
          ),
          pdfWidgets.SizedBox(height: 10),
          pdfWidgets.Text('Name: Dr. $doctorName $doctorLname'),
          pdfWidgets.Text('Phone: $doctorPhone'),
          pdfWidgets.Text('Email: $doctorEmail'),
          pdfWidgets.Divider(height: 20),
          pdfWidgets.Row(
            mainAxisAlignment: pdfWidgets.MainAxisAlignment.spaceBetween,
            children: [
              pdfWidgets.Column(
                crossAxisAlignment: pdfWidgets.CrossAxisAlignment.start,
                children: [
                  pdfWidgets.Text(
                    'Reason for Referral \n (Check all that apply):',
                    style: pdfWidgets.TextStyle(fontWeight: pdfWidgets.FontWeight.bold),
                  ),
                  pdfWidgets.SizedBox(height: 10),
                  // Add checkboxes and reasons for referral here
                  if(reasonsForReferralCheckboxes[0] == true)
                  pdfWidgets.Text('[x] Hemophilia'),
                  if(reasonsForReferralCheckboxes[0] == false)
                  pdfWidgets.Text('[ ] Hemophilia'),

                  if(reasonsForReferralCheckboxes[1] == true)
                  pdfWidgets.Text('[x] Anemia'),
                  if(reasonsForReferralCheckboxes[1] == false)
                  pdfWidgets.Text('[ ] Anemia'),

                  if(reasonsForReferralCheckboxes[2] == true)
                  pdfWidgets.Text('[x] Heavy menstrual bleeding'),
                  if(reasonsForReferralCheckboxes[2] == false)
                  pdfWidgets.Text('[ ] Heavy menstrual bleeding'),

                  if(reasonsForReferralCheckboxes[3] == true)
                  pdfWidgets.Text('[x] Other (please indicate) \n $other'),
                  if(reasonsForReferralCheckboxes[3] == false)
                  pdfWidgets.Text('[ ] Other (please indicate)'),
                ],
              ),
              pdfWidgets.Column(
                crossAxisAlignment: pdfWidgets.CrossAxisAlignment.start,
                children: [
                  pdfWidgets.Text(
                    'Investigations Included',
                    style: pdfWidgets.TextStyle(fontWeight: pdfWidgets.FontWeight.bold),
                  ),
                  pdfWidgets.SizedBox(height: 10),
                  // Add checkboxes for investigations here
                  // if(investigationsCheckboxes[0] = true)
                  // pdfWidgets.Text('[✔] Ultrasound, CT, MRI'),
                  // if(investigationsCheckboxes[0] = false)
                  pdfWidgets.Text('[ ] Ultrasound, CT, MRI'),

                  // if(investigationsCheckboxes[1] = true)
                  // pdfWidgets.Text('[✔] Bloodwork'),
                  // if(investigationsCheckboxes[1] = false)
                    pdfWidgets.Text('[ ] Bloodwork'),

                  // if(investigationsCheckboxes[2] = true)
                  // pdfWidgets.Text('[✔] Pathology'),
                  // if(investigationsCheckboxes[2] = false)
                    pdfWidgets.Text('[ ] Pathology'),

                  // if(investigationsCheckboxes[3] = true)
                  //   pdfWidgets.Text('[✔] Other (please indicate)'),
                  // if(investigationsCheckboxes[3] = false)
                    pdfWidgets.Text('[ ] Other (please indicate)'),
                ],
              ),
            ],
          ),
          pdfWidgets.Divider(height: 20),
          pdfWidgets.Row(
            mainAxisAlignment: pdfWidgets.MainAxisAlignment.spaceBetween,
            children: [
              pdfWidgets.Column(
                crossAxisAlignment: pdfWidgets.CrossAxisAlignment.start,
                children: [
                  pdfWidgets.Text(
                    'Comments: ',
                    style: pdfWidgets.TextStyle(fontWeight: pdfWidgets.FontWeight.bold),
                  ),
                  pdfWidgets.SizedBox(height: 50),
                ],
              ),
            ],
          ),
          pdfWidgets.Divider(height: 20),
          // Add comments section here
        ],
      ),
    );
  }
}



