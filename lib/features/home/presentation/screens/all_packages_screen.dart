import 'package:flutter/material.dart';
import 'package:trip_mate/commons/log.dart';
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
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final HomeApiSource _apiSource = HomeApiSource();
  
  List<TourModel> _allPackages = [];
  List<TourModel> _filteredPackages = [];
  
  int _currentPage = 1;
  bool _isLoading = true;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  
  static const int _pageLimit = 6;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _isLoading = true;
      _currentPage = 1;
      _allPackages = [];
      _filteredPackages = [];
    });

    try {
      final data = await _apiSource.fetchAllPackages(page: 1, limit: _pageLimit);
      final tours = data['tours'] as List<TourModel>;
      final total = data['total'] as int;

      setState(() {
        _allPackages = tours;
        _filteredPackages = tours;
        _hasMore = tours.length >= _pageLimit;
        _isLoading = false;
      });
      
      logDebug('Loaded initial ${tours.length} packages, total: $total');
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      logDebug('Error loading initial data: $e');
    }
  }

  Future<void> _loadMore() async {
    // Prevent multiple simultaneous load more requests
    if (_isLoadingMore || !_hasMore || _searchController.text.isNotEmpty) {
      return;
    }

    setState(() {
      _isLoadingMore = true;
    });

    final nextPage = _currentPage + 1;
    logDebug('Loading page $nextPage');

    try {
      final data = await _apiSource.fetchAllPackages(page: nextPage, limit: _pageLimit);
      final newTours = data['tours'] as List<TourModel>;
      
      setState(() {
        _allPackages.addAll(newTours);
        _filteredPackages = _allPackages;
        _currentPage = nextPage;
        _hasMore = newTours.length >= _pageLimit;
        _isLoadingMore = false;
      });
      
      logDebug('Loaded ${newTours.length} more packages, total: ${_allPackages.length}');
    } catch (e) {
      setState(() {
        _isLoadingMore = false;
      });
      logDebug('Error loading more data: $e');
    }
  }

  void _onScroll() {
    if (_isBottom) {
      _loadMore();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    // Trigger load more when 200px from bottom
    return currentScroll >= (maxScroll - 200);
  }

  void _onSearchChanged(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredPackages = _allPackages;
      } else {
        _filteredPackages = _allPackages
            .where((pkg) =>
                pkg.title.toLowerCase().contains(query.toLowerCase()) ||
                (pkg.destination?.toLowerCase().contains(query.toLowerCase()) ?? false))
            .toList();
      }
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
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
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
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredPackages.isEmpty
                    ? const Center(child: Text('No packages found'))
                    : CustomScrollView(
                        controller: _scrollController,
                        slivers: [
                          SliverPadding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            sliver: SliverGrid(
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.75,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                              ),
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
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
                                childCount: _filteredPackages.length,
                              ),
                            ),
                          ),
                          // Loading indicator for load more
                          if (_isLoadingMore)
                            const SliverToBoxAdapter(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                            ),
                        ],
                      ),
          ),
        ],
      ),
    );
  }
}
