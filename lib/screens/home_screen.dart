import 'package:flutter/material.dart';
import 'package:focus_spread/routes/app_router.dart';

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
        separatorBuilder: ( _ , __) => const Divider( height: 0 ),
        itemCount: menuOptions.length,
        itemBuilder: ( _, int i) {
          final menuOption = menuOptions[i];
          return ListTile(
            trailing: const Icon(Icons.chevron_right),
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