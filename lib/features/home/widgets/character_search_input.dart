import 'package:flutter/material.dart';
import '../../../core/theme/app_spacing.dart';
import 'custom_dropdown.dart';
import 'search_text_field.dart';

class CharacterSearchInput extends StatefulWidget {
  const CharacterSearchInput({super.key});

  @override
  State<CharacterSearchInput> createState() => _CharacterSearchInputState();
}

class _CharacterSearchInputState extends State<CharacterSearchInput> {
  final TextEditingController _controller = TextEditingController();
  String _selectedServer = '서버선택';

  final List<String> _servers = ['서버선택', '카인', '시로코', '디레지에', '프레이', '바칼'];

  void _onSearch() {
    final name = _controller.text.trim();
    if (name.isEmpty || _selectedServer == '서버선택') return;
    Navigator.pushNamed(
      context,
      '/character_result',
      arguments: {'server': _selectedServer, 'name': name},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Row(
        children: [
          CustomDropdown(
            value: _selectedServer,
            items: _servers,
            onChanged: (value) {
              if (value != null) setState(() => _selectedServer = value);
            },
          ),
          const SizedBox(width: AppSpacing.sm),
          SearchTextField(controller: _controller, onSearch: _onSearch),
        ],
      ),
    );
  }
}
