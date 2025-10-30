import 'package:flutter/material.dart';

class GuestLoginScreen extends StatelessWidget {
  const GuestLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('게스트 로그인')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.person_outline, size: 80, color: Colors.grey),
            const SizedBox(height: 20),
            const Text('게스트로 로그인하시겠습니까?', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/home');
              },
              child: const Text('게스트로 계속하기'),
            ),
          ],
        ),
      ),
    );
  }
}
