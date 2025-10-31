// lib/features/auction/presentation/widgets/price_line_chart_first5.dart
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

// PriceRange enum은 data 파일에 있으니 네임스페이스로 임포트
import '../../data/auction_item_data.dart' as data;

/// 5개의 분기(d7, d14, d30, d90, d365)에서
/// 각 분기의 "첫 번째 값"만 뽑아 그리는 라인 차트
class PriceLineChartFirst5 extends StatelessWidget {
  /// 아이템의 시세 히스토리 맵 (AuctionItem.history 그대로)
  final Map<data.PriceRange, List<double>> history;

  final EdgeInsets padding;
  final List<Color> gradientColors;

  const PriceLineChartFirst5({
    super.key,
    required this.history,
    this.padding = const EdgeInsets.all(16),
    this.gradientColors = const [Color(0xff23b6e6), Color(0xff02d39a)],
  });

  @override
  Widget build(BuildContext context) {
    // 표시 순서 고정
    final ranges = <data.PriceRange>[
      data.PriceRange.d7,
      data.PriceRange.d14,
      data.PriceRange.d30,
      data.PriceRange.d90,
      data.PriceRange.d365,
    ];

    // 각 분기의 첫 값만 수집 (값 없으면 건너뜀)
    final values = <double>[];
    final labels = <String>[];
    for (final r in ranges) {
      final series = history[r];
      if (series != null && series.isNotEmpty) {
        values.add(series.first.toDouble());
        labels.add(_labelOf(r));
      }
    }

    if (values.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    // FlSpot 변환
    final spots = <FlSpot>[
      for (int i = 0; i < values.length; i++) FlSpot(i.toDouble(), values[i]),
    ];

    // 동적 y 범위 계산
    final rawMin = values.reduce(min);
    final rawMax = values.reduce(max);
    double minY = rawMin, maxY = rawMax;
    if ((rawMax - rawMin).abs() < 1e-9) {
      const pad = 1.0; // 값이 모두 같을 때 여백
      minY -= pad;
      maxY += pad;
    } else {
      final pad = (rawMax - rawMin) * 0.1;
      minY -= pad;
      maxY += pad;
    }

    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        color: Color(0xff232d37),
      ),
      padding: padding,
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: (values.length - 1).toDouble(),
          minY: minY,
          maxY: maxY,
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  final i = value.toInt();
                  if (i < 0 || i >= labels.length) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      labels[i],
                      style: const TextStyle(color: Color(0xff68737d), fontSize: 11),
                    ),
                  );
                },
                reservedSize: 26,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: ((maxY - minY) / 4).clamp(1, double.infinity),
                getTitlesWidget: (value, meta) => Text(
                  value.toStringAsFixed(0),
                  style: const TextStyle(color: Color(0xff67727d), fontSize: 11),
                ),
                reservedSize: 40,
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: const Color(0xff37434d), width: 1),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            horizontalInterval: ((maxY - minY) / 4).clamp(1, double.infinity),
            verticalInterval: 1,
            getDrawingHorizontalLine: (value) =>
                const FlLine(color: Color(0xff37434d), strokeWidth: 1),
            getDrawingVerticalLine: (value) =>
                const FlLine(color: Color(0xff37434d), strokeWidth: 1),
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
              barWidth: 4,
              isStrokeCapRound: true,
              dotData: FlDotData(show: true), // 포인트 5개라 점 보이도록
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: gradientColors.map((c) => c.withOpacity(0.25)).toList(),
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
          ],
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (touched) => touched
                  .map((ts) => LineTooltipItem(
                        '${values[ts.spotIndex].toStringAsFixed(0)} G',
                        const TextStyle(color: Colors.white),
                      ))
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }

  String _labelOf(data.PriceRange r) {
    switch (r) {
      case data.PriceRange.d7:
        return '7D';
      case data.PriceRange.d14:
        return '14D';
      case data.PriceRange.d30:
        return '30D';
      case data.PriceRange.d90:
        return '90D';
      case data.PriceRange.d365:
        return '365D';
    }
  }
}
