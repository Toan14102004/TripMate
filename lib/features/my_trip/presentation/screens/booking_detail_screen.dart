import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trip_mate/commons/helpers/is_dark_mode.dart';
import 'package:trip_mate/core/configs/theme/app_colors.dart';
import 'package:intl/intl.dart';
import 'package:trip_mate/features/home/domain/models/tour_model.dart';
import 'package:trip_mate/features/home/presentation/screens/package_detail_screen.dart';
import 'package:trip_mate/features/my_trip/data/sources/my_trip_api_service.dart';
import 'package:trip_mate/features/my_trip/domain/entities/trip.dart';
import 'package:trip_mate/features/my_trip/presentation/widgets/confirm_dialog.dart';
import 'package:trip_mate/features/wallet/presentation/providers/wallet_provider.dart';

class BookingDetailScreen extends StatefulWidget {
  final int bookingId;

  const BookingDetailScreen({super.key, required this.bookingId});

  @override
  State<BookingDetailScreen> createState() => _BookingDetailScreenState();
}

class _BookingDetailScreenState extends State<BookingDetailScreen> {
  bool _isLoading = true;
  BookingDetail? _bookingDetail;
  String? _errorMessage;
  double? _currentBalance;

  @override
  void initState() {
    super.initState();
    _loadBookingDetail();
  }

