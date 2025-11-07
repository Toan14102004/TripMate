import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:trip_mate/core/app_global.dart';
import 'package:trip_mate/core/configs/theme/app_theme.dart';
import 'package:trip_mate/core/ultils/toast_util.dart';
import 'package:trip_mate/features/auth/presentation/providers/verification/verification_provider.dart';
import 'package:trip_mate/features/choose_mode/presentation/bloc/theme_cubit.dart';
import 'package:trip_mate/features/home/presentation/providers/detail_cubit.dart';
import 'package:trip_mate/features/profile/presentation/providers/profile_bloc.dart';
import 'package:trip_mate/features/root/presentation/providers/page_bloc.dart';
import 'package:trip_mate/features/security/presentation/providers/new_password/new_password_bloc.dart';
import 'package:trip_mate/features/settings/presentation/providers/settings_bloc.dart';
import 'package:trip_mate/features/splash/presentation/screens/splash_screen.dart';
import 'package:trip_mate/features/wallet/presentation/providers/wallet_provider.dart';
import 'package:trip_mate/firebase_options.dart';
import 'package:trip_mate/routes/app_route.dart';
import 'package:trip_mate/service_locator.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
String path = '';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependencies();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
  );

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorageDirectory.web
        : HydratedStorageDirectory((await getTemporaryDirectory()).path),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ToastUtil.ensureInitialized();
    return MultiBlocProvider(
      providers: [
        BlocProvider<WalletCubit>(create: (context) => WalletCubit()),
        BlocProvider<NewPasswordCubit>(create: (context) => NewPasswordCubit()),
        BlocProvider<ThemeCubit>(create: (context) => ThemeCubit()),
        BlocProvider<VerificationCubit>(create:  (context) => VerificationCubit()),
        BlocProvider<PageCubit>(create: (context) => PageCubit()),
        BlocProvider<SettingsCubit>(create: (context) => SettingsCubit()),
        BlocProvider<ProfileCubit>(create: (context) => ProfileCubit()),
        BlocProvider<TourDetailCubit>(create: (context) => TourDetailCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, state) {
          return MaterialApp(
            navigatorKey: AppGlobal.navigatorKey,
            themeMode: state,
            builder: FToastBuilder(),
            darkTheme: AppTheme.darkTheme,
            debugShowCheckedModeBanner: false,
            routes: AppRoutes.routes,
            onGenerateRoute: (settings) => AppRoutes.onGenerateRoute(settings),
            title: 'Tralto',
            theme: AppTheme.lightTheme,
            home: const TravelSplashScreen(),
          );
        },
      ),
    );
  }
}
