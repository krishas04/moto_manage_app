import 'package:flutter/material.dart';
import 'package:moto_manage/core/constants/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType? type;
  const CustomTextField({super.key, required this.controller,required this.label,this.type});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label :',
            style: TextStyle(),
          ),
          TextFormField(
            controller:controller,
            decoration: InputDecoration(
              hintText: "Enter your ${label.toLowerCase()}",
              enabledBorder: buildOutlineInputBorder(),
              focusedBorder:  buildOutlineInputBorder(),
            ),
            keyboardType: type,
            validator:(value)=> value==null || value.isEmpty ? "$label is Required": null,
          ),
        ],
      ),
    );
  }

  static OutlineInputBorder buildOutlineInputBorder() {
    return OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
                color: AppColors.darkGrey
            )
        );
  }
}
