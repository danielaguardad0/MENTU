import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool obscure;
  final TextInputType keyboardType;

  const CustomInput({
    Key? key,
    required this.controller,
    required this.label,
    this.obscure = false,
    this.keyboardType = TextInputType.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: label,
      ),
    );
  }
}
