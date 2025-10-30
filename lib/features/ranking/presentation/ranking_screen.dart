import 'package:flutter/material.dart';
import '../data/job_data.dart';
import '../data/job_image_map.dart';

class RankingScreen extends StatefulWidget {
  const RankingScreen({super.key});

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  String _selectedRankType = '랭킹';
  String? _selectedJob;
  String? _selectedAwakening;
  // 🔹 더미 랭킹 데이터
  final List<Map<String, dynamic>> _dummyRankingData = [
    {
      'rank': 1,
      'name': '플레이어A',
      'score': 185000,
      'job': '귀검사(남)',
      'awakening': '아수라',
      'type': '딜러',
    },
    {
      'rank': 2,
      'name': '플레이어B',
      'score': 182500,
      'job': '귀검사(남)',
      'awakening': '아수라',
      'type': '딜러',
    },
    {
      'rank': 3,
      'name': '플레이어C',
      'score': 179800,
      'job': '귀검사(남)',
      'awakening': '아수라',
      'type': '딜러',
    },
    {
      'rank': 4,
      'name': '플레이어D',
      'score': 177200,
      'job': '귀검사(남)',
      'awakening': '아수라',
      'type': '딜러',
    },
    {
      'rank': 5,
      'name': '플레이어E',
      'score': 175000,
      'job': '귀검사(남)',
      'awakening': '아수라',
      'type': '딜러',
    },
    {
      'rank': 6,
      'name': '플레이어F',
      'score': 172400,
      'job': '귀검사(남)',
      'awakening': '아수라',
      'type': '딜러',
    },
    {
      'rank': 7,
      'name': '플레이어G',
      'score': 170900,
      'job': '귀검사(남)',
      'awakening': '아수라',
      'type': '딜러',
    },
    {
      'rank': 8,
      'name': '플레이어H',
      'score': 169300,
      'job': '귀검사(남)',
      'awakening': '아수라',
      'type': '딜러',
    },
    {
      'rank': 9,
      'name': '플레이어I',
      'score': 168000,
      'job': '귀검사(남)',
      'awakening': '아수라',
      'type': '딜러',
    },
    {
      'rank': 10,
      'name': '플레이어J',
      'score': 166400,
      'job': '귀검사(남)',
      'awakening': '아수라',
      'type': '딜러',
    },
  ];

  final List<String> rankTypes = ['랭킹', '명성', '명성 전직업'];

