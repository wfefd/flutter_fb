import 'package:flutter/material.dart';
import '../../../../core/widgets/custom_dropdown.dart';
import '../../../character/presentation/widgets/page_search_text_field.dart';

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

  void _handleSearch(BuildContext context) {
    final name = controller.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('캐릭터 이름을 입력하세요.')));
      return;
    }
    onSearch(); // 부모(CharacterSearchTab)의 _searchCharacter 호출
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          CustomDropdown(
            value: selectedServer,
            items: servers,
            onChanged: (value) {
              if (value != null) onServerChanged(value);
            },
          ),
          SearchTextField(
            controller: controller,
            onSearch: () => _handleSearch(context),
          ),
        ],
      ),
    );
  }
}
