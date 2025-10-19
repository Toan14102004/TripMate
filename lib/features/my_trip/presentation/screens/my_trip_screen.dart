import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trip_mate/commons/helpers/is_dark_mode.dart';
import 'package:trip_mate/commons/widgets/error_screen.dart';
import 'package:trip_mate/commons/widgets/loading_screen.dart';
import 'package:trip_mate/core/configs/theme/app_colors.dart';
import 'package:trip_mate/features/home/domain/models/tour_model.dart';
import 'package:trip_mate/features/home/presentation/screens/package_detail_screen.dart';
import 'package:trip_mate/features/my_trip/presentation/providers/my_trip_provider.dart';
import 'package:trip_mate/features/my_trip/presentation/providers/my_trip_state.dart';
import 'package:trip_mate/routes/app_route.dart';
import '../../domain/entities/trip.dart';

class MyTripScreen extends StatelessWidget {
  const MyTripScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MyTripCubit()..initialize(),
      child: BlocBuilder<MyTripCubit, MyTripState>(
        builder: (context, state) {
          if (state is MyTripLoading)
            return const TravelLoadingScreen();
          else if (state is MyTripToursData) {
            return Scaffold(
              backgroundColor:
                  context.isDarkMode
                      ? AppColors.black
                      : AppColors.lightBackground,
              appBar: AppBar(
                elevation: 0,
                backgroundColor:
                    context.isDarkMode
                        ? AppColors.black
                        : AppColors.lightBackground,
                centerTitle: true,
                title: Text(
                  "MyTrip",
                  style: TextStyle(
                    color:
                        !context.isDarkMode
                            ? AppColors.black
                            : AppColors.lightBackground,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                leading: const Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                      'https://i.pravatar.cc/150?img=3',
                    ),
                  ),
                ),
                actions: [
                  Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: Icon(
                      Icons.more_horiz,
                      color:
                          !context.isDarkMode
                              ? AppColors.black
                              : AppColors.lightBackground,
                    ),
                  ),
                ],
              ),

              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Danh mục tab: Packages, Flight, Hotel
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildCategoryTab(
                          Icons.card_giftcard,
                          "Packages",
                          true,
                        ),
                        _buildCategoryTab(Icons.flight, "Flight", false),
                        _buildCategoryTab(Icons.hotel, "Hotel", false),
                      ],
                    ),
                    const SizedBox(height: 20),

                    Text(
                      "Result found (${state.tours.length})",
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 10),

                    Expanded(
                      child: ListView.builder(
                        itemCount: state.tours.length,
                        itemBuilder: (context, index) {
                          final trip = state.tours[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          PackageDetailScreen(tour: TourModel(tourId: int.tryParse(trip.id) ?? 0, title: trip.title)),
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(
                                  image: NetworkImage(trip.imageUrl),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              height: 180,
                              child: Stack(
                                children: [
                                  // Lớp mờ
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Colors.black.withOpacity(0.4),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // Nội dung
                                  Positioned(
                                    top: 12,
                                    left: 12,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.8),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                            size: 16,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            trip.rating.toString(),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 16,
                                    left: 16,
                                    right: 16,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          trip.title,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          trip.duration,
                                          style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Positioned(
                                    bottom: 16,
                                    right: 16,
                                    child: CircleAvatar(
                                      radius: 16,
                                      backgroundColor: Colors.white,
                                      child: Icon(
                                        Icons.bookmark_outline,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return TravelErrorScreen(
            onRetry: () => context.read<MyTripCubit>().initialize(),
          );
        },
      ),
    );
  }

  Widget _buildCategoryTab(IconData icon, String title, bool selected) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: selected ? Colors.blue.withOpacity(0.1) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected ? Colors.blue : Colors.grey.shade300,
              width: 1.5,
            ),
          ),
          child: Icon(
            icon,
            color: selected ? Colors.blue : Colors.grey,
            size: 28,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: selected ? Colors.blue : Colors.grey,
          ),
        ),
      ],
    );
  }
}
