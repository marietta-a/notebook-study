import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:notebook_study/helpers/enums.dart';
import 'package:notebook_study/models/category_model.dart';
import 'package:notebook_study/screens/notifications/crud_notification.dart';
import 'package:notebook_study/screens/research_project/category_screen.dart';
import 'package:notebook_study/services/category_service.dart';
import 'package:provider/provider.dart';

class CategoryListScreen extends StatelessWidget {
  const CategoryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Category List'),
      ),
      body: Consumer<CategoryService>(
        builder: (context, CategoryService, child) {
          CategoryService.init();
          if(CategoryService.isAdmin()){

            return ListView.builder(
              itemCount: CategoryService.categories.length,
              itemBuilder: (context, index) {
                final category = CategoryService.categories[index];
                return ListTile(
                  title: Text(category.description),
                  subtitle: Text(category.description),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CategoryScreenForm(category: category),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          CategoryService.deleteCategory(category).then((res){
                            if(res){
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: CrudNotificationItem(actionMesage: CrudActionMessages.deleted.index ,))
                              );
                            }
                            else{
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: CrudNotificationItem(actionMesage: CrudActionMessages.error.index ,))
                              );
                            }
                        });
                        },
                      ),
                    ],
                  ),
                );
              },
            );

          }
          else{
            
          return ListView.builder(
            itemCount: CategoryService.categories.length,
            itemBuilder: (context, index) {
              final category = CategoryService.categories[index];
              return ListTile(
                title: Text(category.description),
                subtitle: Text(category.description)
              );
            },
          );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CategoryScreenForm(category: CategoryModel(-1, '', null, null)),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