  @override
  void initState() {
    super.initState();
    // ✅ 이미지 미리 로딩 (렉 방지)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (final job in JobData.getJobs()) {
        precacheImage(
          AssetImage('assets/images/jobs/${JobImageMap.getJobIcon(job)}'),
          context,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final jobs = JobData.getJobs();
    final awakenings = JobData.getAwakenings(_selectedJob);

    return Container(
      color: const Color(0xFFF6F6F6),
      padding: const EdgeInsets.all(12),
      child: SingleChildScrollView(
        // ✅ 스크롤 가능하게 변경
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRankTypeSelector(),
            const SizedBox(height: 16),
            _buildJobSelector(jobs),
            const SizedBox(height: 20),
            if (_selectedJob != null) _buildAwakeningSelector(awakenings),
            if (_selectedJob != null && _selectedAwakening != null)
              _buildRankingSection(),
          ],
        ),
      ),
    );
  }

  // 🔹 랭킹 타입 선택 영역
  Widget _buildRankTypeSelector() {
    return Row(
      children: rankTypes.map((type) {
        final isSelected = _selectedRankType == type;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: GestureDetector(
              onTap: () => setState(() => _selectedRankType = type),
              child: Container(
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

  // ✅ 직업 선택 영역 (GridView.builder 사용)
  Widget _buildJobSelector(List<String> jobs) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: _boxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '직업 선택',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 8),

          // ✅ 높이를 “1.5줄” 정도로 제한
          SizedBox(
            height: 160, // 🔹 한 줄(약 160px) + 반 줄(약 80px)
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: ScrollConfiguration(
                behavior: const ScrollBehavior().copyWith(overscroll: false),
                child: GridView.builder(
                  itemCount: jobs.length,
                  physics: const ClampingScrollPhysics(), // ✅ bounce 제거
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 0.9,
                  ),
                  itemBuilder: (context, index) {
                    final job = jobs[index];
                    final isSelected = _selectedJob == job;
                    return JobCard(
                      job: job,
                      isSelected: isSelected,
                      onTap: () => setState(() {
                        _selectedJob = job;
                        _selectedAwakening = null;
                      }),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ 각성 선택 영역 (GridView.builder로 변경)
  Widget _buildAwakeningSelector(List<String> awakenings) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: _boxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '각성 선택',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 8),
          GridView.builder(
            itemCount: awakenings.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 0.9,
            ),
            itemBuilder: (context, index) {
              final aw = awakenings[index];
              final isSelected = _selectedAwakening == aw;
              return AwakeningCard(
                job: _selectedJob!,
                awakening: aw,
                index: index,
                isSelected: isSelected,
                onTap: () => setState(() => _selectedAwakening = aw),
              );
            },
          ),
        ],
      ),
    );
  }

  BoxDecoration _boxDecoration() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 5,
        offset: const Offset(0, 2),
      ),
    ],
  );
  Widget _buildRankingSection() {
    final now = DateTime.now();
    final formattedDate = "${now.month}월 ${now.day}일";

    // 선택된 직업, 각성 불러오기
    final selectedJob = _selectedJob ?? '';
    final selectedAwakening = _selectedAwakening ?? '';
    const roleType = '딜러';

    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 타이틀
          Text(
            "$formattedDate $selectedJob $selectedAwakening $roleType 랭킹",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 12),

          // 🔹 더미 랭킹 데이터 표시
          ListView.builder(
            itemCount: _dummyRankingData.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final item = _dummyRankingData[index];
              final isTop3 = item['rank'] <= 3;

              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isTop3
                      ? const Color(
                          0xFF7BC57B,
                        ).withOpacity(item['rank'] == 1 ? 0.2 : 0.1)
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        // 순위
                        Text(
                          "${item['rank']}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isTop3
                                ? const Color(0xFF4CAF50)
                                : Colors.black87,
                          ),
                        ),
                        const SizedBox(width: 8),
                        // 플레이어 이름
                        Text(
                          item['name'],
                          style: const TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                    // 명성
                    Text(
                      "명성 ${item['score']}",
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// 🔹 직업 카드 (RepaintBoundary로 GPU 캐싱)
class JobCard extends StatelessWidget {
  final String job;
  final bool isSelected;
  final VoidCallback onTap;

  const JobCard({
    super.key,
    required this.job,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: RepaintBoundary(
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF7BC57B).withOpacity(0.15)
                : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF7BC57B)
                  : Colors.grey.shade300,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 3,
                offset: Offset(1, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  'assets/images/jobs/${JobImageMap.getJobIcon(job)}',
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.person, size: 48, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                job,
                style: TextStyle(
                  color: isSelected ? const Color(0xFF4CAF50) : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 12,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 🔹 각성 카드 (RepaintBoundary + Lazy 렌더링)
class AwakeningCard extends StatelessWidget {
  final String job;
  final String awakening;
  final int index;
  final bool isSelected;
  final VoidCallback onTap;

  const AwakeningCard({
    super.key,
    required this.job,
    required this.awakening,
    required this.index,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final imageFile = JobImageMap.getAwakeningImage(job, index);

    return GestureDetector(
      onTap: onTap,
      child: RepaintBoundary(
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF7BC57B).withOpacity(0.15)
                : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF7BC57B)
                  : Colors.grey.shade300,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 3,
                offset: Offset(1, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  'assets/images/jobs/$imageFile',
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(Icons.person, size: 48, color: Colors.grey.shade400),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                awakening,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isSelected ? const Color(0xFF4CAF50) : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 12,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
