import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// 최근 1주일 시세를 날짜 기준으로 그려주는 라인 차트
///
/// [points] : (DateTime date, double price) 리스트
class PriceLineChartFirst5 extends StatelessWidget {
  final List<(DateTime date, double price)> points;

  final EdgeInsets padding;

  /// 라인 그라디언트 색
  final List<Color> gradientColors;

  /// 차트 카드 배경색
  final Color backgroundColor;

  const PriceLineChartFirst5({
    super.key,
    required this.points,
    this.padding = const EdgeInsets.all(16),
    this.gradientColors = const [
      AppColors.primaryText,
      AppColors.secondaryText,
    ],
    this.backgroundColor = AppColors.surface,
  });

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: backgroundColor,
        ),
        alignment: Alignment.center,
        child: const Text(
          '시세 기록이 없습니다.',
          style: TextStyle(color: AppColors.secondaryText, fontSize: 12),
        ),
      );
    }

    // 값 / 라벨 분리
    final values = <double>[];
    final labels = <String>[];

    for (final p in points) {
      values.add(p.$2);
      labels.add(_formatDate(p.$1));
    }

    final spots = <FlSpot>[
      for (int i = 0; i < values.length; i++) FlSpot(i.toDouble(), values[i]),
    ];

    // 동적 y 범위 계산
    final rawMin = values.reduce(min);
    final rawMax = values.reduce(max);
    double minY = rawMin;
    double maxY = rawMax;

    if ((rawMax - rawMin).abs() < 1e-9) {
      const pad = 1.0;
      minY -= pad;
      maxY += pad;
    } else {
      final pad = (rawMax - rawMin) * 0.15;
      minY -= pad;
      maxY += pad;
    }
    minY = max(0, minY);

    final range = maxY - minY;
    final double yInterval = range <= 0
        ? 1.0
        : (range / 4).clamp(1.0, double.infinity).toDouble();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: backgroundColor,
      ),
      padding: padding,
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: (values.length - 1).toDouble(),
          minY: minY,
          maxY: maxY,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: yInterval,
            getDrawingHorizontalLine: (value) => FlLine(
              color: AppColors.border.withValues(alpha: 0.5),
              strokeWidth: 1,
            ),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  final i = value.toInt();
                  if (i < 0 || i >= labels.length) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      labels[i],
                      style: TextStyle(
                        color: AppColors.secondaryText.withValues(alpha: 0.7),
                        fontSize: 10,
                      ),
                    ),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                interval: yInterval,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toStringAsFixed(0),
                    style: TextStyle(
                      color: AppColors.secondaryText.withValues(alpha: 0.8),
                      fontSize: 11,
                    ),
                  );
                },
              ),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: values.length > 1,
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 4,
                    color: AppColors.background,
                    strokeWidth: 1.5,
                    strokeColor:
                        (barData.gradient?.colors.first) ??
                        AppColors.primaryText,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: gradientColors
                      .map((c) => c.withValues(alpha: 0.15))
                      .toList(),
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
          lineTouchData: LineTouchData(
            handleBuiltInTouches: true,
            touchTooltipData: LineTouchTooltipData(
              tooltipPadding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 6,
              ),
              getTooltipColor: (spot) =>
                  AppColors.primaryText.withValues(alpha: 0.9),
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((barSpot) {
                  final idx = barSpot.spotIndex;
                  if (idx < 0 || idx >= values.length) return null;

                  final dateLabel = labels[idx];
                  final price = values[idx].toStringAsFixed(0);

                  return LineTooltipItem(
                    '$dateLabel\n$price G',
                    const TextStyle(
                      color: AppColors.background,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                }).toList();
              },
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime d) {
    final yy = (d.year % 100).toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    final dd = d.day.toString().padLeft(2, '0');
    // 예: 25.11.15
    return '$yy.$mm.$dd';
  }
}
