// lib/features/home/presentation/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_fb/features/home/widgets/custom_bottom_nav_bar.dart';
import '../../character/presentation/character_search_tab.dart';
import '../../auction/presentation/auction_screen.dart';
import '../../board/presentation/board_list_screen.dart';
import '../../community/presentation/community_list_screen.dart';

// ✅ 새로 추가
import '../../ranking/presentation/ranking_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  int _bottomIndex = 1; // 0: 알림, 1: 홈, 2: 설정

  void _onSearch() {
    final query = _controller.text.trim();
    if (query.isEmpty) return;
    Navigator.pushNamed(context, '/character_search', arguments: query);
  }

  @override
  Widget build(BuildContext context) {
    final bool showTabBar = _bottomIndex == 1;

    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: showTabBar
            ? AppBar(
                titleSpacing: 8,
                title: Row(
                  children: [
                    const Text(
                      '게임 검색 시스템',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: SizedBox(
                        height: 38,
                        child: TextField(
                          controller: _controller,
                          onSubmitted: (_) => _onSearch(),
                          decoration: InputDecoration(
                            hintText: '캐릭터 검색',
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8,
                            ),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.search),
                              onPressed: _onSearch,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.1),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                bottom: const TabBar(
                  isScrollable: true,
                  indicatorColor: Colors.white,
                  tabs: [
                    Tab(text: '홈'),
                    Tab(text: '순위'),
                    Tab(text: '경매장'),
                    Tab(text: '게시판'),
                    Tab(text: '공지사항'),
                  ],
                ),
              )
            : null,
        body: _bottomIndex == 1
            ? const TabBarView(
                children: [
                  CharacterSearchTab(), // 0: 홈
                  RankingScreen(), // ✅ 1: 순위 — 여기 교체됨
                  AuctionScreen(), // 2: 경매장
                  CommunityListScreen(), // 3: 게시판
                  BoardListScreen(), // 4: 공지사항
                ],
              )
            : _bottomIndex == 0
            ? const Center(child: Text('알림 페이지'))
            : const Center(child: Text('설정 페이지')),
        bottomNavigationBar: CustomBottomNavBar(
          currentIndex: _bottomIndex,
          onTabChanged: (index) => setState(() => _bottomIndex = index),
        ),
      ),
    );
  }
}
