import 'package:flutter/material.dart';
import 'package:notebook_study/models/drop_down_model.dart';

class DropdownScreen extends StatefulWidget {
  
  final List<String> items;
  final String title;
  final void Function(DropDownModel)  valueSelected;

  const DropdownScreen({super.key, required this.items, required this.title, required this.valueSelected});

  @override
  _DropdownScreenState createState() => _DropdownScreenState();
}

class _DropdownScreenState extends State<DropdownScreen> {
  // The selected value
  String? selectedValue;

  // The list of dropdown items

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Center(
        child: DropdownButton<String>(
          value: selectedValue, // Current selected value
          hint: Text(widget.title), // Placeholder text
          icon: const Icon(Icons.arrow_drop_down), // Dropdown arrow
          isExpanded: true, // Makes the dropdown width match the button
          items: widget.items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: (dynamic newValue) {
            setState(() {
              selectedValue = newValue; // Update the selected value
            });
             widget.valueSelected;
          },
        ),
      ),
    );
  }
}