import 'package:flutter/material.dart';
import 'package:trip_mate/features/home/data/sources/home_api_source.dart';
import 'package:trip_mate/features/home/domain/models/tour_model.dart';
import 'package:trip_mate/features/home/presentation/screens/package_detail_screen.dart';
import 'package:trip_mate/features/home/presentation/screens/popular_packages_screen.dart';
import 'popular_package_card.dart';

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

  void _navigateToDetail(TourModel package) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PackageDetailScreen(package: package),
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
              "Popular Packages",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PopularPackagesScreen(),
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
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: packages.length,
                itemBuilder: (context, index) {
                  final package = packages[index]; // package ở đây là một đối tượng TourModel
                  return GestureDetector(
                    onTap: () => _navigateToDetail(package),
                    child: PopularPackageCard(
                      image: package.image ?? '',
                      title: package.title,

                      // Sửa 'location' thành 'subtitle' và truyền dữ liệu phù hợp
                      subtitle: package.destination ?? 'N/A', // Hoặc 'Unknown Location', hoặc bất kỳ giá trị mặc định nếu destination là null

                      // Thêm tham số 'rating' và truyền giá trị từ TourModel
                      rating: package.rating ?? 0.0, // Nếu package.rating là null, dùng 0.0

                      // Tham số 'isBookmarked' là tùy chọn mặc định là false.
                      isBookmarked: package.isBookmarked ?? false,
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