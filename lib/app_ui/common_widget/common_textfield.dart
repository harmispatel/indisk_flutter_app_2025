import 'package:flutter/material.dart';
import 'package:indisk_app/utils/common_colors.dart';

class CommonTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool enabled;
  final int? maxLines;
  final int? minLines;
  final InputBorder? border;
  final InputBorder? focusedBorder;
  final InputBorder? errorBorder;
  final Color? fillColor;
  final bool filled;
  final bool readOnly;

  const CommonTextField({
    Key? key,
    this.controller,
    this.hintText,
    this.labelText,
    this.obscureText = false,
    this.keyboardType,
    this.onChanged,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled = true,
    this.maxLines = 1,
    this.minLines,
    this.border,
    this.focusedBorder,
    this.errorBorder,
    this.fillColor,
    this.filled = false,
    this.readOnly = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      onChanged: onChanged,
      validator: validator,
      enabled: enabled,
      maxLines: maxLines,
      minLines: minLines,
      readOnly: readOnly,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        border: border ??
            OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                  color: CommonColors.primaryColor,
                  width: 2.0,
                )),
        focusedBorder: focusedBorder ??
            OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                  color: CommonColors.primaryColor,
                  width: 2.0,
                )),
        errorBorder: errorBorder ??
            OutlineInputBorder(
              borderSide: BorderSide(
                color: CommonColors.red,
                width: 2.0,
              ),
            ),
        filled: filled,
        fillColor: fillColor,
        // contentPadding: const EdgeInsets.symmetric(
        //   vertical: 12.0,
        //   horizontal: 16.0,
        // ),
      ),
    );
  }
}
