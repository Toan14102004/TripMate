import 'package:flutter/material.dart';
import 'package:trip_mate/core/configs/theme/app_colors.dart';
import 'package:trip_mate/features/home/data/sources/home_api_source.dart';
import 'package:trip_mate/core/ultils/toast_util.dart';

class PopularPackageCard extends StatefulWidget {
  final String image;
  final String title;
  final String subtitle;
  final double rating;
  final bool isBookmarked;
  final int tourId;

  const PopularPackageCard({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.rating,
    required this.tourId,
    this.isBookmarked = false,
  });

  @override
  State<PopularPackageCard> createState() => _PopularPackageCardState();
}

class _PopularPackageCardState extends State<PopularPackageCard> {
  late bool _isBookmarked;
  final HomeApiSource _apiSource = HomeApiSource();

  @override
  void initState() {
    super.initState();
    _isBookmarked = widget.isBookmarked;
  }

  Future<void> _toggleFavorite() async {
    if (_isBookmarked) return;

    setState(() {
      _isBookmarked = true;
    });

    final result = await _apiSource.toggleFavorite(widget.tourId);

    result.fold(
      (error) {
        // Error already handled by API source (shows toast)
        setState(() {
          _isBookmarked = false;
        });
      },
      (isFavorited) {
        setState(() {
          _isBookmarked = isFavorited;
        });
        if (isFavorited) {
          ToastUtil.showSuccessToast('Đã thêm vào danh sách yêu thích');
        } else {
          ToastUtil.showSuccessToast('Đã xóa khỏi danh sách yêu thích');
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withOpacity(0.12),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Image.network(
              widget.image,
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: AppColors.grey200,
                  child: const Icon(Icons.broken_image, color: AppColors.grey400),
                );
              },
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.6),
                  ],
                  stops: const [0.3, 0.6, 1.0],
                ),
              ),
            ),
            Positioned(
              left: 12,
              bottom: 12,
              right: 56,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, color: AppColors.warning, size: 14),
                        const SizedBox(width: 3),
                        Text(
                          widget.rating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            color: AppColors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      shadows: [Shadow(color: Colors.black38, blurRadius: 4)],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.subtitle,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      shadows: [Shadow(color: Colors.black38, blurRadius: 4)],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Positioned(
              right: 12,
              bottom: 12,
              child: GestureDetector(
                onTap: _toggleFavorite,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.95),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(8),
                  child:  Icon(
                          _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                          color: AppColors.primary,
                          size: 24,
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
