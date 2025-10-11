import 'package:flutter/material.dart';
import 'package:trip_mate/features/home/data/sources/home_api_source.dart';
import 'package:trip_mate/features/home/domain/models/tour_model.dart';
import 'package:trip_mate/features/home/presentation/screens/package_detail_screen.dart';
import 'package:trip_mate/features/home/presentation/widgets/popular_package_card.dart';
import 'package:trip_mate/features/home/presentation/widgets/search_bar.dart';

class PopularPackagesScreen extends StatefulWidget {
  const PopularPackagesScreen({super.key});

  @override
  State<PopularPackagesScreen> createState() => _PopularPackagesScreenState();
}

class _PopularPackagesScreenState extends State<PopularPackagesScreen> {
  late Future<List<TourModel>> _futurePopularPackages;
  final TextEditingController _searchController = TextEditingController();
  List<TourModel> _filteredPackages = [];

  @override
  void initState() {
    super.initState();
    _futurePopularPackages = HomeApiSource().fetchPopularPackages();
    _futurePopularPackages.then((packages) {
      setState(() {
        _filteredPackages = packages;
      });
    });
  }

  void _onSearchChanged(String query) {
    _futurePopularPackages.then((packages) {
      setState(() {
        _filteredPackages = packages
            .where((pkg) =>
                pkg.title.toLowerCase().contains(query.toLowerCase()) ||
                (pkg.destination?.toLowerCase().contains(query.toLowerCase()) ?? false))
            .toList();
      });
    });
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
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular Packages'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SearchBarWidget(
              controller: _searchController,
              onChanged: _onSearchChanged,
              hintText: 'Search popular packages...',
            ),
          ),
          Expanded(
            child: FutureBuilder<List<TourModel>>(
              future: _futurePopularPackages,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || _filteredPackages.isEmpty) {
                  return const Center(child: Text('No packages found'));
                }
                return GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: _filteredPackages.length,
                  itemBuilder: (context, index) {
                    final package = _filteredPackages[index]; // package ở đây là một đối tượng TourModel
                    return GestureDetector(
                      onTap: () => _navigateToDetail(package),
                      child: PopularPackageCard(
                        image: package.image ?? '',
                        title: package.title,

                        //  'location' -> 'subtitle' và truyền dữ liệu phù hợp
                        subtitle: package.destination ?? 'N/A', // Hoặc 'Unknown Location'

                        // Thêm tham số 'rating' (bắt buộc) và truyền giá trị từ TourModel
                        rating: package.rating ?? 0.0, // Nếu package.rating là null, dùng 0.0

                        // Tham số 'isBookmarked' là tùy chọn, mặc định là false.
                        isBookmarked: package.isBookmarked ?? false,
                      ),
                    );
                  },

                );
              },
            ),
          ),
        ],
      ),
    );
  }
}