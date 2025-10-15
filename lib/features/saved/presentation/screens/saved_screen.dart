import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trip_mate/commons/widgets/error_screen.dart';
import 'package:trip_mate/commons/widgets/loading_screen.dart';
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
          // Error state - full screen error
          if (state is SavedError) {
            return TravelErrorScreen(
              errorMessage: state.message,
              onRetry: () => context.read<SavedCubit>().initialize(),
            );
          }
          
          // Data state - show content
          if (state is SavedToursData) {
            return Scaffold(
              body: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const HomeAppBar(title: "Saved"),
                      const SizedBox(height: 20),
                      const CategoryList(),
                      const SizedBox(height: 24),
                      const SavedPackagesSection(),
                    ],
                  ),
                ),
              ),
            );
          }
          
          // Loading state - full screen loading
          return const TravelLoadingScreen();
        },
      ),
    );
  }
}
