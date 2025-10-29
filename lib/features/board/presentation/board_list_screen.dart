import 'package:flutter/material.dart';

class BoardListScreen extends StatefulWidget {
  const BoardListScreen({super.key});

  @override
  State<BoardListScreen> createState() => _BoardListScreenState();
}

class _BoardListScreenState extends State<BoardListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, String>> mockNotices = [
    {'title': '업데이트 안내', 'date': '2025-10-29', 'content': '1. 신규 이벤트 시작!\n2. 버그 수정'},
    {'title': '서버 점검 공지', 'date': '2025-10-25', 'content': '10월 26일 오전 2시 ~ 6시 점검 예정'},
    {'title': '할로윈 이벤트', 'date': '2025-10-20', 'content': '한정 코스튬을 획득하세요!'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
            children: [
              _buildNoticeList(context, mockNotices),
              _buildNoticeList(context, mockNotices.where((n) => n['title']!.contains('이벤트')).toList()),
              _buildNoticeList(context, mockNotices.where((n) => n['title']!.contains('점검')).toList()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNoticeList(BuildContext context, List<Map<String, String>> notices) {
    if (notices.isEmpty) {
      return const Center(child: Text('공지사항이 없습니다.'));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: notices.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        final notice = notices[index];
        return ListTile(
          title: Text(notice['title']!, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(notice['date']!),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            Navigator.pushNamed(
              context,
              '/board_detail',
              arguments: notice,
            );
          },
        );
      },
    );
  }
}
