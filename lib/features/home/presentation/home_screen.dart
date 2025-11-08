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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _bottomIndex = 1; // 0: 알림, 1: 홈, 2: 설정

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor: AppColors.background, // ✅ 전체 배경색 지정
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // ✅ 탭바 왼쪽 정렬
          children: [
            // ✅ 상단 AppBar (검색창만 포함)
            const CustomTopAppBar(showTabBar: false),

            // ✅ 항상 탭바 보이게
            const CustomTabBar(),

            // ✅ 탭 컨텐츠
            const Expanded(
              child: TabBarView(
                children: [
                  CharacterSearchTab(),
                  RankingScreen(),
                  AuctionScreen(),
                  CommunityListScreen(),
                  BoardListScreen(),
                ],
              ),
            ),
          ],
        ),

        // ✅ 하단 네비게이션바
        bottomNavigationBar: CustomBottomNavBar(
          currentIndex: _bottomIndex,
          onTabChanged: (index) => setState(() => _bottomIndex = index),
        ),
      ),
    );
  }
}
