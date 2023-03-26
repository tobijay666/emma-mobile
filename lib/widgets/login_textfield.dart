import 'package:emma01/utils/textfield_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class LoginTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final FormFieldValidator<String> validator;
  final bool hasAsterisk;
  const LoginTextField(
      {Key? key,
      required this.controller,
      required this.hintText,
      required this.validator,
      this.hasAsterisk = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: hasAsterisk,
      validator: (value) {
        if (validator != null) {
          return validator(value);
        }
        // if (value == null || value.isEmpty) {
        //   return 'Please enter your email';
        // } else if (!value.contains('@')) {
        //   return 'Please enter a valid email';
        // }
        // return null;
      },
      controller: controller,
      decoration: InputDecoration(
        hintText: 'Enter Your Email',
        hintStyle: ThemeTextStyle.loginHiddenTextFieldStyle,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
