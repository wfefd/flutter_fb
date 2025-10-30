//검색창
import 'package:flutter/material.dart';

class CharacterSearchInput extends StatelessWidget {
  final String selectedServer;
  final List<String> servers;
  final TextEditingController controller;
  final ValueChanged<String> onServerChanged;
  final VoidCallback onSearch;

  const CharacterSearchInput({
    super.key,
    required this.selectedServer,
    required this.servers,
    required this.controller,
    required this.onServerChanged,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            DropdownButton<String>(
              value: selectedServer,
              items: servers
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: (value) {
                if (value != null) onServerChanged(value);
              },
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: '캐릭터 이름을 입력하세요',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: onSearch,
                  ),
                ),
                onSubmitted: (_) => onSearch(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 30),
        const Expanded(
          child: Center(
            child: Text(
              '서버를 선택하고 캐릭터를 검색하세요',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }
}
