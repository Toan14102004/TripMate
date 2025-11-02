import 'package:flutter/material.dart';
import 'package:trip_mate/commons/log.dart';
import 'package:trip_mate/core/configs/theme/app_colors.dart';
import 'package:trip_mate/commons/helpers/is_dark_mode.dart';
import 'package:trip_mate/features/home/data/sources/home_api_source.dart';
import 'package:trip_mate/features/home/domain/models/tour_model.dart';
import 'package:trip_mate/features/home/presentation/screens/package_detail_screen.dart';
import 'package:trip_mate/features/home/presentation/widgets/popular_package_card.dart';
import 'package:trip_mate/features/home/presentation/widgets/search_bar.dart';
import 'package:trip_mate/features/home/presentation/widgets/top_package_card.dart';

class TopPackagesScreen extends StatefulWidget {
  const TopPackagesScreen({super.key});

  @override
  State<TopPackagesScreen> createState() => _TopPackagesScreenState();
}

class _TopPackagesScreenState extends State<TopPackagesScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final HomeApiSource _apiSource = HomeApiSource();
  
  List<TourModel> _allPackages = [];
  List<TourModel> _filteredPackages = [];
  
  int _currentPage = 1;
  bool _isLoading = true;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  
  static const int _pageLimit = 10;

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
      final data = await _apiSource.fetchTopPackages(page: 1, limit: _pageLimit);
      final tours = data['tours'] as List<TourModel>;
      final total = data['total'] as int;

      setState(() {
        _allPackages = tours;
        _filteredPackages = tours;
        _hasMore = tours.length >= _pageLimit;
        _isLoading = false;
      });
      
      logDebug('Loaded initial ${tours.length} top packages, total: $total');
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      logDebug('Error loading initial data: $e');
    }
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore || !_hasMore || _searchController.text.isNotEmpty) {
      return;
    }

    setState(() {
      _isLoadingMore = true;
    });

    final nextPage = _currentPage + 1;
    logDebug('Loading page $nextPage');

    try {
      final data = await _apiSource.fetchTopPackages(page: nextPage, limit: _pageLimit);
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
    final isDark = context.isDarkMode;
    
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Popular Packages'),
        centerTitle: true,
      ),
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
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
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                    ),
                  )
                : _filteredPackages.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off_rounded,
                              size: 64,
                              color: isDark ? AppColors.grey500 : AppColors.grey400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No popular packages found',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: isDark ? AppColors.grey300 : AppColors.grey600,
                              ),
                            ),
                          ],
                        ),
                      )
                    : CustomScrollView(
                        controller: _scrollController,
                        slivers: [
                          SliverPadding(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            sliver: SliverGrid(
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.85,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 16,
                              ),
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  final package = _filteredPackages[index];
                                  return GestureDetector(
                                    onTap: () => _navigateToDetail(package),
                                    child: PopularPackageCard(
                                      image: package.image ?? '',
                                      title: package.title,
                                      subtitle: package.destination ?? 'N/A',
                                      rating: package.rating ?? 0.0,
                                      isBookmarked: package.isBookmarked ?? false,
                                    ),
                                  );
                                },
                                childCount: _filteredPackages.length,
                              ),
                            ),
                          ),
                          if (_isLoadingMore)
                            const SliverToBoxAdapter(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 24),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                                  ),
                                ),
                              ),
                            ),
                          SliverToBoxAdapter(
                            child: SizedBox(height: _isLoadingMore ? 0 : 24),
                          ),
                        ],
                      ),
          ),
        ],
      ),
    );
  }
}
