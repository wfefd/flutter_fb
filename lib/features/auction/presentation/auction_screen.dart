// features/auction/presentation/auction_screen.dart
import 'package:flutter/material.dart';

class AuctionScreen extends StatelessWidget {
  const AuctionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('경매장')),
      body: const Center(
        child: Text('경매장 화면 (추후 구현 예정)'),
      ),
    );
  }
}
