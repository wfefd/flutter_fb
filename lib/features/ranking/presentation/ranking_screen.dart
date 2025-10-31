// lib/features/ranking/presentation/ranking_screen.dart
import 'package:flutter/material.dart';
import '../data/job_data.dart';
import '../widgets/ranking_list.dart';
import '../widgets/job_selector.dart';
import '../widgets/awakening_selector.dart';
import '../../character/presentation/widgets/character_detail_view.dart';

class RankingScreen extends StatefulWidget {
  const RankingScreen({super.key});

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  String _selectedRankType = '랭킹';
  String? _selectedJob;
  String? _selectedAwakening;

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

  final List<String> rankTypes = ['랭킹', '명성', '명성 전직업'];

  @override
  Widget build(BuildContext context) {
    final jobs = JobData.getJobs();
    final awakenings = JobData.getAwakenings(_selectedJob);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(12),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildRankTypeSelector(),
                  const SizedBox(height: 16),
                  JobSelector(
                    jobs: jobs,
                    selectedJob: _selectedJob,
                    onJobSelected: _onJobSelected,
                  ),
                  const SizedBox(height: 20),
                  if (_selectedJob != null)
                    AwakeningSelector(
                      job: _selectedJob!,
                      awakenings: awakenings,
                      selectedAwakening: _selectedAwakening,
                      onAwakeningSelected: _onAwakeningSelected,
                    ),
                  const SizedBox(height: 12),
                  if (_selectedJob != null && _selectedAwakening != null)
                    RankingList(
                      job: _selectedJob!,
                      awakening: _selectedAwakening!,
                      rankingData: _dummyRankingData,
                      onTapCharacter: (character) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CharacterDetailView(
                              character: character,
                              fromRanking: true, // ✅ 핵심
                            ),
                          ),
                        );
                      },
                    ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 상단 랭크 타입 버튼
  Widget _buildRankTypeSelector() {
    return Row(
      children: rankTypes.map((type) {
        final isSelected = _selectedRankType == type;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: GestureDetector(
              onTap: () {
                if (_selectedRankType != type) {
                  setState(() => _selectedRankType = type);
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                height: 36,
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF7BC57B)
                      : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(6),
                ),
                alignment: Alignment.center,
                child: Text(
                  type,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
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
