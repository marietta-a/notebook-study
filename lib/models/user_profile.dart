
import 'package:firebase_auth/firebase_auth.dart';

class UserProfile{
  String? uuid;
  String? firstName;
  String? lastName;
  String? userName;
  String? email;
  String? role;

  UserProfile(this.uuid, this.firstName, this.lastName, this.userName, this.email, this.role);

  UserProfile? toUserProfile(User? u){
     return UserProfile(uuid, firstName, lastName, u?.displayName, u?.email, role);
  }
  
  Map<String, dynamic> toJson() => {
    'id': uuid,
    'firstName': firstName,
    'lastName': lastName,
    'userName': userName,
    'email': email,
    'role': role
  };

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(json['id'], json['firstName'], json['lastName'], json['userName'], json['email'], json['role']);
  }
}