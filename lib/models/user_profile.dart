
import 'package:firebase_auth/firebase_auth.dart';

class UserProfile{
  String? uid;
  String? firstName;
  String? lastName;
  String? userName;
  String? email;
  String? role;

  UserProfile({this.uid, this.firstName, this.lastName, this.userName, this.email, this.role});

  UserProfile? toUserProfile(User? u){
     return UserProfile(
      uid:  uid,
      firstName:  firstName,
      lastName:  lastName,
      userName: u?.displayName,
      email:  u?.email,
      role:  role);
  }
  
  Map<String, dynamic> toJson() => {
    'uid': uid,
    'firstName': firstName,
    'lastName': lastName,
    'userName': userName,
    'email': email,
    'role': role
  };

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      uid: json['uid'],
      firstName:  json['firstName'],
      lastName:  json['lastName'],
      userName:  json['userName'],
      email:  json['email'],
      role:  json['role']);
  }
}