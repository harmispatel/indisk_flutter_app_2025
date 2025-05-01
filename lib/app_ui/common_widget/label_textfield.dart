import 'package:flutter/material.dart';
import 'package:indisk_app/utils/common_styles.dart';

class LabelTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;

  final String? hintText;

  final int? maxLines;
  final TextInputType? textInputType;

  final Function(String)?  onTextChange;

  const LabelTextField(
      {super.key,
      required this.controller,
      required this.label,
       this.onTextChange,
       this.textInputType,
      required this.hintText,this.maxLines});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label', style: getMediumTextStyle(
          fontSize: 20.0
        )),
        SizedBox(height: 10),
        TextFormField(
          controller: controller,
          maxLines: maxLines ?? null,
          keyboardType: textInputType ?? TextInputType.text,
          onChanged: onTextChange ?? (value){

          },
          decoration: InputDecoration(
            hintText: '$hintText',
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }
}
