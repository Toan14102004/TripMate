import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trip_mate/features/saved/presentation/providers/saved_provider.dart';
import 'package:trip_mate/features/saved/presentation/providers/saved_state.dart';
import 'saved_package_card.dart';

class SavedPackagesSection extends StatefulWidget {
  final String? title;
  final TextStyle? titleStyle;
  
  const SavedPackagesSection({
    super.key,
    this.title,
    this.titleStyle,
  });

  @override
  State<SavedPackagesSection> createState() => _SavedPackagesSectionState();
}

class _SavedPackagesSectionState extends State<SavedPackagesSection> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SavedCubit, SavedState>(
      builder: (context, state) {
        // Only handle SavedToursData state here
        // Loading and Error states are handled at screen level
        if (state is SavedToursData) {
          final savedTours = state.tours;
          final displayTitle = widget.title ?? 'Result found (${savedTours.length})';
          
          // Empty state - show friendly message
          if (savedTours.isEmpty) {
            return Center(
              child: Column(
                children: [
                  const Icon(
                    Icons.bookmark_border,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No saved tours yet',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Start exploring and save your favorite tours!',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }
          
          // Has data - show list
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Text(
                  displayTitle,
                  style: widget.titleStyle ?? const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: savedTours.length,
                itemBuilder: (context, index) {
                  final tour = savedTours[index];
                  return SavedPackageCard(
                    key: ValueKey(tour.tourId),
                    image: tour.image,
                    title: tour.title,
                    subtitle: tour.subtitle,
                    rating: tour.rating,
                    isBookmarked: tour.isBookmarked,
                    onBookmarkToggle: () {
                      // Remove tour from list when bookmark is toggled
                      context.read<SavedCubit>().removeTour(tour.tourId);
                    },
                  );
                },
              ),
            ],
          );
        }
        
        // Default fallback (should never reach here)
        return const SizedBox.shrink();
      },
    );
  }
}

