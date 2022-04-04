import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:focus_spread/helpers/helpers.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    required this.hintText,
    required this.controller,
    this.inputFormatters,
  }) : super(key: key);

  final String hintText;
  final TextEditingController controller;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'(^\-?\d*\.?\d*)')),
        NumberTextInputFormatter()
      ],
      controller: controller,
      decoration: Helpers.inputDecoration(hintText: hintText),
      keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
      validator: (value) {
        if( value == null || value.isEmpty ) return 'Valor requerido';
        return null;
      },
    );
  }
}

class NumberTextInputFormatter extends TextInputFormatter {
  NumberTextInputFormatter({ this.decimalRange = 4 }) : assert( decimalRange > 0 );

  final int decimalRange;

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    TextEditingValue _newValue = sanitize(newValue);
    String text = _newValue.text;

    if (text == '.') {
      return TextEditingValue(
        text: '0.',
        selection: _newValue.selection.copyWith(baseOffset: 2, extentOffset: 2),
        composing: TextRange.empty,
      );
    }

    return isValid(text) ? _newValue : oldValue;
  }

  bool isValid(String text) {
    int dots = '.'.allMatches(text).length;

    if (dots == 0) {
      return true;
    }

    if (dots > 1) {
      return false;
    }

    return text.substring(text.indexOf('.') + 1).length <= decimalRange;
  }

  TextEditingValue sanitize(TextEditingValue value) {
    if ( !value.text.contains('-') ) {
      return value;
    }

    String text = '-' + value.text.replaceAll('-', '');

    return TextEditingValue(text: text, selection: value.selection, composing: TextRange.empty);
  }
}