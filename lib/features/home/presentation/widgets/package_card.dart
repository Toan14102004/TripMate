import 'package:flutter/material.dart';
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

    final Color cardBackgroundColor = isDarkMode ? Colors.grey.shade700 : Colors.white;
    const Color ratingTextColor =  Colors.black;

    const Color ratingContainerColor = Colors.white;

    final Color titleTextColor = isDarkMode ? Colors.white : Colors.black;
    final Color locationTextColor = isDarkMode ? Colors.white : Colors.grey.shade700;
    final Color priceTextColor = isDarkMode ? Colors.white : Colors.deepOrangeAccent;
    const Color starIconColor = Colors.orange;


    return Container(
      width: 160,
      height: 160,
      decoration: BoxDecoration(
        color: cardBackgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
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
                      height: 100,
                      width: 160,
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.broken_image, color: Colors.grey),
                    );
                  },
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: ratingContainerColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.star, color: starIconColor, size: 14),
                      const SizedBox(width: 2),
                      Text(
                        rating.toString(),
                        style: const TextStyle(
                          fontSize: 12,
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
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: titleTextColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  location,
                  style: TextStyle(
                    fontSize: 12,
                    color: locationTextColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  price,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
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
