import 'package:flutter/material.dart';

class FormComponents extends StatelessWidget {
  FormComponents({
    super.key,
    this.textInputType = TextInputType.emailAddress,
    this.hide = false,
  });

  TextInputType textInputType;
  bool hide;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: textInputType,
      obscureText: hide,
      decoration: InputDecoration(
        suffixIcon: hide ? Icon(Icons.remove_red_eye_rounded) : null,
        border: OutlineInputBorder(),
      ),
    );
  }
}
