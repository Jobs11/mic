import 'package:flutter/material.dart';

enum SimTab { simulator, expected }

class Pillsegmentedtwo extends StatelessWidget {
  const Pillsegmentedtwo({
    super.key,
    required this.value,
    required this.onChanged,
    this.height = 44,
    this.borderWidth = 2,
    this.radius = 22,
    this.selectedColor = const Color(0xFFEFE8DC), // 선택 배경(살짝 베이지 톤)
    this.unselectedColor = Colors.white, // 비선택 배경
    this.borderColor = Colors.black, // 외곽선/구분선 색
    this.padding = const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
    this.textStyle = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      color: Colors.black,
    ),
    this.leftLabel = '시뮬레이터',
    this.rightLabel = '기댓값',
  });

  final SimTab value;
  final ValueChanged<SimTab> onChanged;

  final double height;
  final double borderWidth;
  final double radius;
  final Color selectedColor;
  final Color unselectedColor;
  final Color borderColor;
  final EdgeInsets padding;
  final TextStyle textStyle;
  final String leftLabel;
  final String rightLabel;

  @override
  Widget build(BuildContext context) {
    final isLeft = value == SimTab.simulator;
    final isRight = value == SimTab.expected;

    return Container(
      height: height,

      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: borderColor, width: borderWidth),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius - 2),
        child: Row(
          children: [
            // 왼쪽 탭
            Expanded(
              child: InkWell(
                onTap: () => onChanged(SimTab.simulator),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 140),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isLeft ? selectedColor : unselectedColor,
                  ),
                  child: Text(
                    leftLabel,
                    style: textStyle.copyWith(
                      fontWeight: isLeft ? FontWeight.w800 : FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
            // 가운데 구분선
            Container(width: 1.5, color: borderColor),
            // 오른쪽 탭
            Expanded(
              child: InkWell(
                onTap: () => onChanged(SimTab.expected),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 140),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isRight ? selectedColor : unselectedColor,
                  ),
                  child: Text(
                    rightLabel,
                    style: textStyle.copyWith(
                      fontWeight: isRight ? FontWeight.w800 : FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
