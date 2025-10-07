import 'package:flutter/material.dart';
import '../widgets/common_appbar.dart';

class FlightDetailScreen extends StatelessWidget {
  const FlightDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: 'Flight Details'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('NYC ➝ SIN', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('19:00 - 09:30 • 00h 30m', style: TextStyle(color: Colors.grey)),
                  SizedBox(height: 6),
                  Text('June 07, 2023', style: TextStyle(color: Colors.grey)),
                  Divider(height: 28),
                  Text('American Airlines', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('\$160', style: TextStyle(fontSize: 18, color: Colors.blue)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
