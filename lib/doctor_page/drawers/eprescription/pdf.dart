import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teleconsultation/doctor_page/drawers/eprescription/signature_screen.dart';
import '../../../constant.dart';
import 'file_handle_api.dart';
import 'package:pdf/widgets.dart' as pdfLib;
import 'file_handle_api.dart';
import 'package:pdf/pdf.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';


class MyForm extends StatefulWidget {
  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _patientName, _patientAddress, _patientAge;
  late String patientName, patientAddress, patientAge;
  late TextEditingController _medicineController;
  late TextEditingController _medicineQtyController;
  static List<String> medicineType = [''];
  static List<String> medicineList = [''];
  var tableData = [
    [
      '',
      '',
    ],
  ];
  Future<File> generate() async {
    final pdf = pdfLib.Document();
    const double point = 1.0;
    const double inch = 72.0;
    const double cm = inch / 2.54;
    const double mm = inch / 25.4;

    PdfPageFormat prescriptionSize =
    const PdfPageFormat(14.8 * cm, 21.0 * cm, marginAll: 2.0 * cm);

    final RxImage =
    (await rootBundle.load('assets/icons/Rx.png')).buffer.asUint8List();

    final tableHeaders = [
      'Medicine',
      'Quantity',
    ];


    var isFirstPage = true;
    var inputFormat = DateFormat('MM/dd/yyyy');
    var date = DateTime.now();
    var formattedDate = inputFormat.format(date);

    pdf.addPage(
      // pdfLib.Page(
      //     pageFormat: PdfPageFormat.a4,
      // ),// Pa
      pdfLib.MultiPage(
        pageFormat: prescriptionSize,
        header: (context) {
          return pdfLib.Text(
            'Fuentes Clinic',
            textAlign: pdfLib.TextAlign.center,
            style: pdfLib.TextStyle(
              fontSize: 17.0,
              fontWeight: pdfLib.FontWeight.bold,
            ),
          );
        },
        build: (context) {
          return [
            pdfLib.Row(
              children: [
                // pdfLib.Image(
                //   pdfLib.MemoryImage(iconImage),
                //   height: 72,
                //   width: 72,
                // ),
                pdfLib.SizedBox(width: 1 * PdfPageFormat.mm),
                pdfLib.Column(
                  mainAxisSize: pdfLib.MainAxisSize.min,
                  crossAxisAlignment: pdfLib.CrossAxisAlignment.center,
                  children: [
                    // pdfLib.SizedBox(height: 15.5),
                    pdfLib.Text(
                      'Dr. $doctorName $doctorLname (ObGyn) \n$doctorAddress',
                      style: const pdfLib.TextStyle(
                        fontSize: 9.0,
                        color: PdfColors.grey700,
                      ),
                    ),
                  ],
                ),
                pdfLib.Spacer(),
                pdfLib.Column(
                  mainAxisSize: pdfLib.MainAxisSize.min,
                  crossAxisAlignment: pdfLib.CrossAxisAlignment.end,
                  children: [
                    // pdfLib.Text(
                    //   'h',
                    //   style: pdfLib.TextStyle(
                    //     fontSize: 19.0,
                    //     fontWeight: pdfLib.FontWeight.bold,
                    //   ),
                    // ),
                    // pdfLib.SizedBox(height: 15.5),
                    pdfLib.Text(
                      '$doctorEmail',
                      style: const pdfLib.TextStyle(
                        fontSize: 9.0,
                        color: PdfColors.grey700,
                      ),
                    ),
                    pdfLib.Text(
                      'Date: '+formattedDate,
                      style: const pdfLib.TextStyle(
                        fontSize: 9.0,
                        color: PdfColors.grey700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // pdfLib.SizedBox(height: 1 * PdfPageFormat.mm),
            pdfLib.Divider(),
            // pdfLib.SizedBox(height: 1 * PdfPageFormat.mm),
            pdfLib.Row(
              children: [
                // pdfLib.Image(
                //   pdfLib.MemoryImage(iconImage),
                //   height: 72,
                //   width: 72,
                // ),
                pdfLib.SizedBox(width: 1 * PdfPageFormat.mm),
                pdfLib.Column(
                  mainAxisSize: pdfLib.MainAxisSize.min,
                  crossAxisAlignment: pdfLib.CrossAxisAlignment.center,
                  children: [
                    // pdfLib.SizedBox(height: 15.5),
                    pdfLib.Text(
                      'Patient Name: $patientName \nAddress: $patientAddress',
                      style: const pdfLib.TextStyle(
                        fontSize: 9.0,
                        color: PdfColors.grey700,
                      ),
                    ),
                  ],
                ),
                pdfLib.Spacer(),
                pdfLib.Column(
                  mainAxisSize: pdfLib.MainAxisSize.min,
                  crossAxisAlignment: pdfLib.CrossAxisAlignment.end,
                  children: [
                    // pdfLib.Text(
                    //   'h',
                    //   style: pdfLib.TextStyle(
                    //     fontSize: 19.0,
                    //     fontWeight: pdfLib.FontWeight.bold,
                    //   ),
                    // ),
                    // pdfLib.SizedBox(height: 15.5),
                    pdfLib.Text(
                      'Age: $patientAge  Gender: Female',
                      style: const pdfLib.TextStyle(
                        fontSize: 9.0,
                        color: PdfColors.grey700,
                      ),
                    ),
                    pdfLib.Text(
                      'Date: '+formattedDate,
                      style: const pdfLib.TextStyle(
                        fontSize: 9.0,
                        color: PdfColors.grey700,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            pdfLib.SizedBox(height: 5 * PdfPageFormat.mm),
            pdfLib.Image(
              pdfLib.MemoryImage(RxImage),
              height: 40,
              width: 40,
            ),
            ///
            /// PDF Table Create
            ///
            pdfLib.Table.fromTextArray(
              headers: tableHeaders,
              data: tableData,
              border: null,
              headerStyle: pdfLib.TextStyle(fontWeight: pdfLib.FontWeight.bold),
              headerDecoration:
              const pdfLib.BoxDecoration(color: PdfColors.grey300),
              cellHeight: 10.0,
              cellAlignments: {
                0: pdfLib.Alignment.center,
                1: pdfLib.Alignment.center,
                2: pdfLib.Alignment.centerRight,
                3: pdfLib.Alignment.centerRight,
                4: pdfLib.Alignment.centerRight,
              },
            ),
          ];
        },
        footer: (context) {
          return pdfLib.Row(
            children: [
              // pdfLib.Text(
              //   '-----',
              //   style: pdfLib.TextStyle(
              //     color: PdfColors.white,
              //     fontSize: 19.0,
              //     fontWeight: pdfLib.FontWeight.bold,
              //   ),
              // ),
              pdfLib.Column(
                mainAxisSize: pdfLib.MainAxisSize.min,
                crossAxisAlignment: pdfLib.CrossAxisAlignment.start,
                children: [
                  pdfLib.Row(
                      children:[
                        pdfLib.Text(
                          '----------',
                          style: pdfLib.TextStyle(
                            color: PdfColors.white,
                            fontSize: 19.0,
                            fontWeight: pdfLib.FontWeight.bold,
                          ),
                        ),
                        pdfLib.Image(
                          pdfLib.MemoryImage(byteData),
                          height: 60,
                          width: 200,
                        ),]
                  ),
                  pdfLib.Text(
                    'Signature: ________________',
                    style: const pdfLib.TextStyle(
                      fontSize: 11.0,
                      color: PdfColors.grey700,
                    ),
                  ),
                  pdfLib.Text(
                    'License No: ____________________',
                    style: const pdfLib.TextStyle(
                      fontSize: 9.0,
                      color: PdfColors.grey700,
                    ),
                  ),
                ],
              ),
            ],
          );

          //   pdfLib.Column(
          //   mainAxisSize: pdfLib.MainAxisSize.min,
          //   children: [
          //     pdfLib.Divider(),
          //     pdfLib.SizedBox(height: 2 * PdfPageFormat.mm),
          //     pdfLib.Text(
          //       'Signature: _______________',
          //       style: pdfLib.TextStyle(fontWeight: pdfLib.FontWeight.bold),
          //     ),
          //     pdfLib.SizedBox(height: 1 * PdfPageFormat.mm),
          //     pdfLib.Row(
          //       mainAxisAlignment: pdfLib.MainAxisAlignment.center,
          //       children: [
          //         pdfLib.Text(
          //           'Address: ',
          //           style: pdfLib.TextStyle(fontWeight: pdfLib.FontWeight.bold),
          //         ),
          //         pdfLib.Text(
          //           'Merul Badda, Anandanagor, Dhaka 1212',
          //         ),
          //       ],
          //     ),
          //     pdfLib.SizedBox(height: 1 * PdfPageFormat.mm),
          //     pdfLib.Row(
          //       mainAxisAlignment: pdfLib.MainAxisAlignment.center,
          //       children: [
          //         pdfLib.Text(
          //           'Email: ',
          //           style: pdfLib.TextStyle(fontWeight: pdfLib.FontWeight.bold),
          //         ),
          //         pdfLib.Text(
          //           'flutterapproach@gmail.com',
          //         ),
          //       ],
          //     ),
          //   ],
          // );
        },
      ),
    );
    return FileHandleApi.saveDocument(name: '$patientName _prescription.pdf', pdf: pdf);
  }


  late SharedPreferences loginData;
  String? doctorEmail, doctorName, doctorLname, doctorAddress;
  SharedPreferences? appointmentData;
  SharedPreferences? patientData;

  void initial() async{
    loginData = await SharedPreferences.getInstance();
    setState(() {
      doctorEmail = loginData.getString('email')!;
      doctorName = loginData.getString('name')!;
      doctorLname = loginData.getString('surname')!;
      doctorAddress = loginData.getString('address')!;
    });
  }


  @override
  void initState() {
    super.initState();
    initial();
    _patientAddress = TextEditingController();
    _patientName = TextEditingController();
    _patientAge = TextEditingController();
    _medicineController = TextEditingController();
    _medicineQtyController = TextEditingController();
  }

  @override
  void dispose() {
    _medicineController.dispose();
    _medicineQtyController.dispose();
    _patientAddress.dispose();
    _patientName.dispose();
    _patientAge.dispose();
    super.dispose();
  }

  File? imageFile;
  var byteData;
  final picker = ImagePicker();
  chooseImage(ImageSource source) async{
    final pickedFile = await picker.getImage(source: source);
    imageFile = File(pickedFile!.path);
    Uint8List uint8list = Uint8List.fromList(File(pickedFile!.path).readAsBytesSync());
    byteData = uint8list;
    setState(() {
      imageFile = File(pickedFile!.path);
    });
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
              Container(
                  alignment: Alignment.center,
                  child: imageFile != null
                      ?Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          image: FileImage(imageFile!),
                        )
                    ),
                  )
                      :Container(
                    height: 150,
                    width: 200,
                    decoration: const BoxDecoration(
                        color: Colors.grey
                    ),
                  )
              ),

              Container(
                child: Row(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        chooseImage(ImageSource.gallery);
                      },
                      child: const Text("Gallery"),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: shrinePink400,
                          padding: const EdgeInsets.symmetric(horizontal: 50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))),
                    ),
                    SizedBox(width: size.width * 0.020),
                    ElevatedButton(
                      onPressed: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SignaturePage()));
                      },
                      child: const Text("E-Signature"),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: shrinePink400,
                          padding: const EdgeInsets.symmetric(horizontal: 50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))),
                    ),
                  ],
                ),
              ),
              // name textfield
              const SizedBox(height: 10,),
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
              const SizedBox(height: 20,),
              const Text('Prescribed Medicine', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),),
              ..._getMedicines(),
              const SizedBox(height: 40,),
              ElevatedButton(
                onPressed: () async {
                  if(_formKey.currentState!.validate()){
                    _formKey.currentState!.save();
                    for(var i= 0; i<medicineList.length && i<medicineType.length; i++){
                      tableData.add([medicineType[i], medicineList[i]]);
                      // print("Name: $name Address: $address Age: $age ");
                      // print("Type: "+medicineType[i]+" Pcs: "+medicineList[i]);
                    }
                    final pdfFile = await generate();

                    // opening the pdf file
                    FileHandleApi.openFile(pdfFile);
                    tableData.clear();
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

  List<Widget> _getMedicines(){
    List<Widget> medicineTextFields = [];
    for(int i=0; i<medicineList.length && i<medicineType.length; i++){
      medicineTextFields.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              children: [
                Expanded(child: MedicineTextFields(i)),
                const SizedBox(width: 16,),
                Expanded(child: MedicineQuantity(i)),
                const SizedBox(width: 16,),
                // we need add button at last friends row
                _addRemoveButton(i == medicineList.length-1, i == medicineType.length-1,i),
              ],
            ),
          )
      );
    }
    return medicineTextFields;
  }

  /// add / remove button
  Widget _addRemoveButton(bool add, bool add1,int index){
    return InkWell(
      onTap: (){
        if(add && add1){
          // add new text-fields at the top of all friends textfields
          medicineList.insert(0, '');
          medicineType.insert(0, '');
        }
        else {
          medicineList.removeAt(index);
          medicineType.removeAt(index);
        }
        setState((){});
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: (add) ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon((add) ? Icons.add : Icons.remove, color: Colors.white,),
      ),
    );
  }


}

