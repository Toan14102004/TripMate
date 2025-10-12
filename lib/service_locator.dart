import 'package:get_it/get_it.dart';
import 'package:trip_mate/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:trip_mate/features/auth/data/sources/auth_api_source.dart';
import 'package:trip_mate/features/auth/domain/repositories/auth_repository.dart';
import 'package:trip_mate/features/auth/domain/usecases/resend_token_usecase.dart';
import 'package:trip_mate/features/auth/domain/usecases/signin_usecase.dart';
import 'package:trip_mate/features/auth/domain/usecases/signup_usecase.dart';
import 'package:trip_mate/features/auth/domain/usecases/verify_email_usecase.dart';
import 'package:trip_mate/features/auth/domain/usecases/verify_pass_usecase.dart';
import 'package:trip_mate/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:trip_mate/features/profile/data/sources/profile_api_source.dart';
import 'package:trip_mate/features/profile/domain/repositories/profile_repository.dart';
import 'package:trip_mate/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:trip_mate/features/profile/domain/usecases/logout_profile_usercase.dart';
import 'package:trip_mate/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:trip_mate/features/security/data/repositories/security_repository_impl.dart';
import 'package:trip_mate/features/security/data/sources/security_api_source.dart';
import 'package:trip_mate/features/security/domain/repositories/security_repository.dart';
import 'package:trip_mate/features/security/domain/usecases/New_password_usecase.dart';
import 'package:trip_mate/features/security/domain/usecases/reset_password_usecase.dart';
import 'package:trip_mate/services/location_service.dart';

GetIt sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // Services
  sl.registerSingleton<AuthApiSource>(AuthApiSource());
  sl.registerSingleton<SecurityApiSource>(SecurityApiSource());
  sl.registerSingleton<ProfileApiSource>(ProfileApiSource());
  sl.registerSingleton<LocationService>(LocationService());

  // Repositories
  sl.registerSingleton<AuthRepository>(AuthRepositoryImpl());
  sl.registerSingleton<SecurityRepository>(SecurityRepositoryImpl());
  sl.registerSingleton<ProfileRepository>(ProfileRepositoryImpl());

  // Use Cases
  sl.registerSingleton<SignInUseCase>(SignInUseCase());
  sl.registerSingleton<SignUpUseCase>(SignUpUseCase());
  sl.registerSingleton<VerifyPassUseCase>(VerifyPassUseCase());
  sl.registerSingleton<VerifyEmailUseCase>(VerifyEmailUseCase());
  sl.registerSingleton<ResendTokenUsecase>(ResendTokenUsecase());
  sl.registerSingleton<ResetPassUseCase>(ResetPassUseCase());
  sl.registerSingleton<NewPassUseCase>(NewPassUseCase());
  sl.registerSingleton<GetProfileUseCase>(GetProfileUseCase());
  sl.registerSingleton<UpdateProfileUseCase>(UpdateProfileUseCase());
  sl.registerSingleton<LogoutProfileUseCase>(LogoutProfileUseCase());
}
