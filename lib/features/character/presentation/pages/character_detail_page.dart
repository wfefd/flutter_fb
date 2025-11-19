// lib/features/character/presentation/views/character_detail_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_fb/core/theme/app_colors.dart';
import 'package:flutter_fb/core/theme/app_text_styles.dart';

// ✅ 기본 캐릭터 요약 정보
import 'package:flutter_fb/features/character/models/domain/character.dart';

// ⭐ 상세용 모델 & 레포지토리
import 'package:flutter_fb/features/character/models/ui/character_detail.dart';
import 'package:flutter_fb/features/character/repository/character_repository.dart';
import 'package:flutter_fb/features/character/repository/firebase_character_repository.dart';

// 장비/슬롯 모델 추가 ★ NEW
import 'package:flutter_fb/features/character/models/domain/equipment_item.dart';
import 'package:flutter_fb/features/character/models/ui/equipment_slot.dart';

// 탭들
import 'package:flutter_fb/features/character/presentation/widgets/detail_buff_tab.dart';
import 'package:flutter_fb/features/character/presentation/widgets/skill_bloom_tab.dart';
import '../widgets/detail_equipment_tab.dart';
import '../widgets/detail_basic_stat_tab.dart';
import '../widgets/detail_detail_stat_tab.dart';
import '../widgets/detail_avatar_creature_tab.dart';
// 상단 import 쪽에 추가
import 'package:flutter_fb/features/character/models/ui/avatar_creature_slot.dart';
import 'package:flutter_fb/features/character/models/ui/buff_slot.dart';

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

  // ✅ 상세 데이터 & 레포지토리
  late final CharacterRepository _repository;
  CharacterDetail? _detail;
  bool _loading = true;
  String? _error;

  final List<Widget?> _builtTabs = List.filled(8, null);

  @override
  void initState() {
    super.initState();
    _repository = FirebaseCharacterRepository();
    _loadDetail();
  }

  Future<void> _loadDetail() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final detail = await _repository.getCharacterDetailById(
        widget.character.id,
      );

      if (!mounted) return;
      setState(() {
        _detail = detail;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = '캐릭터 정보를 불러오는 데 실패했습니다.';
        _loading = false;
      });
    }
  }

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

          // ✅ 상세 로딩 상태 처리
          if (_loading)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else if (_error != null || _detail == null)
            Expanded(
              child: Center(
                child: Text(
                  _error ?? '캐릭터 정보를 불러올 수 없습니다.',
                  style: AppTextStyles.body2,
                ),
              ),
            )
          else
            Expanded(
              child: Column(
                children: [
                  _buildTabSelector(),
                  Divider(height: 1, color: AppColors.border),
                  Expanded(child: _buildTabContent()),
                ],
              ),
            ),
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
            child: c.imagePath.isNotEmpty
                ? Image.network(
                    c.imagePath,
                    width: 216,
                    height: 216,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/images/no_image.png',
                        width: 216,
                        height: 216,
                        fit: BoxFit.cover,
                      );
                    },
                  )
                : Image.asset(
                    'assets/images/no_image.png',
                    width: 216,
                    height: 216,
                    fit: BoxFit.cover,
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

    // ✅ 여기서 _detail이 null일 일은 없음 (위에서 가드함)
    final detail = _detail!;

    switch (i) {
      case 0:
        // 장착장비 탭: 장비 리스트 → 슬롯 리스트로 변환해서 넘기기 ★ CHANGED
        final slots = buildSlotsFromItems(detail.equipments);
        _builtTabs[i] = EquipmentTab(slots: slots);
        break;
      case 1:
        // 스탯 탭: BasicStat 리스트 넘기기
        _builtTabs[i] = StatTab(stats: detail.basicStats);
        break;
      case 2:
        // 세부스탯 탭
        _builtTabs[i] = DetailStatTab(
          detailStats: detail.detailStats,
          extraStats: detail.extraDetailStats,
        );
        break;
      case 3:
        // 🔥 여기 수정: 아바타 리스트 → 슬롯 리스트 변환 후 전달
        final avatarSlots = buildAvatarSlotsFromItems(detail.avatars);
        _builtTabs[i] = AvatarCreatureTab(slots: avatarSlots);
        break;

      case 4:
        final buffSlots = buildBuffSlotsFromItems(detail.buffItems);
        _builtTabs[i] = BuffTab(slots: buffSlots);
        break;
      case 5:
        // 스킬 개화 (임시)
        _builtTabs[i] = const SkillBloomTab();
        break;
      default:
        // 6: 딜표, 7: 스킬정보 → 지금은 더미 텍스트
        _builtTabs[i] = Center(
          child: Text(
            i == 6 ? '딜표 데이터 (추후 연동)' : '스킬 정보 (추후 연동)',
            style: AppTextStyles.body1,
          ),
        );
    }

    return _builtTabs[i]!;
  }

  @override
  bool get wantKeepAlive => true;
}
