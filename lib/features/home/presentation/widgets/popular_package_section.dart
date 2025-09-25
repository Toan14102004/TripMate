import 'package:flutter/material.dart';
import 'package:trip_mate/features/home/data/sources/home_api_source.dart';
import 'popular_package_card.dart';
import 'package:trip_mate/features/home/domain/models/tour_model.dart'; 
import 'package:trip_mate/features/home/presentation/screens/popular_packages_screen.dart';

class PopularPackageSection extends StatefulWidget {
  const PopularPackageSection({super.key});

  @override
  State<PopularPackageSection> createState() => _PopularPackageSectionState();
}

class _PopularPackageSectionState extends State<PopularPackageSection> {
  late Future<List<TourModel>> _futurePopularPackages;

  @override
  void initState() {
    super.initState();
    _futurePopularPackages = HomeApiSource().fetchPopularPackages();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Popular Packages", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PopularPackagesScreen(),
                  ),
                );
              },
              child: const Text("See All", style: TextStyle(color: Colors.blue)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 180,
          child: FutureBuilder<List<TourModel>>(
            future: _futurePopularPackages,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No popular packages'));
              }
              final packages = snapshot.data!;
              return PageView.builder(
                itemCount: packages.length,
                itemBuilder: (context, index) {
                  final pkg = packages[index];
                  return PopularPackageCard(
                    image: pkg.image ?? '',
                    title: pkg.title,
                    subtitle: pkg.subtitle ?? '',
                    rating: pkg.rating ?? 0,
                    isBookmarked: pkg.isBookmarked ?? false,
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