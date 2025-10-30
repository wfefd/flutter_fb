import 'package:flutter/material.dart';
import '../repository/community_repository.dart';
import '../model/community_post.dart';

class CommunityListScreen extends StatefulWidget {
  const CommunityListScreen({super.key});

  @override
  State<CommunityListScreen> createState() => _CommunityListScreenState();
}

class _CommunityListScreenState extends State<CommunityListScreen> {
  final TextEditingController _searchController = TextEditingController();
  late final InMemoryCommunityRepository _repo;

  List<CommunityPost> _allPosts = [];
  List<CommunityPost> _filteredPosts = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _repo = InMemoryCommunityRepository();
    _load();
    _searchController.addListener(_applyFilter);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    // 전체 로드
    final data = await _repo.fetchPosts();
    setState(() {
      _allPosts = data;
      _applyFilter(); // 초기 필터(빈 검색어면 전체)
      _loading = false;
    });
  }

  void _applyFilter() {
    final q = _searchController.text.trim().toLowerCase();
    if (q.isEmpty) {
      setState(() => _filteredPosts = List.of(_allPosts));
      return;
    }
    setState(() {
      _filteredPosts = _allPosts.where((p) {
        final t = p.title.toLowerCase();
        final c = p.content.toLowerCase();
        return t.contains(q) || c.contains(q); // 제목/내용 검색
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,

      body: Column(
        children: [
          // 🔎 제목/내용 검색 필드
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: '제목/내용 검색',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: (_searchController.text.isEmpty)
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _applyFilter();
                        },
                      ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                isDense: true,
              ),
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _applyFilter(),
            ),
          ),

          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _filteredPosts.isEmpty
                    ? const Center(child: Text('게시글이 없습니다.'))
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        itemCount: _filteredPosts.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final p = _filteredPosts[index];
                          return ListTile(
                            title: Text(
                              p.title,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              '${p.author} · ${_fmtDate(p.createdAt)} · 조회 ${p.views} · 댓글 ${p.commentCount}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing:
                                const Icon(Icons.arrow_forward_ios, size: 16),
                            onTap: () {
                              // 기존 BoardDetailScreen이 Map<String, String>을 받으므로 변환
                              Navigator.pushNamed(
                                context,
                                '/board_detail',
                                arguments: {
                                  'title': p.title,
                                  'date': _fmtDate(p.createdAt),
                                  'content': p.content,
                                },
                              );
                            },
                          );
                        },
                      ),
          ),
        ],
      ),

      // ➕ FAB (글쓰기)

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final created = await Navigator.pushNamed(
            context,
            '/community_post_write',
            arguments: _repo, // ✅ 같은 레포 인스턴스를 넘겨서 저장 일관성 유지
          );
          if (created != null) {
            // 방법1) 새 글을 맨 위에 붙이고 필터 재적용
            setState(() {
              _allPosts.insert(0, created as CommunityPost);
            });
            _applyFilter();

            // 방법2) 전체를 레포에서 다시 로드하고 싶으면:
            // await _load();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  String _fmtDate(DateTime d) {
    return '${d.year.toString().padLeft(4, '0')}-'
        '${d.month.toString().padLeft(2, '0')}-'
        '${d.day.toString().padLeft(2, '0')}';
  }
}
