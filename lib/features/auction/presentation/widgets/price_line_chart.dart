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
  final Color backgroundColor; // ✅ 배경색을 외부에서 전달받도록 추가

  const PriceLineChartFirst5({
    super.key,
    required this.history,
    this.padding = const EdgeInsets.all(16),
    this.gradientColors = const [
      Colors.amber,
      Colors.deepOrangeAccent,
    ],
    this.backgroundColor = const Color(0xff2a3a4c), // ✅ 기본 배경색 설정
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
      // 데이터 없는 경우 표시 개선
      return Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          color: backgroundColor, // ✅ 외부에서 전달받은 배경색 사용
        ),
        child: const Center(
          child: Text(
            '시세 기록이 없습니다.',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
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
    // 최소값은 0보다 낮아지지 않도록
    minY = max(0, minY);


    return Container(
      // Container의 배경색은 외부 Container에서 담당하므로 여기서는 제거
      // decoration: BoxDecoration(
      //   borderRadius: const BorderRadius.all(Radius.circular(12)),
      //   color: backgroundColor, // ✅ 외부에서 전달받은 배경색 사용
      // ),
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
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 11,
                      ),
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
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 11,
                  ),
                ),
                reservedSize: 40,
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: Colors.white.withOpacity(0.15), width: 1),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            horizontalInterval: ((maxY - minY) / 4).clamp(1, double.infinity),
            verticalInterval: 1,
            getDrawingHorizontalLine: (value) => FlLine(
              color: Colors.white.withOpacity(0.1),
              strokeWidth: 1,
            ),
            getDrawingVerticalLine: (value) => FlLine(
              color: Colors.white.withOpacity(0.1),
              strokeWidth: 1,
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
              barWidth: 4,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 5,
                    color: Colors.white,
                    strokeWidth: 2,
                    strokeColor: barData.gradient?.colors.first ??
                        barData.color ??
                        Colors.amber,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: gradientColors
                      .map((c) => c.withOpacity(0.25))
                      .toList(),
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
          ],
          // 툴팁
          lineTouchData: LineTouchData(
            handleBuiltInTouches: true,
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (LineBarSpot touchedSpot) {
                return Colors.black.withOpacity(0.8);
              },
              tooltipBorderRadius: BorderRadius.circular(8.0),
              getTooltipItems: (List<LineBarSpot> touchedSpots) {
                return touchedSpots.map((LineBarSpot touchedSpot) {
                  final int spotIndex = touchedSpot.spotIndex;
                  // 범위 체크
                  if (spotIndex < 0 || spotIndex >= values.length) {
                    return null;
                  }

                  final String label = labels[spotIndex];
                  final String price = values[spotIndex].toStringAsFixed(0);

                  return LineTooltipItem(
                    '$label: $price G',
                    const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
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

  String _labelOf(data.PriceRange r) {
    switch (r) {
      case data.PriceRange.d7:
        return '365D';
      case data.PriceRange.d14:
        return '90D';
      case data.PriceRange.d30:
        return '30D';
      case data.PriceRange.d90:
        return '14D';
      case data.PriceRange.d365:
        return '7D';
    }
  }
}