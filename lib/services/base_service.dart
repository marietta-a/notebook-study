import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BaseService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void authorize() {
     final user = _auth.currentUser;
     if(user == null){
      throw Exception("User is not authorized");
     }
  }

  User? getUser(){
    return _auth.currentUser;
  }
  
  addItem(String collectionName, Map<String, dynamic> item) async {
    try{
      await firestore.collection(collectionName).add(item)
      .then((ref) {
        return ref;
      }).catchError((error){
        throw error;
      });

    }
    catch(ex){
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getItems(String collectionName) async {

     return await firestore.collection(collectionName).get()
     .then((res) {
       var result = res.docs.map((item) => item.data()).toList();
       return result;
     }).catchError((err){
        throw err;
     });
    
  }

  updateItem(String collectionName, int id, Map<String, dynamic> item) async {
  
    final snapShot = await firestore.collection(collectionName).where('id', isEqualTo: id).get();

    if(snapShot.docs.isNotEmpty){
      snapShot.docs.forEach((data) async {
        var docRef = data.reference;
        await docRef.update(item).then((_) {
          print('document successfully updated');
        }).catchError((error){
          print('Error updating document: $error');
        });
      });
    }
  }


  deleteItem(String collectionName, int id) async {
    
    final snapShot = await firestore.collection(collectionName).where('id', isEqualTo: id).get();

    if(snapShot.docs.isNotEmpty){
      snapShot.docs.forEach((item) async {
        var docRef = item.reference;
        await docRef.delete().then((_) {
          print('document successfully updated');
        }).catchError((error){
          print('Error updating document: $error');
        });
      });
    }

  }

}