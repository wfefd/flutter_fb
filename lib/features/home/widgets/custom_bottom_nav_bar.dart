import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabChanged; // 👉 이름 조금 더 명확하게 변경

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        if (index == 2) {
          // ⚙️ 설정 탭 클릭 시 라우터 이동
          Navigator.pushNamed(context, '/settings');
        } else {
          // 나머지는 상태만 변경하도록 부모에게 전달
          onTabChanged(index);
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: '알림',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: '홈',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: '설정',
        ),
      ],
    );
  }
}
