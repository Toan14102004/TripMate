import 'package:flutter/material.dart';
import 'package:trip_mate/features/home/domain/models/mock_tour_data.dart';
import 'package:trip_mate/features/home/data/sources/home_api_source.dart';
import 'package:trip_mate/features/home/presentation/widgets/package_card.dart';
import 'package:trip_mate/features/home/domain/models/tour_model.dart'; 

class PackageSection extends StatefulWidget {
  const PackageSection({super.key});

  @override
  State<PackageSection> createState() => _PackageSectionState();
}

class _PackageSectionState extends State<PackageSection> {
  late Future<List<TourModel>> _futurePackages;

  @override
  void initState() {
    super.initState();
    _futurePackages = HomeApiSource().fetchAllPackages();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text("122 Packages", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text("See All", style: TextStyle(color: Colors.blue)),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 210,
          child: FutureBuilder<List<TourModel>>(
            future: _futurePackages,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No packages found'));
              }
              final packages = snapshot.data!;
              return ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: packages.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final pkg = packages[index];
                  return PackageCard(
                    image: pkg.image ?? '',
                    title: pkg.title,
                    location: pkg.destination ?? '',
                    price: '\$${pkg.price?.toStringAsFixed(0) ?? '0'}/Night',
                    rating: pkg.rating ?? 0,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}