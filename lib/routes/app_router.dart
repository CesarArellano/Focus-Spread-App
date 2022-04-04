import 'package:flutter/material.dart';
import 'package:focus_spread/screens/friis_screen.dart';

import 'package:focus_spread/screens/screens.dart';
import 'package:focus_spread/models/menu_option.dart';

class AppRouter {
  static String initialRoute = 'home';

  static final Map<String, Widget Function(BuildContext)> routes = {
    'home': ( _ ) => const HomeScreen(),
    'friis': ( _ ) => const FriisScreen(),
    'two-rays': ( _ ) => const TwoRaysScreen(),
    'okumura': ( _ ) => const OkumuraScreen(),
    'okumura-hata': ( _ ) => const OkumuraHataScreen(),
  };

  static Route<dynamic> onGenerateRoute( RouteSettings settings ) {
    return MaterialPageRoute(
      builder: (_) => const HomeScreen()
    );
  }

  static final List<MenuOption> menuOptions = [
    MenuOption(route: 'friis', name: 'Modelo de Friis'),
    MenuOption(route: 'two-rays', name: 'Modelo de Dos Rayos'),
    MenuOption(route: 'okumura', name: 'Modelo de Okumura'),
    MenuOption(route: 'okumura-hata', name: 'Modelo de Okumura Hata'),
  ];
}