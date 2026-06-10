import 'package:get_it/get_it.dart';
import '../data/repositories/auth_repository.dart';
import '../data/repositories/alerta_repository.dart';

final getIt = GetIt.instance;

Future<void> setupDependencyInjection() async {

  getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());
  getIt.registerLazySingleton<AlertaRepository>(() => AlertaRepositoryImpl());
}
