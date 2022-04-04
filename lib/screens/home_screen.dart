import 'package:flutter/material.dart';
import 'package:focus_spread/routes/app_router.dart';
import 'package:focus_spread/theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final menuOptions = AppRouter.menuOptions;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Modelos de Propagación'),
      ),
      body: ListView.separated(
        physics: const BouncingScrollPhysics(),
        separatorBuilder: ( _ , __) => const Divider( height: 0, thickness: 1, ),
        itemCount: menuOptions.length,
        itemBuilder: ( _, int i) {
          final menuOption = menuOptions[i];
          return ListTile(
            contentPadding: const EdgeInsets.all(10),
            trailing: const Icon(Icons.chevron_right, color: AppTheme.primaryColor),
            title: Text( menuOption.name ),
            onTap: () {
              Navigator.pushNamed(context, menuOption.route );
            },
          );
        },
      )
    );
  }
}