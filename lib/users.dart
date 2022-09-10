import 'package:json_annotation/json_annotation.dart';

part 'users.g.dart';


@JsonSerializable()
class ProfileModel {

  bool selected = false;
  late String id, email, fName, lName, contactNo, password, cPassword;
  ProfileModel({
    required this.id,
    required this.email,
    required this.fName,
    required this.lName,
    required this.contactNo
});

  factory ProfileModel.fromJson(Map<String, dynamic> json) => _$ProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileModelToJson(this);
}