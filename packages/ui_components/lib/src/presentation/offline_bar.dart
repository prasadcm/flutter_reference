import 'package:flutter/material.dart';

class OfflineBar extends StatelessWidget {
  const OfflineBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        color: Colors.orange.shade100,
        padding: const EdgeInsets.all(8),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off, size: 20),
            SizedBox(width: 8),
            Text('Offline mode: Showing cached categories'),
          ],
        ),
      ),
    );
  }
}
