import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mic/function/datas.dart';

class StarforceBarChart extends StatelessWidget {
  const StarforceBarChart({super.key, required this.rows});

  final List<List<dynamic>> rows;

  // 색상(이미지 톤)
  static const Color navy = Color(0xFF002645);
  static const Color panel = Color(0xFF002645);
  static const Color line = Color(0xFF083566);
  static const Color gold = Color(0xFFfdebc6);

  double? _parseRate(dynamic v) {
    if (v == null) return null;
    final s = v.toString().trim();
    if (s == '—' || s.isEmpty) return null;
    // "55,6" → 55.6
    return double.tryParse(s.replaceAll(',', '.'));
  }

  @override
  Widget build(BuildContext context) {
    // rows → BarChart 데이터로 변환
    final groups = <BarChartGroupData>[];
    double maxY = 0;

    for (final r in rows) {
      final String xLabel = r[0].toString();
      final rate = _parseRate(r[1]); // 성공률

      // x축 값(정수). 같은 성이 중복되면 index 기반으로 밀어넣음
      final x = int.tryParse(xLabel) ?? (groups.length + 1);

      if (rate != null) {
        maxY = rate > maxY ? rate : maxY;
        groups.add(
          BarChartGroupData(
            x: x,
            barRods: [
              BarChartRodData(
                toY: rate,
                width: 6.w,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
                color: Typicalcolor.bg,
              ),
            ],
          ),
        );
      }
    }

    // 여유 여백
    maxY = (maxY == 0 ? 10 : maxY) * 1.15;

    return Container(
      width: 130.w,
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
            barGroups: groups..sort((a, b) => a.x.compareTo(b.x)),
            titlesData: FlTitlesData(
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),

              // X축: 성(1~10 같은 정수 라벨)
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

              // Y축: 성공률(간단히 정수/한 자리 소수)
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 34.sp,
                  getTitlesWidget: (value, meta) => Text(
                    value % 20 == 0
                        ? value.toStringAsFixed(value % 1 == 0 ? 0 : 1)
                        : '',
                    style: TextStyle(
                      color: Typicalcolor.font,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
            barTouchData: BarTouchData(
              enabled: true,
              touchTooltipData: BarTouchTooltipData(
                getTooltipColor: (_) => Typicalcolor.bg, // ← 여기로 변경
                getTooltipItem: (group, groupIndex, rod, rodIndex) =>
                    BarTooltipItem(
                      '성 ${group.x}\n성공률 ${rod.toY.toStringAsFixed(1)}%',
                      TextStyle(
                        color: Typicalcolor.font,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
