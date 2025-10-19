import 'package:flutter/material.dart';
import 'package:trip_mate/features/home/data/sources/home_api_source.dart';
import 'package:trip_mate/features/home/domain/models/tour_model.dart';
import 'package:trip_mate/features/home/presentation/screens/package_detail_screen.dart';
import 'package:trip_mate/features/home/presentation/widgets/search_bar.dart';
import 'package:trip_mate/features/home/presentation/widgets/top_package_card.dart';

class TopPackagesScreen extends StatefulWidget {
  const TopPackagesScreen({super.key});

  @override
  State<TopPackagesScreen> createState() => _TopPackagesScreenState();
}

class _TopPackagesScreenState extends State<TopPackagesScreen> {
  late Future<List<TourModel>> _futureTopPackages;
  final TextEditingController _searchController = TextEditingController();
  List<TourModel> _filteredPackages = [];

  @override
  void initState() {
    super.initState();
    _futureTopPackages = HomeApiSource().fetchTopPackages();
    _futureTopPackages.then((packages) {
      setState(() {
        _filteredPackages = packages;
      });
    });
  }

  void _onSearchChanged(String query) {
    _futureTopPackages.then((packages) {
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
        builder: (context) => PackageDetailScreen(tour: package),
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
        title: const Text('Top Packages'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SearchBarWidget(
              controller: _searchController,
              onChanged: _onSearchChanged,
              hintText: 'Search top packages...',
            ),
          ),
          Expanded(
            child: FutureBuilder<List<TourModel>>(
              future: _futureTopPackages,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || _filteredPackages.isEmpty) {
                  return const Center(child: Text('No packages found'));
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _filteredPackages.length,
                  itemBuilder: (context, index) {
                    final package = _filteredPackages[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: GestureDetector(
                        onTap: () => _navigateToDetail(package),
                        child: TopPackageCard(
                          image: package.image ?? '',
                          title: package.title,
                          location: package.destination ?? '',
                          price: '\$${package.price?.toStringAsFixed(0) ?? '0'}/Night',
                          rating: package.rating ?? 0,
                          reviews: package.reviewCount?.toString() ?? '0',
                        ),
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
