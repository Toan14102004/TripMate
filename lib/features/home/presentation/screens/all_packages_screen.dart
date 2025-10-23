import 'package:flutter/material.dart';
import 'package:trip_mate/features/home/data/sources/home_api_source.dart';
import 'package:trip_mate/features/home/domain/models/tour_model.dart';
import 'package:trip_mate/features/home/presentation/screens/package_detail_screen.dart';
import 'package:trip_mate/features/home/presentation/widgets/package_card.dart';
import 'package:trip_mate/features/home/presentation/widgets/search_bar.dart';

class AllPackagesScreen extends StatefulWidget {
  const AllPackagesScreen({super.key});

  @override
  State<AllPackagesScreen> createState() => _AllPackagesScreenState();
}

class _AllPackagesScreenState extends State<AllPackagesScreen> {
  late Future<Map<String, dynamic>> _futureAllPackages;
  final TextEditingController _searchController = TextEditingController();
  List<TourModel> _filteredPackages = [];

  @override
  void initState() {
    super.initState();
    _futureAllPackages = HomeApiSource().fetchAllPackages();
    _futureAllPackages.then((data) {
      setState(() {
        _filteredPackages = data['tours'] as List<TourModel>;
      });
    });
  }

  void _onSearchChanged(String query) {
    _futureAllPackages.then((data) {
      final packages = data['tours'] as List<TourModel>;
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
        title: const Text('All Packages'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SearchBarWidget(
              controller: _searchController,
              onChanged: _onSearchChanged,
              hintText: 'Search packages...',
            ),
          ),
          Expanded(
            child: FutureBuilder<Map<String, dynamic>>(
              future: _futureAllPackages,
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
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: _filteredPackages.length,
                  itemBuilder: (context, index) {
                    final pkg = _filteredPackages[index];
                    return GestureDetector(
                      onTap: () => _navigateToDetail(pkg),
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
      ),
    );
  }
}

