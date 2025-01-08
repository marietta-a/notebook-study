import 'package:flutter/foundation.dart';
import 'package:notebook_study/core/mixin.dart';
import 'package:notebook_study/helpers/enums.dart';
import 'package:notebook_study/models/user_profile.dart';
import 'package:notebook_study/services/base_service.dart';
import 'package:notebook_study/models/category_model.dart';


class CategoryService  extends BaseService with ChangeNotifier, Initializable {

     late List<CategoryModel> categories = [];

     
     categoriesChanged(List<CategoryModel> categories){
         this.categories = categories;
         notifyListeners();
     }
     
       @override
      Future<void> init() async {
          if(categories.isEmpty){
            await getCategories();
          }
       }

      addCategory(CategoryModel item) async {
         try{
          item.id = categories.length + 1;
          final user = getUser();
          item.createdBy = UserProfile(user?.uid, '', '', user?.displayName, user?.email, UserRoles.viewer.name);
          
          var cat = await addItem(CollectionNames.categories.name, item.toJson());
          // item.recordChanged(cat);
          categories.add(CategoryModel.fromJson(cat));
          notifyListeners();
         }
         catch(ex){
          rethrow;
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