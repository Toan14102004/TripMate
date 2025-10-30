import 'package:flutter/material.dart';
import 'package:trip_mate/core/configs/theme/app_colors.dart';
import 'package:trip_mate/commons/helpers/is_dark_mode.dart';

class PackageCard extends StatelessWidget {
  final String image;
  final String title;
  final String location;
  final String price;
  final double rating;

  const PackageCard({
    super.key,
    required this.image,
    required this.title,
    required this.location,
    required this.price,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = context.isDarkMode;

    final Color cardBackgroundColor = isDarkMode ? Colors.grey.shade700 : AppColors.white;
    const Color ratingTextColor =  Colors.black;

    const Color ratingContainerColor = Colors.white;

    final Color titleTextColor = isDarkMode ? Colors.white : Colors.black;
    final Color locationTextColor = isDarkMode ? AppColors.grey500 : Colors.grey.shade700;
    final Color priceTextColor = isDarkMode ? AppColors.primary : Colors.deepOrangeAccent;
    const Color starIconColor = Colors.orange;


    return Container(
      width: 160,
      height: 200,
      decoration: BoxDecoration(
        color: cardBackgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  image,
                  height: 120,
                  width: 160,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 120,
                      width: 160,
                      color: AppColors.grey100,
                      child: const Icon(Icons.broken_image, color: AppColors.grey400),
                    );
                  },
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: ratingContainerColor,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadowLight,
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      const SizedBox(width: 3),
                      Text(
                        rating.toString(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: ratingTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: titleTextColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  location,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: locationTextColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  price,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: priceTextColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
