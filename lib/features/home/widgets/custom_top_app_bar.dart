// lib/core/widgets/custom_top_app_bar.dart
import 'package:flutter/material.dart';

class CustomTopAppBar extends StatefulWidget implements PreferredSizeWidget {
  final bool showTabBar;
  const CustomTopAppBar({super.key, this.showTabBar = true});

  @override
  State<CustomTopAppBar> createState() => _CustomTopAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(
      kToolbarHeight + (showTabBar ? kTextTabBarHeight : 0.0));
}

class _CustomTopAppBarState extends State<CustomTopAppBar> {
  final TextEditingController _controller = TextEditingController();

  void _onSearch() {
    final query = _controller.text.trim();
    if (query.isEmpty) return;
    Navigator.pushNamed(context, '/character_search', arguments: query);
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
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
      bottom: widget.showTabBar
          ? const TabBar(
              isScrollable: true,
              indicatorColor: Colors.white,
              tabs: [
                Tab(text: '홈'),
                Tab(text: '순위'),
                Tab(text: '경매장'),
                Tab(text: '게시판'),
                Tab(text: '공지사항'),
              ],
            )
          : null,
    );
  }
}
