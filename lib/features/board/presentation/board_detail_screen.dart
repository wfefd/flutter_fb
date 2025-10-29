import 'package:flutter/material.dart';

class BoardDetailScreen extends StatelessWidget {
  const BoardDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notice = ModalRoute.of(context)!.settings.arguments as Map<String, String>;

    return Scaffold(
      appBar: AppBar(
        title: Text(notice['title'] ?? '공지사항'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notice['title'] ?? '',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              notice['date'] ?? '',
              style: const TextStyle(color: Colors.grey),
            ),
            const Divider(height: 30),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  notice['content'] ?? '',
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('뒤로가기'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
