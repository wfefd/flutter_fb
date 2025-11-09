// lib/features/home/presentation/home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_fb/features/home/widgets/custom_bottom_nav_bar.dart';
import 'package:flutter_fb/features/home/widgets/custom_top_app_bar.dart';
import 'package:flutter_fb/features/home/widgets/custom_tab_bar.dart';
import '../../character/presentation/character_search_tab.dart';
import '../../auction/presentation/auction_screen.dart';
import '../../board/presentation/board_list_screen.dart';
import '../../community/presentation/community_list_screen.dart';
import '../../ranking/presentation/ranking_screen.dart';
import '../../../core/theme/app_colors.dart';
import '../widgets/ranking_table_container.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _bottomIndex = 1; // 0: 알림, 1: 홈, 2: 설정

  @override
  Widget build(BuildContext context) {
    // ✅ 임시 데이터
    final dummyRows = [
      {'rank': 1, 'name': '오지환', 'level': 300, 'job': '키네시스'},
      {'rank': 2, 'name': '버터', 'level': 300, 'job': '나이트로드'},
      {'rank': 3, 'name': '테룡이', 'level': 300, 'job': '카이저'},
      {'rank': 4, 'name': '솝상', 'level': 300, 'job': '비숍'},
      {'rank': 5, 'name': '보마노랑이', 'level': 300, 'job': '보우마스터'},
    ];

    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomTopAppBar(showTabBar: false),
            const CustomTabBar(),
            Expanded(
              child: TabBarView(
                children: [
                  // ✅ 홈탭: 캐릭터 검색 + 랭킹 블록
                  SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Column(
                      children: [
                        const CharacterSearchTab(),
                        WorldRankingBlock(rows: dummyRows), // ✅ 여기서 보임
                      ],
                    ),
                  ),
                  const RankingScreen(),
                  const AuctionScreen(),
                  const CommunityListScreen(),
                  const BoardListScreen(),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: CustomBottomNavBar(
          currentIndex: _bottomIndex,
          onTabChanged: (index) => setState(() => _bottomIndex = index),
        ),
      ),
    );
  }
}
