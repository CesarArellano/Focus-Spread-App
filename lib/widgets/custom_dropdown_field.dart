import 'package:flutter/material.dart';
import 'package:focus_spread/helpers/helpers.dart';

class CustomDropdownField<T> extends StatelessWidget {
  const CustomDropdownField({
    Key? key,
    required this.hintText,
    this.items,
    this.onChanged
  }) : super(key: key);

  final String hintText;
  final List<DropdownMenuItem<T>>? items;
  final void Function(T?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
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