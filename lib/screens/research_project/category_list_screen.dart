import 'package:flutter/material.dart';
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
                        CategoryService.deleteCategory(category);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CategoryScreenForm(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
