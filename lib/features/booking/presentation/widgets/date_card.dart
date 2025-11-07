import 'package:flutter/material.dart';
import 'package:trip_mate/commons/helpers/is_dark_mode.dart';
import 'package:trip_mate/core/configs/theme/app_colors.dart';

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

class DateCard extends StatelessWidget {
  final StartEndDate date;
  final bool isSelected;
  final VoidCallback onTap;

  const DateCard({
    required this.date,
    required this.isSelected,
    required this.onTap,
  });

  bool get _isPastDate {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final startDay = DateTime(date.startDate.year, date.startDate.month, date.startDate.day);
    return startDay.isBefore(today);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final isPast = _isPastDate;

    return InkWell(
      onTap: isPast ? null : onTap,
      borderRadius: BorderRadius.circular(12),
      child: Opacity(
        opacity: isPast ? 0.5 : 1.0,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color:
                isPast
                    ? (isDark ? AppColors.grey700 : AppColors.grey100)
                    : (isSelected
                        ? AppColors.primary.withOpacity(0.1)
                        : (isDark ? AppColors.darkBackground : AppColors.grey50)),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color:
                  isPast
                      ? (isDark ? AppColors.grey700 : AppColors.grey300)
                      : (isSelected
                          ? AppColors.primary
                          : (isDark ? AppColors.grey700 : AppColors.grey200)),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    isPast ? Icons.event_busy : Icons.calendar_today,
                    color:
                        isPast
                            ? (isDark ? AppColors.grey600 : AppColors.grey400)
                            : (isSelected
                                ? AppColors.primary
                                : (isDark ? AppColors.grey500 : AppColors.grey400)),
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
                            isPast
                                ? (isDark ? AppColors.grey600 : AppColors.grey400)
                                : (isSelected
                                    ? AppColors.primary
                                    : (isDark ? AppColors.white : AppColors.black)),
                        decoration: isPast ? TextDecoration.lineThrough : null,
                      ),
                    ),
                  ),
                  if (isPast)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.error.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Đã qua',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.error,
                        ),
                      ),
                    )
                  else if (isSelected)
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
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isPast ? AppColors.grey500 : AppColors.primary,
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
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isPast ? AppColors.grey500 : AppColors.primary,
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
                              isPast
                                  ? (isDark ? AppColors.grey700 : AppColors.grey200)
                                  : (date.availableSlots > 10
                                      ? AppColors.success.withOpacity(0.1)
                                      : AppColors.warning.withOpacity(0.1)),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${date.availableSlots} chỗ',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color:
                                isPast
                                    ? AppColors.grey500
                                    : (date.availableSlots > 10
                                        ? AppColors.success
                                        : AppColors.warning),
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