import 'package:flutter/material.dart';

/// ✅ 안정화 버전: GPU 부하 제거 + rebuild 최소화 + KeepAlive 충돌 제거
class SelectableImageCard extends StatefulWidget {
  final String label;
  final String imagePath;
  final bool isSelected;
  final VoidCallback onTap;
  final double imageSize;
  final double borderRadius;

  const SelectableImageCard({
    super.key,
    required this.label,
    required this.imagePath,
    required this.isSelected,
    required this.onTap,
    this.imageSize = 48,
    this.borderRadius = 12,
  });

  @override
  State<SelectableImageCard> createState() => _SelectableImageCardState();
}

class _SelectableImageCardState extends State<SelectableImageCard> {
  late Image _cachedImage;

  @override
  void initState() {
    super.initState();

    // ✅ 미리 GPU 캐싱
    _cachedImage = Image.asset(
      widget.imagePath,
      width: widget.imageSize,
      height: widget.imageSize,
      fit: BoxFit.cover,
      cacheWidth: (widget.imageSize * 2).toInt(),
      filterQuality: FilterQuality.low,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      precacheImage(_cachedImage.image, context);
    });
  }

  @override
  void didUpdateWidget(covariant SelectableImageCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 이미지 경로가 바뀌면 새로 캐싱
    if (oldWidget.imagePath != widget.imagePath) {
      _cachedImage = Image.asset(
        widget.imagePath,
        width: widget.imageSize,
        height: widget.imageSize,
        fit: BoxFit.cover,
        cacheWidth: (widget.imageSize * 2).toInt(),
        filterQuality: FilterQuality.low,
      );
      WidgetsBinding.instance.addPostFrameCallback((_) {
        precacheImage(_cachedImage.image, context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      borderRadius: BorderRadius.circular(widget.borderRadius),
      splashColor: Colors.green.withOpacity(0.1),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: _boxDecoration(widget.isSelected, widget.borderRadius),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: _cachedImage,
            ),
            const SizedBox(height: 6),
            Text(
              widget.label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: widget.isSelected
                    ? const Color(0xFF4CAF50)
                    : Colors.black87,
                fontWeight: widget.isSelected
                    ? FontWeight.bold
                    : FontWeight.normal,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static BoxDecoration _boxDecoration(bool isSelected, double radius) {
    return BoxDecoration(
      color: isSelected
          ? const Color(0xFF7BC57B).withOpacity(0.15)
          : Colors.white,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(
        color: isSelected ? const Color(0xFF7BC57B) : Colors.grey.shade300,
        width: isSelected ? 2 : 1,
      ),
      boxShadow: const [
        BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(1, 2)),
      ],
    );
  }
}
