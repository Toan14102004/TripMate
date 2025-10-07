import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'rating_badge.dart';

class TripCard extends StatelessWidget {
  final String id;
  final String title;
  final String subtitle;
  final String imageUrl;
  final double rating;
  final VoidCallback onTap;

  const TripCard({
    super.key,
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.rating,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(20.0);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 150,
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0,6))],
        ),
        child: ClipRRect(
          borderRadius: borderRadius,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                placeholder: (ctx, url) => Container(color: Colors.grey[200]),
                errorWidget: (ctx, url, err) => Container(color: Colors.grey[300], child: Icon(Icons.broken_image)),
              ),
              // gradient overlay at bottom
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: 70,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.black.withOpacity(0.55), Colors.transparent],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),
              ),
              // rating badge top-left
              Positioned(top: 10, left: 10, child: RatingBadge(rating: rating)),
              // bookmark icon bottom-right
              Positioned(
                bottom: 10,
                right: 10,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)]),
                  child: Icon(Icons.bookmark, size: 18, color: Colors.blue[700]),
                ),
              ),
              // text bottom-left
              Positioned(
                left: 14,
                bottom: 14,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
