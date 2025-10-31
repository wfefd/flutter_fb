import 'package:flutter/material.dart';
import '../data/job_image_map.dart';
import 'selectable_image_card.dart';

class AwakeningSelector extends StatelessWidget {
  final String job;
  final List<String> awakenings;
  final String? selectedAwakening;
  final ValueChanged<String> onAwakeningSelected;

  const AwakeningSelector({
    super.key,
    required this.job,
    required this.awakenings,
    required this.selectedAwakening,
    required this.onAwakeningSelected,
  });

  @override
  Widget build(BuildContext context) {
    // ✅ 이미지 경로 미리 계산 (build 중 반복 연산 방지)
    final awakeningList = List.generate(
      awakenings.length,
      (i) => {
        'name': awakenings[i],
        'imagePath':
            'assets/images/jobs/${JobImageMap.getAwakeningImage(job, i)}',
      },
    );

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: _boxDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '각성 선택',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 8),

          // ✅ shrinkWrap 제거 및 높이 지정 (성능 향상)
          SizedBox(
            height: 120, // 높이 고정으로 레이아웃 계산 최소화
            child: GridView.builder(
              itemCount: awakeningList.length,
              physics: const ClampingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 0.9,
              ),
              itemBuilder: (context, index) {
                final awakening = awakeningList[index];
                final isSelected = selectedAwakening == awakening['name'];

                return SelectableImageCard(
                  label: awakening['name']!,
                  imagePath: awakening['imagePath']!,
                  isSelected: isSelected,
                  onTap: () => onAwakeningSelected(awakening['name']!),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ✅ BoxDecoration 재사용 (매번 객체 생성 방지)
  static final _boxDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
    ],
  );
}
