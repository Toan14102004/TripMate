import 'package:flutter/material.dart';
import '../widgets/common_appbar.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HotelInfoScreen extends StatelessWidget {
  const HotelInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: 'The Enchanted Garden'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ClipRRect(borderRadius: BorderRadius.circular(18), child: CachedNetworkImage(imageUrl: 'https://picsum.photos/800/500?image=1066', height: 220, fit: BoxFit.cover)),
          const SizedBox(height: 12),
          const Text('\$200 / night', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(children: const [Icon(Icons.star, color: Colors.orange), SizedBox(width: 6), Text('4.6')]),
          const SizedBox(height: 14),
          const Text('About Hotel', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Enchanting garden hotel with ponds and cozy cottages...'),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFE5E5), foregroundColor: Colors.red, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))), child: const Text('Cancel This Hotel')),
        ],
      ),
    );
  }
}
