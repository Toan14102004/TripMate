import 'package:flutter/material.dart';
import 'package:trip_mate/features/saved/domain/models/saved_tour_data.dart';
import 'package:trip_mate/features/saved/domain/models/saved_tour_model.dart';
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
  late List<SavedTourModel> _savedTours;

  @override
  void initState() {
    super.initState();
    // Create a copy of the saved tours list to manage state
    _savedTours = List.from(savedTours);
  }

  void _removeItem(int index) {
    setState(() {
      _savedTours.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final displayTitle = widget.title ?? 'Result found (${_savedTours.length})';
    
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
          itemCount: _savedTours.length,
          itemBuilder: (context, index) {
            final tour = _savedTours[index];
            return SavedPackageCard(
              key: ValueKey(tour.tourId), // Add unique key to track widget identity
              image: tour.image,
              title: tour.title,
              subtitle: tour.subtitle,
              rating: tour.rating,
              isBookmarked: tour.isBookmarked,
              onBookmarkToggle: () {
                // Remove item from saved list when bookmark is toggled
                _removeItem(index);
              },
            );
          },
        ),
      ],
    );
  }
}

