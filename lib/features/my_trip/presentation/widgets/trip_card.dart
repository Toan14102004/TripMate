import 'package:flutter/material.dart';
import '../../domain/entities/trip.dart';

class TripCard extends StatelessWidget {
  final Trip trip;

  const TripCard({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(trip.imageUrl, height: 180, width: double.infinity, fit: BoxFit.cover),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(trip.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(trip.location, style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.orange, size: 16),
                    const SizedBox(width: 4),
                    Text(trip.rating.toString()),
                    const Spacer(),
                    Text(trip.duration, style: const TextStyle(fontWeight: FontWeight.w500)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
