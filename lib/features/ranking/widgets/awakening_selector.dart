import 'package:flutter/material.dart';
import 'package:flutter_fb/core/theme/app_colors.dart';
import '../data/job_image_map.dart';
import '../../../core/widgets/custom_container_divided.dart';

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
    final awakeningList = List.generate(
      awakenings.length,
      (i) => {
        'name': awakenings[i],
        'imagePath':
            'assets/images/jobs/${JobImageMap.getAwakeningImage(job, i)}',
      },
    );

    return CustomContainerDivided(
      header: const Text(
        '각성 선택',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: awakeningList.map((awakening) {
            final isSelected = selectedAwakening == awakening['name'];
            return GestureDetector(
              onTap: () => onAwakeningSelected(awakening['name']!),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF2F2F38)
                      : const Color(0xFFF5F6F8),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF2F2F38)
                        : Colors.grey.shade300,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      awakening['imagePath']!,
                      width: 20,
                      height: 20,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      awakening['name']!,
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF333333),
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                    if (isSelected)
                      const Padding(
                        padding: EdgeInsets.only(left: 4),
                        child: Icon(Icons.check, size: 16, color: Colors.white),
                      ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