class MedicineTextFields extends StatefulWidget {
  final int index;
  MedicineTextFields(this.index);
  @override
  _MedicineTextFieldsState createState() => _MedicineTextFieldsState();
}

class _MedicineTextFieldsState extends State<MedicineTextFields> {
  late TextEditingController _medicineController;

  @override
  void initState() {
    super.initState();
    _medicineController = TextEditingController();
  }

  @override
  void dispose() {
    _medicineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _medicineController.text = _MyFormState.medicineType[widget.index] ?? '';
    });

    return TextFormField(
      controller: _medicineController,
      onChanged: (v) => _MyFormState.medicineType[widget.index] = v,
      decoration: const InputDecoration(
          hintText: 'Enter medicine'
      ),
      validator: (v){
        if(v!.trim().isEmpty) return 'Please enter medicine';
        return null;
      },
    );
  }
}

class MedicineQuantity extends StatefulWidget {
  final int index;
  MedicineQuantity(this.index);
  @override
  _MedicineQuantityState createState() => _MedicineQuantityState();
}

class _MedicineQuantityState extends State<MedicineQuantity> {
  late TextEditingController _medicineQtyController;

  @override
  void initState() {
    super.initState();
    _medicineQtyController = TextEditingController();
  }

  @override
  void dispose() {
    _medicineQtyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _medicineQtyController.text = _MyFormState.medicineList[widget.index] ?? '';
    });

    return TextFormField(
      keyboardType: TextInputType.number,
      controller: _medicineQtyController,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly
      ],
      onChanged: (v) => _MyFormState.medicineList[widget.index] = v,
      decoration: const InputDecoration(
          hintText: 'Enter Quantity'
      ),
      validator: (v){
        if(v!.trim().isEmpty) return 'Please enter quantity';
        return null;
      },
    );
  }
}