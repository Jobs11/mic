import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Pillsegmentedfour extends StatelessWidget {
  const Pillsegmentedfour({
    super.key,
    required this.value,
    required this.onChanged,
    required this.labels, // ["경험치계산기", "일일", "주간", "쿠폰"]
    this.height = 44,
    this.borderWidth = 2,
    this.radius = 22,
    this.selectedColor = const Color(0xFF3b3b3b),
    this.unselectedColor = const Color(0xFFEFE8DC),
    this.selectedTextColor = const Color(0xFF3b3b3b),
    this.unselectedTextColor = const Color(0xFFEFE8DC),
    this.borderColor = Colors.black,
    this.textStyle = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      color: Colors.black,
    ),
  });

  final int value; // 선택된 인덱스 (0~3)
  final ValueChanged<int> onChanged;
  final List<String> labels;

  final double height;
  final double borderWidth;
  final double radius;
  final Color selectedColor;
  final Color unselectedColor;
  final Color selectedTextColor;
  final Color unselectedTextColor;

  final Color borderColor;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: borderColor, width: borderWidth),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius - 2),
        child: Row(
          children: List.generate(labels.length * 2 - 1, (i) {
            if (i.isOdd) {
              // 가운데 구분선
              return Container(width: 1.5, color: borderColor);
            }
            final index = i ~/ 2;
            final isSelected = value == index;
            return Expanded(
              child: InkWell(
                onTap: () => onChanged(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 140),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected ? selectedColor : unselectedColor,
                  ),
                  child: Stack(
                    children: [
                      // 테두리
                      Text(
                        labels[index],
                        style: textStyle.copyWith(
                          fontSize: isSelected ? 18.sp : 14.sp,
                          fontWeight: isSelected
                              ? FontWeight.w800
                              : FontWeight.w700,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 2
                            ..color = isSelected
                                ? Color(0xFFEFE8DC)
                                : Color(0xFF3b3b3b),
                        ),
                      ),
                      // 안쪽 채우기
                      Text(
                        labels[index],
                        style: textStyle.copyWith(
                          fontSize: isSelected ? 18.sp : 14.sp,
                          fontWeight: isSelected
                              ? FontWeight.w800
                              : FontWeight.w700,
                          color: isSelected
                              ? selectedTextColor
                              : unselectedTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
