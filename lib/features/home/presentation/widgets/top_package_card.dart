import 'package:flutter/material.dart';
import 'package:trip_mate/commons/helpers/is_dark_mode.dart';

import 'package:flutter/material.dart';
import 'package:trip_mate/commons/helpers/is_dark_mode.dart'; // Giả sử helper này hoạt động đúng

class TopPackageCard extends StatelessWidget {
  final String image;
  final String title;
  final String location;
  final String price;
  final double rating;
  final String reviews;
  final bool isBookmarked;

  const TopPackageCard({
    super.key,
    required this.image,
    required this.title,
    required this.location,
    required this.price,
    required this.rating,
    required this.reviews,
    this.isBookmarked = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = context.isDarkMode;
    final Color titleTextColor = isDarkMode ? Colors.white : Colors.black; // Tiêu đề: Đen trong dark mode
    final Color locationTextColor = isDarkMode ? Colors.white : Colors.grey.shade700; // Vị trí: Đen nhạt trong dark mode
    final Color ratingTextColor = isDarkMode ? Colors.white : Colors.black87; // Rating: Đen trong dark mode
    final Color reviewsTextColor = isDarkMode ? Colors.white : Colors.grey.shade700; // Reviews: Đen nhạt trong dark mode
    final Color priceTextColor = isDarkMode ? Colors.white : Colors.deepOrange; // Giá: Đen trong dark mode

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey.shade700 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              image,
              width: 56,
              height: 56,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 56,
                  height: 56,
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.broken_image, color: Colors.grey),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: titleTextColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  location,
                  style: TextStyle(
                    fontSize: 12,
                    color: locationTextColor,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.orange, size: 14), // Giữ màu cam cho sao hoặc dùng starIconColor
                    const SizedBox(width: 2),
                    Text(
                      '$rating',
                      style: TextStyle(
                        fontSize: 12,
                        color: ratingTextColor,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '($reviews Reviews)',
                      style: TextStyle(
                        fontSize: 12,
                        color: reviewsTextColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Text(
            price,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: priceTextColor, // Áp dụng màu chữ giá
            ),
          ),
        ],
      ),
    );
  }
}
