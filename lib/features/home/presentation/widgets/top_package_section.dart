import 'package:flutter/material.dart';
import 'package:trip_mate/features/home/data/sources/home_api_source.dart';
import 'top_package_card.dart';
import 'package:trip_mate/features/home/domain/models/tour_model.dart'; 

class TopPackageSection extends StatefulWidget {
  const TopPackageSection({super.key});

  @override
  State<TopPackageSection> createState() => _TopPackageSectionState();
}

class _TopPackageSectionState extends State<TopPackageSection> {
  late Future<List<TourModel>> _futureTopPackages;

  @override
  void initState() {
    super.initState();
    _futureTopPackages = HomeApiSource().fetchTopPackages();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text("Top Packages", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text("See All", style: TextStyle(color: Colors.blue)),
          ],
        ),
        const SizedBox(height: 12),
        FutureBuilder<List<TourModel>>(
          future: _futureTopPackages,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No top packages'));
            }
            final packages = snapshot.data!;
            return Column(
              children: packages.map((pkg) => TopPackageCard(
                image: pkg.image ?? '',
                title: pkg.title,
                location: pkg.destination ?? '',
                price: '\$${pkg.price?.toStringAsFixed(0) ?? '0'}/Night',
                rating: pkg.rating ?? 0,
                reviews: pkg.reviewCount?.toString() ?? '0',
              )).toList(),
            );
          },
        ),
      ],
    );
  }
}