import 'package:flutter/material.dart';
import 'package:notebook_study/models/category_model.dart';
import 'package:notebook_study/services/category_service.dart';
import 'package:provider/provider.dart';

class CategoryScreenForm extends StatefulWidget {
  final CategoryModel? category;

  const CategoryScreenForm({super.key, this.category});

  @override
  _CategoryScreenFormState createState() => _CategoryScreenFormState();
}

class _CategoryScreenFormState extends State<CategoryScreenForm> {
  late GlobalKey<FormState> _formKey;
  late String _description;
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _description = widget.category!.description;
    _formKey = GlobalKey<FormState>();
    _controller = TextEditingController();
    _focusNode = FocusNode();
  }

  

  void _setCursorPosition() {
    if (_focusNode.hasFocus) {
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length),
      );
    } else {
      // Request focus if not already focused
      FocusScope.of(context).requestFocus(_focusNode);
    }
  }

  @override
  Widget build(BuildContext context) {

    final provider = Provider.of<CategoryService>(context, listen: false);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category!.id <= 0 ? 'Add Category' : 'Edit Category'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                autofocus: true,
                initialValue: _description,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter description';
                  }
                  return null;
                },
                onSaved: (value) => _description = value!,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _setCursorPosition();
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    if (widget.category!.id <= 0) {
                      final newCategory = CategoryModel(
                        widget.category!.id, 
                        _description, 
                        DateTime.now(),
                        null
                      );
                       provider.init();
                       provider.addCategory(newCategory);
                    } else {
                      final updatedCategory = CategoryModel(
                        widget.category!.id, 
                        _description,  
                        DateTime.now(),
                        widget.category!.createdBy
                      );
                      provider.init();
                      provider.updateCategory(updatedCategory);
                       Navigator.pop(context);
                    }

                  }
                },
                child: Text(widget.category!.id <= 0 ? 'Add Category' : 'Edit Category'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
