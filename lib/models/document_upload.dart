import 'package:notebook_study/models/category_model.dart';
import 'package:notebook_study/models/user_profile.dart';

class DocumentUpload {
  final String name; // Name of the document
  final String url; // Download URL
  final String type; // MIME type of the document (e.g., "application/pdf")
  final int size;
  late UserProfile? user;
  late CategoryModel? category; // Size of the document in bytes

  DocumentUpload({
    required this.name,
    required this.url,
    required this.type,
    required this.size,
    this.user,
    this.category
  });

  

  Map<String, dynamic> toJson() => {
    'name': name,
    'url': url,
    'type': type,
    'size': size,
    'user': user?.toJson(),
    'category': category?.toJson(),
  };

  factory DocumentUpload.fromJson(Map<String, dynamic> json) {
    return DocumentUpload(
      name: json['name'], 
      url: json['url'],
      type: json['type'],
      size: json['size'],
      category: json['category'],
      user: json['user']
     );
  }
}