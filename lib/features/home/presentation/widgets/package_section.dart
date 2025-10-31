import 'package:flutter/material.dart';
import 'package:trip_mate/features/home/data/sources/home_api_source.dart';
import 'package:trip_mate/features/home/presentation/screens/all_packages_screen.dart';
import 'package:trip_mate/features/home/presentation/screens/package_detail_screen.dart';
import 'package:trip_mate/features/home/presentation/widgets/package_card.dart';
import 'package:trip_mate/features/home/domain/models/tour_model.dart';

class PackageSection extends StatefulWidget {
  const PackageSection({super.key});

  @override
  State<PackageSection> createState() => _PackageSectionState();
}

class _PackageSectionState extends State<PackageSection> {
  late Future<List<TourModel>> _futurePackages;
  late Future<int> _totalPackages;

  @override
  void initState() {
    super.initState();

    final futureData = HomeApiSource().fetchAllPackages(limit: 4);
    _futurePackages = futureData.then((data) => data['tours'] as List<TourModel>);
    _totalPackages = futureData.then((data) => data['total'] as int);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FutureBuilder<int>(
              future: _totalPackages,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    "${snapshot.data} Packages",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  );
                }
                return const Text(
                  "... Packages",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                );
              },
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AllPackagesScreen(),
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
        AspectRatio(
          aspectRatio: 18 / 9,
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
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => PackageDetailScreen(tour: pkg),
                        ),
                      );
                    },
                    child: PackageCard(
                      image: pkg.image ?? '',
                      title: pkg.title,
                      location: pkg.destination ?? '',
                      price: '${pkg.reviewCount?.toStringAsFixed(0) ?? '0'} Reviews',
                      rating: pkg.rating ?? 0,
                    ),
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
