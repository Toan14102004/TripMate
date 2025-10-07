import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../widgets/common_appbar.dart';
import '../widgets/included_chip.dart';
import '../../domain/entities/trip.dart';

class TripDetailScreen extends StatelessWidget {
  const TripDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final trip = ModalRoute.of(context)!.settings.arguments as Trip;

    return Scaffold(
      appBar: const CommonAppBar(title: ''),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: CachedNetworkImage(
              imageUrl: trip.imageUrl,
              height: 240,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: Text(trip.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
              Row(
                children: [
                  const CircleAvatar(radius: 14, backgroundImage: NetworkImage('https://picsum.photos/50')),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)]),
                    child: Row(children: [
                      const Icon(Icons.star, size: 14, color: Colors.orange),
                      const SizedBox(width: 6),
                      Text(trip.rating.toStringAsFixed(1), style: const TextStyle(fontWeight: FontWeight.bold)),
                    ]),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.place, color: Colors.red[300], size: 18),
              const SizedBox(width: 6),
              Text(trip.location, style: TextStyle(color: Colors.grey[700])),
            ],
          ),
          const SizedBox(height: 14),
          const Text('About Trip', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(trip.description, style: TextStyle(color: Colors.grey[700], height: 1.4)),
          const SizedBox(height: 16),
          const Text("What's Included?", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              IncludedChip(icon: Icons.flight, label: 'Flight'),
              IncludedChip(icon: Icons.drive_eta, label: 'Transfer'),
              IncludedChip(icon: Icons.hotel, label: 'Hotel'),
              IncludedChip(icon: Icons.restaurant, label: 'Food'),
            ],
          ),
          const SizedBox(height: 18),
          const Text('Image and Videos', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          SizedBox(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                ClipRRect(borderRadius: BorderRadius.circular(12), child: CachedNetworkImage(imageUrl: trip.imageUrl, width: 160, fit: BoxFit.cover)),
                const SizedBox(width: 10),
                ClipRRect(borderRadius: BorderRadius.circular(12), child: CachedNetworkImage(imageUrl: 'https://picsum.photos/200/100?image=1060', width: 120, fit: BoxFit.cover)),
                const SizedBox(width: 10),
                ClipRRect(borderRadius: BorderRadius.circular(12), child: CachedNetworkImage(imageUrl: 'https://picsum.photos/200/100?image=1031', width: 120, fit: BoxFit.cover)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text('Check in Map', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Container(
            height: 160,
            decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(14)),
            child: Center(child: Text('Map placeholder (add GoogleMap widget)')),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFE5E5), foregroundColor: Colors.red, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
              onPressed: () {},
              child: const Text('Cancel This Trip', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
