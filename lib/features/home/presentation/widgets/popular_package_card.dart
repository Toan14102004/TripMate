import 'package:flutter/material.dart';

class PopularPackageCard extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;
  final double rating;
  final bool isBookmarked;

  const PopularPackageCard({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.rating,
    this.isBookmarked = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(
            image,
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          left: 16,
          bottom: 32,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star, color: Colors.orange, size: 16),
                    const SizedBox(width: 4),
                    Text(rating.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  shadows: [Shadow(color: Colors.black26, blurRadius: 4)],
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  shadows: [Shadow(color: Colors.black26, blurRadius: 4)],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          right: 16,
          bottom: 32,
          child: Icon(
            isBookmarked ? Icons.bookmark : Icons.bookmark_border,
            color: Colors.white,
            size: 28,
            shadows: const [Shadow(color: Colors.black26, blurRadius: 4)],
          ),
        ),
      ],
    );
  }
}