import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart' hide Marker;
import 'package:trip_mate/commons/log.dart';
import 'package:trip_mate/core/configs/theme/app_colors.dart';
import 'package:trip_mate/commons/helpers/is_dark_mode.dart';
import 'package:trip_mate/core/ultils/toast_util.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import 'package:trip_mate/features/booking/data/sources/booking_api_source.dart';
import 'package:trip_mate/features/booking/domain/entities/start_end_date_model.dart';
import 'package:trip_mate/services/location_service.dart';
import 'package:url_launcher/url_launcher.dart';

class BookingTourScreen extends StatefulWidget {
  final int tourId;
  final int userId;
  final String tourTitle;

  const BookingTourScreen({
    super.key,
    required this.tourId,
    required this.userId,
    required this.tourTitle,
  });

  @override
  State<BookingTourScreen> createState() => _BookingTourScreenState();
}

class _BookingTourScreenState extends State<BookingTourScreen> {
  final _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();

  // Form controllers
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  // Booking data
  int? _selectedDateId;
  StartEndDate? _selectedDate;
  int _numAdults = 1;
  int _numChildren = 0;
  bool _receiveEmail = true;
  bool _findingLocation = false;
  // Start-End dates
  List<StartEndDate> _dates = [];
  int _currentPage = 1;
  bool _isLoadingDates = true;
  bool _isLoadingMore = false;
  bool _hasMoreDates = true;
  static const int _pageLimit = 4;

