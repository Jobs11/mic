import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mic/function/datas.dart';
import 'package:mic/function/starforce_expected_fn.dart';

// rows: PerStarStat 리스트 (simulateOnce 결과의 perStar 정렬본)
class StarforceBarChart extends StatelessWidget {
  const StarforceBarChart({super.key, required this.rows});

  final List<PerStarStat> rows;

  @override
  Widget build(BuildContext context) {
    // rows → BarChart 데이터로 변환
    final groups = <BarChartGroupData>[];
    double maxY = 0;

    // 성 순서대로 정렬 (안 되어있다면 대비)
    final ordered = [...rows]..sort((a, b) => a.star.compareTo(b.star));

    for (final r in ordered) {
      if (r.attempts <= 0) continue; // 시도 0이면 스킵

      final rate = (r.success / r.attempts) * 100.0; // 실측 성공률(%)
      if (rate > maxY) maxY = rate;

      groups.add(
        BarChartGroupData(
          x: r.star, // 1,2,3...
          barRods: [
            BarChartRodData(
              toY: rate,
              width: 6.w,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
              ),
              color: Typicalcolor.bg, // 막대 색
            ),
          ],
        ),
      );
    }

    // 여유 여백
    maxY = (maxY == 0 ? 10 : maxY) * 1.15;

    return Container(
      width: 120.w,
      height: 250.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Typicalcolor.title, Typicalcolor.subtitle],
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Typicalcolor.subborder, width: 2.w),
        boxShadow: const [
          BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 3,
            color: Color(0x80061C28),
          ),
        ],
      ),
      child: AspectRatio(
        aspectRatio: 1.6,
        child: BarChart(
          BarChartData(
            maxY: maxY,
            minY: 0,
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              getDrawingHorizontalLine: (v) =>
                  FlLine(color: Typicalcolor.subborder, strokeWidth: 1),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border.all(color: Typicalcolor.subborder, width: 2.w),
            ),
            barGroups: groups,
            titlesData: FlTitlesData(
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),

              // X축: 성 (정수 라벨)
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) => Padding(
                    padding: EdgeInsets.only(top: 6.h),
                    child: Text(
                      value.toInt().toString(),
                      style: TextStyle(
                        color: Typicalcolor.font,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ),

              // Y축: 성공률(%)
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 36.sp,
                  getTitlesWidget: (value, meta) {
                    // 20% 단위로 라벨 표시
                    if (value % 20 == 0) {
                      final txt = value % 1 == 0
                          ? value.toStringAsFixed(0)
                          : value.toStringAsFixed(1);
                      return Text(
                        txt,
                        style: TextStyle(
                          color: Typicalcolor.font,
                          fontWeight: FontWeight.w700,
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),
            barTouchData: BarTouchData(
              enabled: true,
              touchTooltipData: BarTouchTooltipData(
                getTooltipColor: (_) => Typicalcolor.bg,
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  // 툴팁에 시도/메소까지 노출 (해당 성 정보 찾기)
                  final star = group.x;
                  final stat = ordered.firstWhere(
                    (e) => e.star == star,
                    orElse: () => PerStarStat(star),
                  );
                  final rate = rod.toY.toStringAsFixed(1);
                  final tries = stat.attempts;
                  final meso = stat.mesoSpent;

                  return BarTooltipItem(
                    '성 $star → ${star + 1}\n'
                    '성공률 $rate%\n'
                    '시도 $tries 회 · 메소 $meso',
                    TextStyle(
                      color: Typicalcolor.font,
                      fontWeight: FontWeight.w800,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
