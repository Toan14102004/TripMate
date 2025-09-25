import 'package:flutter/material.dart';
import '../../data/sources/home_api_source.dart';
import '../../domain/models/tour_model.dart';

class PackageDetailScreen extends StatefulWidget {
  final int packageId;
  const PackageDetailScreen({super.key, required this.packageId});

  @override
  State<PackageDetailScreen> createState() => _PackageDetailScreenState();
}

class _PackageDetailScreenState extends State<PackageDetailScreen> {
  late Future<TourModel> _futureDetail;

  @override
  void initState() {
    super.initState();
    _futureDetail = HomeApiSource().fetchPackageDetail(widget.packageId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Package Detail'),
        leading: BackButton(),
      ),
      body: FutureBuilder<TourModel>(
        future: _futureDetail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('No detail found'));
          }
          final pkg = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(pkg.image ?? '', height: 180, width: double.infinity, fit: BoxFit.cover),
                ),
                const SizedBox(height: 16),
                Text(pkg.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.orange, size: 18),
                    Text(pkg.destination ?? '', style: const TextStyle(fontSize: 14)),
                    const Spacer(),
                    Text('\$${pkg.price?.toStringAsFixed(0) ?? ''}/Person', style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.orange, size: 18),
                    Text('${pkg.rating ?? 0}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 8),
                    Text('(${pkg.reviewCount ?? 0} reviews)', style: const TextStyle(color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 16),
                const Text('About Trip', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 8),
                Text(pkg.description ?? 'No description', style: const TextStyle(fontSize: 14)),
                // ... bổ sung thêm các phần khác theo UI của bạn ...
              ],
            ),
          );
        },
      ),
    );
  }
}