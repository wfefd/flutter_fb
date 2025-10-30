import 'package:flutter/material.dart';

// ✅ 공지 모델/카테고리/레포 import (경로 구조에 맞춰둠)
import '../model/notice.dart';
import '../model/notice_category.dart';
import '../repository/notice_repository.dart';

class NoticeWriteScreen extends StatefulWidget {
  const NoticeWriteScreen({super.key});

  @override
  State<NoticeWriteScreen> createState() => _NoticeWriteScreenState();
}

class _NoticeWriteScreenState extends State<NoticeWriteScreen> {
  final _titleCtrl = TextEditingController();
  final _contentCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _submitting = false;
  bool _showPreview = false;

  NoticeCategory _category = NoticeCategory.general;

  static const int _titleMax = 80;
  static const int _contentMin = 10;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _contentCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    // ✅ 같은 레포 인스턴스를 arguments로 받음
    final repo = ModalRoute.of(context)!.settings.arguments
        as NoticeRepository?; // InMemoryNoticeRepository 등

    if (repo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('레포지토리를 전달받지 못했습니다. FAB에서 arguments로 레포를 넘겨주세요.')),
      );
      return;
    }

    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _submitting = true);

    final now = DateTime.now();
    final draft = Notice(
      id: 0, // 레포에서 id 할당
      title: _titleCtrl.text.trim(),
      content: _contentCtrl.text.trim(),
      author: '운영팀',
      createdAt: now,
      category: _category,
      pinned: false,
      views: 0,
      commentCount: 0,
    );

    try {
      final created = await repo.createNotice(draft);
      if (!mounted) return;
      Navigator.pop(context, created); // 성공 시 생성된 Notice 돌려주기
    } catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('작성 실패: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 900;

    return Scaffold(
      appBar: AppBar(
        title: const Text('공지사항 작성'),
        actions: [
          IconButton(
            tooltip: _showPreview ? '편집 보기' : '미리보기',
            icon: Icon(_showPreview ? Icons.edit_note : Icons.preview),
            onPressed: () => setState(() => _showPreview = !_showPreview),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: isWide
              ? Row(
                  children: [
                    Expanded(child: _buildEditor(context)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildPreviewCard(context)),
                  ],
                )
              : ListView(
                  children: [
                    _buildEditor(context),
                    const SizedBox(height: 16),
                    if (_showPreview) _buildPreviewCard(context),
                    const SizedBox(height: 80),
                  ],
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _submitting ? null : _submit,
        icon: _submitting
            ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
            : const Icon(Icons.check),
        label: const Text('작성 완료'),
      ),
    );
  }

  // ===== UI blocks =====

  Widget _buildEditor(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 카테고리 + 제목
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 1.5,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SectionTitle(icon: Icons.campaign, title: '공지 정보'),
                const SizedBox(height: 12),

                // 🔘 공지 유형 선택 (3개 버튼 느낌)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ChoiceChip(
                      label: const Text('일반'),
                      selected: _category == NoticeCategory.general,
                      onSelected: (_) => setState(() => _category = NoticeCategory.general),
                    ),
                    ChoiceChip(
                      label: const Text('이벤트'),
                      selected: _category == NoticeCategory.event,
                      onSelected: (_) => setState(() => _category = NoticeCategory.event),
                    ),
                    ChoiceChip(
                      label: const Text('점검'),
                      selected: _category == NoticeCategory.maintenance,
                      onSelected: (_) => setState(() => _category = NoticeCategory.maintenance),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _titleCtrl,
                  maxLength: _titleMax,
                  decoration: const InputDecoration(
                    labelText: '제목',
                    hintText: '공지 제목을 입력하세요 (최대 80자)',
                    prefixIcon: Icon(Icons.title),
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  validator: (v) {
                    final s = v?.trim() ?? '';
                    if (s.isEmpty) return '제목을 입력하세요.';
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 12),

        // 내용
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 1.5,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SectionTitle(icon: Icons.notes, title: '내용'),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _contentCtrl,
                  decoration: const InputDecoration(
                    hintText: '공지 내용을 작성하세요. (엔터로 줄바꿈)',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: 12,
                  minLines: 8,
                  validator: (v) {
                    final s = v?.trim() ?? '';
                    if (s.length < _contentMin) return '내용은 최소 $_contentMin자 이상 입력하세요.';
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.info_outline, size: 16, color: Theme.of(context).hintColor),
                    const SizedBox(width: 6),
                    Text(
                      '등록 후 목록에서 확인할 수 있어요.',
                      style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor),
                    ),
                    const Spacer(),
                    TextButton.icon(
                      icon: Icon(_showPreview ? Icons.visibility_off : Icons.visibility),
                      label: Text(_showPreview ? '미리보기 끄기' : '미리보기'),
                      onPressed: () => setState(() => _showPreview = !_showPreview),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPreviewCard(BuildContext context) {
    final title = _titleCtrl.text.trim().isEmpty ? '제목 미입력' : _titleCtrl.text.trim();
    final content = _contentCtrl.text.trim().isEmpty ? '내용 미입력' : _contentCtrl.text.trim();

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 1.5,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionTitle(icon: Icons.preview, title: '미리보기'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(avatar: const Icon(Icons.sell, size: 16), label: Text(_catLabel(_category))),
                const Chip(avatar: Icon(Icons.person, size: 16), label: Text('운영팀')),
                Chip(avatar: const Icon(Icons.today, size: 16), label: Text(_fmtDate(DateTime.now()))),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.4),
              ),
              child: Text(content, style: const TextStyle(height: 1.5)),
            ),
          ],
        ),
      ),
    );
  }

  // ===== utils =====

  String _fmtDate(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  String _catLabel(NoticeCategory c) {
    switch (c) {
      case NoticeCategory.general:
        return '일반';
      case NoticeCategory.event:
        return '이벤트';
      case NoticeCategory.maintenance:
        return '점검';
    }
  }
}

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  const _SectionTitle({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 6),
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}
