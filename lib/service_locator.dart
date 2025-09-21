import 'package:get_it/get_it.dart';

GetIt sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // Services
  // sl.registerSingleton<AuthFirebaseService>(AuthFirebaseServiceImpl());

  // Repositories
  // sl.registerSingleton<Authrepository>(AuthRepositoryImpl());

  // Use Cases
  // sl.registerSingleton<SighupUsecase>(SighupUsecase());
}
