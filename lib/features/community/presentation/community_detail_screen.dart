// lib/features/community/presentation/community_detail_screen.dart
import 'package:flutter/material.dart';
import '../model/community_post.dart';
import '../repository/community_repository.dart';
import '../model/community_comment.dart';

class CommunityDetailScreen extends StatefulWidget {
  final CommunityPost post;
  final InMemoryCommunityRepository repo; // 같은 인스턴스 권장

  const CommunityDetailScreen({
    super.key,
    required this.post,
    required this.repo,
  });

  @override
  State<CommunityDetailScreen> createState() => _CommunityDetailScreenState();
}

class _CommunityDetailScreenState extends State<CommunityDetailScreen>
    with TickerProviderStateMixin {
  late CommunityPost _post;
  final TextEditingController _commentCtrl = TextEditingController();

  List<CommunityComment> _comments = [];
  bool _loading = true;
  bool _commentsCollapsed = false;

  bool _viewCounted = false; // 조회수 중복 증가 방지

  @override
  void initState() {
    super.initState();
    _post = widget.post;
    _load(initial: true);
  }

  @override
  void dispose() {
    _commentCtrl.dispose();
    super.dispose();
  }

  Future<void> _load({bool initial = false}) async {
    setState(() => _loading = true);

    // 최초 진입 시 조회수 +1
    if (initial && !_viewCounted) {
      final v = await widget.repo.incrementViews(_post.id);
      if (mounted && v != null) {
        _post = v;
        _viewCounted = true;
      }
    }

    final loaded = await widget.repo.getPostById(_post.id);
    final cmts = await widget.repo.fetchComments(_post.id);
    if (!mounted) return;

    setState(() {
      _post = loaded ?? _post;
      _comments = cmts;
      _loading = false;
    });
  }

  // 헬퍼: 로컬 댓글 배열에서 교체
  void _replaceComment(CommunityComment c) {
    final i = _comments.indexWhere((e) => e.id == c.id);
    if (i >= 0) setState(() => _comments[i] = c);
  }

  // 좋아요 토글(증가/감소)
  Future<void> _toggleLike(CommunityComment c, {required bool inc}) async {
    final updated = await widget.repo.likeComment(_post.id, c.id, increment: inc);
    if (updated != null) _replaceComment(updated);
  }

  // 댓글 수정 다이어로그
  Future<void> _editComment(CommunityComment c) async {
    final ctrl = TextEditingController(text: c.content);
    final done = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('댓글 수정'),
        content: TextField(
          controller: ctrl,
          minLines: 1,
          maxLines: 5,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: '내용을 수정하세요',
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('취소')),
          FilledButton(onPressed: () => Navigator.pop(context, ctrl.text.trim()), child: const Text('저장')),
        ],
      ),
    );

    if (done == null || done.isEmpty) return;
    final saved = await widget.repo.updateComment(c.copyWith(content: done));
    if (saved != null) _replaceComment(saved);
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = _fmtDate(_post.createdAt);

    return Scaffold(
      appBar: AppBar(
        title: const Text('게시글 상세'),
        actions: [
          IconButton(
            tooltip: '공유',
            icon: const Icon(Icons.ios_share),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('준비 중 :)')),
              );
            },
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
                children: [
                  // 제목
                  Text(
                    _post.title,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),

                  // 메타 정보
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Chip(
                        label: Text(_post.author),
                        avatar: const Icon(Icons.person, size: 16),
                        visualDensity: VisualDensity.compact,
                      ),
                      Chip(
                        label: Text(dateStr),
                        avatar: const Icon(Icons.today, size: 16),
                        visualDensity: VisualDensity.compact,
                      ),
                      Chip(
                        label: Text('조회 ${_post.views}'),
                        avatar: const Icon(Icons.remove_red_eye, size: 16),
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // 본문
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 1.5,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        _post.content,
                        style: const TextStyle(height: 1.55, fontSize: 16),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 댓글 섹션
                  _buildCommentSection(context),
                ],
              ),
            ),
    );
  }

  // 댓글 섹션: 헤더(접기/펼치기) + 목록 + 입력
  Widget _buildCommentSection(BuildContext context) {
    final count = _comments.length;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 헤더
            InkWell(
              onTap: () => setState(() => _commentsCollapsed = !_commentsCollapsed),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                child: Row(
                  children: [
                    const Icon(Icons.comment),
                    const SizedBox(width: 6),
                    Text('댓글 ($count)',
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                    const Spacer(),
                    AnimatedRotation(
                      turns: _commentsCollapsed ? 0.5 : 0.0, // 180deg
                      duration: const Duration(milliseconds: 200),
                      child: const Icon(Icons.expand_more),
                    ),
                  ],
                ),
              ),
            ),

            // 본문(접기/펼치기)
            AnimatedSize(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              alignment: Alignment.topCenter,
              child: _commentsCollapsed
                  ? const SizedBox.shrink()
                  : Column(
                      children: [
                        const Divider(height: 8),
                        if (count == 0)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Text(
                              '첫 댓글을 남겨보세요!',
                              style: TextStyle(color: Theme.of(context).hintColor),
                            ),
                          )
                        else
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _comments.length,
                            separatorBuilder: (_, __) => const Divider(height: 8),
                            itemBuilder: (context, index) {
                              final c = _comments[index];
                              return ListTile(
                                dense: true,
                                contentPadding: EdgeInsets.zero,
                                leading: const CircleAvatar(
                                  radius: 16,
                                  child: Icon(Icons.person, size: 16),
                                ),
                                title: Row(
                                  children: [
                                    Text(c.author,
                                        style: const TextStyle(fontWeight: FontWeight.w600)),
                                    const SizedBox(width: 8),
                                    Text(
                                      _fmtDateTime(c.createdAt),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Theme.of(context).hintColor,
                                      ),
                                    ),
                                  ],
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(c.content),
                                ),
                                trailing: Wrap(
                                  spacing: 4,
                                  children: [
                                    // 좋아요
                                    Text('${c.likes}', style: const TextStyle(fontSize: 12)),
                                    IconButton(
                                      tooltip: '좋아요',
                                      icon: const Icon(Icons.thumb_up_alt_outlined),
                                      onPressed: () => _toggleLike(c, inc: true),
                                    ),
                                    // 수정
                                    IconButton(
                                      tooltip: '수정',
                                      icon: const Icon(Icons.edit_outlined),
                                      onPressed: () => _editComment(c),
                                    ),
                                    // 삭제
                                    IconButton(
                                      tooltip: '삭제',
                                      icon: const Icon(Icons.delete_outline),
                                      onPressed: () async {
                                        await widget.repo.deleteComment(_post.id, c.id);
                                        await _load();
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        const SizedBox(height: 8),
                        _buildCommentInput(context),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // 댓글 입력
  Widget _buildCommentInput(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _commentCtrl,
            minLines: 1,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: '댓글을 입력하세요',
              isDense: true,
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            ),
          ),
        ),
        const SizedBox(width: 8),
        IconButton.filled(
          icon: const Icon(Icons.send),
          onPressed: () async {
            final text = _commentCtrl.text.trim();
            if (text.isEmpty) return;

            await widget.repo.addComment(
              _post.id,
              '익명', // 로그인 붙이면 사용자명으로 교체
              text,
            );

            _commentCtrl.clear();
            await _load();
            if (_commentsCollapsed) {
              setState(() => _commentsCollapsed = false);
            }
          },
        ),
      ],
    );
  }

  // ===== utils =====
  String _fmtDate(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  String _fmtDateTime(DateTime d) =>
      '${_fmtDate(d)} ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';

}
