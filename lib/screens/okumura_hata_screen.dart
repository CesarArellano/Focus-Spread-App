import 'dart:math';

import 'package:flutter/material.dart';
import 'package:focus_spread/helpers/helpers.dart';

import 'package:focus_spread/theme/app_theme.dart';
import 'package:focus_spread/widgets/custom_dropdown_field.dart';
import 'package:focus_spread/widgets/custom_text_field.dart';

class OkumuraHataScreen extends StatelessWidget {
  
  const OkumuraHataScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modelo de Okumura Hata'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 15),
                const Text(
                  'Ingrese los siguientes datos:',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 15),
                _CustomForm(),
              ],
            ),
          )
        ),
      ),
    );
  }
}

class _CustomForm extends StatelessWidget {
  
  _CustomForm({Key? key}):super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _frequencyCtrl = TextEditingController();
  final TextEditingController _heightRxCtrl = TextEditingController();
  final TextEditingController _heightTxCtrl = TextEditingController();
  final TextEditingController _distanceCtrl = TextEditingController();

  final Map<String, int> dropdownValue = {
    'cityType': 1,
  };

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomTextField(
            controller: _frequencyCtrl,
            hintText: 'Ingrese fc (MHz)',
          ),
          const SizedBox(height: 15),
          CustomTextField(
            controller: _heightTxCtrl,
            hintText: 'Ingrese Hte (m)',
          ),
          const SizedBox(height: 15),
          CustomTextField(
            controller: _heightRxCtrl,
            hintText: 'Ingrese Hre (m)',
          ),
          const SizedBox(height: 15),
          CustomTextField(
            controller: _distanceCtrl,
            hintText: 'Ingrese distancia (km)',
          ),
          const SizedBox(height: 20),
          CustomDropdownField(
            hintText: 'Tipo de ciudad',
            items: const <DropdownMenuItem<int>>[
              DropdownMenuItem( child: Text('Seleccione el tipo de ciudad') ),
              DropdownMenuItem( value: 1, child: Text('Ciudad pequeña') ),
              DropdownMenuItem( value: 2, child: Text('Ciudad grande') ),
            ],
            onChanged: (int? value) {
              dropdownValue['cityType'] = value ?? 1;
            },
          ),
          const SizedBox(height: 15),
          MaterialButton(
            shape: const StadiumBorder(),
            color: AppTheme.primaryColor,
            child:  const Padding(
              padding: EdgeInsets.all(15.0),
              child: Text('Calcular valores', style: TextStyle(color: Colors.white, fontSize: 14),),
            ),
            onPressed: () => validateAndShowResults(context: context)
          )
        ],
      ),
    );
  }

  void validateAndShowResults({
    required BuildContext context,
  }) {
    if( ! _formKey.currentState!.validate() ) return;

    FocusScope.of(context).unfocus();

    final double frequency = double.tryParse(_frequencyCtrl.text) ?? 0;
    final double heightTx = double.tryParse(_heightTxCtrl.text) ?? 0;
    final double heightRx = double.tryParse(_heightRxCtrl.text) ?? 0;
    final double distance = double.tryParse(_distanceCtrl.text) ?? 0;
    
    if( frequency < 150 || frequency > 1500 ) {
      Helpers.errorSnackBar(
        context: context,
        text: 'fc está fuera del rango válido'
      );
      return;
    }

    if( dropdownValue['cityType'] == 2 ) {
      if( frequency >= 300 ) {
        Helpers.errorSnackBar(
          context: context,
          text: 'fc está fuera del rango válido'
        );
        return;
      }
    }

    if( heightTx < 30 || heightTx > 200 ) {
      Helpers.errorSnackBar(
        context: context,
        text: 'Hte está fuera del rango válido'
      );
      return;
    }

    if( heightRx < 1 || heightRx > 10 ) {
      Helpers.errorSnackBar(
        context: context,
        text: 'Hre está fuera del rango válido'
      );
      return;
    }

    final double correctionFactor = _calculateCorrectionFactor(
      frequency: frequency,
      heightRx: heightRx,
      cityType:  dropdownValue['cityType']!
    );
    final double urbanPropagationLosses = 69.55 + 26.16 * log10(frequency) - 13.82 * log10(heightTx) - correctionFactor + (44.9 - 6.55 * log10(heightTx)) * log10(distance);
    final double suburbanPropagationLosses = urbanPropagationLosses - 2 * pow( log10( frequency / 28 ), 2 ) - 5.4;
    final double ruralPropagationLosses = urbanPropagationLosses - 4.78 * pow( log10( frequency ), 2 ) + 18.33 * log10(frequency) - 40.94;

    Helpers.showCustomDialog(
      context: context,
      title: 'Resultados',
      children: <Widget>[
        const Text('Factor de correción:'),
        Text('${ correctionFactor.toStringAsFixed(4) } dB'),
        const SizedBox(height: 10),
        const Text('Pérdidas de propagación Urbano:'),
        Text('${ urbanPropagationLosses.isNaN ? 0 : urbanPropagationLosses.toStringAsFixed(4) } dB'),
        const SizedBox(height: 10),
        const Text('Pérdidas de propagación Suburbano:'),
        Text('${ suburbanPropagationLosses.isNaN ? 0 : suburbanPropagationLosses.toStringAsFixed(4) } dB'),
        const SizedBox(height: 10),
        const Text('Pérdidas de propagación Rural:'),
        Text('${ ruralPropagationLosses.isNaN ? 0 : ruralPropagationLosses.toStringAsFixed(4) } dB'),
      ]
    );
  }

  double _calculateCorrectionFactor({
    required double frequency,
    required double heightRx,
    required int cityType 
  }) {
    return ( cityType == 1)
      ? ( 1.1 * log10(frequency) - 0.7 ) * heightRx - ( 1.56 * log10(frequency) - 0.8 )
      : ( 8.29 * pow( log10(1.54 * heightRx ), 2) ) - 1.1;
  }
}