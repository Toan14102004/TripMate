// TODO: MyTrip 기능에 필요한 위젯을 구현하세요.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../routes/app_route.dart';


import '../providers/trip_provider.dart';
import 'trip_card.dart';
import '../../domain/entities/trip.dart';

class MyTripWidget extends ConsumerWidget {
  const MyTripWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripsState = ref.watch(tripListNotifierProvider);

    return tripsState.when(
      data: (trips) {
        if (trips.isEmpty) {
          return const Center(child: Text('No trips found'));
        }
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          itemCount: trips.length,
          itemBuilder: (ctx, i) {
            final Trip t = trips[i];
            return TripCard(
              id: t.id,
              title: t.title,
              subtitle: t.subtitle,
              imageUrl: t.imageUrl,
              rating: t.rating,
              onTap: () {
                // SỬ DỤNG HẰNG SỐ ROUTE ĐỂ AN TOÀN VÀ DỄ BẢO TRÌ HƠN
                Navigator.pushNamed(context, AppRoutes.tripDetail, arguments: t);
              },
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, st) => Center(child: Text('Error: $err')),
    );
  }
}
