import 'package:flutter/material.dart';
import 'package:flutter_fb/core/theme/app_colors.dart';
import 'package:flutter_fb/core/theme/app_text_styles.dart';

/// header → divider → children (각 항목마다 divider 추가)
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
    Widget? styledHeader;

    // ✅ header가 Text일 경우, 자동으로 공통 스타일 적용
    if (header is Text) {
      final textWidget = header as Text;
      styledHeader = Padding(
        padding: const EdgeInsets.all(12),
        child: DefaultTextStyle.merge(
          style: AppTextStyles.body1.copyWith(color: AppColors.primaryText),
          child: textWidget,
        ),
      );
    } else if (header != null) {
      // Text 외의 위젯이면 그대로
      styledHeader = Padding(padding: const EdgeInsets.all(12), child: header!);
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.border,
          width: 0.5,
          strokeAlign: BorderSide.strokeAlignInside,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ 헤더
          if (styledHeader != null) styledHeader,

          // ✅ header 밑 구분선
          Divider(height: 1, color: dividerColor),

          // ✅ 내용 (children 사이마다 divider 자동 삽입)
          Padding(
            padding: padding ?? const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(children.length, (index) {
                final item = children[index];
                final isLast = index == children.length - 1;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    item,
                    if (!isLast)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Divider(
                          height: 1,
                          color: dividerColor.withOpacity(0.8),
                        ),
                      ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
