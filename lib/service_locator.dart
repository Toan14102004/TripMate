import 'package:get_it/get_it.dart';
import 'package:trip_mate/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:trip_mate/features/auth/data/sources/auth_api_source.dart';
import 'package:trip_mate/features/auth/domain/repositories/auth_repository.dart';
import 'package:trip_mate/features/auth/domain/usecases/resend_token_usecase.dart';
import 'package:trip_mate/features/auth/domain/usecases/signin_usecase.dart';
import 'package:trip_mate/features/auth/domain/usecases/signup_usecase.dart';
import 'package:trip_mate/features/auth/domain/usecases/verify_usecase.dart';

GetIt sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // Services
  sl.registerSingleton<AuthApiSource>(AuthApiSource());

  // Repositories
  sl.registerSingleton<AuthRepository>(AuthRepositoryImpl());

  // Use Cases
  sl.registerSingleton<SignInUseCase>(SignInUseCase());
  sl.registerSingleton<SignUpUseCase>(SignUpUseCase());
  sl.registerSingleton<VerifyUseCase>(VerifyUseCase());
  sl.registerSingleton<ResendTokenUsecase>(ResendTokenUsecase());
}
