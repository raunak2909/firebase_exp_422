import 'package:flutter/material.dart';

InputDecoration myFieldDecoration({
  IconData? prefixIcon,
  required String hint,
  required String label,
  bool isPassword = false,
  bool isPasswordVisible = false,
  VoidCallback? onPasswordVisibilityTap
}){
  return InputDecoration(
    prefixIcon: prefixIcon != null? Icon(prefixIcon) : null,
    hintText: hint,
    labelText: label,
    suffixIcon: isPassword ? IconButton(onPressed: onPasswordVisibilityTap, icon: Icon(isPasswordVisible ? Icons.visibility : Icons.visibility_off)) : null,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(21),
    ),
  );
}

