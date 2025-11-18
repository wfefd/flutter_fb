import 'package:flutter/material.dart';
import 'package:flutter_fb/core/theme/app_colors.dart';
import 'package:flutter_fb/core/theme/app_text_styles.dart';
import 'package:flutter_fb/features/character/models/character.dart';

import 'package:flutter_fb/features/character/presentation/widgets/detail_buff_tab.dart';
import 'package:flutter_fb/features/character/presentation/widgets/skill_bloom_tab.dart';
import '../widgets/detail_equipment_tab.dart'; // ✅ 장비 탭: EquipmentTab
import '../widgets/detail_basic_stat_tab.dart';
import '../widgets/detail_detail_stat_tab.dart';
import '../widgets/avatar_creature_tab.dart';

class CharacterDetailView extends StatefulWidget {
  final Character character;
  final bool fromRanking;

  const CharacterDetailView({
    super.key,
    required this.character,
    this.fromRanking = false,
  });

  @override
  State<CharacterDetailView> createState() => _CharacterDetailViewState();
}

class _CharacterDetailViewState extends State<CharacterDetailView>
    with AutomaticKeepAliveClientMixin {
  int _selectedTabIndex = 0;

  final List<String> tabs = const [
    '장착장비',
    '스탯',
    '세부스탯',
    '아바타&크리쳐',
    '버프강화',
    '스킬개화',
    '딜표',
    '스킬정보',
  ];

  final Map<int, Future<String>> _tabDataCache = {};
  final List<Widget?> _builtTabs = List.filled(8, null);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final c = widget.character;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: widget.fromRanking
          ? AppBar(
              title: Text(c.name, style: AppTextStyles.subtitle),
              backgroundColor: AppColors.surface,
              foregroundColor: AppColors.primaryText,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new),
                iconSize: 18,
                onPressed: () => Navigator.pop(context),
              ),
              elevation: 1,
            )
          : null,
      body: Column(
        children: [
          _buildCharacterInfo(c),
          Divider(height: 1, color: AppColors.border),
          _buildTabSelector(),
          Divider(height: 1, color: AppColors.border),
          Expanded(child: _buildTabContent()),
        ],
      ),
    );
  }

  Widget _buildCharacterInfo(Character c) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              c.imagePath.isNotEmpty
                  ? c.imagePath
                  : 'assets/images/no_image.png',
              width: 216,
              height: 216,
              fit: BoxFit.cover,
              cacheWidth: 240,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(c.name, style: AppTextStyles.h2),
                const SizedBox(height: 4),
                Text('${c.job} | ${c.server}', style: AppTextStyles.body2),
                const SizedBox(height: 4),
                Text('Lv.${c.level}', style: AppTextStyles.body2),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Image.asset(
                      'assets/images/fame.png',
                      width: 20,
                      height: 20,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      c.fame,
                      style: AppTextStyles.subtitle.copyWith(
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabSelector() {
    return Wrap(
      spacing: 1,
      runSpacing: 1,
      children: List.generate(tabs.length, (index) {
        final isSelected = _selectedTabIndex == index;
        return SizedBox(
          width: MediaQuery.of(context).size.width / 4 - 1,
          height: 40,
          child: InkWell(
            onTap: () => setState(() => _selectedTabIndex = index),
            child: Container(
              color: isSelected ? AppColors.primaryText : AppColors.surface,
              alignment: Alignment.center,
              child: Text(
                tabs[index],
                style: isSelected
                    ? AppTextStyles.body1.copyWith(color: Colors.white)
                    : AppTextStyles.body2.copyWith(
                        color: AppColors.primaryText,
                        fontWeight: FontWeight.w500,
                      ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildTabContent() {
    return IndexedStack(
      index: _selectedTabIndex,
      children: List.generate(tabs.length, (i) => _getTab(i)),
    );
  }

  Widget _getTab(int i) {
    if (_builtTabs[i] != null) return _builtTabs[i]!;

    switch (i) {
      case 0:
        _builtTabs[i] = EquipmentTab(); // 장착장비
        break;
      case 1:
        _builtTabs[i] = const StatTab(); // 스탯
        break;
      case 2:
        _builtTabs[i] = const DetailStatTab(); // 세부스탯
        break;
      case 3:
        _builtTabs[i] = const AvatarCreatureTab(); // 아바타&크리쳐
        break;
      case 4:
        _builtTabs[i] = const BuffTab(); // 버프강화
        break;
      case 5:
        _builtTabs[i] = const SkillBloomTab(); // 스킬개화
        break;
      default:
        _builtTabs[i] = FutureBuilder<String>(
          future: _tabDataCache.putIfAbsent(i, () => _loadTabData(i)),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Text('데이터 로드 실패', style: AppTextStyles.body2),
              );
            }
            return Center(
              child: Text(snapshot.data!, style: AppTextStyles.body1),
            );
          },
        );
    }

    return _builtTabs[i]!;
  }

  Future<String> _loadTabData(int index) async {
    await Future.delayed(const Duration(milliseconds: 600));
    switch (index) {
      case 6:
        return '딜표 데이터 로드 완료';
      case 7:
        return '스킬 정보 로드 완료';
      default:
        return '데이터 없음';
    }
  }

  @override
  bool get wantKeepAlive => true;
}
