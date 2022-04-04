import 'dart:math';

import 'package:flutter/material.dart';
import 'package:focus_spread/helpers/helpers.dart';

import 'package:focus_spread/theme/app_theme.dart';
import 'package:focus_spread/widgets/custom_text_field.dart';

class TwoRaysScreen extends StatelessWidget {
  
  const TwoRaysScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modelo de Dos Rayos'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 10),
                const Text(
                  'Ingrese los siguientes datos:',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 15),
                _CustomForm()
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

  final TextEditingController _inputPowerCtrl = TextEditingController();
  final TextEditingController _gainRxCtrl = TextEditingController();
  final TextEditingController _gainTxCtrl = TextEditingController();
  final TextEditingController _heightRxCtrl = TextEditingController();
  final TextEditingController _heightTxCtrl = TextEditingController();
  final TextEditingController _distanceCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomTextField(
            controller: _inputPowerCtrl,
            hintText: 'Ingrese Pt (Watts)',
          ),
          const SizedBox(height: 15),
          CustomTextField(
            controller: _gainRxCtrl,
            hintText: 'Ingrese Gr (dB)',
          ),
          const SizedBox(height: 15),
          CustomTextField(
            controller: _gainTxCtrl,
            hintText: 'Ingrese Gt (dB)',
          ),
          const SizedBox(height: 15),
          CustomTextField(
            controller: _heightRxCtrl,
            hintText: 'Ingrese Hr (m)',
          ),
          const SizedBox(height: 15),
          CustomTextField(
            controller: _heightTxCtrl,
            hintText: 'Ingrese Ht (m)',
          ),
          const SizedBox(height: 15),
          CustomTextField(
            controller: _distanceCtrl,
            hintText: 'Ingrese distancia (km)',
          ),
          const SizedBox(height: 10),
          MaterialButton(
            color: AppTheme.primaryColor,
            child: const Text('Calcular valores', style: TextStyle(color: Colors.white, fontSize: 14),),
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

    final double inputPower = double.tryParse(_inputPowerCtrl.text) ?? 0;
    final double gainRx = double.tryParse(_gainRxCtrl.text) ?? 0;
    final double gainTx = double.tryParse(_gainTxCtrl.text) ?? 0;
    final double heightRx = double.tryParse(_heightRxCtrl.text) ?? 0;
    final double heightTx = double.tryParse(_heightTxCtrl.text) ?? 0;
    final double distance = double.tryParse(_distanceCtrl.text) ?? 0;
    
    final double outputPowerResult = (inputPower * gainRx * gainTx * pow(heightRx, 2) * pow(heightTx, 2)) / pow(distance, 4);
    final double propagationLossesResult = 40 * log10(distance) - ( 10 * log10(gainTx) + 10 * log10(gainRx) + 20 * log10(heightTx) + 20 * log10(heightRx) );


    Helpers.showCustomDialog(
      context: context,
      title: 'Resultados',
      children: <Widget>[
        const Text('Potencia recibida:'),
        Text('$outputPowerResult W'),
        const SizedBox(height: 10),
        const Text('Pérdidas por trayectoria:'),
        Text('${ propagationLossesResult.isNaN ? 0 : propagationLossesResult } dB')
      ]
    );
  }
}