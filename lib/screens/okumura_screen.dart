import 'package:flutter/material.dart';
import 'package:focus_spread/helpers/helpers.dart';

import 'package:focus_spread/theme/app_theme.dart';
import 'package:focus_spread/widgets/custom_text_field.dart';

class OkumuraScreen extends StatelessWidget {
  
  const OkumuraScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modelo de Okumura'),
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

  final TextEditingController _lossesFCtrl = TextEditingController();
  final TextEditingController _attenuationMuCtrl = TextEditingController();
  final TextEditingController _heightTxCtrl = TextEditingController();
  final TextEditingController _heightRxCtrl = TextEditingController();
  final TextEditingController _gainAreaCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomTextField(
            controller: _lossesFCtrl,
            hintText: 'Ingrese LF (dB)',
          ),
          const SizedBox(height: 15),
          CustomTextField(
            controller: _attenuationMuCtrl,
            hintText: 'Ingrese Amu (dB)',
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
            controller: _gainAreaCtrl,
            hintText: 'Ingrese Garea (dB)',
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

    final double lossesF = double.tryParse(_lossesFCtrl.text) ?? 0;
    final double attenuationMu = double.tryParse(_attenuationMuCtrl.text) ?? 0;
    final double heightRx = double.tryParse(_heightRxCtrl.text) ?? 0;
    final double heightTx = double.tryParse(_heightTxCtrl.text) ?? 0;
    final double gainArea = double.tryParse(_gainAreaCtrl.text) ?? 0;
    
    if( heightTx < 30 || heightTx > 1000 ) {
      Helpers.errorSnackBar(
        context: context,
        text: 'Hte está fuera del rango válido'
      );
      return;
    }

    if( heightRx < 0 || heightRx > 10 ) {
      Helpers.errorSnackBar(
        context: context,
        text: 'Hre está fuera del rango válido'
      );
      return;
    }

    final gainHte = 20 * log10( heightTx / 200 );
    final gainHre = ( heightRx < 3 ) ? 10 * log10( heightRx / 3 ) : 20 * log10( heightRx / 3 );

    final double propagationLossesResult = lossesF + attenuationMu - gainHte - gainHre - gainArea;

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