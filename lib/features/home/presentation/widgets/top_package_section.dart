import 'package:flutter/material.dart';
import 'package:trip_mate/features/home/data/sources/home_api_source.dart';
import 'package:trip_mate/features/home/domain/models/tour_model.dart';
import 'package:trip_mate/features/home/presentation/screens/package_detail_screen.dart';
import 'package:trip_mate/features/home/presentation/screens/top_packages_screen.dart';
import 'top_package_card.dart';

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

  void _navigateToDetail(TourModel package) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PackageDetailScreen(tour: package),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Top Packages",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TopPackagesScreen(),
                  ),
                );
              },
              child: const Text(
                "See All",
                style: TextStyle(color: Colors.blue),
              ),
            ),
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
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: packages.length > 2 ? 2 : packages.length,
              itemBuilder: (context, index) {
                final package = packages[index];
                return GestureDetector(
                  onTap: () => _navigateToDetail(package),
                  child: TopPackageCard(
                    image: package.image ?? '',
                    title: package.title,
                    location: package.destination ?? '',
                    price: '\$${package.price?.toStringAsFixed(0) ?? '0'}/Night',
                    rating: package.rating ?? 0,
                    reviews: package.reviewCount?.toString() ?? '0',
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}