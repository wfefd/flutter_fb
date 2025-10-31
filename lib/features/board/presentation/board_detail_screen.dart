// lib/features/board/presentation/board_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BoardDetailScreen extends StatelessWidget {
  const BoardDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, String> notice =
        (ModalRoute.of(context)?.settings.arguments as Map<String, String>?) ??
            const {'title': '공지사항', 'date': '', 'content': ''};

    final title   = notice['title']    ?? '공지사항';
    final date    = notice['date']     ?? '';
    final content = notice['content']  ?? '';
    final author  = notice['author']   ?? '운영팀';     // 새로 추가
    final category= notice['category'] ?? '';          // 새로 추가: 'general' | 'event' | 'maintenance' | 기타 텍스트

    return Scaffold(
      appBar: AppBar(
        title: const Text('공지 상세'),
        actions: [
          IconButton(
            tooltip: '본문 복사',
            icon: const Icon(Icons.copy_all_rounded),
            onPressed: () async {
              await Clipboard.setData(
                ClipboardData(text: '$title\n$date\n\n$content'),
              );
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('공지 내용이 복사되었습니다.')),
                );
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
          children: [
            // 제목
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.2,
                  ),
            ),
            const SizedBox(height: 8),

            // 메타: 종류(카테고리) · 작성자 · 날짜
            Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                if (category.isNotEmpty)
                  Chip(
                    avatar: Icon(_categoryIcon(category), size: 16),
                    label: Text(_categoryLabel(category)),
                    visualDensity: VisualDensity.compact,
                    backgroundColor: Theme.of(context)
                        .colorScheme
                        .primary
                        .withOpacity(0.08),
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                Chip(
                  avatar: const Icon(Icons.person, size: 16),
                  label: Text(author),
                  visualDensity: VisualDensity.compact,
                ),
                Chip(
                  avatar: const Icon(Icons.event, size: 16),
                  label: Text(
                    date,
                    overflow: TextOverflow.ellipsis,
                  ),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 구분선
            Divider(
              height: 28,
              thickness: 1,
              color: Theme.of(context).dividerColor.withOpacity(0.6),
            ),
            const SizedBox(height: 6),

            // 본문 카드
            Card(
              elevation: 1.5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
                child: SelectableText(
                  content.isEmpty ? '내용이 없습니다.' : content,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.6,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 퀵 액션 (옵션)
            Row(
              children: [
                _QuickActionChip(
                  icon: Icons.text_increase,
                  label: '글자 키우기',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('디자인만 구성됨 (옵션 기능)')),
                    );
                  },
                ),
                const SizedBox(width: 8),
                _QuickActionChip(
                  icon: Icons.bookmark_border,
                  label: '북마크',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('디자인만 구성됨 (옵션 기능)')),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),

      // 하단 확장 버튼
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: SizedBox(
          height: 48,
          child: ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_rounded),
            label: const Text('뒤로가기'),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
      ),
    );
  }

  // ---- helpers ----
  String _categoryLabel(String raw) {
    switch (raw) {
      case 'event':
        return '이벤트';
      case 'maintenance':
        return '점검';
      case 'general':
        return '일반';
      default:
        // 이미 한글 텍스트가 들어오는 경우 그대로 표기
        return raw;
    }
  }

  IconData _categoryIcon(String raw) {
    switch (raw) {
      case 'event':
        return Icons.campaign;
      case 'maintenance':
        return Icons.build_circle_outlined;
      case 'general':
        return Icons.label_rounded;
      default:
        return Icons.sell;
    }
  }
}

class _QuickActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: Icon(icon, size: 16),
      label: Text(label),
      onPressed: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      labelStyle: const TextStyle(fontWeight: FontWeight.w600),
      backgroundColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
    );
  }
}
