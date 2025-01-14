import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:notebook_study/helpers/enums.dart';
import 'package:notebook_study/models/document_upload.dart';
import 'package:notebook_study/services/base_service.dart';

class DocumentUploadService  extends BaseService {

 final FirebaseStorage _storageInstance = FirebaseStorage.instance;

 Future<TaskSnapshot> uploadDocument(File file, String fileName) async {
    try{
    
      Reference storageRef = _storageInstance.ref().child('uploads/$fileName');

        // Start upload
      return await storageRef.putFile(file);
    }
    catch(ex){
      print(ex);
      rethrow;
    }
       
  }

  Future<TaskSnapshot> uploadDocumentFromBytes(Uint8List fileBytes, String fileName) async {
  try {
    Reference storageRef = _storageInstance.ref().child('uploads/$fileName');
    return await storageRef.putData(fileBytes);
  } catch (ex) {
    print(ex);
    rethrow;
  }
}


  Future<bool> addDocument(DocumentUpload item) async {
      try{

      CollectionReference docCollection = getInstance().collection(CollectionNames.documentuploads.name);
      DocumentReference docRef = await docCollection.add(item.toJson());

      if(item.category != null){
        CollectionReference docCatCollection = docRef.collection(CollectionNames.categories.name);
        await docCatCollection.add(item.category!.toJson());
      }
      if(item.user != null){
        CollectionReference docUCollection = docRef.collection(CollectionNames.user_profiles.name);
        await docUCollection.add(item.user!.toJson());
      }

      return true;
      }
      catch(ex){
      print(ex);
      return false;
      }
  }
}