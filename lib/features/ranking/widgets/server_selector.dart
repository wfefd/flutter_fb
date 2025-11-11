import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/custom_container_divided.dart';

class ServerSelector extends StatefulWidget {
  final List<String> servers;
  final String selectedServer;
  final ValueChanged<String> onServerSelected;

  const ServerSelector({
    super.key,
    required this.servers,
    required this.selectedServer,
    required this.onServerSelected,
  });

  @override
  State<ServerSelector> createState() => _ServerSelectorState();
}

class _ServerSelectorState extends State<ServerSelector> {
  @override
  Widget build(BuildContext context) {
    return CustomContainerDivided(
      header: const Text(
        "서버 선택",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.primaryText,
        ),
      ),
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: widget.servers.map((server) {
              final isSelected = widget.selectedServer == server;
              return Padding(
                padding: const EdgeInsets.only(right: AppSpacing.sm),
                child: GestureDetector(
                  onTap: () => widget.onServerSelected(server),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primaryText.withOpacity(
                              0.9,
                            ) // 선택 시 진한 텍스트색 기반 강조
                          : AppColors.surface, // 기본 배경색
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? Colors.transparent
                            : AppColors.border,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: AppColors.primaryText.withOpacity(0.2),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : [],
                    ),
                    child: Text(
                      server,
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : AppColors.primaryText,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
