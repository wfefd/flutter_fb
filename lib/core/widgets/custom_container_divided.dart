import 'package:flutter/material.dart';
import 'package:flutter_fb/core/theme/app_colors.dart';

/// 소제목 없이 header 밑에 Divider가 들어가는 버전의 공통 컨테이너
/// header → divider → children 구조
class CustomContainerDivided extends StatelessWidget {
  final Widget? header;
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;
  final Color dividerColor;

  const CustomContainerDivided({
    super.key,
    this.header,
    required this.children,
    this.padding,
    this.dividerColor = const Color(0xFFEAEAEA),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.border,
          width: 1,
          strokeAlign: BorderSide.strokeAlignInside,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ 헤더
          if (header != null)
            Padding(padding: const EdgeInsets.all(12), child: header!),

          // ✅ Divider (소제목 대신)
          Divider(height: 1, color: dividerColor),

          // ✅ 내용
          Padding(
            padding: padding ?? const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ],
      ),
    );
  }
}
