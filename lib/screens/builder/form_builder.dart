// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:notebook_study/helpers/enums.dart';
import 'package:notebook_study/services/category_service.dart';
import 'package:provider/provider.dart';

class FormBuilder extends StatefulWidget {
  final Map<String, dynamic> item;
  final String formName;
  final int formMode;
  
  final VoidCallback commandSaveClicked; 
  
 const FormBuilder({super.key, required this.item, required this.formName, required this.formMode, required this.commandSaveClicked});


  @override
  _FormBuilderState createState() => _FormBuilderState();
}

class _FormBuilderState extends State<FormBuilder> {
  late GlobalKey<FormState> _formKey;

  
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
    _formKey = GlobalKey<FormState>();
  }


  @override
  Widget build(BuildContext context) {


    final provider = Provider.of<CategoryService>(context, listen: false);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(FormModes.values[widget.formMode] == FormModes.add ? 'Add ${widget.formName}' : 'Edit ${widget.formName}'),
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
                    children: widget.item.entries.map((entry){
                        dynamic initVal = widget.formMode == FormModes.add.index ? null : entry.value;
                        return  TextFormField(
                        autofocus: true,
                        focusNode: _focusNode1,
                        initialValue: initVal,
                        decoration: const InputDecoration(labelText: 'Description'),
                        validator: (initVal) {
                          if (initVal == null || initVal.isEmpty) {
                            return 'Please enter $entry.key';
                          }
                          return null;
                        },
                        onSaved: (value) => initVal = value!,
                        );
                      }).toList()
                    ),
                    
                  ),
                  
                  const SizedBox(height: 20),
                  ElevatedButton(
                      onPressed: () {
                        // _setCursorPosition();
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                            
                            widget.commandSaveClicked();
                            Navigator.pop(context);
                        }
                      },
                      child: Text(FormModes.values[widget.formMode] == FormModes.add ? 'Add ${widget.formName}' : 'Edit ${widget.formName}')
                      
                    )
                ])
              ),
          ),
        );
  }
}
