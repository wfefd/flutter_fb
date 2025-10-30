// lib/features/board/presentation/board_list_screen.dart
import 'package:flutter/material.dart';
import '../model/notice.dart';
import '../model/notice_category.dart';
import '../repository/notice_repository.dart';

class BoardListScreen extends StatefulWidget {
  const BoardListScreen({super.key});

  @override
  State<BoardListScreen> createState() => _BoardListScreenState();
}

class _BoardListScreenState extends State<BoardListScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final InMemoryNoticeRepository _repo;

  List<Notice> _notices = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _repo = InMemoryNoticeRepository();
    _tabController = TabController(length: 3, vsync: this)
      ..addListener(() {
        if (_tabController.indexIsChanging) return;
        _loadForTab(_tabController.index);
      });
    _loadForTab(0); // 초기: 전체
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadForTab(int tabIndex) async {
    setState(() => _loading = true);

    NoticeCategory? category;
    switch (tabIndex) {
      case 1:
        category = NoticeCategory.event;
        break;
      case 2:
        category = NoticeCategory.maintenance;
        break;
      case 0:
      default:
        category = null; // 전체
    }

    final data = await _repo.fetchNotices(category: category);

    if (!mounted) return;
    setState(() {
      _notices = data;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 상단 탭 + 목록은 body에 유지
      body: Column(
        children: [
          // 🔹 공지 카테고리 탭바
          Container(
            color: Colors.grey.shade200,
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.black,
              indicatorColor: Colors.blue,
              tabs: const [
                Tab(text: '전체'),
                Tab(text: '이벤트'),
                Tab(text: '점검'),
              ],
            ),
          ),

          // 🔹 탭별 공지사항 목록
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(), // 탭 버튼으로만 전환
              children: [
                _buildNoticeList(context, _notices),
                _buildNoticeList(context, _notices),
                _buildNoticeList(context, _notices),
              ],
            ),
          ),
        ],
      ),

      // 🔸 플로팅 액션 버튼: 공지 작성
      floatingActionButton: FloatingActionButton(
        tooltip: '공지 작성',
        child: const Icon(Icons.add),
        onPressed: () async {
          // 같은 레포 인스턴스를 전달 → write 화면에서 저장
          final result = await Navigator.pushNamed(
            context,
            '/notice_write',
            arguments: _repo, // NoticeRepository 구현체
          );

          // 작성 후 돌아오면 현재 탭 기준으로 다시 로드
          if (result != null && mounted) {
            _loadForTab(_tabController.index);
          }
        },
      ),
    );
  }

  Widget _buildNoticeList(BuildContext context, List<Notice> notices) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (notices.isEmpty) {
      return const Center(child: Text('공지사항이 없습니다.'));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: notices.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        final n = notices[index];
        return ListTile(
          leading: n.pinned ? const Icon(Icons.push_pin, size: 18) : null,
          title: Text(
            n.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(_fmtDate(n.createdAt)),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            // 기존 '/board_detail' 라우트가 Map<String,String> 기대 → 변환해서 전달
            Navigator.pushNamed(
              context,
              '/board_detail',
              arguments: {
                'title': n.title,
                'date': _fmtDate(n.createdAt),
                'content': n.content,
              },
            );
          },
        );
      },
    );
  }

  String _fmtDate(DateTime d) {
    return '${d.year.toString().padLeft(4, '0')}-'
        '${d.month.toString().padLeft(2, '0')}-'
        '${d.day.toString().padLeft(2, '0')}';
  }
}
