import 'dart:convert';


List<DoctorFetch> userFromJson(String str) => List<DoctorFetch>.from(json.decode(str).map((x) => DoctorFetch.fromJson(x)));

class DoctorFetch {
  String userId;
  String doctorName, doctorLastName;


  DoctorFetch({
    required this.userId,
    required this.doctorName,
    required this.doctorLastName
  });

  bool selected = false;

  factory DoctorFetch.fromJson(Map<String, dynamic> json) => DoctorFetch(
    userId: json["userId"] ?? "",
    doctorName: json["firstName"] ?? "",
    doctorLastName: json["lastName"]
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "doctorName": doctorName,
    "doctorLastName": doctorLastName
  };
}