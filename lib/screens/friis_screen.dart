import 'package:flutter/material.dart';
import 'package:focus_spread/helpers/helpers.dart';

import 'package:focus_spread/theme/app_theme.dart';
import 'package:focus_spread/widgets/custom_text_field.dart';

class FriisScreen extends StatelessWidget {
  
  const FriisScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modelo de Friis'),
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

  final TextEditingController _frequencyCtrl = TextEditingController();
  final TextEditingController _distanceCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomTextField(
            controller: _frequencyCtrl,
            hintText: 'Ingrese frecuencia (MHz)',
          ),
          const SizedBox(height: 15),
          CustomTextField(
            controller: _distanceCtrl,
            hintText: 'Ingrese distancia (km)',
          ),
          const SizedBox(height: 15),
          MaterialButton(
            shape: const StadiumBorder(),
            color: AppTheme.primaryColor,
            child: const Padding(
              padding: EdgeInsets.all(15.0),
              child: Text('Calcular valor', style: TextStyle(color: Colors.white, fontSize: 14),),
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
    final double distance = double.tryParse(_distanceCtrl.text) ?? 0;

    final double propagationLossesResult = 32.44 + 20 * log10(distance) + 20 * log10(frequency);

    Helpers.showCustomDialog(
      context: context,
      title: 'Resultado',
      children: <Widget>[
        const Text('Pérdidas por trayectoria:'),
        Text('${ propagationLossesResult.isNaN ? 0 : propagationLossesResult.toStringAsFixed(4) } dB')
      ]
    );
  }
}