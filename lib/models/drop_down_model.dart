import 'package:flutter/material.dart';

class DropDownModel extends Intent{
  final String key;
  final String value;
  const DropDownModel({required this.key, required this.value});
  
  Map<String, dynamic> toJson() => {
    'key': key,
    'value': value,
  };

  factory DropDownModel.fromJson(Map<String, dynamic> json) {
    return DropDownModel(
      key: json['key'],
      value:  json['value']
    );
  }
}