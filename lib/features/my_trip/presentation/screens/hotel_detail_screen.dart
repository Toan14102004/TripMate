import 'package:flutter/material.dart';
import '../widgets/common_appbar.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HotelDetailScreen extends StatelessWidget {
  const HotelDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: 'Hotel Details'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: CachedNetworkImage(imageUrl: 'https://picsum.photos/800/500?image=1055', height: 200, fit: BoxFit.cover),
          ),
          const SizedBox(height: 12),
          const Text('The Golden Beach', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Row(children: const [Icon(Icons.star, size: 16, color: Colors.orange), SizedBox(width: 6), Text('4.9')]),
          const SizedBox(height: 12),
          const Text('About Hotel', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('A lovely hotel with beach access and pool, ideal for family vacations.'),
        ],
      ),
    );
  }
}