  Future<void> _loadBookingDetail() async {
    double currentBalance = await context.read<WalletCubit>().getUserBalance();
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _currentBalance = currentBalance;
    });

    try {
      final tripDetail = await MyTripApiService.fetchTripsDetail(
        bookingId: widget.bookingId.toString(),
      );

      if (tripDetail != null) {
        setState(() {
          _bookingDetail = tripDetail;
          _errorMessage = null;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Không thể tải thông tin booking';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Không thể tải thông tin booking';
        _isLoading = false;
      });
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return AppColors.success;
      case 'pending':
        return AppColors.warning;
      case 'cancelled':
        return AppColors.error;
      case 'completed':
        return AppColors.info;
      default:
        return AppColors.grey500;
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return 'Đã xác nhận';
      case 'pending':
        return 'Chờ xác nhận';
      case 'cancelled':
        return 'Đã hủy';
      case 'completed':
        return 'Hoàn thành';
      default:
        return status;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Icons.check_circle;
      case 'pending':
        return Icons.pending;
      case 'cancelled':
        return Icons.cancel;
      case 'completed':
        return Icons.verified;
      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Chi tiết đặt tour'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadBookingDetail,
          ),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _errorMessage != null
              ? _buildErrorWidget()
              : _buildContent(isDark),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: AppColors.error),
          const SizedBox(height: 16),
          Text(_errorMessage!, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _loadBookingDetail,
            icon: const Icon(Icons.refresh),
            label: const Text('Thử lại'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(bool isDark) {
    final booking = _bookingDetail!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status Badge
          _buildStatusBadge(booking.bookingStatus, isDark),

          const SizedBox(height: 20),

          // Booking ID Card
          _buildInfoCard(
            isDark: isDark,
            child: Row(
              children: [
                Icon(Icons.confirmation_number, color: AppColors.primary),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mã đặt tour',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? AppColors.grey400 : AppColors.grey600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '#${booking.bookingId}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.copy, size: 20),
                  onPressed: () {
                    Clipboard.setData(
                      ClipboardData(text: booking.bookingId.toString()),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Đã sao chép mã booking')),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Tour Information
          _buildSectionTitle('Thông tin tour', Icons.tour, isDark),
          const SizedBox(height: 12),
          _buildTourCard(booking.tour, isDark),

          const SizedBox(height: 20),

          // Date Information
          _buildSectionTitle('Lịch trình', Icons.calendar_month, isDark),
          const SizedBox(height: 12),
          _buildDateCard(booking.date, isDark),

          const SizedBox(height: 20),

          // Customer Information
          _buildSectionTitle('Thông tin khách hàng', Icons.person, isDark),
          const SizedBox(height: 12),
          _buildCustomerCard(booking, isDark),

          const SizedBox(height: 20),

          // Booking Details
          _buildSectionTitle('Chi tiết đặt tour', Icons.receipt_long, isDark),
          const SizedBox(height: 12),
          _buildBookingDetailsCard(booking, isDark),

          const SizedBox(height: 20),

          // Price Summary
          _buildPriceSummary(booking, isDark),

          const SizedBox(height: 24),

          // Action Buttons
          if (booking.bookingStatus.toLowerCase() == 'pending')
            _buildActionButtons(isDark),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status, bool isDark) {
    final color = _getStatusColor(status);
    final text = _getStatusText(status);
    final icon = _getStatusIcon(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon, bool isDark) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.white : AppColors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard({required bool isDark, required Widget child}) {
    return Container(
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
      child: child,
    );
  }

  Widget _buildTourCard(TourInfo tour, bool isDark) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => PackageDetailScreen(
                  tour: TourModel(tourId: tour.tourId, title: ""),
                ),
          ),
        );
      },
      child: _buildInfoCard(
        isDark: isDark,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                tour.image,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    color: AppColors.grey300,
                    child: const Icon(Icons.image_not_supported, size: 64),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Text(
              tour.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.location_on, tour.destination),
            const SizedBox(height: 8),
            _buildInfoRow(Icons.access_time, tour.time),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.star, color: AppColors.warning, size: 18),
                const SizedBox(width: 4),
                Text(
                  '${tour.starAvg}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 8),
                Text(
                  '(${tour.reviewCount} đánh giá)',
                  style: TextStyle(
                    color: isDark ? AppColors.grey400 : AppColors.grey600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateCard(DateInfo date, bool isDark) {
    return _buildInfoCard(
      isDark: isDark,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ngày khởi hành',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? AppColors.grey400 : AppColors.grey600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDate(date.startDate),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward, color: AppColors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Ngày kết thúc',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? AppColors.grey400 : AppColors.grey600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDate(date.endDate),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(color: isDark ? AppColors.grey700 : AppColors.grey200),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildPriceItem('Người lớn', date.priceAdult, isDark),
              ),
              Expanded(
                child: _buildPriceItem('Trẻ em', date.priceChildren, isDark),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceItem(String label, double price, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? AppColors.grey400 : AppColors.grey600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${_formatPrice(price)} đ',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildCustomerCard(BookingDetail booking, bool isDark) {
    return _buildInfoCard(
      isDark: isDark,
      child: Column(
        children: [
          _buildInfoRow(Icons.person, booking.fullName),
          const SizedBox(height: 12),
          _buildInfoRow(Icons.email, booking.email),
          const SizedBox(height: 12),
          _buildInfoRow(Icons.phone, booking.phoneNumber),
          const SizedBox(height: 12),
          _buildInfoRow(Icons.location_on, booking.address),
        ],
      ),
    );
  }

  Widget _buildBookingDetailsCard(BookingDetail booking, bool isDark) {
    return _buildInfoCard(
      isDark: isDark,
      child: Column(
        children: [
          _buildDetailRow(
            'Ngày đặt',
            _formatDateTime(booking.bookingDate),
            isDark,
          ),
          const SizedBox(height: 12),
          _buildDetailRow('Số người lớn', '${booking.numAdults} người', isDark),
          const SizedBox(height: 12),
          _buildDetailRow('Số trẻ em', '${booking.numChildren} người', isDark),
          const SizedBox(height: 12),
          _buildDetailRow(
            'Mã coupon',
            booking.codeCoupon ?? 'Không có',
            isDark,
          ),
          const SizedBox(height: 12),
          _buildDetailRow(
            'Nhận email xác nhận',
            booking.receiveEmail ? 'Có' : 'Không',
            isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isDark ? AppColors.grey400 : AppColors.grey600,
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildPriceSummary(BookingDetail booking, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withOpacity(0.1),
            AppColors.primary.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tổng tiền',
                style: TextStyle(
                  fontSize: 16,
                  color: isDark ? AppColors.grey300 : AppColors.grey700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${booking.numAdults} người lớn + ${booking.numChildren} trẻ em',
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? AppColors.grey400 : AppColors.grey600,
                ),
              ),
            ],
          ),
          Text(
            '${_formatPrice(booking.totalPrice)} đ',
            style: const TextStyle(
              fontSize: 24,
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(bool isDark) {
    return Column(
      children: [
        if (_bookingDetail!.bookingStatus == 'confirmed') ...[
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton.icon(
              onPressed: () {
                _showCancelDialog();
              },
              icon: const Icon(Icons.cancel),
              label: const Text(
                'Hủy đặt tour',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
        if (_bookingDetail!.bookingStatus == 'pending') ...[
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton.icon(
              onPressed: () {
                _showDeleteDialog();
              },
              icon: const Icon(Icons.cancel),
              label: const Text(
                'Xoá booking',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
        SizedBox(
          width: double.infinity,
          height: 54,
          child: OutlinedButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return PaymentConfirmationDialog(
                    currentBalance: _currentBalance ?? 0,
                    totalAmount: _bookingDetail!.totalPrice,
                    onConfirm: () {
                      MyTripApiService.payCoins(
                        bookingId: _bookingDetail!.bookingId,
                        amount: _bookingDetail!.totalPrice,
                      );
                    },
                    isDarkMode: context.isDarkMode,
                  );
                },
              );
            },
            icon: const Icon(
              Icons.monetization_on_rounded,
              color: AppColors.primary,
            ),
            label: const Text(
              'Trả tiền',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  void _showCancelDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Xác nhận hủy'),
            content: const Text(
              'Bạn có chắc chắn muốn hủy đặt tour này không?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Không'),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await MyTripApiService.cancelTripsDetail(
                    bookingId: widget.bookingId.toString(),
                  );
                  _loadBookingDetail();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đã hủy đặt tour thành công')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                ),
                child: const Text('Hủy tour'),
              ),
            ],
          ),
    );
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder:
          (BuildContext dialogContext) => AlertDialog(
            title: const Text('Xác nhận xoá'),
            content: const Text(
              'Bạn có chắc chắn muốn hủy đặt tour này không?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Không'),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(dialogContext);

                  await MyTripApiService.deleteTrips(
                    bookingId: widget.bookingId.toString(),
                  );
                  if (mounted) {
                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Đã hủy đặt tour thành công'),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                ),
                child: const Text('Hủy tour'),
              ),
            ],
          ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  String _formatDateTime(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
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
