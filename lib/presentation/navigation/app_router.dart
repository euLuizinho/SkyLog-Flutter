import 'package:flutter/material.dart';
import '../screens/login_screen.dart';
import '../screens/main_navigation_screen.dart';
import '../screens/detalhe_alerta_screen.dart';

class AppRouter {
  static const String login = '/';
  static const String home = '/home';
  static const String alertas = '/alertas';
  static const String perfil = '/perfil';
  static const String detalheAlerta = '/alerta';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final name = settings.name;

    if (name == login) {
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => const LoginScreen(),
      );
    }

    if (name == home) {
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => const MainNavigationScreen(initialTab: 0),
      );
    }

    if (name == alertas) {
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => const MainNavigationScreen(initialTab: 1),
      );
    }

    if (name == perfil) {
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => const MainNavigationScreen(initialTab: 2),
      );
    }

    if (name != null && name.startsWith(detalheAlerta)) {
      final uri = Uri.parse(name);
      String? id;

      if (uri.pathSegments.length > 1) {
        id = uri.pathSegments[1];
      } else {
        id = uri.queryParameters['id'];
      }

      id ??= settings.arguments as String?;

      return MaterialPageRoute(
        settings: settings,
        builder: (_) => DetalheAlertaScreen(alertaId: id ?? ''),
      );
    }

    return MaterialPageRoute(
      settings: settings,
      builder: (_) => Scaffold(
        body: Center(
          child: Text('Caminho não encontrado: $name'),
        ),
      ),
    );
  }
}
