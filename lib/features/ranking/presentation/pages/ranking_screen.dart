import 'package:flutter/material.dart';
import '../../data/job_data.dart';
import '../../widgets/ranking_list.dart';
import '../../widgets/job_selector.dart';
import '../../widgets/server_selector.dart'; // 🔹 추가
import '../../../character/presentation/pages/character_detail_view.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../widgets/awakening_selector.dart';

class RankingScreen extends StatefulWidget {
  const RankingScreen({super.key});

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  String _selectedServer = '전체';
  String? _selectedJob;
  String? _selectedAwakening;

  final List<String> _servers = [
    '전체',
    '카인',
    '디레지에',
    '시로코',
    '프레이',
    '카시야스',
    '힐더',
    '안톤',
    '바칼',
  ];

  final List<Map<String, dynamic>> _dummyRankingData = [
    {
      'rank': 1,
      'name': '플레이어A',
      'score': 185000,
      'job': '귀검사(남)',
      'awakening': '아수라',
      'type': '딜러',
      'server': '카시야스',
      'class': '아수라',
      'level': 110,
      'power': '185,000',
      'image': 'assets/images/character1.png',
    },
    {
      'rank': 2,
      'name': '플레이어B',
      'score': 182500,
      'job': '귀검사(남)',
      'awakening': '아수라',
      'type': '딜러',
      'server': '디레지에',
      'class': '아수라',
      'level': 110,
      'power': '182,500',
      'image': 'assets/images/character1.png',
    },
    {
      'rank': 3,
      'name': '플레이어C',
      'score': 179800,
      'job': '귀검사(남)',
      'awakening': '아수라',
      'type': '딜러',
      'server': '힐더',
      'class': '아수라',
      'level': 110,
      'power': '179,800',
      'image': 'assets/images/character1.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final jobs = JobData.getJobs();
    final awakenings = JobData.getAwakenings(_selectedJob);

    return Container(
      color: AppColors.background,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 서버 선택 섹션
            ServerSelector(
              servers: _servers,
              selectedServer: _selectedServer,
              onServerSelected: (server) {
                setState(() => _selectedServer = server);
              },
            ),

            const SizedBox(height: AppSpacing.lg),

            // 🔹 직업 선택
            JobSelector(
              jobs: jobs,
              selectedJob: _selectedJob,
              onJobSelected: _onJobSelected,
            ),

            const SizedBox(height: AppSpacing.lg),

            // 🔹 각성 선택
            if (_selectedJob != null)
              AwakeningSelector(
                job: _selectedJob!,
                awakenings: awakenings,
                selectedAwakening: _selectedAwakening,
                onAwakeningSelected: _onAwakeningSelected,
              ),

            const SizedBox(height: AppSpacing.md),

            // 🔹 랭킹 리스트
            if (_selectedJob != null && _selectedAwakening != null)
              RankingList(
                job: _selectedJob!,
                awakening: _selectedAwakening!,
                rankingData: _dummyRankingData
                    .where(
                      (r) =>
                          _selectedServer == '전체' ||
                          r['server'] == _selectedServer,
                    )
                    .toList(),
                onTapCharacter: (character) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CharacterDetailView(
                        character: character,
                        fromRanking: true,
                      ),
                    ),
                  );
                },
              ),

            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  void _onJobSelected(String job) {
    setState(() {
      _selectedJob = job;
      _selectedAwakening = null;
    });
  }

  void _onAwakeningSelected(String aw) {
    setState(() => _selectedAwakening = aw);
  }
}
