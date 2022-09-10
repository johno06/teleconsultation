// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'users.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileModel _$ProfileModelFromJson(Map<String, dynamic> json) {
  return ProfileModel(
    id: json['id'] as String,
    email: json['email'] as String,
    fName: json['fName'] as String,
    lName: json['lName'] as String,
    contactNo: json['contactNo'] as String,
  )
    ..selected = json['selected'] as bool
    ..password = json['password'] as String
    ..cPassword = json['cPassword'] as String;
}

Map<String, dynamic> _$ProfileModelToJson(ProfileModel instance) =>
    <String, dynamic>{
      'selected': instance.selected,
      'id': instance.id,
      'email': instance.email,
      'fName': instance.fName,
      'lName': instance.lName,
      'contactNo': instance.contactNo,
      'password': instance.password,
      'cPassword': instance.cPassword,
    };
