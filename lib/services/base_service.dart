import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notebook_study/helpers/enums.dart';
import 'package:notebook_study/models/user_profile.dart';

class BaseService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static User? currentUser =  FirebaseAuth.instance.currentUser;

  void authorize() {
     final user = _auth.currentUser;
     if(user == null){
      throw Exception("User is not authorized");
     }
  }

  FirebaseFirestore getInstance() {
    return firestore;
  }


  User? getUser(){
    return _auth.currentUser;
  }

  UserProfile? getUserProfile(){
    User? user = getUser();
    return UserProfile(
      uid:  user!.uid,
      firstName:  '',
      lastName:  '',
      userName:  user.displayName,
      email:  user.email,
      role:  UserRoles.viewer.name
    );
  }
  
  bool isAdmin(){
    return true;
  }

  addItem(String collectionName, Map<String, dynamic> item) async {
    try{
     return await firestore.collection(collectionName).add(item)
      .then((ref) {
        return ref.snapshots().map((item) => item.data()).first;
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

  Future<QuerySnapshot<Map<String, dynamic>>> findItem(String collectionName, String arg, dynamic value) async {
    return await firestore.collection(collectionName).where(arg, isEqualTo: value).get();
  }

  Future<bool> updateItem(String collectionName, int id, Map<String, dynamic> item) async {
  
    final snapShot = await findItem(collectionName, 'id', id);
    var isSuccess = true;

    if(snapShot.docs.isNotEmpty){
      snapShot.docs.forEach((data) async {
        var docRef = data.reference;
        await docRef.update(item).then((_) {
          isSuccess = true;
          // print('document successfully updated');
        }).catchError((error){
          isSuccess = false;
          // print('Error updating document: $error');
        });
      });
    }
    
    return isSuccess;
  }

  


  Future<bool> deleteItem(String collectionName, int id) async {
    
    final snapShot = await firestore.collection(collectionName).where('id', isEqualTo: id).get();
    var isSuccess = true;

    if(snapShot.docs.isNotEmpty){
      snapShot.docs.forEach((item) async {
        var docRef = item.reference;
        await docRef.delete().then((_) {
          // print('document successfully updated');
          isSuccess = true;
        }).catchError((error){
          // print('Error updating document: $error');
          isSuccess = false;
        });
      });
    }

    return isSuccess;

  }

}