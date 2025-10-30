// 상세보기
import 'package:flutter/material.dart';

class CharacterDetailView extends StatefulWidget {
  final Map<String, dynamic> character; // 전달받은 캐릭터 데이터
  const CharacterDetailView({super.key, required this.character});

  @override
  State<CharacterDetailView> createState() => _CharacterDetailViewState();
}

class _CharacterDetailViewState extends State<CharacterDetailView> {
  int _selectedTabIndex = 0;

  final List<String> tabs = [
    '장착장비',
    '스탯',
    '세부스탯',
    '아바타&크리쳐',
    '버프강화',
    '스킬개화',
    '딜표',
    '스킬정보',
  ];

  @override
  Widget build(BuildContext context) {
    final c = widget.character;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // 캐릭터 이미지 및 기본정보
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 1,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            c['image'] ?? 'assets/images/no_image.png',
                            fit: BoxFit.cover,
                            height: 200,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              c['name'],
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '${c['class']} | ${c['server']}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '레벨: Lv.${c['level']}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                const Icon(
                                  Icons.workspace_premium,
                                  color: Colors.amber,
                                  size: 22,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  c['power'] ?? '0',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.amber,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // 안내박스
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F1F1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '• 캐릭터 스탯 및 조회는 2023.12.21 이후 접속한 계정의 캐릭터만 확인 가능합니다.',
                          style: TextStyle(fontSize: 12, color: Colors.black87),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '• 캐릭터 정보와 유니온 정보는 실시간으로 갱신됩니다. 평균 15분 내외의 딜레이가 있을 수 있습니다.',
                          style: TextStyle(fontSize: 12, color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // 탭
                _buildTabs(),

                const SizedBox(height: 20),

                // 탭별 내용
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: _buildTabContent(_selectedTabIndex),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          // 첫 번째 행
          Row(
            children: List.generate(4, (index) {
              final isSelected = _selectedTabIndex == index;
              final text = tabs[index];
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedTabIndex = index),
                  child: Container(
                    height: 40,
                    color: isSelected ? const Color(0xFF7BC57B) : Colors.white,
                    alignment: Alignment.center,
                    child: Text(
                      text,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: isSelected ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          const Divider(height: 1, color: Color(0xEEEEEEEE)),

          // 두 번째 행
          Row(
            children: List.generate(4, (index) {
              final actualIndex = index + 4;
              final isSelected = _selectedTabIndex == actualIndex;
              final text = tabs[actualIndex];
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedTabIndex = actualIndex),
                  child: Container(
                    height: 40,
                    color: isSelected ? const Color(0xFF7BC57B) : Colors.white,
                    alignment: Alignment.center,
                    child: Text(
                      text,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: isSelected ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          Container(height: 1, color: const Color(0xFFE0E0E0)),
        ],
      ),
    );
  }

  Widget _buildTabContent(int index) {
    switch (index) {
      case 0:
        return const Text('스탯/장비 내용 표시');
      case 1:
        return const Text('유니온 정보 표시');
      case 2:
        return const Text('스킬 / 심볼 관련 내용');
      case 3:
        return const Text('본캐 / 부캐 정보');
      case 4:
        return const Text('큐브 내용');
      case 5:
        return const Text('스타포스 내용');
      default:
        return const SizedBox.shrink();
    }
  }
}
