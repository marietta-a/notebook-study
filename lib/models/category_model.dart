import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notebook_study/models/user_profile.dart';


class CategoryModel with ChangeNotifier{
  int id;
  String description;
  DateTime? dateUpdated;
  UserProfile? createdBy;

  late CategoryModel category;
  
  CategoryModel(this.id, this.description, this.dateUpdated, this.createdBy);

  Map<String, dynamic> toJson() => {
    'id': id,
    'description': description,
    'dateUpdated': dateUpdated,
  };

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(json['id'], json['description'],
      json['dateUpdated'] != null ? (json['dateUpdated'] as Timestamp).toDate() : null,
       json['userId']
     );
  }

  // Generated factory method to deserialize from JSON
  // factory CategoryModel.fromJson(Map<String, dynamic> json) => _$CategoryModelFromJson(json);

  // Generated method to serialize to JSON
  // Map<String, dynamic> toJson() => _$UserToJson(this);
  // void recordChanged(CategoryModel cat){
  //      category = cat;
  //      notifyListeners();
  // }
}