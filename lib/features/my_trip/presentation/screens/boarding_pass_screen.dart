import 'package:flutter/material.dart';
import '../widgets/common_appbar.dart';

class BoardingPassScreen extends StatelessWidget {
  const BoardingPassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: 'Boarding Pass'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text('Passenger: MD Rafi Islam', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                const Text('NYC ➝ SIN', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Container(height: 110, color: Colors.grey[200], child: const Center(child: Text('Barcode / QR placeholder'))),
                const SizedBox(height: 14),
                ElevatedButton(onPressed: () {}, child: const Text('Download Ticket')),
                const SizedBox(height: 8),
                OutlinedButton(onPressed: () {}, style: OutlinedButton.styleFrom(foregroundColor: Colors.red), child: const Text('Cancel This Flight')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
