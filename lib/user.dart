import 'dart:convert';


List<UserFetch> userFromJson(String str) => List<UserFetch>.from(json.decode(str).map((x) => UserFetch.fromJson(x)));

class UserFetch {
   // String id;
   // String email;
   // String name;
   // String surname;
   // String contactNo;
   // String password;
   // String cPassword;
   // String birthday;
   // String homeAddress;

   String id;
   String email;
   String name;
   String surname;
   String phone;
   String birthdate;
   // String gender;
   String address;
   // String emailVerificationToken;
   bool verified;
   bool isAdmin;
   String password;
   bool isDoctor;
   String createdAt;
   String updatedAt;
   List<dynamic>devices=[];

  UserFetch({
    // required this.id,
    // required this.email,
    // required this.name,
    // required this.surname,
    // required this.birthday,
    // required this.homeAddress,
    // required this.contactNo,
    // required this.password,
    // required  this.cPassword
    required this.id,
    required this.email,
    required this.name,
    required this.surname,
    required this.birthdate,
    required this.address,
    required this.phone,
    // required this.gender,
    required this.isDoctor,
    // required this.emailVerificationToken,
    required this.verified,
    required this.isAdmin,
    required this.createdAt,
    required this.updatedAt,
    required this.password,
    required this.devices
  });

  bool selected = false;

  factory UserFetch.fromJson(Map<String, dynamic> json) => UserFetch(
    // id: json["_id"] ?? "",
    // email: json["email"] ?? "",
    // name: json["name"] ?? "",
    // surname: json["surname"] ?? "",
    // birthday: json["birthday"] ?? "",
    // homeAddress: json["homeAddress"] ?? "",
    // contactNo: json["contactNo"] ?? "",
    // password: json["password"] ?? "",
    // cPassword: json["cPassword"] ?? "",
    id: json["_id"] ?? "",
    email: json["email"] ?? "",
    name: json["name"] ?? "",
    surname: json["surname"] ?? "",
    birthdate: json["birthdate"] ?? "",
    address: json["address"] ?? "",
    phone: json["phone"] ?? "",
    // gender: json["gender"] ?? "",
    isDoctor: json["isDoctor"] ?? "",
    // emailVerificationToken: json["emailVerificationToken"] ?? "",
    verified: json["verified"] ?? "",
    isAdmin: json["isAdmin"] ?? "",
    createdAt: json["createdAt"] ?? "",
    updatedAt: json["updatedAt"] ?? "",
    password: json["password"] ?? "",
    devices: json["devices"] ?? []
  );

  Map<String, dynamic> toJson() => {
    // "_id": id,
    // "email": email,
    // "name": name,
    // "surname": surname,
    // "birthday": birthday,
    // "homeAddress": homeAddress,
    // "contactNo": contactNo,
    // "password": password,
    // "cPassword": cPassword
    "_id": id,
    "email": email,
    "name": name,
    "surname": surname,
    "birthdate": birthdate,
    "address": address,
    "phoneNumber": phone,
    // "gender": gender,
    "isDoctor": isDoctor,
    "password": password,
    "devices": devices
  };
}