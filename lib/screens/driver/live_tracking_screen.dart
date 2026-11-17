import 'package:flutter/material.dart';

class LiveTrackingScreen extends StatelessWidget {
  final dynamic trip;
  const LiveTrackingScreen({super.key, this.trip});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Live Tracking')),
      body: const Center(child: Text('Live Tracking')),
    );
  }
}
