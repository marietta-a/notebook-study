import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:notebook_study/core/mixin.dart';
import 'package:notebook_study/helpers/enums.dart';
import 'package:notebook_study/services/base_service.dart';
import 'package:notebook_study/models/category_model.dart';


class CategoryService  extends BaseService with ChangeNotifier, Initializable {
     
     late String collectionName = CollectionNames.categories.name;
     late List<CategoryModel> categories = [];

     
     categoriesChanged(List<CategoryModel> categories){
         this.categories = categories;
         notifyListeners();
     }
     
       @override
      Future<void> init() async {
          
          var props = new CategoryModel(-1, "", null, null).toJson();
          props.forEach((key, val){
              print("Prop name: $key, Prop type: ${val.runtimeType}");
          });

          if(categories.isEmpty){
            await getCategories();
          }
          categories.sort((a, b) => a.category.description.compareTo(b.category.description));
       }

      Future<bool> addCategory(CategoryModel item) async {
         try{
          
          item.id = categories.length + 1;
          final user = getUser();

          

          CollectionReference docCollection = getInstance().collection(collectionName);
          DocumentReference docRef = await docCollection.add(item.toJson());

          if(user != null){
            item.createdBy = getUserProfile();
            CollectionReference docUCollection = docRef.collection(CollectionNames.user_profiles.name);
            await docUCollection.add(item.createdBy!.toJson());
          }

          return true;
         }
         catch(ex){
          print(ex);
          return false;
         }
      }

      getCategories() async{
        try{
          var records = await getItems(CollectionNames.categories.name);
          categories = records.map((item) => CategoryModel.fromJson(item) ).toList();
          notifyListeners();
        }
        catch(ex){
          rethrow;
        }
      }

      updateCategory(CategoryModel item) async {
        try{
          await updateItem(CollectionNames.categories.name, item.id, item.toJson());
          // item.recordChanged(cat);
          var existing = categories.firstWhere((el) => el.id == item.id );
          categories.remove(existing);
          categories.add(item);
          notifyListeners();
        }
        catch(ex){
          rethrow;
        }
      }

      deleteCategory(CategoryModel item) async {
        try{
          await deleteItem(CollectionNames.categories.name, item.id);
          // item.recordChanged(cat);
          
          var existing = categories.firstWhere((el) => el.id == item.id );
          categories.remove(existing);
          notifyListeners();
        }
        catch(ex){
          print(ex);
          rethrow;
        }
      }
      
}