import 'package:get_it/get_it.dart';
import 'package:trip_mate/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:trip_mate/features/auth/data/sources/auth_api_source.dart';
import 'package:trip_mate/features/auth/domain/repositories/auth_repository.dart';
import 'package:trip_mate/features/auth/domain/usecases/resend_token_usecase.dart';
import 'package:trip_mate/features/auth/domain/usecases/signin_usecase.dart';
import 'package:trip_mate/features/auth/domain/usecases/signup_usecase.dart';
import 'package:trip_mate/features/auth/domain/usecases/verify_email_usecase.dart';
import 'package:trip_mate/features/auth/domain/usecases/verify_pass_usecase.dart';
import 'package:trip_mate/features/home/data/repositories/home_repository_impl.dart';
import 'package:trip_mate/features/home/data/sources/home_api_source.dart';
import 'package:trip_mate/features/home/domain/repositories/home_repository.dart';
import 'package:trip_mate/features/my_trip/data/repositories/my_trip_repository_impl.dart';
import 'package:trip_mate/features/my_trip/data/sources/my_trip_api_service.dart';
import 'package:trip_mate/features/my_trip/domain/repositories/my_trip_repository.dart';
import 'package:trip_mate/features/my_trip/domain/usecases/get_my_trip_usecase.dart';
import 'package:trip_mate/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:trip_mate/features/profile/data/sources/profile_api_source.dart';
import 'package:trip_mate/features/profile/domain/repositories/profile_repository.dart';
import 'package:trip_mate/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:trip_mate/features/profile/domain/usecases/logout_profile_usercase.dart';
import 'package:trip_mate/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:trip_mate/features/saved/data/repositories/saved_repository_impl.dart';
import 'package:trip_mate/features/saved/data/sources/saved_api_source.dart';
import 'package:trip_mate/features/saved/domain/repositories/saved_repository.dart';
import 'package:trip_mate/features/saved/domain/usecases/saved_usecase.dart';
import 'package:trip_mate/features/security/data/repositories/security_repository_impl.dart';
import 'package:trip_mate/features/security/data/sources/security_api_source.dart';
import 'package:trip_mate/features/security/domain/repositories/security_repository.dart';
import 'package:trip_mate/features/security/domain/usecases/New_password_usecase.dart';
import 'package:trip_mate/features/security/domain/usecases/reset_password_usecase.dart';
import 'package:trip_mate/features/wallet/data/repositories/wallet_repository_impl.dart';
import 'package:trip_mate/features/wallet/data/sources/wallet_api_source.dart';
import 'package:trip_mate/features/wallet/domain/repositories/wallet_repository.dart';
import 'package:trip_mate/features/wallet/domain/usecases/deposit_money_usecase.dart';
import 'package:trip_mate/features/wallet/domain/usecases/get_wallet_usecase.dart';
import 'package:trip_mate/services/location_service.dart';

GetIt sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // Services
  sl.registerSingleton<AuthApiSource>(AuthApiSource());
  sl.registerSingleton<SecurityApiSource>(SecurityApiSource());
  sl.registerSingleton<ProfileApiSource>(ProfileApiSource());
  sl.registerSingleton<SavedApiSource>(SavedApiSource());
  sl.registerSingleton<LocationService>(LocationService());
  sl.registerSingleton<MyTripApiService>(MyTripApiService());
  sl.registerSingleton<HomeApiSource>(HomeApiSource());
  sl.registerSingleton<WalletApiSource>(WalletApiSource());

  // Repositories
  sl.registerSingleton<AuthRepository>(AuthRepositoryImpl());
  sl.registerSingleton<SecurityRepository>(SecurityRepositoryImpl());
  sl.registerSingleton<ProfileRepository>(ProfileRepositoryImpl());
  sl.registerSingleton<SavedRepository>(SavedRepositoryImpl());
  sl.registerSingleton<MyTripRepository>(MyTripRepositoryImpl());
  sl.registerSingleton<HomeRepository>(HomeRepositoryImpl());
  sl.registerSingleton<WalletRepository>(WalletRepositoryImpl());
  
  // Use Cases
  sl.registerSingleton<SignUpUseCase>(SignUpUseCase());
  sl.registerSingleton<SignInUseCase>(SignInUseCase());
  sl.registerSingleton<VerifyPassUseCase>(VerifyPassUseCase());
  sl.registerSingleton<VerifyEmailUseCase>(VerifyEmailUseCase());
  sl.registerSingleton<ResendTokenUsecase>(ResendTokenUsecase());
  sl.registerSingleton<ResetPassUseCase>(ResetPassUseCase());
  sl.registerSingleton<NewPassUseCase>(NewPassUseCase());
  sl.registerSingleton<GetProfileUseCase>(GetProfileUseCase());
  sl.registerSingleton<UpdateProfileUseCase>(UpdateProfileUseCase());
  sl.registerSingleton<LogoutProfileUseCase>(LogoutProfileUseCase());
  sl.registerSingleton<GetSavedToursUseCase>(GetSavedToursUseCase());
  sl.registerSingleton<GetMyTripToursUseCase>(GetMyTripToursUseCase());
  sl.registerSingleton<GetWalletUseCase>(GetWalletUseCase());
  sl.registerSingleton<DepositMoneyUseCase>(DepositMoneyUseCase());

}
