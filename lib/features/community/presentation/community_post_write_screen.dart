// lib/features/community/presentation/community_post_write_screen.dart
import 'package:flutter/material.dart';
import '../model/community_post.dart';
import '../model/post_category.dart';
import '../repository/community_repository.dart';

class CommunityPostWriteScreen extends StatefulWidget {
  const CommunityPostWriteScreen({super.key});

  @override
  State<CommunityPostWriteScreen> createState() => _CommunityPostWriteScreenState();
}

class _CommunityPostWriteScreenState extends State<CommunityPostWriteScreen> {
  final _titleCtrl = TextEditingController();
  final _contentCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _submitting = false;
  bool _showPreview = false;

  static const int _titleMax = 60;
  static const int _contentMin = 10;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _contentCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final repo = ModalRoute.of(context)!.settings.arguments as InMemoryCommunityRepository?;
    if (repo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('레포지토리를 찾을 수 없습니다.')),
      );
      return;
    }

    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _submitting = true);

    final post = CommunityPost(
      id: 0,
      title: _titleCtrl.text.trim(),
      content: _contentCtrl.text.trim(),
      author: '나', // TODO: 로그인 사용자명으로 교체
      createdAt: DateTime.now(),
      category: PostCategory.general, // ✅ 카테고리 고정
      views: 0,
      commentCount: 0,
    );

    try {
      final created = await repo.createPost(post);
      if (!mounted) return;
      Navigator.pop(context, created);
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
        title: const Text('게시물 작성'),
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
        // 제목 카드
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 1.5,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SectionTitle(icon: Icons.description, title: '기본 정보'),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _titleCtrl,
                  maxLength: _titleMax,
                  decoration: const InputDecoration(
                    labelText: '제목',
                    hintText: '제목을 입력하세요 (최대 60자)',
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
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),

        const SizedBox(height: 12),

        // 내용 카드
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
                    hintText: '내용을 작성하세요. 엔터로 줄바꿈 가능합니다.',
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
                      '작성한 내용은 저장 후 수정할 수 있어요.',
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
              children: const [
                // 카테고리 칩 제거 (일반 고정이므로 표시 안함)
                Chip(avatar: Icon(Icons.person, size: 16), label: Text('나')),
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
              child: Text(
                content,
                style: const TextStyle(height: 1.5),
              ),
            ),
          ],
        ),
      ),
    );
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
