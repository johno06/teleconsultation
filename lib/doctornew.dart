import 'dart:convert';


List<DoctorNewFetch> userFromJson(String str) => List<DoctorNewFetch>.from(json.decode(str).map((x) => DoctorNewFetch.fromJson(x)));

class DoctorNewFetch {

  String id;
  String userId;
  String firstName;
  String lastName;
  String phoneNumber;
  String website;
  String address;
  String specialization;
  String experience;
  int fee;
  List<dynamic>timings = [];
  String status;
  String createdAt;
  String updatedAt;
  List<dynamic>devices=[];

  DoctorNewFetch({
    required this.id,
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.website,
    required this.address,
    required this.specialization,
    required this.experience,
    required this.fee,
    required this.timings,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.devices
  });

  bool selected = false;

  factory DoctorNewFetch.fromJson(Map<String, dynamic> json) => DoctorNewFetch(
      id: json["_id"] ?? "",
      userId: json["userId"] ?? "",
      firstName: json["firstName"] ?? "",
      lastName: json["lastName"] ?? "",
      phoneNumber: json["phoneNumber"] ?? "",
      website: json["website"] ?? "",
      address: json["address"] ?? "",
      specialization: json["specialization"] ?? "",
      experience: json["experience"] ?? "",
      fee: json["fee"] ?? "",
      timings: json["timings"] ?? [],
      status: json["status"] ?? "",
      createdAt: json["createdAt"] ?? "",
      updatedAt: json["updatedAt"] ?? "",
      devices: json["devices"] ?? []
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "userId": userId,
    "firstName": firstName,
    "lastName": lastName,
    "phoneNumber": phoneNumber,
    "website": website,
    "address": address,
    "specialization": specialization,
    "experience": experience,
    "fee": fee,
    "timings": timings,
    "devices": devices
  };
}