  bool _isMapVisible = false;
  LatLng? _mapCenter;
  Marker? _addressMarker;
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadDates();
    _mapCenter = const LatLng(21.028511, 105.804817);
  }

  Future<void> _geocodeAndShowMap() async {
    final address = _addressController.text.trim();
    if (address.isEmpty) {
      ToastUtil.showErrorToast('Vui lòng nhập địa chỉ trước!');
      return;
    }

    setState(() {
      _isMapVisible = true;
      _addressMarker = null;
    });

    try {
      List<Location> locations = await locationFromAddress(address);

      if (locations.isNotEmpty) {
        final location = locations.first;
        final newPosition = LatLng(location.latitude, location.longitude);

        setState(() {
          _mapCenter = newPosition;
          _addressMarker = Marker(
            point: newPosition,
            width: 80,
            height: 80,
            child: const Icon(
              Icons.location_pin,
              color: AppColors.error,
              size: 40,
            ),
          );
        });

        _mapController.move(newPosition, 16.0);
        ToastUtil.showSuccessToast('Đã tìm thấy vị trí trên bản đồ!');
      } else {
        ToastUtil.showErrorToast('Không tìm thấy tọa độ cho địa chỉ này.');
        setState(() {
          _isMapVisible = false;
        });
      }
    } catch (e) {
      ToastUtil.showErrorToast(
        'Lỗi tìm kiếm: Vui lòng kiểm tra địa chỉ và kết nối mạng.',
      );
      setState(() {
        _isMapVisible = false;
      });
    }
  }

  Future<void> _loadDates() async {
    setState(() {
      _isLoadingDates = true;
      _currentPage = 1;
      _dates = [];
    });

    try {
      // Call API to fetch start-end dates
      final data = await fetchStartEndDates(
        page: 1,
        limit: _pageLimit,
        tourId: widget.tourId.toString(),
      );

      final dates = data['dates'] as List<StartEndDateModel>;
      final total = data['total'] as int;

      setState(() {
        _dates =
            dates
                .map(
                  (model) => StartEndDate(
                    id: model.id,
                    startDate: model.startDate,
                    endDate: model.endDate,
                    priceAdult: model.priceAdult,
                    priceChildren: model.priceChildren,
                    availableSlots: model.availableSlots,
                  ),
                )
                .toList();
        _hasMoreDates = dates.length >= _pageLimit;
        _isLoadingDates = false;
      });

      logDebug('Loaded ${dates.length} dates, total: $total');
    } catch (e) {
      setState(() {
        _isLoadingDates = false;
      });
      logDebug('Error loading dates: $e');
    }
  }

  Future<void> _loadMoreDates() async {
    if (_isLoadingMore || !_hasMoreDates) return;

    setState(() {
      _isLoadingMore = true;
    });

    final nextPage = _currentPage + 1;

    try {
      await Future.delayed(const Duration(seconds: 1));
      final mockDates = List.generate(
        5,
        (i) => StartEndDate(
          id: (_currentPage * _pageLimit) + i + 1,
          startDate: DateTime.now().add(
            Duration(days: (_currentPage * 7 + i) * 7),
          ),
          endDate: DateTime.now().add(
            Duration(days: (_currentPage * 7 + i) * 7 + 3),
          ),
          priceAdult: 2000000 + ((_currentPage * 10 + i) * 100000),
          priceChildren: 1000000 + ((_currentPage * 10 + i) * 50000),
          availableSlots: 15 - i,
        ),
      );

      setState(() {
        _dates.addAll(mockDates);
        _currentPage = nextPage;
        _hasMoreDates = mockDates.length >= _pageLimit;
        _isLoadingMore = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingMore = false;
      });
      logDebug('Error loading more dates: $e');
    }
  }

  void _onScroll() {
    if (_isBottom) {
      _loadMoreDates();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll - 200);
  }

  double get _totalPrice {
    if (_selectedDate == null) return 0;
    return (_selectedDate!.priceAdult * _numAdults) +
        (_selectedDate!.priceChildren * _numChildren);
  }

  void _showDatePicker() {
    final isDark = context.isDarkMode;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Column(
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
                        'Chọn ngày khởi hành',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),

                Divider(
                  height: 1,
                  color: isDark ? AppColors.grey700 : AppColors.grey200,
                ),

                // Dates list
                Expanded(
                  child:
                      _isLoadingDates
                          ? const Center(child: CircularProgressIndicator())
                          : ListView.separated(
                            controller: _scrollController,
                            padding: const EdgeInsets.all(16),
                            itemCount: _dates.length + (_isLoadingMore ? 1 : 0),
                            separatorBuilder:
                                (context, index) => const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              if (index == _dates.length) {
                                return const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(16),
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }

                              final date = _dates[index];
                              final isSelected = _selectedDateId == date.id;

                              return _DateCard(
                                date: date,
                                isSelected: isSelected,
                                onTap: () {
                                  setState(() {
                                    _selectedDateId = date.id;
                                    _selectedDate = date;
                                  });
                                  Navigator.pop(context);
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

  Future<void> _submitBooking() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedDateId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn ngày khởi hành')),
      );
      return;
    }

    // TODO: Call API to create booking
    // final bookingData = {
    //   'tourId': widget.tourId,
    //   'userId': widget.userId,
    //   'dateId': _selectedDateId,
    //   'fullName': _fullNameController.text,
    //   'email': _emailController.text,
    //   'phoneNumber': _phoneController.text,
    //   'address': _addressController.text,
    //   'numAdults': _numAdults,
    //   'numChildren': _numChildren,
    //   'totalPrice': _totalPrice,
    //   'bookingStatus': 'pending',
    //   'receiveEmail': _receiveEmail,
    // };

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      Navigator.pop(context); // Close loading

      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text('Đặt tour thành công!'),
              content: const Text('Chúng tôi sẽ liên hệ với bạn sớm nhất.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close dialog
                    Navigator.pop(context); // Back to previous screen
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
      );
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Đặt tour'),
        centerTitle: true,
      ),
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tour info card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: isDark ? Colors.black26 : Colors.black12,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.tour, color: AppColors.primary, size: 24),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            widget.tourTitle,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                      ],
                    ),
                    if (_selectedDate != null) ...[
                      const SizedBox(height: 16),
                      Divider(
                        color: isDark ? AppColors.grey700 : AppColors.grey200,
                      ),
                      const SizedBox(height: 16),
                      _InfoRow(
                        icon: Icons.calendar_month,
                        label: 'Khởi hành',
                        value: _formatDate(_selectedDate!.startDate),
                      ),
                      const SizedBox(height: 8),
                      _InfoRow(
                        icon: Icons.event,
                        label: 'Kết thúc',
                        value: _formatDate(_selectedDate!.endDate),
                      ),
                      const SizedBox(height: 8),
                      _InfoRow(
                        icon: Icons.people,
                        label: 'Số chỗ còn',
                        value: '${_selectedDate!.availableSlots} chỗ',
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Select date button
              Text(
                'Ngày khởi hành *',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: _showDatePicker,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.surfaceDark : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color:
                          _selectedDate != null
                              ? AppColors.primary
                              : (isDark
                                  ? AppColors.grey600
                                  : AppColors.grey200),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color:
                            _selectedDate != null
                                ? AppColors.primary
                                : (isDark
                                    ? AppColors.grey500
                                    : AppColors.grey400),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _selectedDate != null
                              ? '${_formatDate(_selectedDate!.startDate)} - ${_formatDate(_selectedDate!.endDate)}'
                              : 'Chọn ngày khởi hành',
                          style: TextStyle(
                            color:
                                _selectedDate != null
                                    ? (isDark
                                        ? AppColors.white
                                        : AppColors.black)
                                    : (isDark
                                        ? AppColors.grey500
                                        : AppColors.grey400),
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: isDark ? AppColors.grey500 : AppColors.grey400,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Number of people
              Text(
                'Số lượng người',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _CounterCard(
                      label: 'Người lớn',
                      count: _numAdults,
                      onIncrement: () => setState(() => _numAdults++),
                      onDecrement: () {
                        if (_numAdults > 1) setState(() => _numAdults--);
                      },
                      price: _selectedDate?.priceAdult,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _CounterCard(
                      label: 'Trẻ em',
                      count: _numChildren,
                      onIncrement: () => setState(() => _numChildren++),
                      onDecrement: () {
                        if (_numChildren > 0) setState(() => _numChildren--);
                      },
                      price: _selectedDate?.priceChildren,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Contact information
              Text(
                'Thông tin liên hệ',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _fullNameController,
                decoration: const InputDecoration(
                  labelText: 'Họ và tên *',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập họ tên';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email *',
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập email';
                  }
                  if (!value.contains('@')) {
                    return 'Email không hợp lệ';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Số điện thoại *',
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập số điện thoại';
                  }
                  if (value.length < 10) {
                    return 'Số điện thoại không hợp lệ';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 4,
                    child: TextFormField(
                      onChanged: (value) {
                        setState(() {
                          _isMapVisible = false;
                        });
                      },
                      controller: _addressController,
                      decoration: const InputDecoration(
                        labelText: 'Địa chỉ',
                        prefixIcon: Icon(Icons.location_on),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 12,
                        ),
                      ),
                      maxLines: 1,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 3,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () async {
                          if (!_findingLocation) {
                            setState(() {
                              _isMapVisible = false;
                              _findingLocation = true;
                            });
                            final _locationService = LocationService();
                            String city =
                                await _locationService
                                    .getCurrentDetailLocation();
                            setState(() {
                              _addressController.text = city;
                              _findingLocation = false;
                            });
                          }
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Ink(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.primary,
                                AppColors.primary.withOpacity(0.8),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: !_findingLocation ? AppColors.primary.withOpacity(0.3) : AppColors.greyDark,
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 12,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.my_location,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    !_findingLocation ? 'Vị trí của tôi' : 'Finding...',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  if (_addressController.text.isEmpty) {
                    ToastUtil.showErrorToast('Please enter an address first!');
                  } else {
                    setState(() {
                      _isMapVisible = !_isMapVisible;
                    });
                    if (_isMapVisible) {
                      _geocodeAndShowMap();
                    }
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 52,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color:
                        context.isDarkMode ? AppColors.black : AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color:
                          _isMapVisible ? AppColors.error : AppColors.primary,
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: (_isMapVisible
                                ? AppColors.error
                                : AppColors.primary)
                            .withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      _isMapVisible ? 'Hide Map' : 'Show on Map',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color:
                            _isMapVisible ? AppColors.error : AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (_isMapVisible &&
                  _mapCenter != null &&
                  _addressController.text.isNotEmpty)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.primary, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadow,
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(
                        initialCenter: _mapCenter!,
                        initialZoom: 16.0,
                        interactionOptions: const InteractionOptions(
                          flags: InteractiveFlag.all,
                        ),
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png',
                          subdomains: const ['a', 'b', 'c', 'd'],
                          userAgentPackageName: 'com.example.trip_mate',
                        ),
                        MarkerLayer(
                          markers: [
                            if (_addressMarker != null) _addressMarker!,
                          ],
                        ),
                        RichAttributionWidget(
                          attributions: [
                            TextSourceAttribution(
                              'OpenStreetMap contributors',
                              onTap:
                                  () => launchUrl(
                                    Uri.parse(
                                      'https://openstreetmap.org/copyright',
                                    ),
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              if (_isMapVisible && _mapCenter != null)
                const SizedBox(height: 16),
              // Receive email checkbox
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : AppColors.grey50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Checkbox(
                      value: _receiveEmail,
                      onChanged: (value) {
                        setState(() {
                          _receiveEmail = value ?? true;
                        });
                      },
                      activeColor: AppColors.primary,
                    ),
                    Expanded(
                      child: Text(
                        'Nhận email xác nhận đặt tour',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Total price
              if (_selectedDate != null)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary.withOpacity(0.1),
                        AppColors.primary.withOpacity(0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tổng tiền',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$_numAdults người lớn + $_numChildren trẻ em',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                      Text(
                        '${_formatPrice(_totalPrice)} đ',
                        style: Theme.of(
                          context,
                        ).textTheme.headlineSmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 24),

              // Submit button
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _submitBooking,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Xác nhận đặt tour',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _formatPrice(double price) {
    return price
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }
}

// Models
class StartEndDate {
  final int id;
  final DateTime startDate;
  final DateTime endDate;
  final double priceAdult;
  final double priceChildren;
  final int availableSlots;

  StartEndDate({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.priceAdult,
    required this.priceChildren,
    required this.availableSlots,
  });
}

// Widgets
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            color: isDark ? AppColors.grey400 : AppColors.grey600,
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: isDark ? AppColors.white : AppColors.black,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _CounterCard extends StatelessWidget {
  final String label;
  final int count;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final double? price;

  const _CounterCard({
    required this.label,
    required this.count,
    required this.onIncrement,
    required this.onDecrement,
    this.price,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.grey700 : AppColors.grey200,
        ),
      ),
      child: Column(
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          if (price != null) ...[
            const SizedBox(height: 4),
            Text(
              '${_formatPrice(price!)} đ',
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _CounterButton(icon: Icons.remove, onTap: onDecrement),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  count.toString(),
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              _CounterButton(icon: Icons.add, onTap: onIncrement),
            ],
          ),
        ],
      ),
    );
  }

  String _formatPrice(double price) {
    return price
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }
}

class _CounterButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CounterButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppColors.primary, size: 20),
      ),
    );
  }
}

class _DateCard extends StatelessWidget {
  final StartEndDate date;
  final bool isSelected;
  final VoidCallback onTap;

  const _DateCard({
    required this.date,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? AppColors.primary.withOpacity(0.1)
                  : (isDark ? AppColors.darkBackground : AppColors.grey50),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                isSelected
                    ? AppColors.primary
                    : (isDark ? AppColors.grey700 : AppColors.grey200),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color:
                      isSelected
                          ? AppColors.primary
                          : (isDark ? AppColors.grey500 : AppColors.grey400),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${_formatDate(date.startDate)} - ${_formatDate(date.endDate)}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color:
                          isSelected
                              ? AppColors.primary
                              : (isDark ? AppColors.white : AppColors.black),
                    ),
                  ),
                ),
                if (isSelected)
                  const Icon(
                    Icons.check_circle,
                    color: AppColors.primary,
                    size: 24,
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Người lớn',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? AppColors.grey400 : AppColors.grey600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${_formatPrice(date.priceAdult)} đ',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Trẻ em',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? AppColors.grey400 : AppColors.grey600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${_formatPrice(date.priceChildren)} đ',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Còn trống',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? AppColors.grey400 : AppColors.grey600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color:
                            date.availableSlots > 10
                                ? AppColors.success.withOpacity(0.1)
                                : AppColors.warning.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${date.availableSlots} chỗ',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color:
                              date.availableSlots > 10
                                  ? AppColors.success
                                  : AppColors.warning,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}';
  }

  String _formatPrice(double price) {
    return price
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }
}
