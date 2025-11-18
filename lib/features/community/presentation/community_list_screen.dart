// lib/features/community/presentation/community_list_screen.dart
import 'package:flutter/material.dart';

import '../repository/community_repository.dart';
import '../model/community_post.dart';

// 앱 공통 디자인
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

// 커스텀 검색 필드
import '../../../core/widgets/custom_text_field.dart';

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
    _repo.loadFromFirestore();

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

    // 🔹 1) Firestore → InMemory로 먼저 로딩
    await _repo.loadFromFirestore();

    // 🔹 2) 메모리에서 게시글 가져오기
    final data = await _repo.fetchPosts();

    setState(() {
      _allPosts = data;
      _applyFilter(); // 초기 필터
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
        return t.contains(q) || c.contains(q);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Column(
            children: [
              // 🔎 검색 필드 영역 배경색
              Container(
                color: const Color(0xFFF7F7F7), // ← 여기 배경색
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: CustomTextField(
                  hintText: '제목/내용 검색',
                  controller: _searchController,
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.border,
                      width: 1,
                      strokeAlign: BorderSide.strokeAlignInside,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 상단 제목 (공지사항 리스트랑 맞춤)
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          '커뮤니티',
                          style: AppTextStyles.body1.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryText,
                          ),
                        ),
                      ),

                      const Divider(height: 1, color: Color(0xFFEAEAEA)),

                      // 리스트 영역
                      Expanded(
                        child: _loading
                            ? const Center(child: CircularProgressIndicator())
                            : _filteredPosts.isEmpty
                            ? Center(
                                child: Text(
                                  '게시글이 없습니다.',
                                  style: AppTextStyles.body2.copyWith(
                                    color: AppColors.secondaryText,
                                  ),
                                ),
                              )
                            : ListView.separated(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 6,
                                ),
                                itemCount: _filteredPosts.length,
                                separatorBuilder: (_, __) => Divider(
                                  height: 1,
                                  color: Colors.grey.shade200,
                                ),
                                itemBuilder: (context, index) {
                                  final p = _filteredPosts[index];
                                  return _buildPostRow(context, p);
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // 🔹 오른쪽 하단 "글 작성" 버튼 (공지사항 작성 버튼과 동일 스타일)
          Positioned(right: 24, bottom: 24, child: _buildWriteButton(context)),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 게시글 한 줄 UI (공지 리스트 스타일에 맞춰 커스텀)

  Widget _buildPostRow(BuildContext context, CommunityPost p) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/community_detail',
          // detail 쪽에서 repo도 필요하면 Map으로 넘겨서 쓰는 패턴 사용 가능
          arguments: p,
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 제목
            Text(
              p.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.body1.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 4),

            // 글쓴이 · 시간 · 조회 · 댓글 · 좋아요
            Text(
              '${p.author} · ${_fmtDate(p.createdAt)} · 조회 ${p.views} · 댓글 ${p.commentCount} · 좋아요 ${p.likes}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.secondaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 글 작성 버튼 (공지사항 작성 버튼 스타일 재사용)

  Widget _buildWriteButton(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ElevatedButton.icon(
        onPressed: () async {
          final created = await Navigator.pushNamed(
            context,
            '/community_post_write',
            arguments: _repo,
          );

          if (created != null && created is CommunityPost) {
            setState(() {
              _allPosts.insert(0, created);
            });
            _applyFilter();
          }
        },
        icon: const Icon(Icons.edit, size: 18),
        label: const Text('글 작성'),
        style: ButtonStyle(
          padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 16),
          ),
          backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
            if (states.contains(MaterialState.disabled)) {
              return AppColors.border; // Disabled
            }
            if (states.contains(MaterialState.pressed)) {
              return AppColors.primaryText.withOpacity(0.9); // Pressed
            }
            if (states.contains(MaterialState.hovered)) {
              return AppColors.secondaryText; // Hover
            }
            return AppColors.primaryText; // Default
          }),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
          ),
          textStyle: MaterialStateProperty.all(
            AppTextStyles.body2.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          elevation: MaterialStateProperty.all(0),
        ),
      ),
    );
  }

  String _fmtDate(DateTime d) {
    return '${d.year.toString().padLeft(4, '0')}-'
        '${d.month.toString().padLeft(2, '0')}-'
        '${d.day.toString().padLeft(2, '0')}';
  }
}
