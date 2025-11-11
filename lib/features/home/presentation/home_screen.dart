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

class BaseScreen extends StatelessWidget {
  final Widget child;
  const BaseScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.all(16.0), child: child);
  }
}

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
        backgroundColor: AppColors.background,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomTopAppBar(showTabBar: false),
            const CustomTabBar(),
            Expanded(
              child: TabBarView(
                children: [
                  // 홈 탭
                  const BaseScreen(
                    child:
                        CharacterSearchTab(), // ✅ 스크롤은 CharacterSearchTab 안에서 처리됨
                  ),
                  const BaseScreen(child: RankingScreen()),
                  const BaseScreen(child: AuctionScreen()),
                  const BaseScreen(child: CommunityListScreen()),
                  const BaseScreen(child: BoardListScreen()),
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
