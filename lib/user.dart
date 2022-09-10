import 'dart:convert';


List<UserFetch> userFromJson(String str) => List<UserFetch>.from(json.decode(str).map((x) => UserFetch.fromJson(x)));

class UserFetch {
   String id;
   String email;
   String fName;
   String lName;
   String contactNo;
   String password;
   String cPassword;
   String birthday;
   String homeAddress;

  UserFetch({
    required this.id,
    required this.email,
    required this.fName,
    required this.lName,
    required this.birthday,
    required this.homeAddress,
    required this.contactNo,
    required this.password,
    required  this.cPassword
  });

  bool selected = false;

  factory UserFetch.fromJson(Map<String, dynamic> json) => UserFetch(
    id: json["_id"] ?? "",
    email: json["email"] ?? "",
    fName: json["fName"] ?? "",
    lName: json["lName"] ?? "",
    birthday: json["birthday"] ?? "",
    homeAddress: json["homeAddress"] ?? "",
    contactNo: json["contactNo"] ?? "",
    password: json["password"] ?? "",
    cPassword: json["cPassword"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "email": email,
    "fName": fName,
    "lName": lName,
    "birthday": birthday,
    "homeAddress": homeAddress,
    "contactNo": contactNo,
    "password": password,
    "cPassword": cPassword
  };
}