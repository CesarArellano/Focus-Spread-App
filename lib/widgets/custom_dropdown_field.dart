import 'package:flutter/material.dart';
import 'package:focus_spread/helpers/helpers.dart';

class CustomDropdownField extends StatelessWidget {
  const CustomDropdownField({
    Key? key,
    required this.hintText,
    this.items,
    this.onChanged
  }) : super(key: key);

  final String hintText;
  final List<DropdownMenuItem<int>>? items;
  final void Function(int?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int>(
      decoration: Helpers.inputDecoration(hintText: hintText),
      items: items,
      validator: (value) {
        if( value == null ) return 'Valor requerido'; 
        return null;
      },
      onChanged: onChanged
    );
  }
}