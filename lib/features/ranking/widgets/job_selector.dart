import 'package:flutter/material.dart';
import '../data/job_image_map.dart';

class JobSelector extends StatelessWidget {
  final List<String> jobs;
  final String? selectedJob;
  final ValueChanged<String> onJobSelected;

  const JobSelector({
    super.key,
    required this.jobs,
    required this.selectedJob,
    required this.onJobSelected,
  });

  @override
  Widget build(BuildContext context) {
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
            height: 160,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: ScrollConfiguration(
                behavior: const ScrollBehavior().copyWith(overscroll: false),
                child: GridView.builder(
                  itemCount: jobs.length,
                  physics: const ClampingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 0.9,
                  ),
                  itemBuilder: (context, index) {
                    final job = jobs[index];
                    final isSelected = selectedJob == job;
                    return _JobCard(
                      job: job,
                      isSelected: isSelected,
                      onTap: () => onJobSelected(job),
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
}

/// 🔹 내부 전용 JobCard (RepaintBoundary 포함)
class _JobCard extends StatelessWidget {
  final String job;
  final bool isSelected;
  final VoidCallback onTap;

  const _JobCard({
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
