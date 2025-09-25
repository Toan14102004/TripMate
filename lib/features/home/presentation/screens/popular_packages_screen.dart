import 'package:flutter/material.dart';
import '../../data/sources/home_api_source.dart';
import '../widgets/popular_package_card.dart';
import '../screens/package_detail_screen.dart';
import 'package:trip_mate/features/home/domain/models/tour_model.dart'; 

class PopularPackagesScreen extends StatefulWidget {
  const PopularPackagesScreen({super.key});

  @override
  State<PopularPackagesScreen> createState() => _PopularPackagesScreenState();
}

class _PopularPackagesScreenState extends State<PopularPackagesScreen> {
  late Future<List<TourModel>> _futurePopularPackages;
  String _sortType = 'Trending Now';

  @override
  void initState() {
    super.initState();
    _futurePopularPackages = HomeApiSource().fetchPopularPackages();
  }

  void _showSortPopup() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text('High Price'),
            onTap: () => Navigator.pop(context, 'High Price'),
          ),
          ListTile(
            title: const Text('Low Price'),
            onTap: () => Navigator.pop(context, 'Low Price'),
          ),
          ListTile(
            title: const Text('Trending Now'),
            onTap: () => Navigator.pop(context, 'Trending Now'),
          ),
        ],
      ),
    );
    if (selected != null) {
      setState(() {
        _sortType = selected;
      });
    }
  }

  List<TourModel> _sortPackages(List<TourModel> packages) {
    if (_sortType == 'High Price') {
      packages.sort((a, b) => (b.price ?? 0).compareTo(a.price ?? 0));
    } else if (_sortType == 'Low Price') {
      packages.sort((a, b) => (a.price ?? 0).compareTo(b.price ?? 0));
    } else if (_sortType == 'Trending Now') {
      packages.sort((a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0));
    }
    return packages;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular Packages'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: _showSortPopup,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Result found (80)', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Expanded(
              child: FutureBuilder<List<TourModel>>(
                future: _futurePopularPackages,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No popular packages'));
                  }
                  List<TourModel> packages = List.from(snapshot.data!);
                  packages = _sortPackages(packages);
                  return ListView.separated(
                    itemCount: packages.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final pkg = packages[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PackageDetailScreen(packageId: pkg.tourId),
                            ),
                          );
                        },
                        child: PopularPackageCard(
                          image: pkg.image ?? '',
                          title: pkg.title,
                          subtitle: pkg.subtitle ?? '',
                          rating: pkg.rating ?? 0,
                          isBookmarked: pkg.isBookmarked ?? false,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}