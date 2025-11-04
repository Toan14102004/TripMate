import 'package:flutter/material.dart';
import 'package:trip_mate/commons/log.dart';
import 'package:trip_mate/core/configs/theme/app_colors.dart';
import 'package:trip_mate/commons/helpers/is_dark_mode.dart';
import 'package:trip_mate/features/home/data/sources/home_api_source.dart';
import 'package:trip_mate/features/home/domain/models/tour_model.dart';
import 'package:trip_mate/features/home/presentation/screens/package_detail_screen.dart';
import 'package:trip_mate/features/home/presentation/widgets/popular_package_card.dart';
import 'package:trip_mate/features/home/presentation/widgets/search_bar.dart';

// ignore: must_be_immutable
class AllPackagesScreen extends StatefulWidget {
  String? orderBy;

  AllPackagesScreen({super.key, this.orderBy});

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

  // Filter parameters
  String? _selectedOrderBy;
  String? _selectedDomain;
  String? _selectedTime;
  String? _selectedDestination;

  int _activeFiltersCount = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _selectedOrderBy = widget.orderBy;
      _isLoading = true;
      _currentPage = 1;
      _allPackages = [];
      _filteredPackages = [];
    });

    _updateActiveFiltersCount();

    try {
      final data = await _apiSource.fetchFilteredPackages(
        page: 1,
        limit: _pageLimit,
        orderBy: _selectedOrderBy,
        domain: _selectedDomain,
        time: _selectedTime,
        destination: _selectedDestination,
      );
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
    if (_isLoadingMore || !_hasMore || _searchController.text.isNotEmpty) {
      return;
    }

    setState(() {
      _isLoadingMore = true;
    });

    final nextPage = _currentPage + 1;
    logDebug('Loading page $nextPage');

    try {
      final data = await _apiSource.fetchFilteredPackages(
        page: nextPage,
        limit: _pageLimit,
        orderBy: _selectedOrderBy,
        domain: _selectedDomain,
        time: _selectedTime,
        destination: _selectedDestination,
      );
      final newTours = data['tours'] as List<TourModel>;

      setState(() {
        _allPackages.addAll(newTours);
        _filteredPackages = _allPackages;
        _currentPage = nextPage;
        _hasMore = newTours.length >= _pageLimit;
        _isLoadingMore = false;
      });

      logDebug(
        'Loaded ${newTours.length} more packages, total: ${_allPackages.length}',
      );
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
        _filteredPackages =
            _allPackages
                .where(
                  (pkg) =>
                      pkg.title.toLowerCase().contains(query.toLowerCase()) ||
                      (pkg.destination?.toLowerCase().contains(
                            query.toLowerCase(),
                          ) ??
                          false),
                )
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

  void _updateActiveFiltersCount() {
    int count = 0;
    if (_selectedOrderBy != null) count++;
    if (_selectedDomain != null) count++;
    if (_selectedTime != null) count++;
    if (_selectedDestination != null) count++;
    setState(() {
      _activeFiltersCount = count;
    });
  }

  void _showFilterBottomSheet() {
    final isDark = context.isDarkMode;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => StatefulBuilder(
            builder: (context, setModalState) {
              return Container(
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkBackground : Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Handle bar
                    Container(
                      margin: const EdgeInsets.only(top: 12),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.grey600 : AppColors.grey300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),

                    // Header
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Bộ lọc',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          TextButton(
                            onPressed: () {
                              setModalState(() {
                                _selectedOrderBy = null;
                                _selectedDomain = null;
                                _selectedTime = null;
                                _selectedDestination = null;
                              });
                            },
                            child: const Text(
                              'Xóa tất cả',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Divider(
                      height: 1,
                      color: isDark ? AppColors.grey700 : AppColors.grey200,
                    ),

                    // Filter options
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Sort by
                          _FilterSection(
                            title: 'Sắp xếp theo',
                            child: Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                _FilterChip(
                                  label: 'Mới nhất',
                                  isSelected: _selectedOrderBy == 'newest',
                                  onTap: () {
                                    setModalState(() {
                                      _selectedOrderBy =
                                          _selectedOrderBy == 'newest'
                                              ? null
                                              : 'newest';
                                    });
                                  },
                                ),
                                _FilterChip(
                                  label: 'Đánh giá cao',
                                  isSelected: _selectedOrderBy == 'rating',
                                  onTap: () {
                                    setModalState(() {
                                      _selectedOrderBy =
                                          _selectedOrderBy == 'rating'
                                              ? null
                                              : 'rating';
                                    });
                                  },
                                ),
                                _FilterChip(
                                  label: 'Được đặt nhiều',
                                  isSelected: _selectedOrderBy == 'booking',
                                  onTap: () {
                                    setModalState(() {
                                      _selectedOrderBy =
                                          _selectedOrderBy == 'booking'
                                              ? null
                                              : 'booking';
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Domain
                          _FilterSection(
                            title: 'Miền',
                            child: Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                _FilterChip(
                                  label: 'Miền Bắc',
                                  isSelected: _selectedDomain == 'mb',
                                  onTap: () {
                                    setModalState(() {
                                      _selectedDomain =
                                          _selectedDomain == 'mb' ? null : 'mb';
                                    });
                                  },
                                ),
                                _FilterChip(
                                  label: 'Miền Trung',
                                  isSelected: _selectedDomain == 'mt',
                                  onTap: () {
                                    setModalState(() {
                                      _selectedDomain =
                                          _selectedDomain == 'mt' ? null : 'mt';
                                    });
                                  },
                                ),
                                _FilterChip(
                                  label: 'Miền Nam',
                                  isSelected: _selectedDomain == 'mn',
                                  onTap: () {
                                    setModalState(() {
                                      _selectedDomain =
                                          _selectedDomain == 'mn' ? null : 'mn';
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Duration
                          _FilterSection(
                            title: 'Thời gian',
                            child: Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                _FilterChip(
                                  label: '1 ngày',
                                  isSelected: _selectedTime == '1 ngày',
                                  onTap: () {
                                    setModalState(() {
                                      _selectedTime =
                                          _selectedTime == '1 ngày'
                                              ? null
                                              : '1 ngày';
                                    });
                                  },
                                ),
                                _FilterChip(
                                  label: '2 ngày 1 đêm',
                                  isSelected: _selectedTime == '2 ngày 1 đêm',
                                  onTap: () {
                                    setModalState(() {
                                      _selectedTime =
                                          _selectedTime == '2 ngày 1 đêm'
                                              ? null
                                              : '2 ngày 1 đêm';
                                    });
                                  },
                                ),
                                _FilterChip(
                                  label: '3 ngày 2 đêm',
                                  isSelected: _selectedTime == '3 ngày 2 đêm',
                                  onTap: () {
                                    setModalState(() {
                                      _selectedTime =
                                          _selectedTime == '3 ngày 2 đêm'
                                              ? null
                                              : '3 ngày 2 đêm';
                                    });
                                  },
                                ),
                                _FilterChip(
                                  label: '4 ngày 3 đêm',
                                  isSelected: _selectedTime == '4 ngày 3 đêm',
                                  onTap: () {
                                    setModalState(() {
                                      _selectedTime =
                                          _selectedTime == '4 ngày 3 đêm'
                                              ? null
                                              : '4 ngày 3 đêm';
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Destination
                          _FilterSection(
                            title: 'Điểm đến',
                            child: Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                _FilterChip(
                                  label: 'Đà Lạt',
                                  isSelected: _selectedDestination == 'Đà Lạt',
                                  onTap: () {
                                    setModalState(() {
                                      _selectedDestination =
                                          _selectedDestination == 'Đà Lạt'
                                              ? null
                                              : 'Đà Lạt';
                                    });
                                  },
                                ),
                                _FilterChip(
                                  label: 'Hà Nội',
                                  isSelected: _selectedDestination == 'Hà Nội',
                                  onTap: () {
                                    setModalState(() {
                                      _selectedDestination =
                                          _selectedDestination == 'Hà Nội'
                                              ? null
                                              : 'Hà Nội';
                                    });
                                  },
                                ),
                                _FilterChip(
                                  label: 'Hội An',
                                  isSelected: _selectedDestination == 'Hội An',
                                  onTap: () {
                                    setModalState(() {
                                      _selectedDestination =
                                          _selectedDestination == 'Hội An'
                                              ? null
                                              : 'Hội An';
                                    });
                                  },
                                ),
                                // Thêm các địa điểm mới
                                _FilterChip(
                                  label: 'Đà Nẵng',
                                  isSelected: _selectedDestination == 'Đà Nẵng',
                                  onTap: () {
                                    setModalState(() {
                                      _selectedDestination =
                                          _selectedDestination == 'Đà Nẵng'
                                              ? null
                                              : 'Đà Nẵng';
                                    });
                                  },
                                ),
                                _FilterChip(
                                  label: 'Vịnh Hạ Long',
                                  isSelected:
                                      _selectedDestination == 'Vịnh Hạ Long',
                                  onTap: () {
                                    setModalState(() {
                                      _selectedDestination =
                                          _selectedDestination == 'Vịnh Hạ Long'
                                              ? null
                                              : 'Vịnh Hạ Long';
                                    });
                                  },
                                ),
                                _FilterChip(
                                  label: 'Huế',
                                  isSelected: _selectedDestination == 'Huế',
                                  onTap: () {
                                    setModalState(() {
                                      _selectedDestination =
                                          _selectedDestination == 'Huế'
                                              ? null
                                              : 'Huế';
                                    });
                                  },
                                ),
                                _FilterChip(
                                  label: 'Ninh Bình',
                                  isSelected:
                                      _selectedDestination == 'Ninh Bình',
                                  onTap: () {
                                    setModalState(() {
                                      _selectedDestination =
                                          _selectedDestination == 'Ninh Bình'
                                              ? null
                                              : 'Ninh Bình';
                                    });
                                  },
                                ),
                                // Các địa điểm cũ
                                _FilterChip(
                                  label: 'Nha Trang',
                                  isSelected:
                                      _selectedDestination == 'Nha Trang',
                                  onTap: () {
                                    setModalState(() {
                                      _selectedDestination =
                                          _selectedDestination == 'Nha Trang'
                                              ? null
                                              : 'Nha Trang';
                                    });
                                  },
                                ),
                                _FilterChip(
                                  label: 'Phú Quốc',
                                  isSelected:
                                      _selectedDestination == 'Phú Quốc',
                                  onTap: () {
                                    setModalState(() {
                                      _selectedDestination =
                                          _selectedDestination == 'Phú Quốc'
                                              ? null
                                              : 'Phú Quốc';
                                    });
                                  },
                                ),
                                _FilterChip(
                                  label: 'Sapa',
                                  isSelected: _selectedDestination == 'Sapa',
                                  onTap: () {
                                    setModalState(() {
                                      _selectedDestination =
                                          _selectedDestination == 'Sapa'
                                              ? null
                                              : 'Sapa';
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Apply button
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _updateActiveFiltersCount();
                            _loadInitialData();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Áp dụng',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
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
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'All Packages',
          style: TextStyle(color: isDark ? AppColors.white : AppColors.black),
        ),
        centerTitle: true,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.filter_list_rounded),
                onPressed: _showFilterBottomSheet,
              ),
              if (_activeFiltersCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    child: Text(
                      '$_activeFiltersCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SearchBarWidget(
              controller: _searchController,
              onChanged: _onSearchChanged,
              hintText: 'Search packages...',
              onClick: _showFilterBottomSheet,
              actionFilterNumber: _activeFiltersCount,
            ),
          ),
          Expanded(
            child:
                _isLoading
                    ? const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.primary,
                        ),
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
                            color:
                                isDark ? AppColors.grey500 : AppColors.grey400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No packages found',
                            style: Theme.of(
                              context,
                            ).textTheme.titleMedium?.copyWith(
                              color:
                                  isDark
                                      ? AppColors.grey300
                                      : AppColors.grey600,
                            ),
                          ),
                        ],
                      ),
                    )
                    : CustomScrollView(
                      controller: _scrollController,
                      slivers: [
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          sliver: SliverGrid(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.8,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 16,
                                ),
                            delegate: SliverChildBuilderDelegate((
                              context,
                              index,
                            ) {
                              final pkg = _filteredPackages[index];
                              return GestureDetector(
                                onTap: () => _navigateToDetail(pkg),
                                child: Transform.scale(
                                  scale: 1.0,
                                  child: PopularPackageCard(
                                    image: pkg.image ?? '',
                                    title: pkg.title,
                                    subtitle: pkg.destination ?? 'N/A',
                                    rating: pkg.rating ?? 0.0,
                                    isBookmarked: pkg.isBookmarked ?? false, 
                                    tourId: pkg.tourId,
                                  ),
                                ),
                              );
                            }, childCount: _filteredPackages.length),
                          ),
                        ),
                        if (_isLoadingMore)
                          const SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 24),
                              child: Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.primary,
                                  ),
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

class _FilterSection extends StatelessWidget {
  final String title;
  final Widget child;

  const _FilterSection({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? AppColors.primary.withOpacity(0.15)
                  : (isDark ? AppColors.grey700 : AppColors.grey100),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color:
                isSelected
                    ? AppColors.primary
                    : (isDark ? AppColors.grey700 : AppColors.grey200),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color:
                isSelected
                    ? AppColors.primary
                    : (isDark ? AppColors.grey300 : AppColors.grey700),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
