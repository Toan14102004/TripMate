import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trip_mate/commons/widgets/error_screen.dart';
import 'package:trip_mate/commons/widgets/loading_screen.dart';
import 'package:trip_mate/features/home/presentation/widgets/home_appbar.dart';
import 'package:trip_mate/features/saved/presentation/providers/saved_provider.dart';
import 'package:trip_mate/features/saved/presentation/providers/saved_state.dart';
import 'package:trip_mate/features/saved/presentation/widgets/saved_packages_section.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<SavedCubit>().loadMore();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    // Trigger load more when 200px from bottom
    return currentScroll >= (maxScroll - 200);
  }

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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: HomeAppBar(title: "Saved"),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: state.tours.isEmpty
                          ? const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.bookmark_border,
                                    size: 64,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'Data is empty',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : SingleChildScrollView(
                              controller: _scrollController,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SavedPackagesSection(),
                                  // Show loading indicator when loading more
                                  if (state.isLoadingMore)
                                    const Padding(
                                      padding: EdgeInsets.symmetric(vertical: 16),
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                    ),
                  ],
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
