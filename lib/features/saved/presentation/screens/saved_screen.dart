import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trip_mate/commons/widgets/error_screen.dart';
import 'package:trip_mate/commons/widgets/loading_screen.dart';
import 'package:trip_mate/core/configs/theme/app_colors.dart';
import 'package:trip_mate/features/home/presentation/widgets/home_appbar.dart';
import 'package:trip_mate/features/saved/presentation/providers/saved_provider.dart';
import 'package:trip_mate/features/saved/presentation/providers/saved_state.dart';
import 'package:trip_mate/features/saved/presentation/widgets/category_list.dart';
import 'package:trip_mate/features/saved/presentation/widgets/saved_packages_section.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SavedCubit()..initialize(),
      child: BlocBuilder<SavedCubit, SavedState>(
        builder: (context, state) {
          if (state is SavedError) {
            return TravelErrorScreen(
              errorMessage: state.message,
              onRetry: () => context.read<SavedCubit>().initialize(),
            );
          }

          if (state is SavedToursData) {
            return Scaffold(
              backgroundColor: AppColors.lightBackground,
              body: SafeArea(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const HomeAppBar(title: "Saved"),
                      const SizedBox(height: 24),
                      const SavedPackagesSection(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          }

          return const TravelLoadingScreen();
        },
      ),
    );
  }
}
