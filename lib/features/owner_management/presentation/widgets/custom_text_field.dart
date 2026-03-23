import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType? type;
  const CustomTextField({super.key, required this.controller,required this.label,this.type});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller:controller,
      decoration: InputDecoration(labelText: label),
      keyboardType: type,
      validator:(value)=> value==null || value.isEmpty ? "$label is Required": null,
    );
  }
}
