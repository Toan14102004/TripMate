import 'package:flutter/material.dart';
import 'package:trip_mate/routes/app_route.dart';
import '../../domain/entities/trip.dart';


class MyTripScreen extends StatelessWidget {
  const MyTripScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Trip> trips = [
      Trip(
        id: '1',
        title: 'Jammu Kashmir',
        location: 'India',
        duration: '2 days 3 nights full package',
        rating: 4.8,
        imageUrl:
        'https://images.unsplash.com/photo-1589308078059-be1415eab4c3?w=800',
      ),
      Trip(
        id: '2',
        title: 'Rome, Italy',
        location: 'Italy',
        duration: '2 days 3 nights full package',
        rating: 4.7,
        imageUrl:
        'https://images.unsplash.com/photo-1543340900-1bf3b4f9c5b9?w=800',
      ),
      Trip(
        id: '3',
        title: 'Romantic Paris Getaway',
        location: 'France',
        duration: '3 days 4 nights full package',
        rating: 4.9,
        imageUrl:
        'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?w=800',
      ),
      Trip(
        id: '4',
        title: 'Discover Tokyo Culture',
        location: 'Japan',
        duration: '4 days 3 nights',
        rating: 4.8,
        imageUrl:
        'https://images.unsplash.com/photo-1549692520-acc6669e2f0c?w=800',
      ),
      Trip(
        id: '5',
        title: 'Relax in Beautiful Bali',
        location: 'Indonesia',
        duration: '5 days 4 nights',
        rating: 4.9,
        imageUrl:
        'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800',
      ),
      Trip(
        id: '6',
        title: 'Explore New York City',
        location: 'USA',
        duration: '3 days 2 nights',
        rating: 4.6,
        imageUrl:
        'https://images.unsplash.com/photo-1549921296-3e3c0f1d5b35?w=800',
      ),
      Trip(
        id: '7',
        title: 'Adventure in the Swiss Alps',
        location: 'Switzerland',
        duration: '6 days 5 nights',
        rating: 4.9,
        imageUrl:
        'https://images.unsplash.com/photo-1504198453319-5ce911bafcde?w=800',
      ),
      Trip(
        id: '8',
        title: 'Desert Safari Dubai',
        location: 'UAE',
        duration: '2 days 1 night',
        rating: 4.7,
        imageUrl:
        'https://images.unsplash.com/photo-1504196606672-aef5c9cefc92?w=800',
      ),
      Trip(
        id: '9',
        title: 'Visit the Great Wall of China',
        location: 'China',
        duration: '3 days 2 nights',
        rating: 4.8,
        imageUrl:
        'https://images.unsplash.com/photo-1554118811-1e0d58224f24?w=800',
      ),
      Trip(
        id: '10',
        title: 'Santorini Sunset Experience',
        location: 'Greece',
        duration: '3 days 2 nights',
        rating: 4.9,
        imageUrl:
        'https://images.unsplash.com/photo-1505731132164-cca3b4ae4010?w=800',
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "MyTrip",
          style: TextStyle(
            color: Colors.black87,
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
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.more_horiz, color: Colors.black87),
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
                _buildCategoryTab(Icons.card_giftcard, "Packages", true),
                _buildCategoryTab(Icons.flight, "Flight", false),
                _buildCategoryTab(Icons.hotel, "Hotel", false),
              ],
            ),
            const SizedBox(height: 20),

            Text(
              "Result found (${trips.length})",
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 10),

            Expanded(
              child: ListView.builder(
                itemCount: trips.length,
                itemBuilder: (context, index) {
                  final trip = trips[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.tripDetail,
                          arguments: trip);
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
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.star,
                                      color: Colors.amber, size: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                    trip.rating.toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
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
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                              child: Icon(Icons.bookmark_outline,
                                  color: Colors.blue),
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
