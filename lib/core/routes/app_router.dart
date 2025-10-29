// lib/core/routes/app_router.dart
import 'package:flutter/material.dart';

// --- 각 화면 import ---
import '../../features/auth/presentation/login_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/character/presentation/character_search_screen.dart';
import '../../features/character/presentation/character_detail_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/auction/presentation/auction_itemDetail_screen.dart';
import '../../features/auction/presentation/auction_itemPrice_screen.dart';
import '../../features/board/presentation/board_detail_screen.dart';


class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // ✅ 로그인 → 홈
      case '/':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      // ✅ 캐릭터 검색 결과 (검색어 전달)
      case '/character_search':
        final query = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => CharacterSearchScreen(query: query),
        );

      // ✅ 캐릭터 상세 페이지 (캐릭터 데이터 전달)
      case '/character_detail':
        final character = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => CharacterDetailScreen(character: character),
        );

      // ✅ 설정 페이지 (하단 네비게이션용)
      case '/settings':
        return MaterialPageRoute(builder: (_) => const SettingsScreen());

      // 경매장 아이템 정보 페이지
      case '/auction_item_detail':
        final item = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => AuctionItemDetailScreen(item: item),
        );

      // 경매장 아이템 시세 정보 페이지 
      case '/item_price':
        final item = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => ItemPriceScreen(item: item),
        );

      // ✅ 공지사항 상세 페이지 (게시판 상세)
      case '/board_detail':
        final notice = settings.arguments as Map<String, String>;
        return MaterialPageRoute(
          builder: (_) => BoardDetailScreen(),
          settings: RouteSettings(arguments: notice),
        );
        
      // ❌ 기본 (없는 경로)
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('404 - 페이지를 찾을 수 없습니다.')),
          ),
        );

        
    }
  }
}
