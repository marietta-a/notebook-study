// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:notebook_study/helpers/enums.dart';
import 'package:notebook_study/models/category_model.dart';
import 'package:notebook_study/screens/notifications/crud_notification_screen.dart';
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

  
  final _focusNode1 = FocusNode(); 

  @override
  void dispose() 
  {
    _focusNode1.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _description = widget.category!.description;
    _formKey = GlobalKey<FormState>();
    _controller = TextEditingController();
  }

  

  // void _setCursorPosition() {
  //   if (_focusNode.hasFocus) {
  //     _controller.selection = TextSelection.fromPosition(
  //       TextPosition(offset: _controller.text.length),
  //     );
  //   } else {
  //     // Request focus if not already focused
  //     FocusScope.of(context).requestFocus(_focusNode);
  //   }
  // }

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
            children: <Widget> [
              FocusScope(
                node: FocusScopeNode(),
                child: Column(
                  children: <Widget>[
                  TextFormField(
                      autofocus: true,
                      focusNode: _focusNode1,
                      initialValue: _description,
                      decoration: const InputDecoration(labelText: 'Description'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter description';
                        }
                        return null;
                      },
                      onSaved: (value) => _description = value!,
                    ),
                  ],
                )
              ),
              
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // _setCursorPosition();
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
                       final addResult = provider.addCategory(newCategory);
                       
                       
                       addResult.then((res){
                          if(res){
                            ScaffoldMessenger.of(context).showSnackBar(
                               SnackBar(content: CrudNotificationItem(actionMesage: CrudActionMessages.added.index ,))
                            );
                          }
                          else{
                            ScaffoldMessenger.of(context).showSnackBar(
                               SnackBar(content: CrudNotificationItem(actionMesage: CrudActionMessages.error.index ,))
                            );
                          }
                       });
                    } else {
                      final updatedCategory = CategoryModel(
                        widget.category!.id, 
                        _description,  
                        DateTime.now(),
                        widget.category!.createdBy
                      );
                      provider.init();
                      provider.updateCategory(updatedCategory).then((res){
                          if(res){
                            ScaffoldMessenger.of(context).showSnackBar(
                               SnackBar(content: CrudNotificationItem(actionMesage: CrudActionMessages.updated.index ,))
                            );
                          }
                          else{
                            ScaffoldMessenger.of(context).showSnackBar(
                               SnackBar(content: CrudNotificationItem(actionMesage: CrudActionMessages.error.index ,))
                            );
                          }
                       });
                    }

                       Navigator.pop(context);
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
