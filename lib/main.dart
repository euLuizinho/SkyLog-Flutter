import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/dependency_injection.dart';
import 'core/theme/app_theme.dart';
import 'domain/viewmodels/auth_viewmodel.dart';
import 'domain/viewmodels/home_viewmodel.dart';
import 'domain/viewmodels/alertas_viewmodel.dart';
import 'domain/viewmodels/perfil_viewmodel.dart';
import 'presentation/navigation/app_router.dart';

const FirebaseOptions firebaseOptions = FirebaseOptions(
  apiKey: "AIzaSyBqfxCGLG3ADyStXqz3zAcI7zaWH6DfrGE",
  authDomain: "skylog-1fd35.firebaseapp.com",
  projectId: "skylog-1fd35",
  storageBucket: "skylog-1fd35.firebasestorage.app",
  messagingSenderId: "1079313725670",
  appId: "1:1079313725670:web:a37e78c70f98ecdb2a2327",
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(options: firebaseOptions);
  } catch (e) {
    debugPrint('Erro ao inicializar Firebase: $e');
  }

  await setupDependencyInjection();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthViewModel>(
          create: (_) => AuthViewModel(getIt()),
        ),
        ChangeNotifierProvider<HomeViewModel>(
          create: (_) => HomeViewModel(getIt()),
        ),
        ChangeNotifierProvider<AlertasViewModel>(
          create: (_) => AlertasViewModel(getIt()),
        ),
        ChangeNotifierProvider<PerfilViewModel>(
          create: (_) => PerfilViewModel(getIt()),
        ),
      ],
      child: const SkyLogAppHost(),
    );
  }
}

class SkyLogAppHost extends StatelessWidget {
  const SkyLogAppHost({super.key});

  @override
  Widget build(BuildContext context) {
    final authVm = context.watch<AuthViewModel>();
    final String tema = authVm.userProfile?.tema ?? 'claro';

    return MaterialApp(
      title: 'SkyLog Gestor',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,

      themeMode: tema.toLowerCase() == 'escuro' ? ThemeMode.dark : ThemeMode.light,
      initialRoute: AppRouter.login,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
