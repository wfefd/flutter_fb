import 'package:flutter/material.dart';
import 'package:flutter_fb/features/home/presentation/widgets/bottom_nav_bar.dart';
import 'package:flutter_fb/features/home/presentation/widgets/top_app_bar.dart';
import 'package:flutter_fb/features/home/presentation/widgets/tab_bar.dart';
import '../../character/presentation/pages/character_search_tab.dart';
import '../../auction/presentation/auction_screen.dart';
import '../../board/presentation/board_list_screen.dart';
import '../../community/presentation/community_list_screen.dart';
import '../../ranking/presentation/pages/ranking_screen.dart';
import '../../../core/theme/app_colors.dart';

class BaseScreen extends StatelessWidget {
  final Widget child;
  const BaseScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0), // ✅ 모든 탭에 동일 패딩 적용
      child: child,
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _bottomIndex = 1;

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
                  // ✅ Builder는 그대로 유지 (탭 이동용 context)
                  Builder(
                    builder: (innerContext) => BaseScreen(
                      child: CharacterSearchTab(
                        onTabChange: (index) {
                          DefaultTabController.of(
                            innerContext,
                          )?.animateTo(index);
                        },
                      ),
                    ),
                  ),
                  const BaseScreen(child: RankingScreen()),
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
